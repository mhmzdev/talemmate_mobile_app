part of 'configs.dart';

abstract class AppProps {
  // ── Durations ──────────────────────────────────────────────────────────────
  static final quick = 100.milliseconds;
  static final fast = 200.milliseconds;
  static final medium = 300.milliseconds;
  static final normal = 500.milliseconds;

  // ── Radius tokens ──────────────────────────────────────────────────────────
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusPill = 48;

  static const radiusTop = BorderRadius.vertical(
    top: Radius.circular(radiusMd),
  );
  static const radiusBottom = BorderRadius.vertical(
    bottom: Radius.circular(radiusMd),
  );

  // ── Decorations ────────────────────────────────────────────────────────────
  // Functions, not getters — getters capture the theme value at first call and
  // won't update when the user switches themes at runtime.

  /// Subtle tinted surface — useful for icon containers and tag chips.
  static BoxDecoration softDecoration() => BoxDecoration(
    color: AppTheme.c.primary.addOpacity(.05),
    borderRadius: radiusMd.radius(),
  );

  /// Standard card surface using the warm sub-background with a hairline border.
  static BoxDecoration cardDecoration() => BoxDecoration(
    color: AppTheme.c.subBackground,
    borderRadius: radiusLg.radius(),
    border: Border.all(width: 1, color: AppTheme.c.border),
  );

  /// Elevated card surface using the spec-background (white / dark-card) with
  /// a hairline border — use when a card needs to stand out from subBackground.
  static BoxDecoration cardSpecDecoration() => BoxDecoration(
    color: AppTheme.c.specBackground,
    borderRadius: radiusLg.radius(),
    border: Border.all(width: 1, color: AppTheme.c.border),
  );
}
