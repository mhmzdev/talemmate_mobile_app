import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_score.freezed.dart';
part 'daily_score.g.dart';

@freezed
sealed class DailyScore with _$DailyScore {
  const DailyScore._();

  const factory DailyScore({
    required DateTime date,
    required int score,
    String? topicId,
  }) = _DailyScore;

  factory DailyScore.fromJson(Map<String, Object?> json) =>
      _$DailyScoreFromJson(json);
}
