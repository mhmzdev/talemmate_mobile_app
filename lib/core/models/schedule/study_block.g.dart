// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudyBlock _$StudyBlockFromJson(Map<String, dynamic> json) => _StudyBlock(
  id: json['id'] as String,
  scheduleId: json['scheduleId'] as String,
  dayOfWeek: (json['dayOfWeek'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  startTime: json['startTime'] as String,
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  subjectId: json['subjectId'] as String,
  title: json['title'] as String,
  activities: json['activities'] as String,
  status: $enumDecode(_$BlockStatusEnumMap, json['status']),
  topicId: json['topicId'] as String?,
  aiInsight: json['aiInsight'] as String?,
  isAIGenerated: json['isAIGenerated'] as bool? ?? false,
);

Map<String, dynamic> _$StudyBlockToJson(_StudyBlock instance) =>
    <String, dynamic>{
      'id': instance.id,
      'scheduleId': instance.scheduleId,
      'dayOfWeek': instance.dayOfWeek,
      'date': instance.date.toIso8601String(),
      'startTime': instance.startTime,
      'durationMinutes': instance.durationMinutes,
      'subjectId': instance.subjectId,
      'title': instance.title,
      'activities': instance.activities,
      'status': _$BlockStatusEnumMap[instance.status]!,
      'topicId': instance.topicId,
      'aiInsight': instance.aiInsight,
      'isAIGenerated': instance.isAIGenerated,
    };

const _$BlockStatusEnumMap = {
  BlockStatus.done: 'done',
  BlockStatus.now: 'now',
  BlockStatus.upcoming: 'upcoming',
};
