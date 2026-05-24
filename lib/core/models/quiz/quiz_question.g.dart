// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) =>
    _QuizQuestion(
      id: json['id'] as String,
      quizId: json['quizId'] as String,
      index: (json['index'] as num).toInt(),
      text: json['text'] as String,
      type: $enumDecode(_$QuestionTypeEnumMap, json['type']),
      markValue: (json['markValue'] as num).toInt(),
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      correctAnswerIndex: (json['correctAnswerIndex'] as num?)?.toInt(),
      timeLimit: (json['timeLimit'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QuizQuestionToJson(_QuizQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quizId': instance.quizId,
      'index': instance.index,
      'text': instance.text,
      'type': _$QuestionTypeEnumMap[instance.type]!,
      'markValue': instance.markValue,
      'options': instance.options,
      'correctAnswerIndex': instance.correctAnswerIndex,
      'timeLimit': instance.timeLimit,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.singleAnswer: 'singleAnswer',
  QuestionType.multipleAnswer: 'multipleAnswer',
  QuestionType.shortAnswer: 'shortAnswer',
};
