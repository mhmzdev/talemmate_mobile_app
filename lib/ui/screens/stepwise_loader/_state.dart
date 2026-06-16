part of 'stepwise_loader.dart';

class _ScreenState extends ChangeNotifier {
  // ignore: unused_element
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  // 0 = pending, 1 = active, 2 = done
  List<int> stepStates = [1, 0, 0, 0];
  bool failed = false;

  bool _started = false;
  Timer? _preTimer;

  /// Starts the loader: walks the already-done setup steps for feedback, then
  /// sits on the "calibrating" step while the real generation runs in parallel.
  void startSequenceIfNeeded(BuildContext context) {
    if (_started) return;
    _started = true;
    // Defer past the current build frame — `_run` notifies listeners and kicks
    // a cubit action, neither of which is safe to do during build().
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) _run(context);
    });
  }

  void _run(BuildContext context) {
    failed = false;
    stepStates = [1, 0, 0, 0];
    notifyListeners();

    // Steps 0–1 (subjects + material) are already persisted by onboarding —
    // walk them quickly, then hold on step 2 (calibrating) during generation.
    _preTimer?.cancel();
    var i = 0;
    _preTimer = Timer.periodic(const Duration(milliseconds: 700), (t) {
      stepStates[i] = 2;
      i++;
      if (i <= 2) {
        stepStates[i] = 1;
        notifyListeners();
      } else {
        t.cancel();
      }
    });

    // Kick the real plan generation alongside the animation.
    final userState = UserCubit.c(context).state;
    final userId = userState.user?.uid ?? userState.userData?.uid;
    if (userId == null) {
      onFailed();
      return;
    }
    PlanCubit.c(context).generate(userId);
  }

  /// Marks every step done — called by the generate listener on success, just
  /// before it navigates home.
  void onComplete() {
    _preTimer?.cancel();
    stepStates = [2, 2, 2, 2];
    failed = false;
    notifyListeners();
  }

  /// Surfaces the retry affordance — called by the listener on a generate fault.
  void onFailed() {
    _preTimer?.cancel();
    failed = true;
    notifyListeners();
  }

  /// Re-runs the whole sequence after a failure.
  void retry(BuildContext context) {
    _started = false;
    startSequenceIfNeeded(context);
  }

  @override
  void dispose() {
    _preTimer?.cancel();
    super.dispose();
  }
}
