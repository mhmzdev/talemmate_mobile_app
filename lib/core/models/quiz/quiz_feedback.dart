import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_feedback.freezed.dart';
part 'quiz_feedback.g.dart';

@freezed
sealed class QuizFeedback with _$QuizFeedback {
  const QuizFeedback._();

  const factory QuizFeedback({
    required String id,
    required String attemptId,
    required String questionId,
    required bool isCorrect,
    required String feedbackText,
    String? explanation,
  }) = _QuizFeedback;

  factory QuizFeedback.fromJson(Map<String, Object?> json) =>
      _$QuizFeedbackFromJson(json);
}
