part of 'button.dart';

/// Visual style variant of the button.
enum AppButtonStyle {
  /// Dark primary color fill.
  primary,

  /// Warm cream/accent color fill.
  creamy,

  /// Destructive/error color fill.
  error,

  /// Positive/success color fill.
  success,
}

extension AppButtonStyleExt on AppButtonStyle {
  bool get isPrimary => this == AppButtonStyle.primary;
  bool get isCreamy => this == AppButtonStyle.creamy;
  bool get isError => this == AppButtonStyle.error;
  bool get isSuccess => this == AppButtonStyle.success;
}

/// Controls button height and font size.
enum AppButtonSize {
  small,
  medium,
  large,
}

/// Corner radius shape of the button.
enum AppButtonRadius {
  /// Slightly rounded corners.
  normal,

  /// Noticeably rounded corners.
  rounded,

  /// Fully pill-shaped.
  capsule,
}

/// Interactive state of the button.
enum AppButtonState {
  /// Default idle state.
  def,

  /// Actively being pressed.
  pressed,

  /// Non-interactive, greyed out.
  disabled,
}

extension AppButtonStateExt on AppButtonState {
  bool get isDisabled => this == AppButtonState.disabled;
}
