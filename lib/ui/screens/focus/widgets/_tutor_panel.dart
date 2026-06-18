part of '../focus.dart';

/// Static "Guided by tutor" panel — surfaces the block's `aiInsight` as a calm
/// gold-edged note. Hidden entirely when the block has no insight. No source
/// chips: Focus has no tutor reply to cite.
class _TutorPanel extends StatelessWidget {
  const _TutorPanel({required this.block});

  final StudyBlock block;

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final insight = block.aiInsight?.trim();
    if (insight == null || insight.isEmpty) return const SizedBox.shrink();

    return AppEdgeCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const AppAiPill(text: 'Guided by tutor'),
          Space.y.t12,
          Text(insight, style: AppText.b1.cl(AppTheme.c.text)),
        ],
      ),
    );
  }
}
