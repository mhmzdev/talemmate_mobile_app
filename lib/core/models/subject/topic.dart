import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

enum TrendType { up, down, flat }

@freezed
sealed class Topic with _$Topic {
  const Topic._();

  const factory Topic({
    required String id,
    required String subjectId,
    required String name,
    required int masteryPercentage,
    required TrendType trend,
    @Default(false) bool isWeak,
  }) = _Topic;

  factory Topic.fromJson(Map<String, Object?> json) =>
      _$TopicFromJson(json);
}
