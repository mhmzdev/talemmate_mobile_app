import 'package:freezed_annotation/freezed_annotation.dart';

part 'appearance_preferences.freezed.dart';
part 'appearance_preferences.g.dart';

enum ThemeSetting { auto, light, dark }

@freezed
sealed class AppearancePreferences with _$AppearancePreferences {
  const AppearancePreferences._();

  const factory AppearancePreferences({
    required String userId,
    @Default(ThemeSetting.auto) ThemeSetting theme,
    @Default(true) bool showDuaCard,
    @Default(true) bool showHijriDate,
    String? dailyDuaText,
  }) = _AppearancePreferences;

  factory AppearancePreferences.fromJson(Map<String, Object?> json) =>
      _$AppearancePreferencesFromJson(json);
}
