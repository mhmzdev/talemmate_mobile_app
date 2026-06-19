import 'dart:async';

import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/models/schedule/day_plan.dart';
import 'package:taleemmate/core/models/schedule/schedule.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';
import 'package:taleemmate/core/models/schedule/week_plan.dart';
import 'package:taleemmate/core/models/subject/exam.dart';
import 'package:taleemmate/repos/plan/plan_repo.dart';
import 'package:taleemmate/repos/progress/progress_repo.dart';
import 'package:taleemmate/services/fault/faults.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'state.dart';

class PlanCubit extends Cubit<PlanState> {
  static PlanCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<PlanCubit>(context, listen: listen);

  PlanCubit() : super(PlanState.def());

  StreamSubscription<List<Map<String, dynamic>>>? _blocksSub;
  String? _watchingUserId;
  List<Exam> _exams = const [];

  /// Session uid lifecycle (ADR-014) — driven by the auth-transition listeners.
  /// Begins watching the signed-in user's persisted plan on login / resume.
  void initUid(String uid) => watchForUser(uid);

  /// Clears the session uid plus the watched plan on logout.
  void resetUid() => reset();

  /// Generates + persists a fresh week plan for [userId]. Drives the loader.
  Future<void> generate(String userId) async {
    emit(state.copyWith(generate: state.generate.toLoading()));
    try {
      final raw = await PlanRepo.ins.generate(userId);
      emit(
        state.copyWith(
          generate: state.generate.toSuccess(data: WeekPlan.fromJson(raw)),
        ),
      );
    } on Fault catch (e) {
      emit(state.copyWith(generate: state.generate.toFailed(fault: e)));
    }
  }

  /// Resolves the user's schedule and starts watching its blocks, assembling a
  /// live [WeekPlan] into `week`. Idempotent per user — safe to call from both
  /// the home and plan screens.
  Future<void> watchForUser(String userId) async {
    if (_watchingUserId == userId && _blocksSub != null) return;
    _watchingUserId = userId;
    emit(state.copyWith(week: state.week.toLoading()));
    try {
      final scheduleMap = await PlanRepo.ins.currentSchedule(userId);
      if (scheduleMap == null) {
        // No schedule yet — settle to an (empty) success so the UI can show a
        // calm empty state rather than a spinner forever.
        emit(state.copyWith(week: state.week.toSuccess()));
        return;
      }
      final schedule = Schedule.fromJson(scheduleMap);
      _exams = (await PlanRepo.ins.exams(userId)).map(Exam.fromJson).toList();
      emit(state.copyWith(schedule: schedule));
      _watchSchedule(schedule);
    } on Fault catch (e) {
      _watchingUserId = null;
      emit(state.copyWith(week: state.week.toFailed(fault: e)));
    }
  }

  void _watchSchedule(Schedule schedule) {
    _blocksSub?.cancel();
    _blocksSub = PlanRepo.ins.watchBlocks(schedule.id).listen((rows) {
      final blocks = rows.map(StudyBlock.fromJson).toList();
      emit(
        state.copyWith(
          week: state.week.toSuccess(data: _assembleWeek(schedule, blocks)),
        ),
      );
    });
  }

  /// Builds a 7-day [WeekPlan] (today + 6) from the watched [blocks], grouping
  /// by calendar day and attaching the exam (if any) that falls on each day.
  WeekPlan _assembleWeek(Schedule schedule, List<StudyBlock> blocks) {
    final byDay = <DateTime, List<StudyBlock>>{};
    for (final b in blocks) {
      final key = DateTime(b.date.year, b.date.month, b.date.day);
      byDay.putIfAbsent(key, () => []).add(b);
    }

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final days = <DayPlan>[];
    for (var i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      Exam? exam;
      for (final e in _exams) {
        if (_sameDay(e.date, date)) {
          exam = e;
          break;
        }
      }
      days.add(
        DayPlan(date: date, blocks: byDay[date] ?? const [], exam: exam),
      );
    }

    return WeekPlan(
      id: schedule.id,
      scheduleId: schedule.id,
      startDate: start,
      endDate: start.add(const Duration(days: 6)),
      days: days,
      aiReasoning: schedule.aiReasoning,
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // --- reschedule actions (Focus plan) -----------------------------------

  /// Snooze: start this block 30 minutes later.
  Future<void> snoozeBlock(StudyBlock b) =>
      _reschedule(b, startTime: b.startTime.clockPlusMinutes(30));

  /// Move to tonight: slot it into the fixed after-Isha window (20:30).
  Future<void> moveToTonight(StudyBlock b) => _reschedule(b, startTime: '20:30');

  /// Shorten to 30 min — leaves already-short (≤30) blocks untouched.
  Future<void> shortenBlock(StudyBlock b) => _reschedule(
    b,
    durationMinutes: b.durationMinutes <= 30 ? b.durationMinutes : 30,
  );

  /// Skip today: fold the block into tomorrow's plan.
  Future<void> skipBlock(StudyBlock b) =>
      _reschedule(b, date: b.date.add(const Duration(days: 1)));

  /// Commits a single-block edit (streams to Home via `watchBlocks`), then
  /// refreshes the "Why this plan" reasoning. The move never depends on the AI
  /// call succeeding.
  Future<void> _reschedule(
    StudyBlock b, {
    String? startTime,
    int? durationMinutes,
    DateTime? date,
  }) async {
    try {
      await PlanRepo.ins.updateBlock({
        'id': b.id,
        'startTime': ?startTime,
        'durationMinutes': ?durationMinutes,
        if (date != null) 'date': date.toIso8601String(),
      });
      await _refreshReasoning();
    } on Fault catch (e) {
      emit(state.copyWith(reasoning: state.reasoning.toFailed(fault: e)));
    }
  }

  /// Marks [b] done and records a [SessionMetric] for it.
  Future<void> markBlockDone(StudyBlock b) async {
    await PlanRepo.ins.updateBlock({
      'id': b.id,
      'status': BlockStatus.done.name,
    });
    final userId = _watchingUserId;
    if (userId == null) return;
    await PlanRepo.ins.recordSession({
      'userId': userId,
      'date': DateTime.now().toIso8601String(),
      'durationMinutes': b.durationMinutes,
      'topicIds': [?b.topicId],
    });
    // Completing a focus block counts toward today's study streak (same-day
    // no-op if a quiz already counted today). Best-effort — never block the UI.
    try {
      await ProgressRepo.ins.recordStudyActivity(userId: userId);
    } on Fault {
      // Streak is non-critical — a failure must not undo "mark done".
    }
  }

  /// Rewrites + persists the reasoning paragraph, mirroring it into the live
  /// `schedule`/`week` so the "Why this plan" card updates without a re-watch.
  /// On failure the prior reasoning stays put — the block move still stands.
  Future<void> _refreshReasoning() async {
    final userId = _watchingUserId;
    if (userId == null) return;
    emit(state.copyWith(reasoning: state.reasoning.toLoading()));
    try {
      final text = await PlanRepo.ins.updateReasoning(userId);
      final week = state.week.data;
      emit(
        state.copyWith(
          reasoning: state.reasoning.toSuccess(data: text),
          schedule: state.schedule?.copyWith(aiReasoning: text),
          week: week == null
              ? state.week
              : state.week.toSuccess(data: week.copyWith(aiReasoning: text)),
        ),
      );
    } on Fault catch (e) {
      // Keep prior reasoning — the move still stands.
      emit(state.copyWith(reasoning: state.reasoning.toFailed(fault: e)));
    }
  }

  // --- convenience getters for the UI ------------------------------------

  WeekPlan? get week => state.week.data;

  /// Today's day plan within the watched week, if present.
  DayPlan? get today {
    final w = state.week.data;
    if (w == null) return null;
    for (final d in w.days) {
      if (d.isToday) return d;
    }
    return null;
  }

  /// The nearest upcoming exam across the week (soonest first), or null.
  Exam? get nextExam {
    final upcoming = _exams.where((e) => e.daysUntil >= 0).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  @override
  Future<void> close() {
    _blocksSub?.cancel();
    return super.close();
  }

  void reset() {
    _blocksSub?.cancel();
    _blocksSub = null;
    _watchingUserId = null;
    _exams = const [];
    emit(PlanState.def());
  }
}
