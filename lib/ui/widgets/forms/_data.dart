part of 'forms.dart';

Map<AppFormState, _AppFormTheme> _mapPropsToData() {
  return {
    .def: _AppFormTheme(
      text: AppTheme.c.text,
      label: AppTheme.c.subText,
      helper: AppTheme.c.subText,
      border: AppTheme.c.border,
      surface: AppTheme.c.specBackground,
      error: AppTheme.c.error,
      errorText: AppTheme.c.error,
    ),
    .pressed: _AppFormTheme(
      text: AppTheme.c.text,
      label: AppTheme.isDark ? AppTheme.c.text : AppTheme.c.primary,
      helper: AppTheme.c.subText,
      border: AppTheme.c.primary,
      surface: AppTheme.c.specBackground,
      error: AppTheme.c.error,
      errorText: AppTheme.c.error,
    ),
    .disabled: _AppFormTheme(
      text: AppTheme.c.subText.withValues(alpha: 0.5),
      label: AppTheme.c.subText.withValues(alpha: 0.5),
      helper: AppTheme.c.subText.withValues(alpha: 0.4),
      border: AppTheme.c.border.withValues(alpha: 0.5),
      surface: AppTheme.c.specBackground,
      error: AppTheme.c.error,
      errorText: AppTheme.c.error,
    ),
  };
}
