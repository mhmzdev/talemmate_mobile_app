// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appearance_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppearancePreferences _$AppearancePreferencesFromJson(
  Map<String, dynamic> json,
) => _AppearancePreferences(
  userId: json['userId'] as String,
  theme:
      $enumDecodeNullable(_$ThemeSettingEnumMap, json['theme']) ??
      ThemeSetting.auto,
  showDuaCard: json['showDuaCard'] as bool? ?? true,
  showHijriDate: json['showHijriDate'] as bool? ?? true,
  dailyDuaText: json['dailyDuaText'] as String?,
);

Map<String, dynamic> _$AppearancePreferencesToJson(
  _AppearancePreferences instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'theme': _$ThemeSettingEnumMap[instance.theme]!,
  'showDuaCard': instance.showDuaCard,
  'showHijriDate': instance.showHijriDate,
  'dailyDuaText': instance.dailyDuaText,
};

const _$ThemeSettingEnumMap = {
  ThemeSetting.auto: 'auto',
  ThemeSetting.light: 'light',
  ThemeSetting.dark: 'dark',
};
