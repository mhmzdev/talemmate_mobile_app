import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taleemmate/blocs/chat/cubit.dart';
import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/blocs/progress/cubit.dart';
import 'package:taleemmate/blocs/quotes/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/providers/app.dart';
import 'package:taleemmate/router/routes.dart';

// ---------------------------------------------------------------------------
// Platform setup — call once in setUp() before pumping a screen.
//
// AppProvider reads SharedPreferences (theme cache) on construction, so it must
// have mock values available or it throws a MissingPluginException.
// ---------------------------------------------------------------------------

void setupPlatformMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
}

/// Stub navigation destinations for routing assertions. Each is a bare Scaffold
/// findable by `find.text('<route>-stub')`.
///
/// Spread this AFTER the real route of the screen under test so it isn't
/// overwritten — e.g.:
///   routes: { AppRoutes.login: (_) => const LoginScreen(), ...stubRoutes }
Map<String, WidgetBuilder> get stubRoutes => {
  AppRoutes.splash: (_) => const _Stub('splash'),
  AppRoutes.login: (_) => const _Stub('login'),
  AppRoutes.home: (_) => const _Stub('home'),
  AppRoutes.onboarding: (_) => const _Stub('onboarding'),
  AppRoutes.createAccount: (_) => const _Stub('create-account'),
};

class _Stub extends StatelessWidget {
  const _Stub(this.name);
  final String name;

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('$name-stub')));
}

// ---------------------------------------------------------------------------
// TestApp — wraps the routed screen tree with every cubit a signed-in shell
// touches plus AppProvider, under a themed MaterialApp.
//
// Cubits are provided ABOVE MaterialApp, so every pushed route inherits them.
// Pass mock cubits (helpers/mocks.dart) with their state stubbed.
// ---------------------------------------------------------------------------

class TestApp extends StatelessWidget {
  const TestApp({
    super.key,
    required this.initialRoute,
    required this.routes,
    required this.userCubit,
    required this.quotesCubit,
    required this.libraryCubit,
    required this.chatCubit,
    required this.planCubit,
    this.progressCubit,
  });

  final String initialRoute;
  final Map<String, WidgetBuilder> routes;
  final UserCubit userCubit;
  final QuotesCubit quotesCubit;
  final LibraryCubit libraryCubit;
  final ChatCubit chatCubit;
  final PlanCubit planCubit;

  /// The Progress screen's driving cubit. Optional — bystander shells get a
  /// default inert one (it only does work once `loadForUser` is called).
  final ProgressCubit? progressCubit;

  @override
  Widget build(BuildContext context) {
    final progress = progressCubit;
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>.value(value: userCubit),
        BlocProvider<QuotesCubit>.value(value: quotesCubit),
        BlocProvider<LibraryCubit>.value(value: libraryCubit),
        BlocProvider<ChatCubit>.value(value: chatCubit),
        BlocProvider<PlanCubit>.value(value: planCubit),
        if (progress != null)
          BlocProvider<ProgressCubit>.value(value: progress)
        else
          BlocProvider<ProgressCubit>(create: (_) => ProgressCubit()),
      ],
      child: ChangeNotifierProvider<AppProvider>(
        create: (_) => AppProvider(),
        child: MaterialApp(
          // A plain light theme is enough: screens re-derive their own tokens
          // via App.init(context); AppTheme only reads Theme.of(context)
          // .brightness. (The app's materialLightTheme can't be used here — it
          // reads AppText.* which is only initialised once a screen builds.)
          theme: ThemeData(brightness: Brightness.light),
          initialRoute: initialRoute,
          routes: routes,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
