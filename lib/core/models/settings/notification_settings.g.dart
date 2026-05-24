// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => _NotificationSettings(
  userId: json['userId'] as String,
  blockReminders: json['blockReminders'] as bool? ?? true,
  dailyCheckIn: json['dailyCheckIn'] as bool? ?? true,
  examCountdown: json['examCountdown'] as bool? ?? true,
);

Map<String, dynamic> _$NotificationSettingsToJson(
  _NotificationSettings instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'blockReminders': instance.blockReminders,
  'dailyCheckIn': instance.dailyCheckIn,
  'examCountdown': instance.examCountdown,
};
