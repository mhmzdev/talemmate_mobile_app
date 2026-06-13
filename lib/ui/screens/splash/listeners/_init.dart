part of '../splash.dart';

/// Routes off the splash once session restore resolves. No loading UI of its
/// own, so it is passed into `Screen.belowBuilders`.
class _InitListener extends StatelessWidget {
  const _InitListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (a, b) => a.init != b.init,
      listener: (context, state) {
        if (state.init.isFailed) {
          AppRoutes.login.pushReplace(context);
          return;
        }
        if (state.init.isSuccess) {
          // Session resumed → seed the Library module's session uid (ADR-014).
          final uid = state.user?.uid;
          if (uid != null) LibraryCubit.c(context).initUid(uid);
          final data = state.userData;
          final next = data == null
              ? AppRoutes.login
              : data.isOnboardingComplete
              ? AppRoutes.home
              : AppRoutes.onboarding;
          next.pushReplace(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
