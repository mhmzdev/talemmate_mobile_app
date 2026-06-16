part of '../database.dart';

@DriftAccessor(tables: [Subjects, Topics, Exams])
class SubjectDao extends DatabaseAccessor<AppDatabase> with _$SubjectDaoMixin {
  SubjectDao(super.db);

  Stream<List<SubjectRow>> watchAll() =>
      (select(subjects)..orderBy([(s) => OrderingTerm.asc(s.order)])).watch();

  Stream<List<TopicRow>> watchBySubject(String subjectId) =>
      (select(topics)..where((t) => t.subjectId.equals(subjectId))).watch();

  Stream<List<ExamRow>> watchExams() =>
      (select(exams)..orderBy([(e) => OrderingTerm.asc(e.date)])).watch();

  /// One-shot read of all subjects, ordered. Used for Library grouping headers.
  Future<List<SubjectRow>> getAll() =>
      (select(subjects)..orderBy([(s) => OrderingTerm.asc(s.order)])).get();

  /// One-shot read of a single user's subjects, ordered (ADR-014). Subjects are
  /// per-account, so callers must scope by the session uid — never [getAll].
  Future<List<SubjectRow>> getByUser(String userId) =>
      (select(subjects)
            ..where((s) => s.userId.equals(userId))
            ..orderBy([(s) => OrderingTerm.asc(s.order)]))
          .get();

  /// One-shot read of a single user's exams, soonest first (ADR-014).
  Future<List<ExamRow>> getExamsByUser(String userId) =>
      (select(exams)
            ..where((e) => e.userId.equals(userId))
            ..orderBy([(e) => OrderingTerm.asc(e.date)]))
          .get();

  Future<void> upsertSubject(SubjectsCompanion companion) =>
      into(subjects).insertOnConflictUpdate(companion);

  Future<void> upsertTopic(TopicsCompanion companion) =>
      into(topics).insertOnConflictUpdate(companion);

  Future<void> upsertExam(ExamsCompanion companion) =>
      into(exams).insertOnConflictUpdate(companion);

  Future<int> deleteSubject(String id) =>
      (delete(subjects)..where((s) => s.id.equals(id))).go();

  Future<int> deleteTopic(String id) =>
      (delete(topics)..where((t) => t.id.equals(id))).go();

  Future<int> deleteExam(String id) =>
      (delete(exams)..where((e) => e.id.equals(id))).go();
}
