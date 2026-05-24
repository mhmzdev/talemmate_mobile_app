import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_attempt.freezed.dart';
part 'quiz_attempt.g.dart';

@freezed
sealed class QuizAttempt with _$QuizAttempt {
  const QuizAttempt._();

  const factory QuizAttempt({
    required String id,
    required String quizId,
    required String userId,
    required String questionId,
    required DateTime timestamp,
    int? selectedAnswerIndex,
    bool? isCorrect,
  }) = _QuizAttempt;

  factory QuizAttempt.fromJson(Map<String, Object?> json) =>
      _$QuizAttemptFromJson(json);
}
