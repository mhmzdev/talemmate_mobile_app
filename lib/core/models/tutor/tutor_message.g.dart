// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TutorMessage _$TutorMessageFromJson(Map<String, dynamic> json) =>
    _TutorMessage(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      sender: $enumDecode(_$MessageSenderEnumMap, json['sender']),
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      followUpPoints:
          (json['followUpPoints'] as List<dynamic>?)
              ?.map((e) => FollowUpPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      citations:
          (json['citations'] as List<dynamic>?)
              ?.map((e) => Citation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      kickerQuestion: json['kickerQuestion'] as String?,
    );

Map<String, dynamic> _$TutorMessageToJson(_TutorMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'sender': _$MessageSenderEnumMap[instance.sender]!,
      'text': instance.text,
      'timestamp': instance.timestamp.toIso8601String(),
      'followUpPoints': instance.followUpPoints.map((e) => e.toJson()).toList(),
      'citations': instance.citations.map((e) => e.toJson()).toList(),
      'kickerQuestion': instance.kickerQuestion,
    };

const _$MessageSenderEnumMap = {
  MessageSender.user: 'user',
  MessageSender.ai: 'ai',
};
