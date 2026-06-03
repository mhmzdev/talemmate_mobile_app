// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnboardingData _$OnboardingDataFromJson(Map<String, dynamic> json) =>
    _OnboardingData(
      userId: json['userId'] as String,
      step: (json['step'] as num?)?.toInt() ?? 1,
      name: json['name'] as String? ?? '',
      educationLevel:
          $enumDecodeNullable(
            _$EducationLevelEnumMap,
            json['educationLevel'],
          ) ??
          EducationLevel.undergraduate,
      year: json['year'] as String?,
      goal:
          $enumDecodeNullable(_$OnboardingGoalEnumMap, json['goal']) ??
          OnboardingGoal.passExams,
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
      'name': instance.name,
      'educationLevel': _$EducationLevelEnumMap[instance.educationLevel]!,
      'year': instance.year,
      'goal': _$OnboardingGoalEnumMap[instance.goal]!,
      'subjects': instance.subjects.map((e) => e.toJson()).toList(),
      'exams': instance.exams.map((e) => e.toJson()).toList(),
      'institution': instance.institution,
      'schedule': instance.schedule?.toJson(),
      'uploadedMaterials': instance.uploadedMaterials
          .map((e) => e.toJson())
          .toList(),
    };

const _$EducationLevelEnumMap = {
  EducationLevel.oALevels: 'oALevels',
  EducationLevel.matricFSc: 'matricFSc',
  EducationLevel.undergraduate: 'undergraduate',
  EducationLevel.masters: 'masters',
};

const _$OnboardingGoalEnumMap = {
  OnboardingGoal.passExams: 'passExams',
  OnboardingGoal.understand: 'understand',
  OnboardingGoal.studyDaily: 'studyDaily',
};
