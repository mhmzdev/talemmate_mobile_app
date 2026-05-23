part of 'button.dart';

/// Returns surface and text colors for each [AppButtonStyle] and [AppButtonState].
Map<AppButtonStyle, _AppButtonModel> _mapPropsToData() {
  return {
    .primary: _AppButtonModel(
      surface: {
        .def: AppTheme.c.primary,
        .pressed: AppTheme.c.primary.withValues(alpha: 0.8),
        .disabled: AppTheme.c.primary.withValues(alpha: 0.5),
      },
      text: {
        .def: AppTheme.c.background,
        .disabled: AppTheme.c.primary,
      },
    ),
    .creamy: _AppButtonModel(
      surface: {
        .def: AppTheme.c.subBackground,
        .pressed: AppTheme.c.accent.withValues(alpha: 0.8),
        .disabled: AppTheme.c.subBackground.withValues(alpha: 0.5),
      },
      text: {
        .def: AppTheme.c.primary,
        .disabled: AppTheme.c.primary.withValues(alpha: 0.7),
      },
    ),
    .error: _AppButtonModel(
      surface: {
        .def: AppTheme.c.error,
        .pressed: AppTheme.c.error.withValues(alpha: 0.8),
        .disabled: AppTheme.c.error.withValues(alpha: 0.5),
      },
      text: {
        .def: AppTheme.c.background,
        .disabled: AppTheme.c.background,
      },
    ),
    .success: _AppButtonModel(
      surface: {
        .def: AppTheme.c.success,
        .pressed: AppTheme.c.success.withValues(alpha: 0.8),
        .disabled: AppTheme.c.success.withValues(alpha: 0.5),
      },
      text: {
        .def: AppTheme.c.background,
        .disabled: AppTheme.c.background,
      },
    ),
  };
}

/// Returns the [TextStyle] for each [AppButtonSize].
Map<AppButtonSize, TextStyle> _mapSizeToFontSize() {
  return {
    .large: AppText.h3.removeHeight(),
    .medium: AppText.b1.removeHeight(),
    .small: AppText.b2.removeHeight(),
  };
}

/// Returns the [BorderRadius] for each [AppButtonRadius].
Map<AppButtonRadius, BorderRadius> _mapRadiusToBorderRadius() {
  return {
    .normal: 12.radius(),
    .rounded: 20.radius(),
    .capsule: 50.radius(),
  };
}
