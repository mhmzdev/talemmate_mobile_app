// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_attempt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizAttempt _$QuizAttemptFromJson(Map<String, dynamic> json) => _QuizAttempt(
  id: json['id'] as String,
  quizId: json['quizId'] as String,
  userId: json['userId'] as String,
  questionId: json['questionId'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  selectedAnswerIndex: (json['selectedAnswerIndex'] as num?)?.toInt(),
  isCorrect: json['isCorrect'] as bool?,
);

Map<String, dynamic> _$QuizAttemptToJson(_QuizAttempt instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quizId': instance.quizId,
      'userId': instance.userId,
      'questionId': instance.questionId,
      'timestamp': instance.timestamp.toIso8601String(),
      'selectedAnswerIndex': instance.selectedAnswerIndex,
      'isCorrect': instance.isCorrect,
    };
