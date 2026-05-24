part of '../configs.dart';

class _ThemeModel {
  final Color primary;
  final Color accent;
  final Color onPrimary;
  final Color onAccent;
  final Color text;
  final Color subText;
  final Color background;
  final Color subBackground;
  final Color specBackground;
  final Color border;
  final Color success;
  final Color warning;
  final Color error;

  const _ThemeModel({
    required this.primary,
    required this.accent,
    required this.onPrimary,
    required this.onAccent,
    required this.text,
    required this.subText,
    required this.background,
    required this.subBackground,
    required this.specBackground,
    required this.border,
    required this.success,
    required this.warning,
    required this.error,
  });

  _ThemeModel copyWith({
    Color? primary,
    Color? accent,
    Color? onPrimary,
    Color? onAccent,
    Color? primaryLabel,
    Color? text,
    Color? subText,
    Color? background,
    Color? subBackground,
    Color? specBackground,
    Color? border,
    Color? success,
    Color? warning,
    Color? error,
  }) {
    return _ThemeModel(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      onPrimary: onPrimary ?? this.onPrimary,
      onAccent: onAccent ?? this.onAccent,
      text: text ?? this.text,
      subText: subText ?? this.subText,
      background: background ?? this.background,
      subBackground: subBackground ?? this.subBackground,
      specBackground: specBackground ?? this.specBackground,
      border: border ?? this.border,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
    );
  }
}
