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
          Navigator.pushReplacementNamed(context, AppRoutes.home);
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
