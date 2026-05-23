part of '../configs.dart';

sealed class AppColors {
  static const primary = Color(0xff0F2027);
  static const accent = Color(0xffD4A574);

  static const error = Color(0xffA35C5C);
  static const success = Color(0xff4F7A5C);
  static const warning = Color(0xffD4860A);
}

sealed class AppColorsLight {
  static const primary = Color(0xff0F2027);
  static const accent = Color(0xffD4A574);

  static const text = Color(0xff1A2F38);
  static const subText = Color(0xff5A6770);
  static const background = Color(0xffFAF7F2);
  static const subBackground = Color(0xffF4EFE6);
}

sealed class AppColorsDark {
  static const primary = Color(0xff0E2128);
  static const accent = Color(0xffD4A574);

  static const text = Color(0xffFAF7F2);
  static const subText = Color(0xff8AA4A9);
  static const background = Color(0xff0E2128);
  static const subBackground = Color(0xff132F3B);
}
