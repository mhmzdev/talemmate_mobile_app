import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:taleemmate/core/db/database.dart';
import 'package:taleemmate/core/models/quiz/quiz_question.dart';
import 'package:taleemmate/services/firebase/ai/ai_service.dart';
import 'package:taleemmate/services/firebase/ai/system_prompts.dart';
import 'package:taleemmate/services/fault/faults.dart';
import 'package:uuid/uuid.dart';

part 'quiz_mocks.dart';
part 'quiz_parser.dart';
part 'quiz_data_provider.dart';

/// Drift + Gemini backed repo for single-answer MCQ quiz generation (ADR-013):
/// public methods take/return `Map`/`List<Map>`/primitives only — `QuizCubit`
/// does the `Quiz.fromJson` conversion.
class QuizRepo {
  static QuizRepo _instance = QuizRepo._();
  QuizRepo._();

  static QuizRepo get ins => _instance;

  /// Swaps the singleton for a mock in tests (see docs/TESTING.md). Never call
  /// from production code.
  @visibleForTesting
  static set ins(QuizRepo repo) => _instance = repo;

  /// --- repo functions --- ///

  /// Generates a fresh single-answer MCQ quiz for the given subject (optionally
  /// scoped to a topic). [sourceItemIds] grounds the quiz on specific library
  /// materials — one, several, or null/empty to use every indexed material in
  /// the subject. Persists the quiz + questions and returns a
  /// `Quiz.toJson()`-shaped map with nested `questions`. Throws a [Fault] on
  /// failure.
  Future<Map<String, dynamic>> generate({
    required String userId,
    required String subjectId,
    String? topicId,
    List<String>? sourceItemIds,
  }) => _QuizProvider.generate(
    userId: userId,
    subjectId: subjectId,
    topicId: topicId,
    sourceItemIds: sourceItemIds,
  );

  /// Records one answered question. [attempt] is a `QuizAttempt.toJson()`-shaped
  /// map (`id`, `quizId`, `userId`, `questionId`, `timestamp`,
  /// `selectedAnswerIndex`, `isCorrect`).
  Future<void> recordAnswer(Map<String, dynamic> attempt) =>
      _QuizProvider.recordAnswer(attempt);

  /// A persisted quiz with its questions as a `Quiz.toJson()`-shaped map, or
  /// null. Kept thin — used for reload.
  Future<Map<String, dynamic>?> quiz(String quizId) =>
      _QuizProvider.quiz(quizId);
}
