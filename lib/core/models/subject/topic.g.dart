// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Topic _$TopicFromJson(Map<String, dynamic> json) => _Topic(
  id: json['id'] as String,
  subjectId: json['subjectId'] as String,
  name: json['name'] as String,
  masteryPercentage: (json['masteryPercentage'] as num).toInt(),
  trend: $enumDecode(_$TrendTypeEnumMap, json['trend']),
  isWeak: json['isWeak'] as bool? ?? false,
);

Map<String, dynamic> _$TopicToJson(_Topic instance) => <String, dynamic>{
  'id': instance.id,
  'subjectId': instance.subjectId,
  'name': instance.name,
  'masteryPercentage': instance.masteryPercentage,
  'trend': _$TrendTypeEnumMap[instance.trend]!,
  'isWeak': instance.isWeak,
};

const _$TrendTypeEnumMap = {
  TrendType.up: 'up',
  TrendType.down: 'down',
  TrendType.flat: 'flat',
};
