import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taleemmate/core/models/tutor/tutor_message.dart';

part 'tutor_conversation.freezed.dart';
part 'tutor_conversation.g.dart';

@freezed
sealed class TutorConversation with _$TutorConversation {
  const TutorConversation._();

  const factory TutorConversation({
    required String id,
    required String userId,
    required String subjectId,
    required int groundedSourceCount,
    required DateTime createdAt,
    required DateTime lastMessageAt,
    String? topicId,
    String? title,
    @Default([]) List<TutorMessage> messages,
  }) = _TutorConversation;

  factory TutorConversation.fromJson(Map<String, Object?> json) =>
      _$TutorConversationFromJson(json);
}
