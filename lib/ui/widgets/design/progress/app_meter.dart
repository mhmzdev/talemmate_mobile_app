import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// Thin rounded progress meter. The fill is the brand [AppTheme.c.primary] by
/// default; [gold] swaps it to the accent, and [color] overrides it entirely
/// (e.g. rose for a weak mastery row).
class AppMeter extends StatelessWidget {
  const AppMeter({
    super.key,
    required this.fraction,
    this.gold = false,
    this.color,
    this.height = 6,
  });

  final double fraction;
  final bool gold;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final fill = color ?? (gold ? AppTheme.c.accent : AppTheme.c.primary);

    return ClipRRect(
      borderRadius: 999.radius(),
      child: Container(
        height: height,
        color: AppTheme.c.border,
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: fraction.clamp(0.0, 1.0),
          child: Container(color: fill),
        ),
      ),
    );
  }
}
