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
