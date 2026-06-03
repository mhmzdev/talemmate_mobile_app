part of 'create_account.dart';

class _ScreenState extends ChangeNotifier {
  // ignore: unused_element
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  final formKey = GlobalKey<FormBuilderState>();

  int _passwordStrength = 0;
  int get passwordStrength => _passwordStrength;

  void onPasswordChanged(String? value) {
    if (value == null) return;
    _passwordStrength = _computeStrength(value);
    notifyListeners();
  }

  void submit(BuildContext context) {
    try {
      final form = formKey.currentState;
      if (form == null || !form.saveAndValidate()) return;
      context.dismissKeyboard();
      UserCubit.c(context).register(form.value);
    } catch (e, st) {
      'create_account.submit error: $e\n$st'.appLog(level: AppLogLevel.error);
      UIFlash.error(context, 'Something went wrong. Please try again.');
    }
  }

  int _computeStrength(String password) {
    var score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[^A-Za-z0-9]'))) score++;
    return score;
  }
}
