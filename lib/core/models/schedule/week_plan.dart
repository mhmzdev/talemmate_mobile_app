import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taleemmate/core/models/schedule/day_plan.dart';

part 'week_plan.freezed.dart';
part 'week_plan.g.dart';

@freezed
sealed class WeekPlan with _$WeekPlan {
  const WeekPlan._();

  const factory WeekPlan({
    required String id,
    required String scheduleId,
    required DateTime startDate,
    required DateTime endDate,
    @Default([]) List<DayPlan> days,
    String? aiReasoning,
  }) = _WeekPlan;

  factory WeekPlan.fromJson(Map<String, Object?> json) =>
      _$WeekPlanFromJson(json);
}
