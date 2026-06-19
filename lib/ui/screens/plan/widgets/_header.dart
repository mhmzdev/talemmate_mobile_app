part of '../plan.dart';

/// Plan top bar — greeting + this week's range, tappable profile [AppAvatar].
/// Thin binding around the shared [AppCoreHeader].
class _PlanHeader extends StatelessWidget {
  const _PlanHeader();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final user = context.userData;
    final start = DateTime.now();
    final end = start.add(const Duration(days: 6));

    return AppCoreHeader(
      greeting: 'Assalam-o-alaikum,',
      name: user?.fullName,
      subtitle: 'Week of ${start.dayMonthShort} → ${end.dayMonthShort}',
      trailing: AppAvatar(
        initials: user?.initials ?? '?',
        onTap: () => AppRoutes.profile.push(context),
      ),
    );
  }
}
