import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/ui/widgets/design/alerts/app_alert_base.dart';
import 'package:taleemmate/ui/widgets/design/full_screen_loader/full_screen_loader.dart';
import 'package:taleemmate/utils/flash.dart';

/// Shared "rebuild this week" affordance for the Profile editors (Subjects,
/// Schedule). Those editors hold their changes locally and only **apply** them
/// when the user commits to a rebuild — so "Save changes" always shows this
/// confirm, **Rebuild** persists + regenerates (via [onRebuild]), and **Later**
/// discards the edits (nothing is written). The destructive week rebuild runs
/// behind [PlanRebuildLoader].
class PlanRegenerate {
  const PlanRegenerate._();

  /// Always-shown confirm. **Later** pops the editor (edits discarded, no write,
  /// no AI call); **Rebuild** runs [onRebuild] — which persists the edits and
  /// kicks `PlanCubit.generate` (driven by [PlanRebuildLoader], which pops +
  /// confirms on success). The warning is explicit that today's completed/moved
  /// blocks reset.
  static void confirm(BuildContext context, {required VoidCallback onRebuild}) {
    showAppAlert(
      context,
      routeName: 'regenerate-plan',
      icon: const Icon(Icons.refresh),
      title: 'Rebuild this week\'s plan?',
      subtitle:
          'Applying your changes rebuilds the week — today\'s completed or '
          'moved blocks will reset. Tap Later to keep your current plan.',
      actions: [
        AppAlertAction(
          label: 'Later',
          onTap: () {
            Navigator.of(context).pop(); // close the alert
            _closeEditor(context); // back to Profile, edits discarded
          },
        ),
        AppAlertAction(
          label: 'Rebuild',
          isDestructive: true,
          onTap: () {
            Navigator.of(context).pop(); // close the alert
            onRebuild();
          },
        ),
      ],
    );
  }

  /// Pops the editor route, guarding the (test-only) case where it is the root.
  static void _closeEditor(BuildContext context) {
    final nav = Navigator.of(context);
    if (nav.canPop()) nav.pop();
  }
}

/// Overlay listener driving the full-screen loader while a post-edit
/// `PlanCubit.generate` runs, then popping the editor on success (or flashing
/// the fault and leaving the plan intact on failure). Mount in the editor's
/// `overlayBuilders`. The old plan only changes on a successful Gemini parse, so
/// a failure leaves it untouched.
class PlanRebuildLoader extends StatelessWidget {
  const PlanRebuildLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlanCubit, PlanState>(
      listenWhen: (a, b) => a.generate != b.generate,
      listener: (context, state) {
        if (state.generate.isFailed) {
          UIFlash.error(context, state.generate.errorMessage);
        }
        if (state.generate.isSuccess) {
          UIFlash.success(context, 'Your week has been rebuilt');
          final nav = Navigator.of(context);
          if (nav.canPop()) nav.pop(); // close the editor
        }
      },
      builder: (context, state) => FullScreenLoader(
        loading: state.generate.isLoading,
        title: 'Rebuilding your plan…',
      ),
    );
  }
}
