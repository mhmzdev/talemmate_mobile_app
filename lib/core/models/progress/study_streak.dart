import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_streak.freezed.dart';
part 'study_streak.g.dart';

@freezed
sealed class StudyStreak with _$StudyStreak {
  const StudyStreak._();

  const factory StudyStreak({
    required String userId,
    required int dayCount,
    required DateTime lastStudiedDate,
    required DateTime startDate,
  }) = _StudyStreak;

  factory StudyStreak.fromJson(Map<String, Object?> json) =>
      _$StudyStreakFromJson(json);
}
