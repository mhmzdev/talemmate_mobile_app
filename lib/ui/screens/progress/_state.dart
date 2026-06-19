part of 'progress.dart';

/// Ephemeral Progress-screen state: kicks the cubit's lazy load once on open
/// (mirrors `quiz/_state.dart`). No Firebase/Drift here — data flows through
/// [ProgressCubit].
class _ScreenState extends ChangeNotifier {
  bool _started = false;

  /// Loads progress once (deferred past build) — safe to call every build.
  void startIfNeeded(BuildContext context) {
    if (_started) return;
    _started = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) _load(context);
    });
  }

  void _load(BuildContext context) {
    final uid = _uid(context);
    if (uid != null) ProgressCubit.c(context).loadForUser(uid);
  }

  String? _uid(BuildContext context) {
    final s = UserCubit.c(context).state;
    return s.user?.uid ?? s.userData?.uid;
  }

  // ignore: unused_element
  static _ScreenState s(BuildContext context, [bool listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);
}
