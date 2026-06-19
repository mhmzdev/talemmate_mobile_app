part of '../profile.dart';

/// "At a glance" — three quick stats (streak, hours studied, readiness) in a
/// single bordered card. Values are placeholders until progress data is wired.
/// Built on the shared [AppStatCard].
class _GlanceCard extends StatelessWidget {
  const _GlanceCard();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    return Padding(
      padding: Space.h.t24,
      child: const AppStatCard(
        stats: [
          AppStat(value: '11', unit: 'days', label: 'Streak'),
          AppStat(value: '86', unit: 'hrs', label: 'Studied'),
          AppStat(value: '68', unit: '/100', label: 'Readiness', highlight: true),
        ],
      ),
    );
  }
}
