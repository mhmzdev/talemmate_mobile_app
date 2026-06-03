// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Quiz _$QuizFromJson(Map<String, dynamic> json) => _Quiz(
  id: json['id'] as String,
  subjectId: json['subjectId'] as String,
  currentQuestionIndex: (json['currentQuestionIndex'] as num).toInt(),
  questions:
      (json['questions'] as List<dynamic>?)
          ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  topicId: json['topicId'] as String?,
  sourceLabel: json['sourceLabel'] as String?,
  isAIGenerated: json['isAIGenerated'] as bool? ?? true,
);

Map<String, dynamic> _$QuizToJson(_Quiz instance) => <String, dynamic>{
  'id': instance.id,
  'subjectId': instance.subjectId,
  'currentQuestionIndex': instance.currentQuestionIndex,
  'questions': instance.questions.map((e) => e.toJson()).toList(),
  'topicId': instance.topicId,
  'sourceLabel': instance.sourceLabel,
  'isAIGenerated': instance.isAIGenerated,
};
