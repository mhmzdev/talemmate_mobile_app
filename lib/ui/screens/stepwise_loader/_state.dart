part of 'stepwise_loader.dart';

class _ScreenState extends ChangeNotifier {
  // ignore: unused_element
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  // 0 = pending, 1 = active, 2 = done
  List<int> stepStates = [1, 0, 0, 0];
  bool _sequenceStarted = false;
  Timer? _timer;
  int _activeIndex = 0;

  void startSequenceIfNeeded(BuildContext context) {
    if (_sequenceStarted) return;
    _sequenceStarted = true;
    _timer = Timer.periodic(const Duration(milliseconds: 900), (t) {
      stepStates[_activeIndex] = 2;
      _activeIndex++;
      if (_activeIndex < stepStates.length) {
        stepStates[_activeIndex] = 1;
        notifyListeners();
      } else {
        t.cancel();
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 600), () {
          if (context.mounted) AppRoutes.home.pushReplace(context);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
