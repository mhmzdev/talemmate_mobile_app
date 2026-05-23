part of 'button.dart';

/// Holds per-state colors for a single button style.
class _AppButtonModel {
  /// Text color keyed by [AppButtonState].
  final Map<AppButtonState, Color> text;

  /// Background/surface color keyed by [AppButtonState].
  final Map<AppButtonState, Color> surface;

  _AppButtonModel({
    required this.text,
    required this.surface,
  });
}
