import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:taleemmate/core/db/database.dart';
import 'package:taleemmate/repos/progress/streak_math.dart';
import 'package:taleemmate/services/firebase/ai/ai_service.dart';
import 'package:taleemmate/services/firebase/ai/system_prompts.dart';
import 'package:taleemmate/services/fault/faults.dart';

part 'progress_mocks.dart';
part 'progress_parser.dart';
part 'progress_data_provider.dart';

/// Drift + Gemini backed repo for the Progress dashboard (ADR-013): public
/// methods take/return `Map`/`List<Map>`/primitives only — `ProgressCubit` does
/// the `Model.fromJson` conversion and assembles the view-model.
class ProgressRepo {
  static ProgressRepo _instance = ProgressRepo._();
  ProgressRepo._();

  static ProgressRepo get ins => _instance;

  /// Swaps the singleton for a mock in tests (see docs/TESTING.md). Never call
  /// from production code.
  @visibleForTesting
  static set ins(ProgressRepo repo) => _instance = repo;

  /// --- repo functions --- ///

  /// Live per-subject readiness metrics for [userId], as
  /// `ProgressMetric.toJson()`-shaped maps. Re-emits when the AI pass upserts.
  Stream<List<Map<String, dynamic>>> watchMetrics(String userId) =>
      _ProgressProvider.watchMetrics(userId);

  /// The deterministic snapshot the dashboard needs in one shot: `streak`
  /// (a `StudyStreak.toJson()` map or null), `dailyScores`, `sessionMetrics`,
  /// `subjects`, `exams` (lists of maps), plus `quizCount` / `questionCount`.
  Future<Map<String, dynamic>> dashboardData(String userId) =>
      _ProgressProvider.dashboardData(userId);

  /// Records one completed quiz: writes a `DailyScore` of `round(score/total*100)`
  /// then bumps the study streak for [date]. Best-effort.
  Future<void> recordQuizScore({
    required String userId,
    required String subjectId,
    required int score,
    required int total,
    required DateTime date,
  }) => _ProgressProvider.recordQuizScore(
    userId: userId,
    subjectId: subjectId,
    score: score,
    total: total,
    date: date,
  );

  /// Bumps the study streak for [date] (defaults to today): same-day no-op,
  /// consecutive-day +1, otherwise reset to 1.
  Future<void> recordStudyActivity({required String userId, DateTime? date}) =>
      _ProgressProvider.recordStudyActivity(userId: userId, date: date);

  /// Runs the AI readiness pass — upserts a `ProgressMetric` per subject and
  /// returns the global `studyInsight` (the cubit holds it; it isn't persisted).
  /// Throws a [Fault] on AI failure; the caller keeps the deterministic data.
  Future<String?> refreshReadiness(String userId) =>
      _ProgressProvider.refreshReadiness(userId);
}
