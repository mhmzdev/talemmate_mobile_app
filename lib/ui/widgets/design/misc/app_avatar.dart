import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// Circular initials avatar — the app's identity mark.
///
/// Renders serif [initials] on a primary-ink disc (no user images — initials
/// are the identity mark everywhere). Used at 38px in the home header (as a
/// tap target into Profile) and at 54px on the Profile screen.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.initials,
    this.size = 38,
    this.onTap,
  });

  final String initials;
  final double size;

  /// When set, the avatar becomes a tap target (e.g. open Profile).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final disc = Container(
      width: size,
      height: size,
      alignment: .center,
      decoration: BoxDecoration(
        color: AppTheme.c.primary,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        // Serif, medium, slightly tightened — matches the design avatar
        // (var(--font-serif), 500, -.01em) and scales the glyph to the disc.
        style: AppText.h2
            .cl(AppColors.onPrimary)
            .fs(size * 0.4)
            .w(5)
            .copyWith(letterSpacing: size * -0.004),
      ),
    );

    if (onTap == null) return disc;

    return GestureDetector(onTap: onTap, child: disc);
  }
}
