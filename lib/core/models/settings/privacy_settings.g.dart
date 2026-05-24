// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrivacySettings _$PrivacySettingsFromJson(Map<String, dynamic> json) =>
    _PrivacySettings(
      userId: json['userId'] as String,
      onDeviceProcessing: json['onDeviceProcessing'] as bool? ?? false,
      cloudBackupEnabled: json['cloudBackupEnabled'] as bool? ?? false,
      cloudBackupLastSync: json['cloudBackupLastSync'] == null
          ? null
          : DateTime.parse(json['cloudBackupLastSync'] as String),
    );

Map<String, dynamic> _$PrivacySettingsToJson(_PrivacySettings instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'onDeviceProcessing': instance.onDeviceProcessing,
      'cloudBackupEnabled': instance.cloudBackupEnabled,
      'cloudBackupLastSync': instance.cloudBackupLastSync?.toIso8601String(),
    };
