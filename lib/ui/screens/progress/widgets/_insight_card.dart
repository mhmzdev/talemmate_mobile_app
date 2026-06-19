part of '../progress.dart';

/// Bottom AI insight card — a gold-edge card with an "Insight" pill and the
/// global study-pattern note in a serif headline.
class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.insight});

  final String insight;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return AppEdgeCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const AppAiPill(text: 'Insight'),
          Space.y.t08,
          Text(
            insight,
            style: AppText.h3.fra().cl(AppTheme.c.text).copyWith(height: 1.35),
          ),
        ],
      ),
    );
  }
}
