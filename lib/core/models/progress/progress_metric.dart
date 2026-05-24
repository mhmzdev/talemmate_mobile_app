import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taleemmate/core/models/progress/score_range.dart';

part 'progress_metric.freezed.dart';
part 'progress_metric.g.dart';

@freezed
sealed class ProgressMetric with _$ProgressMetric {
  const ProgressMetric._();

  const factory ProgressMetric({
    required String userId,
    required String subjectId,
    required int readinessScore,
    required DateTime lastUpdatedAt,
    ScoreRange? predictedScoreRange,
    int? weeklyGain,
    String? aiInsight,
  }) = _ProgressMetric;

  factory ProgressMetric.fromJson(Map<String, Object?> json) =>
      _$ProgressMetricFromJson(json);
}
