part of 'focus.dart';

/// Ephemeral Focus-session state: a 1-second countdown for the block's
/// duration, with pause/resume. No Firebase here — business actions
/// (mark done / I'm stuck) delegate to the app-level cubits.
class _ScreenState extends ChangeNotifier {
  _ScreenState(this.block) {
    _total = Duration(minutes: block.durationMinutes);
    _remaining = _total;
    _start();
  }

  final StudyBlock block;

  late final Duration _total;
  late Duration _remaining;
  Timer? _timer;
  bool paused = false;

  Duration get remaining => _remaining;

  /// 0 → 1 progress of the session (time elapsed over total).
  double get fraction => _total.inSeconds == 0
      ? 0
      : 1 - (_remaining.inSeconds / _total.inSeconds).clamp(0.0, 1.0);

  /// `mm:ss` label for the time left.
  String get remainingLabel {
    final m = _remaining.inMinutes.toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void togglePause() {
    paused = !paused;
    paused ? _timer?.cancel() : _start();
    notifyListeners();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 0) return;
      _remaining -= const Duration(seconds: 1);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ignore: unused_element
  static _ScreenState s(BuildContext context, [bool listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);
}
