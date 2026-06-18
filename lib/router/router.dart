import 'package:taleemmate/ui/screens/focus/focus.dart';
import 'package:taleemmate/ui/screens/profile/profile.dart';
import 'package:taleemmate/ui/screens/stepwise_loader/stepwise_loader.dart';
import 'package:taleemmate/ui/screens/onboarding/onboarding.dart';
import 'package:taleemmate/ui/screens/create_account/create_account.dart';
import 'package:taleemmate/ui/screens/login/login.dart';
import 'package:taleemmate/ui/screens/splash/splash.dart';
import 'package:taleemmate/ui/screens/progress/progress.dart';
import 'package:taleemmate/ui/screens/plan/plan.dart';
import 'package:taleemmate/ui/screens/tutor/tutor.dart';
import 'package:taleemmate/ui/screens/library/library.dart';
import 'package:taleemmate/ui/screens/home/home.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

final navigator = GlobalKey<NavigatorState>();

final appRoutes = <String, WidgetBuilder>{
  AppRoutes.profile: (_) => const ProfileScreen(),
  AppRoutes.stepwiseLoader: (_) => const StepwiseLoaderScreen(),
  AppRoutes.onboarding: (_) => const OnboardingScreen(),
  AppRoutes.createAccount: (_) => const CreateAccountScreen(),
  AppRoutes.login: (_) => const LoginScreen(),
  AppRoutes.splash: (_) => const SplashScreen(),
};

Route<dynamic>? onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.home:
      return FadeRoute(child: const HomeScreen(), settings: settings);
    case AppRoutes.library:
      return FadeRoute(child: const LibraryScreen(), settings: settings);
    case AppRoutes.tutor:
      return FadeRoute(child: const TutorScreen(), settings: settings);
    case AppRoutes.plan:
      return FadeRoute(child: const PlanScreen(), settings: settings);
    case AppRoutes.progress:
      return FadeRoute(child: const ProgressScreen(), settings: settings);
    case AppRoutes.focus:
      // Focus is a full-screen "session" surface — slide it up from the bottom
      // (and back down on dismiss) rather than the cross-fade the tabs use.
      return SlideUpRoute(child: const FocusScreen(), settings: settings);
    default:
      return null;
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget child;

  @override
  final RouteSettings settings;

  FadeRoute({required this.child, required this.settings})
    : super(
        settings: settings,
        pageBuilder: (context, ani1, ani2) => child,
        transitionsBuilder: (context, ani1, ani2, child) {
          return FadeTransition(opacity: ani1, child: child);
        },
      );
}

/// A bottom-to-top slide route (slides back down on dismiss). Used for the
/// full-screen Focus session so it reads as a surface that rises over the plan.
class SlideUpRoute extends PageRouteBuilder {
  final Widget child;

  @override
  final RouteSettings settings;

  SlideUpRoute({required this.child, required this.settings})
    : super(
        settings: settings,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, ani1, ani2) => child,
        transitionsBuilder: (context, ani1, ani2, child) {
          final curved = CurvedAnimation(
            parent: ani1,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          );
        },
      );
}
