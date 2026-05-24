import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taleemmate/core/models/tutor/citation.dart';
import 'package:taleemmate/core/models/tutor/follow_up_point.dart';

part 'tutor_message.freezed.dart';
part 'tutor_message.g.dart';

enum MessageSender { user, ai }

@freezed
sealed class TutorMessage with _$TutorMessage {
  const TutorMessage._();

  const factory TutorMessage({
    required String id,
    required String conversationId,
    required MessageSender sender,
    required String text,
    required DateTime timestamp,
    @Default([]) List<FollowUpPoint> followUpPoints,
    @Default([]) List<Citation> citations,
    String? kickerQuestion,
  }) = _TutorMessage;

  factory TutorMessage.fromJson(Map<String, Object?> json) =>
      _$TutorMessageFromJson(json);

  bool get isAI => sender == MessageSender.ai;
}
