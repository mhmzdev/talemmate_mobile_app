import 'package:freezed_annotation/freezed_annotation.dart';

part 'privacy_settings.freezed.dart';
part 'privacy_settings.g.dart';

@freezed
sealed class PrivacySettings with _$PrivacySettings {
  const PrivacySettings._();

  const factory PrivacySettings({
    required String userId,
    @Default(false) bool onDeviceProcessing,
    @Default(false) bool cloudBackupEnabled,
    DateTime? cloudBackupLastSync,
  }) = _PrivacySettings;

  factory PrivacySettings.fromJson(Map<String, Object?> json) =>
      _$PrivacySettingsFromJson(json);
}
