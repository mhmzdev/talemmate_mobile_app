import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// Small gold pill used to flag AI-related affordances — the Profile section
/// aside ("AI") and Library material rows ("AI INDEXED").
class AppAiPill extends StatelessWidget {
  const AppAiPill({super.key, this.text = 'AI'});

  final String text;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Container(
      padding: Space.sym(SpaceToken.t08, SpaceToken.t04),
      decoration: BoxDecoration(
        color: AppTheme.c.accent.withValues(alpha: 0.12),
        borderRadius: 999.radius(),
        border: Border.all(color: AppTheme.c.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Container(
            width: SpaceToken.t04 + 1,
            height: SpaceToken.t04 + 1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.c.accent,
            ),
          ),
          Space.x.t04,
          Text(
            text,
            style: AppText.l1b
                .cl(AppTheme.c.accent)
                .copyWith(letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }
}
