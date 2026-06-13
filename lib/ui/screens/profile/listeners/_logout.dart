part of '../profile.dart';

class _LogoutListener extends StatelessWidget {
  const _LogoutListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (a, b) => a.logout != b.logout,
      listener: (context, state) {
        if (state.logout.isFailed) {
          UIFlash.error(context, state.logout.errorMessage);
        }
        if (state.logout.isSuccess) {
          // Session torn down → wipe the stack to a single /login. Capture the
          // cubit before navigating so reset() doesn't run on a stale context.
          final userCubit = UserCubit.c(context);
          AppRoutes.login.pushAndClear(context);
          userCubit.reset(); // clears user/userData
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
