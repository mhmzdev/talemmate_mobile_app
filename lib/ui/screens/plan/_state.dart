part of 'plan.dart';

class _ScreenState extends ChangeNotifier {
  // ignore: unused_element
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  /// Selected day in the week strip. Null until the user taps a day — the UI
  /// falls back to today's index while it's null.
  int? _selectedDayIndex;
  int? get selectedDayIndex => _selectedDayIndex;

  void selectDay(int index) {
    if (_selectedDayIndex == index) return;
    _selectedDayIndex = index;
    notifyListeners();
  }
}
