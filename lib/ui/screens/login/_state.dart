part of 'login.dart';

class _ScreenState extends ChangeNotifier {
  // ignore: unused_element
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  final formKey = GlobalKey<FormBuilderState>();
  final passwordFocus = FocusNode();

  void submit(BuildContext context) {
    try {
      final form = formKey.currentState!;
      final isValid = form.saveAndValidate();
      if (!isValid) return;

      final values = form.value;

      UserCubit.c(context).login(values);
    } catch (e) {
      UIFlash.error(context, 'Something went wrong on submit!');
    }
  }

  @override
  void dispose() {
    passwordFocus.dispose();
    super.dispose();
  }
}
