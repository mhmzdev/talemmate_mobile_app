import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_up_point.freezed.dart';
part 'follow_up_point.g.dart';

@freezed
sealed class FollowUpPoint with _$FollowUpPoint {
  const FollowUpPoint._();

  const factory FollowUpPoint({
    required String label,
    required String body,
  }) = _FollowUpPoint;

  factory FollowUpPoint.fromJson(Map<String, Object?> json) =>
      _$FollowUpPointFromJson(json);
}
