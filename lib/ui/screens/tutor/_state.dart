part of 'tutor.dart';

class _ScreenState extends ChangeNotifier {
  static _ScreenState s(BuildContext context, [bool listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  /// Composer text field controller.
  final controller = TextEditingController();

  /// Measured height of the floating bottom bar, so the composer clears it.
  /// Seeded with a sensible fallback until `Screen` reports the real value.
  double bottomBarHeight = SpaceToken.t100;

  bool _hasText = false;
  bool get hasText => _hasText;

  _ScreenState() {
    controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final has = controller.text.trim().isNotEmpty;
    if (has != _hasText) {
      _hasText = has;
      notifyListeners();
    }
  }

  void setBottomBarHeight(double height) {
    if (height == bottomBarHeight || height <= 0) return;
    bottomBarHeight = height;
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  void clearInput() => controller.clear();

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);
    controller.dispose();
    super.dispose();
  }
}
