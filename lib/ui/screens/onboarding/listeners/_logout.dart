part of '../onboarding.dart';

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
          // Backed out of onboarding → wipe the stack to a single /login.
          // Capture the cubit before navigating so reset() doesn't run on a
          // stale context.
          final userCubit = UserCubit.c(context);
          final libraryCubit = LibraryCubit.c(context);
          final chatCubit = ChatCubit.c(context);
          AppRoutes.login.pushAndClear(context);
          userCubit.reset(); // clears user/userData
          libraryCubit.resetUid(); // clears session uid + materials (ADR-014)
          chatCubit.resetUid(); // clears session uid + conversations (ADR-014)
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
