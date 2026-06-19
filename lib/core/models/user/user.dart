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

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  /// First word of [fullName] (the given name), trimmed.
  String get firstName => fullName.trim().split(RegExp(r'\s+')).first.trim();

  /// Last word of [fullName] (the family name), trimmed. If there's only one
  /// word, returns an empty string.
  String get lastName => fullName.trim().split(RegExp(r'\s+')).length > 1
      ? fullName.trim().split(RegExp(r'\s+')).last.trim()
      : '';
}
