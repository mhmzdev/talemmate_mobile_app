// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_streak.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudyStreak _$StudyStreakFromJson(Map<String, dynamic> json) => _StudyStreak(
  userId: json['userId'] as String,
  dayCount: (json['dayCount'] as num).toInt(),
  lastStudiedDate: DateTime.parse(json['lastStudiedDate'] as String),
  startDate: DateTime.parse(json['startDate'] as String),
);

Map<String, dynamic> _$StudyStreakToJson(_StudyStreak instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'dayCount': instance.dayCount,
      'lastStudiedDate': instance.lastStudiedDate.toIso8601String(),
      'startDate': instance.startDate.toIso8601String(),
    };
