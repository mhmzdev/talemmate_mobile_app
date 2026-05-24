// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LanguagePreferences _$LanguagePreferencesFromJson(Map<String, dynamic> json) =>
    _LanguagePreferences(
      userId: json['userId'] as String,
      appLanguage:
          $enumDecodeNullable(_$AppLanguageEnumMap, json['appLanguage']) ??
          AppLanguage.english,
      useUrduNastaliq: json['useUrduNastaliq'] as bool? ?? false,
    );

Map<String, dynamic> _$LanguagePreferencesToJson(
  _LanguagePreferences instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'appLanguage': _$AppLanguageEnumMap[instance.appLanguage]!,
  'useUrduNastaliq': instance.useUrduNastaliq,
};

const _$AppLanguageEnumMap = {
  AppLanguage.english: 'english',
  AppLanguage.urdu: 'urdu',
};
