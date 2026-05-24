import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taleemmate/core/models/library/library_item.dart';
import 'package:taleemmate/core/models/schedule/schedule.dart';
import 'package:taleemmate/core/models/subject/exam.dart';
import 'package:taleemmate/core/models/subject/subject.dart';

part 'onboarding_data.freezed.dart';
part 'onboarding_data.g.dart';

@freezed
sealed class OnboardingData with _$OnboardingData {
  const OnboardingData._();

  const factory OnboardingData({
    required String userId,
    @Default(1) int step,
    @Default([]) List<Subject> subjects,
    @Default([]) List<Exam> exams,
    String? institution,
    Schedule? schedule,
    @Default([]) List<LibraryItem> uploadedMaterials,
  }) = _OnboardingData;

  factory OnboardingData.fromJson(Map<String, Object?> json) =>
      _$OnboardingDataFromJson(json);
}
