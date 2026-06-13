part of '../login.dart';

class _LoginListener extends StatelessWidget {
  const _LoginListener();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listenWhen: (a, b) => a.login != b.login,
      listener: (context, state) {
        if (state.login.isFailed) {
          UIFlash.error(context, state.login.errorMessage);
        }
        if (state.login.isSuccess) {
          // Seed the session uid for the app-wide Library module (ADR-014)
          // before routing into the signed-in shell.
          final uid = state.user?.uid;
          if (uid != null) LibraryCubit.c(context).initUid(uid);
          final done = state.userData?.isOnboardingComplete ?? false;
          (done ? AppRoutes.home : AppRoutes.onboarding).pushReplace(context);
        }
      },
      builder: (context, state) {
        final loading = state.login.isLoading;
        return FullScreenLoader(
          loading: loading,
          title: 'Signing In...',
          subtitle: 'This should only take a moment.',
        );
      },
    );
  }
}
