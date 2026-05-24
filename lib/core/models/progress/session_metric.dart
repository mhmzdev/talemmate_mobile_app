import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_metric.freezed.dart';
part 'session_metric.g.dart';

@freezed
sealed class SessionMetric with _$SessionMetric {
  const SessionMetric._();

  const factory SessionMetric({
    required String userId,
    required DateTime date,
    required int durationMinutes,
    @Default([]) List<String> topicIds,
  }) = _SessionMetric;

  factory SessionMetric.fromJson(Map<String, Object?> json) =>
      _$SessionMetricFromJson(json);
}
