// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionMetric _$SessionMetricFromJson(Map<String, dynamic> json) =>
    _SessionMetric(
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      topicIds:
          (json['topicIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SessionMetricToJson(_SessionMetric instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'topicIds': instance.topicIds,
    };
