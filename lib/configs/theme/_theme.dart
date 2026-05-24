part of '../configs.dart';

class AppTheme {
  // ignore: library_private_types_in_public_api
  static late _ThemeModel c;
  static late bool isDark;

  static void init(BuildContext context) {
    isDark = Theme.of(context).brightness == Brightness.dark;
    c = isDark ? _darkTheme : _lightTheme;
  }
}
