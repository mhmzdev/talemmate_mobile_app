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
          // Kick off background text extraction for the uploaded materials —
          // fire-and-forget; the Library reflects each row's status when opened.
          final materialCubit = MaterialCubit.c(context);
          final materials =
              state.complete.data?.uploadedMaterials ?? const <LibraryItem>[];
          for (final item in materials) {
            materialCubit.process(item);
          }
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
