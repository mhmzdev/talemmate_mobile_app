import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_ai_pill.dart';
import 'package:taleemmate/ui/widgets/design/misc/app_edge_card.dart';

/// Gold-edged "Why this …" card surfacing the AI's reasoning paragraph, with an
/// [AppAiPill] header and an optional [footer] (e.g. exam / hours chips). Shared
/// by the home "Why this plan" and plan "Why this week" surfaces.
///
/// While [loading] is true (e.g. a reschedule is re-deriving the reasoning) a
/// "Rethinking…" pill shows beside the header and the current paragraph dims —
/// the old reasoning stays readable until the fresh one lands.
class AiReasoningCard extends StatelessWidget {
  const AiReasoningCard({
    super.key,
    required this.pillText,
    required this.reasoning,
    this.footer,
    this.loading = false,
  });

  final String pillText;
  final String reasoning;
  final Widget? footer;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppEdgeCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              AppAiPill(text: pillText),
              if (loading) ...[Space.x.t08, const _RethinkingPill()],
            ],
          ),
          Space.y.t12,
          AnimatedOpacity(
            duration: AppProps.fast,
            opacity: loading ? 0.45 : 1,
            child: Text(reasoning, style: AppText.b1.cl(AppTheme.c.text)),
          ),
          if (footer != null) ...[Space.y.t12, footer!],
        ],
      ),
    );
  }
}

/// Small "Rethinking…" pill with an inline spinner, shown while the reasoning
/// is being re-derived after a reschedule.
class _RethinkingPill extends StatelessWidget {
  const _RethinkingPill();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Container(
      padding: Space.sym(SpaceToken.t08, SpaceToken.t04),
      decoration: BoxDecoration(
        color: AppTheme.c.subBackground,
        borderRadius: 999.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          SizedBox(
            width: SpaceToken.t12,
            height: SpaceToken.t12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: AppTheme.c.accent,
            ),
          ),
          Space.x.t08,
          Text(
            'Rethinking…',
            style: AppText.l1b
                .cl(AppTheme.c.subText)
                .copyWith(letterSpacing: 0.8),
          ),
        ],
      ),
    );
  }
}
