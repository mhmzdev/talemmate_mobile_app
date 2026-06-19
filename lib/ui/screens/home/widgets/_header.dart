part of '../home.dart';

/// Home top bar — greeting + date on the left, the tappable profile [AppAvatar]
/// on the right (the entry point into Profile). Thin binding around the shared
/// [AppCoreHeader].
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final user = context.userData;

    return AppCoreHeader(
      greeting: 'Assalam-o-alaikum,',
      name: user?.fullName,
      subtitle: DateTime.now().dateWithoutYear,
      trailing: AppAvatar(
        initials: user?.initials ?? '?',
        onTap: () => AppRoutes.profile.push(context),
      ),
    );
  }
}
