// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Subject _$SubjectFromJson(Map<String, dynamic> json) => _Subject(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  colorHex: json['colorHex'] as String,
  confidenceLevel: (json['confidenceLevel'] as num).toDouble(),
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SubjectToJson(_Subject instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'colorHex': instance.colorHex,
  'confidenceLevel': instance.confidenceLevel,
  'order': instance.order,
};
