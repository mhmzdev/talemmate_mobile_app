// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Schedule _$ScheduleFromJson(Map<String, dynamic> json) => _Schedule(
  id: json['id'] as String,
  userId: json['userId'] as String,
  dailyTargetHours: (json['dailyTargetHours'] as num).toDouble(),
  enabledWindowIds:
      (json['enabledWindowIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  weekStartDate: json['weekStartDate'] == null
      ? null
      : DateTime.parse(json['weekStartDate'] as String),
  isAIGenerated: json['isAIGenerated'] as bool? ?? true,
);

Map<String, dynamic> _$ScheduleToJson(_Schedule instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'dailyTargetHours': instance.dailyTargetHours,
  'enabledWindowIds': instance.enabledWindowIds,
  'weekStartDate': instance.weekStartDate?.toIso8601String(),
  'isAIGenerated': instance.isAIGenerated,
};
