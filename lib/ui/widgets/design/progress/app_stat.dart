import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';

/// A single labelled stat — a serif number with a unit suffix above a caption.
/// [highlight] tints the number gold (used for readiness-style figures). Lay
/// several out with [AppStatCard].
class AppStat extends StatelessWidget {
  const AppStat({
    super.key,
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

/// A bordered card laying [stats] out in a single row separated by hairline
/// dividers — the shared "at a glance" / progress stat strip.
class AppStatCard extends StatelessWidget {
  const AppStatCard({super.key, required this.stats});

  final List<AppStat> stats;

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final children = stats
        .asMap()
        .entries
        .expand(
          (e) => [
            if (e.key != 0)
              Container(
                width: 1,
                color: AppTheme.c.border,
                margin: Space.v.t04,
              ),
            Expanded(child: e.value),
          ],
        )
        .toList();

    return Container(
      padding: Space.sym(SpaceToken.t04, SpaceToken.t16),
      decoration: BoxDecoration(
        color: AppTheme.c.specBackground,
        borderRadius: 14.radius(),
        border: Border.all(color: AppTheme.c.border),
      ),
      child: IntrinsicHeight(child: Row(children: children)),
    );
  }
}
