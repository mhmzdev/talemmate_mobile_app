part of 'plan.dart';

class _ScreenState extends ChangeNotifier {
  _ScreenState({this.initialDate});

  // ignore: unused_element
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  /// An optional day to pre-select on first build (e.g. when arriving from
  /// Home's "See what's next" once today is done). Overridden the moment the
  /// user taps a day in the strip ([selectDay] sets [_selectedDayIndex]).
  final DateTime? initialDate;

  /// Selected day in the week strip. Null until the user taps a day — the UI
  /// falls back to [initialDate]'s index, else today's index, while it's null.
  int? _selectedDayIndex;
  int? get selectedDayIndex => _selectedDayIndex;

  void selectDay(int index) {
    if (_selectedDayIndex == index) return;
    _selectedDayIndex = index;
    notifyListeners();
  }
}
