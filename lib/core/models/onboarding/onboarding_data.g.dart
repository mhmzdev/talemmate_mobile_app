// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingData _$OnboardingDataFromJson(Map<String, dynamic> json) =>
    _OnboardingData(
      userId: json['userId'] as String,
      step: (json['step'] as num?)?.toInt() ?? 1,
      subjects:
          (json['subjects'] as List<dynamic>?)
              ?.map((e) => Subject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      exams:
          (json['exams'] as List<dynamic>?)
              ?.map((e) => Exam.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      institution: json['institution'] as String?,
      schedule: json['schedule'] == null
          ? null
          : Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
      uploadedMaterials:
          (json['uploadedMaterials'] as List<dynamic>?)
              ?.map((e) => LibraryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OnboardingDataToJson(_OnboardingData instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'step': instance.step,
      'subjects': instance.subjects,
      'exams': instance.exams,
      'institution': instance.institution,
      'schedule': instance.schedule,
      'uploadedMaterials': instance.uploadedMaterials,
    };
