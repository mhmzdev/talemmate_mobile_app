import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';
import 'package:taleemmate/core/models/subject/exam.dart';

part 'day_plan.freezed.dart';
part 'day_plan.g.dart';

@freezed
sealed class DayPlan with _$DayPlan {
  const DayPlan._();

  const factory DayPlan({
    required DateTime date,
    @Default([]) List<StudyBlock> blocks,
    Exam? exam,
    @Default(false) bool isDone,
  }) = _DayPlan;

  factory DayPlan.fromJson(Map<String, Object?> json) =>
      _$DayPlanFromJson(json);

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  int get totalDurationMinutes =>
      blocks.fold(0, (sum, b) => sum + b.durationMinutes);
}
