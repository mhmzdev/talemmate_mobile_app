// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Exam _$ExamFromJson(Map<String, dynamic> json) => _Exam(
  id: json['id'] as String,
  subjectId: json['subjectId'] as String,
  date: DateTime.parse(json['date'] as String),
  label: json['label'] as String?,
);

Map<String, dynamic> _$ExamToJson(_Exam instance) => <String, dynamic>{
  'id': instance.id,
  'subjectId': instance.subjectId,
  'date': instance.date.toIso8601String(),
  'label': instance.label,
};
