// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor_conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TutorConversation _$TutorConversationFromJson(Map<String, dynamic> json) =>
    _TutorConversation(
      id: json['id'] as String,
      userId: json['userId'] as String,
      subjectId: json['subjectId'] as String,
      groundedSourceCount: (json['groundedSourceCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      topicId: json['topicId'] as String?,
      title: json['title'] as String?,
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => TutorMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TutorConversationToJson(_TutorConversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'subjectId': instance.subjectId,
      'groundedSourceCount': instance.groundedSourceCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastMessageAt': instance.lastMessageAt.toIso8601String(),
      'topicId': instance.topicId,
      'title': instance.title,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
    };
