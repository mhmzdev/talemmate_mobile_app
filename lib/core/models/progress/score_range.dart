import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_range.freezed.dart';
part 'score_range.g.dart';

@freezed
sealed class ScoreRange with _$ScoreRange {
  const ScoreRange._();

  const factory ScoreRange({
    required int min,
    required int max,
  }) = _ScoreRange;

  factory ScoreRange.fromJson(Map<String, Object?> json) =>
      _$ScoreRangeFromJson(json);
}
