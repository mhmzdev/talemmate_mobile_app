part of '../progress.dart';

/// Hero readiness card for the [hero] subject — eyebrow, big serif score /100,
/// a coloured weekly-gain delta, a gold meter, the predicted score range, and
/// the AI readiness note.
class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.hero});

  final MasterySubject hero;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final gain = hero.weeklyGain ?? 0;
    final arrow = gain > 0
        ? '↑'
        : gain < 0
        ? '↓'
        : '—';
    final deltaColor = gain > 0
        ? AppTheme.c.success
        : gain < 0
        ? AppTheme.c.error
        : AppTheme.c.subText;
    final deltaText = gain == 0
        ? '— this week'
        : '$arrow ${gain.abs()} this week';
    final range = hero.predictedRange;
    final insight = hero.aiInsight;

    return Container(
      padding: Space.a.t16,
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _eyebrow('Midterm readiness · ${hero.name}'),
          Space.y.t12,
          Row(
            crossAxisAlignment: .end,
            mainAxisAlignment: .spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  text: '${hero.readinessScore}',
                  style: AppText.h1
                      .fs(46)
                      .cl(AppTheme.c.text)
                      .copyWith(height: 1, letterSpacing: -0.5),
                  children: [
                    TextSpan(
                      text: '/100',
                      style: AppText.h2.cl(AppTheme.c.subText),
                    ),
                  ],
                ),
              ),
              Text(deltaText, style: AppText.b2b.cl(deltaColor)),
            ],
          ),
          Space.y.t12,
          AppMeter(fraction: hero.readinessScore / 100, gold: true),
          if (range != null) ...[
            Space.y.t08,
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  'Predicted score range',
                  style: AppText.b2.cl(AppTheme.c.subText),
                ),
                Text(
                  '${range.min} – ${range.max}',
                  style: AppText.b2.gm().cl(AppTheme.c.text),
                ),
              ],
            ),
          ],
          if (insight != null && insight.isNotEmpty) ...[
            Space.y.t12,
            Row(
              crossAxisAlignment: .start,
              children: [
                const AppAiPill(),
                Space.x.t08,
                Expanded(
                  child: Text(
                    insight,
                    style: AppText.b2
                        .cl(AppTheme.c.text)
                        .copyWith(height: 1.5),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
