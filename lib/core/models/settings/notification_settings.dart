import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

@freezed
sealed class NotificationSettings with _$NotificationSettings {
  const NotificationSettings._();

  const factory NotificationSettings({
    required String userId,
    @Default(true) bool blockReminders,
    @Default(true) bool dailyCheckIn,
    @Default(true) bool examCountdown,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, Object?> json) =>
      _$NotificationSettingsFromJson(json);
}
