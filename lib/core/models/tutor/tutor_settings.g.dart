// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TutorSettings _$TutorSettingsFromJson(
  Map<String, dynamic> json,
) => _TutorSettings(
  userId: json['userId'] as String,
  showCitationsOnEveryReply: json['showCitationsOnEveryReply'] as bool? ?? true,
  scope:
      $enumDecodeNullable(_$TutorScopeEnumMap, json['scope']) ??
      TutorScope.libraryAndLectures,
  reasoningDepth:
      $enumDecodeNullable(_$ReasoningDepthEnumMap, json['reasoningDepth']) ??
      ReasoningDepth.balanced,
);

Map<String, dynamic> _$TutorSettingsToJson(_TutorSettings instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'showCitationsOnEveryReply': instance.showCitationsOnEveryReply,
      'scope': _$TutorScopeEnumMap[instance.scope]!,
      'reasoningDepth': _$ReasoningDepthEnumMap[instance.reasoningDepth]!,
    };

const _$TutorScopeEnumMap = {
  TutorScope.libraryOnly: 'libraryOnly',
  TutorScope.libraryAndLectures: 'libraryAndLectures',
};

const _$ReasoningDepthEnumMap = {
  ReasoningDepth.brief: 'brief',
  ReasoningDepth.balanced: 'balanced',
  ReasoningDepth.detailed: 'detailed',
};
