import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_ai_pill.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_edge_card.dart';

/// Gold-edged "Why this …" card surfacing the AI's reasoning paragraph, with an
/// [AppAiPill] header and an optional [footer] (e.g. exam / hours chips). Shared
/// by the home "Why this plan" and plan "Why this week" surfaces.
class AiReasoningCard extends StatelessWidget {
  const AiReasoningCard({
    super.key,
    required this.pillText,
    required this.reasoning,
    this.footer,
  });

  final String pillText;
  final String reasoning;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppEdgeCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AppAiPill(text: pillText),
          Space.y.t12,
          Text(reasoning, style: AppText.b1.cl(AppTheme.c.text)),
          if (footer != null) ...[Space.y.t12, footer!],
        ],
      ),
    );
  }
}
