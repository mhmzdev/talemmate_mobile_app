part of '../create_account.dart';

class _RegisterListener extends StatelessWidget {
  const _RegisterListener();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listenWhen: (a, b) => a.register != b.register,
      listener: (_, state) {
        if (state.register.isFailed) {
          UIFlash.error(context, state.register.errorMessage);
        }
        if (state.register.isSuccess) {
          // Seed the session uid for the app-wide modules (ADR-014) before
          // routing into onboarding.
          final uid = state.user?.uid;
          if (uid != null) {
            LibraryCubit.c(context).initUid(uid);
            ChatCubit.c(context).initUid(uid);
            PlanCubit.c(context).initUid(uid);
          }
          AppRoutes.onboarding.pushReplace(context);
        }
      },
      builder: (context, state) {
        final loading = state.register.isLoading;
        return FullScreenLoader(
          loading: loading,
          title: 'Signing you in',
          subtitle: 'This usually takes a moment.',
        );
      },
    );
  }
}
