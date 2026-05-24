// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProgressMetric _$ProgressMetricFromJson(Map<String, dynamic> json) =>
    _ProgressMetric(
      userId: json['userId'] as String,
      subjectId: json['subjectId'] as String,
      readinessScore: (json['readinessScore'] as num).toInt(),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
      predictedScoreRange: json['predictedScoreRange'] == null
          ? null
          : ScoreRange.fromJson(
              json['predictedScoreRange'] as Map<String, dynamic>,
            ),
      weeklyGain: (json['weeklyGain'] as num?)?.toInt(),
      aiInsight: json['aiInsight'] as String?,
    );

Map<String, dynamic> _$ProgressMetricToJson(_ProgressMetric instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'subjectId': instance.subjectId,
      'readinessScore': instance.readinessScore,
      'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
      'predictedScoreRange': instance.predictedScoreRange,
      'weeklyGain': instance.weeklyGain,
      'aiInsight': instance.aiInsight,
    };
