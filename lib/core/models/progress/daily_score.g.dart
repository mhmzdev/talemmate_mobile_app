// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyScore _$DailyScoreFromJson(Map<String, dynamic> json) => _DailyScore(
  date: DateTime.parse(json['date'] as String),
  score: (json['score'] as num).toInt(),
  topicId: json['topicId'] as String?,
);

Map<String, dynamic> _$DailyScoreToJson(_DailyScore instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'score': instance.score,
      'topicId': instance.topicId,
    };
