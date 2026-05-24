// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizFeedback _$QuizFeedbackFromJson(Map<String, dynamic> json) =>
    _QuizFeedback(
      id: json['id'] as String,
      attemptId: json['attemptId'] as String,
      questionId: json['questionId'] as String,
      isCorrect: json['isCorrect'] as bool,
      feedbackText: json['feedbackText'] as String,
      explanation: json['explanation'] as String?,
    );

Map<String, dynamic> _$QuizFeedbackToJson(_QuizFeedback instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attemptId': instance.attemptId,
      'questionId': instance.questionId,
      'isCorrect': instance.isCorrect,
      'feedbackText': instance.feedbackText,
      'explanation': instance.explanation,
    };
