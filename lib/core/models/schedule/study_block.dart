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

extension StudyBlockStatus on StudyBlock {
  /// Effective display status. A **manual** completion (stored `status == done`,
  /// written by the Focus session's "Mark block done") is authoritative and
  /// sticks regardless of the clock. Otherwise the status is derived from device
  /// time vs the block's window (`date` + `startTime` + `durationMinutes`).
  /// UIs should read this, not the raw stored value.
  BlockStatus effectiveStatus([DateTime? now]) {
    if (status == BlockStatus.done) return BlockStatus.done;
    final clock = now ?? DateTime.now();
    final start = startDateTime;
    final end = start.add(Duration(minutes: durationMinutes));
    if (clock.isAfter(end)) return BlockStatus.done;
    if (!clock.isBefore(start)) return BlockStatus.now;
    return BlockStatus.upcoming;
  }

  /// The block's start as a full [DateTime] (its `date` at `startTime`).
  DateTime get startDateTime {
    final parts = startTime.split(':');
    final h = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(date.year, date.month, date.day, h, m);
  }
}
