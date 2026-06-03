// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DayPlan _$DayPlanFromJson(Map<String, dynamic> json) => _DayPlan(
  date: DateTime.parse(json['date'] as String),
  blocks:
      (json['blocks'] as List<dynamic>?)
          ?.map((e) => StudyBlock.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  exam: json['exam'] == null
      ? null
      : Exam.fromJson(json['exam'] as Map<String, dynamic>),
  isDone: json['isDone'] as bool? ?? false,
);

Map<String, dynamic> _$DayPlanToJson(_DayPlan instance) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'blocks': instance.blocks.map((e) => e.toJson()).toList(),
  'exam': instance.exam?.toJson(),
  'isDone': instance.isDone,
};
