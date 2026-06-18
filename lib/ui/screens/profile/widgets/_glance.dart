part of '../profile.dart';

/// "At a glance" — three quick stats (streak, hours studied, readiness) in a
/// single bordered card. Values are placeholders until progress data is wired.
class _GlanceCard extends StatelessWidget {
  const _GlanceCard();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Padding(
      padding: Space.h.t24,
      child: Container(
        padding: Space.sym(SpaceToken.t04, SpaceToken.t16),
        decoration: BoxDecoration(
          color: AppTheme.c.specBackground,
          borderRadius: 14.radius(),
          border: Border.all(color: AppTheme.c.border),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              const Expanded(
                child: _Glance(value: '11', unit: 'days', label: 'Streak'),
              ),
              _divider,
              const Expanded(
                child: _Glance(value: '86', unit: 'hrs', label: 'Studied'),
              ),
              _divider,
              const Expanded(
                child: _Glance(
                  value: '68',
                  unit: '/100',
                  label: 'Readiness',
                  highlight: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _divider =>
      Container(width: 1, color: AppTheme.c.border, margin: Space.v.t04);
}

class _Glance extends StatelessWidget {
  const _Glance({
    required this.value,
    required this.unit,
    required this.label,
    this.highlight = false,
  });

  final String value;
  final String unit;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Padding(
      padding: Space.sym(SpaceToken.t12, SpaceToken.t04),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          Row(
            crossAxisAlignment: .end,
            mainAxisSize: .min,
            children: [
              Text(
                value,
                style: AppText.h2.cl(
                  highlight ? AppTheme.c.accent : AppTheme.c.text,
                ),
              ),
              Space.x.t04,
              Padding(
                padding: Space.b.t04,
                child: Text(unit, style: AppText.l1.cl(AppTheme.c.subText)),
              ),
            ],
          ),
          Space.y.t04,
          Text(label, style: AppText.l1.cl(AppTheme.c.subText)),
        ],
      ),
    );
  }
}
