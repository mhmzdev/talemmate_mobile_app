// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_window.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudyWindow _$StudyWindowFromJson(Map<String, dynamic> json) => _StudyWindow(
  id: json['id'] as String,
  label: json['label'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  isEnabled: json['isEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$StudyWindowToJson(_StudyWindow instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isEnabled': instance.isEnabled,
    };
