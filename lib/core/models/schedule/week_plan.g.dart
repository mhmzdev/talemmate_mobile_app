// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'week_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeekPlan _$WeekPlanFromJson(Map<String, dynamic> json) => _WeekPlan(
  id: json['id'] as String,
  scheduleId: json['scheduleId'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  days:
      (json['days'] as List<dynamic>?)
          ?.map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  aiReasoning: json['aiReasoning'] as String?,
);

Map<String, dynamic> _$WeekPlanToJson(_WeekPlan instance) => <String, dynamic>{
  'id': instance.id,
  'scheduleId': instance.scheduleId,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'days': instance.days.map((e) => e.toJson()).toList(),
  'aiReasoning': instance.aiReasoning,
};
