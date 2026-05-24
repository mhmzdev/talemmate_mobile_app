// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserData _$UserDataFromJson(Map<String, dynamic> json) => _UserData(
  uid: json['uid'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  institution: json['institution'] as String?,
  isOnboardingComplete: json['isOnboardingComplete'] as bool? ?? false,
);

Map<String, dynamic> _$UserDataToJson(_UserData instance) => <String, dynamic>{
  'uid': instance.uid,
  'fullName': instance.fullName,
  'email': instance.email,
  'institution': instance.institution,
  'isOnboardingComplete': instance.isOnboardingComplete,
};
