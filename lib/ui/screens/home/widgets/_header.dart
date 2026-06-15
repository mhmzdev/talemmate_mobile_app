part of '../home.dart';

/// Home top bar — greeting + date on the left, notifications bell and the
/// tappable profile [AppAvatar] on the right. The avatar is the entry point
/// into the Profile screen.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final user = UserCubit.c(context, true).state.userData;
    final firstName = (user?.fullName.trim().split(RegExp(r'\s+')).first ?? '')
        .trim();
    final initials = user?.initials ?? '?';

    return Padding(
      padding: Space.h.t20 + Space.t.t12,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Assalam-o-alaikum,\n',
                    children: [
                      if (firstName.isNotEmpty)
                        TextSpan(text: firstName, style: AppText.h1.fra()),
                    ],
                  ),
                  style: AppText.h1.cl(AppTheme.c.text),
                ),
                Space.y.t04,
                Text(
                  DateTime.now().dateWithoutYear,
                  style: AppText.b2
                      .cl(AppTheme.c.subText)
                      .copyWith(letterSpacing: 0.4),
                ),
              ],
            ),
          ),
          Space.x.t08,
          AppAvatar(
            initials: initials,
            onTap: () => AppRoutes.profile.push(context),
          ),
        ],
      ),
    );
  }
}
