part of '../stepwise_loader.dart';

/// Drives the loader's outcome from the real [PlanCubit.generate] call: on
/// success it finishes the step animation and lands on home; on failure it
/// surfaces an error + the retry affordance. Navigation lives here (never in
/// `_state.dart`) per the state-driven-navigation convention.
class _GenerateListener extends StatelessWidget {
  const _GenerateListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PlanCubit, PlanState>(
      listenWhen: (a, b) => a.generate != b.generate,
      listener: (_, state) {
        if (state.generate.isFailed) {
          _ScreenState.s(context).onFailed();
          UIFlash.error(context, state.generate.errorMessage);
        }
        if (state.generate.isSuccess) {
          _ScreenState.s(context).onComplete();
          // Brief dwell so the final checkmark is seen before the transition.
          Future.delayed(const Duration(milliseconds: 600), () {
            if (context.mounted) AppRoutes.home.pushReplace(context);
          });
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
