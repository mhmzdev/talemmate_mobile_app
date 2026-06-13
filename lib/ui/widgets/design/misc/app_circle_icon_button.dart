import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/ui/widgets/headless/app_touch.dart';

/// Small circular icon button on a faint ink wash — the design's `.icon-btn`.
/// Used for the home header bell and the Profile "more" affordance.
class AppCircleIconButton extends StatelessWidget {
  const AppCircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 36,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppTouch(
      onTap: onTap,
      hasSplash: false,
      child: Container(
        width: size,
        height: size,
        alignment: .center,
        decoration: BoxDecoration(
          color: AppTheme.c.primary.withValues(alpha: 0.04),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: size * 0.5, color: AppTheme.c.subText),
      ),
    );
  }
}
