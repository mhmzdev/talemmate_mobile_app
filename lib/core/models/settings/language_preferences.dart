import 'package:freezed_annotation/freezed_annotation.dart';

part 'language_preferences.freezed.dart';
part 'language_preferences.g.dart';

enum AppLanguage { english, urdu }

@freezed
sealed class LanguagePreferences with _$LanguagePreferences {
  const LanguagePreferences._();

  const factory LanguagePreferences({
    required String userId,
    @Default(AppLanguage.english) AppLanguage appLanguage,
    @Default(false) bool useUrduNastaliq,
  }) = _LanguagePreferences;

  factory LanguagePreferences.fromJson(Map<String, Object?> json) =>
      _$LanguagePreferencesFromJson(json);
}
