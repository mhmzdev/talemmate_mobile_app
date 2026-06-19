part of '../database.dart';

@DriftAccessor(
  tables: [ProgressMetrics, StudyStreaks, DailyScores, SessionMetrics],
)
class ProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ProgressDaoMixin {
  ProgressDao(super.db);

  Stream<List<ProgressMetricRow>> watchByUser(String userId) =>
      (select(progressMetrics)..where((p) => p.userId.equals(userId))).watch();

  Future<StudyStreakRow?> streakForUser(String userId) => (select(
    studyStreaks,
  )..where((s) => s.userId.equals(userId))).getSingleOrNull();

  Future<List<DailyScoreRow>> scoresForUser(
    String userId, {
    DateTime? since,
  }) {
    final query = select(dailyScores)..where((d) => d.userId.equals(userId));
    if (since != null) {
      query.where((d) => d.date.isBiggerOrEqualValue(since));
    }
    return (query..orderBy([(d) => OrderingTerm.asc(d.date)])).get();
  }

  Future<List<SessionMetricRow>> sessionMetricsForUser(
    String userId, {
    DateTime? since,
  }) {
    final query = select(sessionMetrics)..where((s) => s.userId.equals(userId));
    if (since != null) {
      query.where((s) => s.date.isBiggerOrEqualValue(since));
    }
    return (query..orderBy([(s) => OrderingTerm.asc(s.date)])).get();
  }

  Future<void> upsertMetric(ProgressMetricsCompanion companion) =>
      into(progressMetrics).insertOnConflictUpdate(companion);

  Future<void> upsertStreak(StudyStreaksCompanion companion) =>
      into(studyStreaks).insertOnConflictUpdate(companion);

  Future<void> insertDailyScore(DailyScoresCompanion companion) =>
      into(dailyScores).insert(companion);

  Future<void> insertSessionMetric(SessionMetricsCompanion companion) =>
      into(sessionMetrics).insert(companion);
}
