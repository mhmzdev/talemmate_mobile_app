import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_question.freezed.dart';
part 'quiz_question.g.dart';

enum QuestionType { singleAnswer, multipleAnswer, shortAnswer }

@freezed
sealed class QuizQuestion with _$QuizQuestion {
  const QuizQuestion._();

  const factory QuizQuestion({
    required String id,
    required String quizId,
    required int index,
    required String text,
    required QuestionType type,
    required int markValue,
    @Default([]) List<String> options,
    int? correctAnswerIndex,
    int? timeLimit,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, Object?> json) =>
      _$QuizQuestionFromJson(json);
}
