import 'dart:async';

import 'package:taleemmate/blocs/progress/progress_dashboard.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/progress/daily_score.dart';
import 'package:taleemmate/core/models/progress/progress_metric.dart';
import 'package:taleemmate/core/models/progress/session_metric.dart';
import 'package:taleemmate/core/models/progress/study_streak.dart';
import 'package:taleemmate/core/models/subject/exam.dart';
import 'package:taleemmate/core/models/subject/subject.dart';
import 'package:taleemmate/repos/progress/progress_repo.dart';
import 'package:taleemmate/services/fault/faults.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'state.dart';

/// Global cubit (registered in `app.dart`) so its watch/cache survive bottom-tab
/// switches and it's reachable from the quiz screen for `recordQuizResult`.
/// Loads lazily on Progress tab open; the deterministic snapshot shows
/// immediately and the AI readiness pass runs only when the data is stale.
class ProgressCubit extends Cubit<ProgressState> {
  static ProgressCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<ProgressCubit>(context, listen: listen);

  ProgressCubit() : super(ProgressState.def());

  /// Readiness is re-generated on tab open only when older than this.
  static const _staleness = Duration(hours: 6);

  StreamSubscription<List<Map<String, dynamic>>>? _metricsSub;
  String? _userId;
  bool _metricsLoaded = false;
  bool _refreshing = false;

  // Deterministic context cache — re-assembled into the dashboard on change.
  List<ProgressMetric> _metrics = const [];
  List<Subject> _subjects = const [];
  List<Exam> _exams = const [];
  List<DailyScore> _dailyScores = const [];
  List<SessionMetric> _sessions = const [];
  StudyStreak? _streak;
  int _quizCount = 0;
  int _questionCount = 0;
  String? _studyInsight;

  /// Loads progress for [userId]. Re-fetches the (cheap, local) deterministic
  /// snapshot on every call; subscribes to the metrics stream once. Triggers the
  /// AI readiness pass only when metrics are stale or absent.
  Future<void> loadForUser(String userId) async {
    final firstLoad = _userId != userId || _metricsSub == null;
    _userId = userId;
    if (firstLoad && state.dashboard.data == null) {
      emit(state.copyWith(dashboard: state.dashboard.toLoading()));
    }
    try {
      final raw = await ProgressRepo.ins.dashboardData(userId);
      _ingestSnapshot(raw);
      if (firstLoad) _watchMetrics(userId);
      _emitDashboard();
      _maybeRefresh();
    } on Fault catch (e) {
      emit(state.copyWith(dashboard: state.dashboard.toFailed(fault: e)));
    }
  }

  void _watchMetrics(String userId) {
    _metricsSub?.cancel();
    _metricsLoaded = false;
    _metricsSub = ProgressRepo.ins.watchMetrics(userId).listen((rows) {
      _metrics = rows.map(ProgressMetric.fromJson).toList();
      _metricsLoaded = true;
      _emitDashboard();
      _maybeRefresh();
    });
  }

  void _ingestSnapshot(Map<String, dynamic> raw) {
    final streak = raw['streak'] as Map<String, dynamic>?;
    _streak = streak == null ? null : StudyStreak.fromJson(streak);
    _dailyScores = ((raw['dailyScores'] as List?) ?? const [])
        .map((e) => DailyScore.fromJson(e as Map<String, dynamic>))
        .toList();
    _sessions = ((raw['sessionMetrics'] as List?) ?? const [])
        .map((e) => SessionMetric.fromJson(e as Map<String, dynamic>))
        .toList();
    _subjects = ((raw['subjects'] as List?) ?? const [])
        .map((e) => Subject.fromJson(e as Map<String, dynamic>))
        .toList();
    _exams = ((raw['exams'] as List?) ?? const [])
        .map((e) => Exam.fromJson(e as Map<String, dynamic>))
        .toList();
    _quizCount = (raw['quizCount'] as num?)?.toInt() ?? 0;
    _questionCount = (raw['questionCount'] as num?)?.toInt() ?? 0;
  }

  /// Kicks the AI readiness pass when the watched metrics are stale or empty.
  /// Waits for the first metrics emission so a fresh-but-not-yet-streamed DB
  /// isn't refreshed needlessly.
  void _maybeRefresh() {
    if (_userId == null || _refreshing || !_metricsLoaded) return;
    if (_subjects.isEmpty) return; // nothing to predict against
    final newest = _metrics.isEmpty
        ? null
        : _metrics
              .map((m) => m.lastUpdatedAt)
              .reduce((a, b) => a.isAfter(b) ? a : b);
    final stale =
        newest == null || DateTime.now().difference(newest) > _staleness;
    if (!stale) return;
    _refresh(_userId!);
  }

  Future<void> _refresh(String userId) async {
    _refreshing = true;
    try {
      final insight = await ProgressRepo.ins.refreshReadiness(userId);
      if (insight != null && insight.isNotEmpty) _studyInsight = insight;
      // The metric upserts re-emit through the watch; emit again so the freshly
      // generated studyInsight (not in the watch) lands too.
      _emitDashboard();
    } on Fault {
      // AI failure leaves the deterministic dashboard intact.
    } finally {
      _refreshing = false;
    }
  }

  /// Records one completed quiz (a `DailyScore` + streak bump). Best-effort —
  /// fired from the quiz results transition; failures are swallowed.
  Future<void> recordQuizResult({
    required String userId,
    required String subjectId,
    required int score,
    required int total,
  }) async {
    try {
      await ProgressRepo.ins.recordQuizScore(
        userId: userId,
        subjectId: subjectId,
        score: score,
        total: total,
        date: DateTime.now(),
      );
    } on Fault {
      // Best-effort: recording must never block the results screen.
    }
  }

  /// Bumps the study streak for today. Best-effort.
  Future<void> recordStudyActivity(String userId) async {
    try {
      await ProgressRepo.ins.recordStudyActivity(userId: userId);
    } on Fault {
      // Best-effort.
    }
  }

  void _emitDashboard() {
    emit(
      state.copyWith(dashboard: state.dashboard.toSuccess(data: _assemble())),
    );
  }

  ProgressDashboard _assemble() {
    final metricBySubject = {for (final m in _metrics) m.subjectId: m};
    final masteries = _subjects.map((s) {
      final m = metricBySubject[s.id];
      return MasterySubject(
        subjectId: s.id,
        name: s.name,
        readinessScore: m?.readinessScore ?? 0,
        weeklyGain: m?.weeklyGain,
        predictedRange: m?.predictedScoreRange,
        aiInsight: m?.aiInsight,
      );
    }).toList();

    final scores = _dailyScores.map((d) => d.score).toList();
    final last14 = scores.length <= 14
        ? scores
        : scores.sublist(scores.length - 14);

    final now = DateTime.now();
    final weekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));
    final weekMinutes = _sessions
        .where((s) => !s.date.isBefore(weekStart))
        .fold<int>(0, (a, s) => a + s.durationMinutes);
    final avgSession = _sessions.isEmpty
        ? 0
        : (_sessions.fold<int>(0, (a, s) => a + s.durationMinutes) /
                  _sessions.length)
              .round();

    return ProgressDashboard(
      hero: _heroSubject(masteries),
      subjects: masteries,
      dailyScores: last14,
      streakDays: _streak?.dayCount ?? 0,
      weekHours: weekMinutes / 60.0,
      avgSessionMinutes: avgSession,
      quizCount: _quizCount,
      questionCount: _questionCount,
      studyInsight: _studyInsight,
    );
  }

  /// Nearest upcoming exam's subject, else the lowest-readiness subject.
  MasterySubject? _heroSubject(List<MasterySubject> masteries) {
    if (masteries.isEmpty) return null;
    final byId = {for (final m in masteries) m.subjectId: m};
    final upcoming = _exams.where((e) => e.daysUntil >= 0).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    for (final e in upcoming) {
      final m = byId[e.subjectId];
      if (m != null) return m;
    }
    final sorted = [...masteries]
      ..sort((a, b) => a.readinessScore.compareTo(b.readinessScore));
    return sorted.first;
  }

  /// Session uid lifecycle (ADR-014) — cleared by the logout listeners. Progress
  /// is loaded lazily on tab open, so there is no `initUid` counterpart.
  void resetUid() => reset();

  void reset() {
    _metricsSub?.cancel();
    _metricsSub = null;
    _userId = null;
    _metricsLoaded = false;
    _refreshing = false;
    _metrics = const [];
    _subjects = const [];
    _exams = const [];
    _dailyScores = const [];
    _sessions = const [];
    _streak = null;
    _quizCount = 0;
    _questionCount = 0;
    _studyInsight = null;
    emit(ProgressState.def());
  }

  @override
  Future<void> close() {
    _metricsSub?.cancel();
    return super.close();
  }
}
