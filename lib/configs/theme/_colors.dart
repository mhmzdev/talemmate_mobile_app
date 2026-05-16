part of '../configs.dart';

sealed class AppColors {
  static const primary = Color(0xff0F2027);
  static const accent = Color(0xffD4A574);
}

sealed class AppColorsLight {
  static const primary = Color(0xff0F2027);
  static const accent = Color(0xffD4A574);

  static const text = Color(0xff0F2027);
  static const subText = Color(0xff5B7A82);
  static const background = Color(0xffFAF7F2);

  static const success = Color(0xff2A9D73);
  static const warning = Color(0xffD4860A);
  static const error = Color(0xffB6113D);
}

sealed class AppColorsDark {
  static const primary = Color(0xff0F2027);
  static const accent = Color(0xffD4A574);

  static const text = Color(0xffFAF7F2);
  static const subText = Color(0xff8AA4A9);
  static const background = Color(0xff0F2027);

  static const success = Color(0xff2A9D73);
  static const warning = Color(0xffD4860A);
  static const error = Color(0xffB6113D);
}
