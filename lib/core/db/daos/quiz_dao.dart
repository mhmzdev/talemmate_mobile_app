part of '../database.dart';

@DriftAccessor(tables: [Quizzes, QuizQuestions, QuizAttempts, QuizFeedbackItems])
class QuizDao extends DatabaseAccessor<AppDatabase> with _$QuizDaoMixin {
  QuizDao(super.db);

  Future<QuizRow?> findById(String id) =>
      (select(quizzes)..where((q) => q.id.equals(id))).getSingleOrNull();

  Future<List<QuizQuestionRow>> questionsForQuiz(String quizId) =>
      (select(quizQuestions)
            ..where((q) => q.quizId.equals(quizId))
            ..orderBy([(q) => OrderingTerm.asc(q.index)]))
          .get();

  Future<List<QuizAttemptRow>> attemptsForUser(String userId) =>
      (select(quizAttempts)
            ..where((a) => a.userId.equals(userId))
            ..orderBy([(a) => OrderingTerm.desc(a.timestamp)]))
          .get();

  Future<QuizFeedbackRow?> feedbackForAttempt(String attemptId) =>
      (select(quizFeedbackItems)
            ..where((f) => f.attemptId.equals(attemptId)))
          .getSingleOrNull();

  Future<void> upsertQuiz(QuizzesCompanion companion) =>
      into(quizzes).insertOnConflictUpdate(companion);

  Future<void> upsertQuestion(QuizQuestionsCompanion companion) =>
      into(quizQuestions).insertOnConflictUpdate(companion);

  Future<void> insertAttempt(QuizAttemptsCompanion companion) =>
      into(quizAttempts).insertOnConflictUpdate(companion);

  Future<void> insertFeedback(QuizFeedbackItemsCompanion companion) =>
      into(quizFeedbackItems).insertOnConflictUpdate(companion);
}
