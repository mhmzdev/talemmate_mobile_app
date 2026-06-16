part of '../database.dart';

@DriftAccessor(tables: [StudyWindows, Schedules, StudyBlocks])
class ScheduleDao extends DatabaseAccessor<AppDatabase>
    with _$ScheduleDaoMixin {
  ScheduleDao(super.db);

  Future<List<StudyWindowRow>> allWindows() => select(studyWindows).get();

  Future<ScheduleRow?> findByUser(String userId) => (select(
    schedules,
  )..where((s) => s.userId.equals(userId))).getSingleOrNull();

  Stream<List<StudyBlockRow>> watchBlocksForDate(DateTime date) =>
      (select(studyBlocks)..where((b) => b.date.equals(date))).watch();

  Stream<List<StudyBlockRow>> watchBlocksForSchedule(String scheduleId) =>
      (select(studyBlocks)
            ..where((b) => b.scheduleId.equals(scheduleId))
            ..orderBy([
              (b) => OrderingTerm.asc(b.date),
              (b) => OrderingTerm.asc(b.startTime),
            ]))
          .watch();

  Future<void> upsertWindow(StudyWindowsCompanion companion) =>
      into(studyWindows).insertOnConflictUpdate(companion);

  Future<void> upsertSchedule(SchedulesCompanion companion) =>
      into(schedules).insertOnConflictUpdate(companion);

  Future<void> upsertBlock(StudyBlocksCompanion companion) =>
      into(studyBlocks).insertOnConflictUpdate(companion);

  Future<int> deleteBlock(String id) =>
      (delete(studyBlocks)..where((b) => b.id.equals(id))).go();

  Future<int> deleteBlocksForSchedule(String scheduleId) =>
      (delete(studyBlocks)..where((b) => b.scheduleId.equals(scheduleId))).go();
}
