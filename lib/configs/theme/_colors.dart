part of '../configs.dart';

/// Brand + status colors shared across both themes.
sealed class AppColors {
  static const primary = Color(0xff0F2027);
  static const accent = Color(0xffD4A574);

  /// Text / icon color rendered ON a primary-colored surface.
  static const onPrimary = Color(0xffFAF7F2);

  /// Text / icon color rendered ON an accent-colored surface.
  static const onAccent = Color(0xff1A2F38);

  static const error = Color(0xffA35C5C);
  static const success = Color(0xff4F7A5C);
  static const warning = Color(0xffD4860A);
}

/// Color tokens for the light theme.
sealed class AppColorsLight {
  static const primary = Color(0xff0F2027);
  static const accent = Color(0xffD4A574);

  static const text = Color(0xff1A2F38);
  static const subText = Color(0xff5A6770);
  static const background = Color(0xffFAF7F2);
  static const specBackground = Color(0xffffffff);
  static const subBackground = Color(0xffF4EFE6);

  /// Subtle warm-grey border for cards, inputs, and dividers.
  static const border = Color(0xffE8E2D9);
}

/// Color tokens for the dark theme.
sealed class AppColorsDark {
  /// Action / interactive color. Distinct warm teal — clearly visible on the
  /// dark background and used as the primary button surface + focus indicator.
  static const primary = Color(0xff286680);
  static const accent = Color(0xffD4A574);

  static const text = Color(0xffFAF7F2);
  static const subText = Color(0xff8AA4A9);
  static const background = Color(0xff0E2128);

  /// Warm gold surface — creamy button and warm-accent card surfaces.
  /// Mirrors the role that cream (#F4EFE6) plays in the light theme.
  static const subBackground = Color(0xffD4A574);

  /// Further-elevated surface — form inputs and neutral cards.
  static const specBackground = Color(0xff1E3F50);

  /// Subtle border for cards, inputs, and dividers.
  static const border = Color(0xff1E3E4E);
}
