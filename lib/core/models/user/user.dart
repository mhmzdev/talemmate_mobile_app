import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
sealed class UserData with _$UserData {
  const UserData._();

  const factory UserData({
    required String uid,
    required String fullName,
    required String email,
    String? institution,
    @Default(false) bool isOnboardingComplete,
  }) = _UserData;

  factory UserData.fromJson(Map<String, Object?> json) =>
      _$UserDataFromJson(json);

  String get initials => fullName.substring(0, 2).toUpperCase();
}
