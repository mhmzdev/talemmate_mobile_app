import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// A label-only selectable pill — selected state fills with the ink `text`
/// colour. Used by the Library filter row (All + per-subject chips).
class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppProps.medium,
        padding: Space.sym(SpaceToken.t12, SpaceToken.t08),
        decoration: BoxDecoration(
          color: selected ? AppTheme.c.text : AppTheme.c.subBackground,
          borderRadius: 20.radius(),
          border: Border.all(
            color: selected ? AppTheme.c.text : AppTheme.c.border,
          ),
        ),
        child: Text(
          label,
          style: AppText.b2.cl(
            selected ? AppTheme.c.background : AppTheme.c.text,
          ),
        ),
      ),
    );
  }
}
