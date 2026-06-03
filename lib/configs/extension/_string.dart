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
}
