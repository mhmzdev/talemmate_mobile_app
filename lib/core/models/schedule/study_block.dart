import 'package:freezed_annotation/freezed_annotation.dart';

part 'study_block.freezed.dart';
part 'study_block.g.dart';

enum BlockStatus { done, now, upcoming }

@freezed
sealed class StudyBlock with _$StudyBlock {
  const StudyBlock._();

  const factory StudyBlock({
    required String id,
    required String scheduleId,
    required int dayOfWeek,
    required DateTime date,
    required String startTime,
    required int durationMinutes,
    required String subjectId,
    required String title,
    required String activities,
    required BlockStatus status,
    String? topicId,
    String? aiInsight,
    @Default(false) bool isAIGenerated,
  }) = _StudyBlock;

  factory StudyBlock.fromJson(Map<String, Object?> json) =>
      _$StudyBlockFromJson(json);
}
