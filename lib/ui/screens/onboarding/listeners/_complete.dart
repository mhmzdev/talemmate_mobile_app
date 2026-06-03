part of '../onboarding.dart';

class _CompleteListener extends StatelessWidget {
  const _CompleteListener();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listenWhen: (a, b) => a.complete != b.complete,
      listener: (_, state) {
        if (state.complete.isFailed) {
          UIFlash.error(context, state.complete.errorMessage);
        }
        if (state.complete.isSuccess) {
          AppRoutes.stepwiseLoader.pushReplace(context);
        }
      },
      builder: (context, state) {
        final loading = state.complete.isLoading;
        return FullScreenLoader(
          loading: loading,
          title: 'Finishing up...',
          subtitle: 'Just a moment while I set up your study plan.',
        );
      },
    );
  }
}
