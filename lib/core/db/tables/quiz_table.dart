import 'package:drift/drift.dart';
import 'package:taleemmate/core/models/quiz/quiz_question.dart';

import '../converters.dart';
import 'subjects_table.dart';

@DataClassName('QuizRow')
class Quizzes extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text().references(Subjects, #id)();
  TextColumn get topicId => text().references(Topics, #id).nullable()();
  IntColumn get currentQuestionIndex => integer()();
  TextColumn get sourceLabel => text().nullable()();
  BoolColumn get isAIGenerated => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('QuizQuestionRow')
class QuizQuestions extends Table {
  TextColumn get id => text()();
  TextColumn get quizId => text().references(Quizzes, #id)();
  IntColumn get index => integer()();
  TextColumn get content => text()();
  TextColumn get type =>
      text().map(const EnumConverter<QuestionType>(QuestionType.values))();
  IntColumn get markValue => integer()();
  TextColumn get options => text().map(const StringListConverter())();
  IntColumn get correctAnswerIndex => integer().nullable()();
  IntColumn get timeLimit => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('QuizAttemptRow')
class QuizAttempts extends Table {
  TextColumn get id => text()();
  TextColumn get quizId => text().references(Quizzes, #id)();
  TextColumn get userId => text()();
  TextColumn get questionId => text().references(QuizQuestions, #id)();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get selectedAnswerIndex => integer().nullable()();
  BoolColumn get isCorrect => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('QuizFeedbackRow')
class QuizFeedbackItems extends Table {
  TextColumn get id => text()();
  TextColumn get attemptId => text().references(QuizAttempts, #id)();
  TextColumn get questionId => text().references(QuizQuestions, #id)();
  BoolColumn get isCorrect => boolean()();
  TextColumn get feedbackText => text()();
  TextColumn get explanation => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
