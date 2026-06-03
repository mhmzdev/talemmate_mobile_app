// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizHistory _$QuizHistoryFromJson(Map<String, dynamic> json) => _QuizHistory(
  userId: json['userId'] as String,
  totalQuizzesAttempted: (json['totalQuizzesAttempted'] as num).toInt(),
  totalQuestionsAnswered: (json['totalQuestionsAnswered'] as num).toInt(),
  attempts:
      (json['attempts'] as List<dynamic>?)
          ?.map((e) => QuizAttempt.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  scoreHistory:
      (json['scoreHistory'] as List<dynamic>?)
          ?.map((e) => DailyScore.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$QuizHistoryToJson(_QuizHistory instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'totalQuizzesAttempted': instance.totalQuizzesAttempted,
      'totalQuestionsAnswered': instance.totalQuestionsAnswered,
      'attempts': instance.attempts.map((e) => e.toJson()).toList(),
      'scoreHistory': instance.scoreHistory.map((e) => e.toJson()).toList(),
    };
