part of '../profile.dart';

/// Identity block — large presence avatar, name, email, and a "more" affordance.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    App.init(context);

    final user = UserCubit.c(context, true).state.userData;
    final name = user?.fullName ?? 'Your profile';
    final email = user?.email ?? '';
    final initials = user?.initials ?? '?';

    return Padding(
      padding: Space.sym(SpaceToken.t24, SpaceToken.t16),
      child: Row(
        children: [
          AppAvatar(initials: initials, size: 54),
          Space.x.t12,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(
                  name,
                  style: AppText.h2.cl(AppTheme.c.text),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                if (email.isNotEmpty) ...[
                  Space.y.t04,
                  Text(
                    email,
                    style: AppText.b2.cl(AppTheme.c.subText),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Space.x.t08,
          AppCircleIconButton(icon: LucideIcons.ellipsis, onTap: () {}),
        ],
      ),
    );
  }
}
