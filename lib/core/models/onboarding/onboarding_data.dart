import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taleemmate/core/models/library/library_item.dart';
import 'package:taleemmate/core/models/schedule/schedule.dart';
import 'package:taleemmate/core/models/subject/exam.dart';
import 'package:taleemmate/core/models/subject/subject.dart';

part 'onboarding_data.freezed.dart';
part 'onboarding_data.g.dart';

enum EducationLevel { oALevels, matricFSc, undergraduate, masters }

extension EducationLevelX on EducationLevel {
  bool get isUndergraduate => this == .undergraduate;
  bool get isMasters => this == .masters;
  bool get hasYear => isUndergraduate || isMasters;

  String get displayName => switch (this) {
    .oALevels => 'O / A Levels',
    .matricFSc => 'Matric / FSc',
    .undergraduate => 'Undergraduate',
    .masters => "Master's",
  };
}

enum OnboardingGoal { passExams, understand, studyDaily }

extension OnboardingGoalX on OnboardingGoal {
  bool get isPassExams => this == .passExams;
  bool get isUnderstand => this == .understand;
  bool get isStudyDaily => this == .studyDaily;
}

@freezed
sealed class OnboardingData with _$OnboardingData {
  const OnboardingData._();

  const factory OnboardingData({
    required String userId,
    @Default(1) int step,
    @Default('') String name,
    @Default(EducationLevel.undergraduate) EducationLevel educationLevel,
    String? year,
    @Default(OnboardingGoal.passExams) OnboardingGoal goal,
    @Default([]) List<Subject> subjects,
    @Default([]) List<Exam> exams,
    String? institution,
    Schedule? schedule,
    @Default([]) List<LibraryItem> uploadedMaterials,
  }) = _OnboardingData;

  factory OnboardingData.fromJson(Map<String, Object?> json) =>
      _$OnboardingDataFromJson(json);
}
