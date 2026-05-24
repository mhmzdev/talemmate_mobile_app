import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taleemmate/core/models/quiz/quiz_question.dart';

part 'quiz.freezed.dart';
part 'quiz.g.dart';

@freezed
sealed class Quiz with _$Quiz {
  const Quiz._();

  const factory Quiz({
    required String id,
    required String subjectId,
    required int currentQuestionIndex,
    @Default([]) List<QuizQuestion> questions,
    String? topicId,
    String? sourceLabel,
    @Default(true) bool isAIGenerated,
  }) = _Quiz;

  factory Quiz.fromJson(Map<String, Object?> json) =>
      _$QuizFromJson(json);

  int get questionCount => questions.length;
}
