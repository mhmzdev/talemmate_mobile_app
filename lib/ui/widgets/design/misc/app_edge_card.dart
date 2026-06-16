import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// A bordered surface card with a colored left edge (the "ai-edge" treatment).
/// Shared by the plan reasoning cards ("Why this plan/week") and the home tutor
/// prompt. [edgeColor] defaults to the brand accent (gold).
class AppEdgeCard extends StatelessWidget {
  const AppEdgeCard({
    super.key,
    required this.child,
    this.edgeColor,
    this.padding,
  });

  final Widget child;
  final Color? edgeColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppTheme.c.specBackground,
        borderRadius: 14.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: .stretch,
          children: [
            Container(width: 3, color: edgeColor ?? AppTheme.c.accent),
            Expanded(
              child: Padding(padding: padding ?? Space.a.t16, child: child),
            ),
          ],
        ),
      ),
    );
  }
}
