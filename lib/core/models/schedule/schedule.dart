import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule.freezed.dart';
part 'schedule.g.dart';

@freezed
sealed class Schedule with _$Schedule {
  const Schedule._();

  const factory Schedule({
    required String id,
    required String userId,
    required double dailyTargetHours,
    @Default([]) List<String> enabledWindowIds,
    DateTime? weekStartDate,
    String? aiReasoning,
    @Default(true) bool isAIGenerated,
  }) = _Schedule;

  factory Schedule.fromJson(Map<String, Object?> json) =>
      _$ScheduleFromJson(json);
}
