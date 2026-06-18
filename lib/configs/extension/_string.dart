part of '../configs.dart';

extension SuperNullableString<T> on String? {
  /// Shorthand for != null && isNotEmpty
  bool get available => this != null && this!.isNotEmpty;
}

extension SuperString<T> on String {
  Future<T?> push<V>(BuildContext context, {Object? arguments}) =>
      Navigator.pushNamed<T?>(context, this, arguments: arguments);

  Future<void> pushReplace(BuildContext context, {Object? arguments}) =>
      Navigator.pushReplacementNamed(context, this, arguments: arguments);

  /// Pushes this route and removes every route beneath it, leaving a clean
  /// stack with this as the only entry. Use for session boundaries (sign-out,
  /// sign-in) where back-navigation into the previous flow must be impossible.
  Future<void> pushAndClear(BuildContext context, {Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(
        context,
        this,
        (route) => false,
        arguments: arguments,
      );

  Future<void> slowHeroPushReplacement(
    BuildContext context, {
    required Widget screen,
    Duration? transitionDuration,
  }) => Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      settings: RouteSettings(name: this),
      transitionDuration: transitionDuration ?? 1.seconds,
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );

  Future<void> pop<V extends Object?>(
    BuildContext context, [
    T? result,
  ]) async => Navigator.pop(context, result);

  Future<void> popUntil(BuildContext context) async =>
      Navigator.popUntil(context, ModalRoute.withName(this));

  bool sameRoute() =>
      NavigationHistoryObserver().history.isNotEmpty &&
      NavigationHistoryObserver().top?.settings.name == this;

  String get splitError => split(': ').lastOrNull ?? 'Unknown error';

  /// Adds [minutes] to a `"HH:mm"` clock string, rolling hours over a 24h day
  /// (e.g. `"23:50".clockPlusMinutes(30) == "00:20"`). Non-numeric parts fall
  /// back to 0.
  String clockPlusMinutes(int minutes) {
    final parts = split(':');
    final h = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    final total = (h * 60 + m + minutes) % (24 * 60);
    final norm = total < 0 ? total + 24 * 60 : total;
    final hh = (norm ~/ 60).toString().padLeft(2, '0');
    final mm = (norm % 60).toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}
