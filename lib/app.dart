import 'blocs/library/cubit.dart';
import 'blocs/onboarding/cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/user/cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:taleemmate/core/db/database.dart';

import 'providers/app.dart';
import 'router/router.dart';
import 'router/routes.dart';
import 'services/logging/route_logger.dart';

class TaleemMate extends StatefulWidget {
  const TaleemMate({super.key});

  @override
  State<TaleemMate> createState() => _TaleemMateState();
}

class _TaleemMateState extends State<TaleemMate> {
  @override
  Widget build(BuildContext context) {
    App.init(context);

    return MultiProvider(
      providers: [
        // bloc-initiate-start
        BlocProvider(create: (_) => LibraryCubit()),
        BlocProvider(create: (_) => OnboardingCubit()),
        BlocProvider(create: (_) => UserCubit()),

        // bloc-initiate-end

        // provider-initiate-start
        ChangeNotifierProvider(create: (_) => AppProvider()),
        Provider<AppDatabase>(
          create: (_) => AppDatabase.ins,
          dispose: (_, db) => db.close(),
        ),

        // provider-initiate-end
      ],
      child: Consumer<AppProvider>(
        builder: (context, state, child) {
          return MaterialApp(
            locale: const Locale('en', 'GB'),
            supportedLocales: const [
              Locale('en', 'GB'),
              Locale('en', 'CA'),
              Locale('en', 'US'),
              Locale('en', 'AU'),
            ],
            title: 'TaleemMate',
            navigatorKey: navigator,
            themeMode: state.themeMode,
            theme: materialLightTheme,
            darkTheme: materialDarkTheme,
            debugShowCheckedModeBanner: false,
            routes: appRoutes,
            navigatorObservers: [RouteLogger()],
            onGenerateRoute: onGenerateRoutes,
            initialRoute: AppRoutes.splash,
            // builder: (context, child) => BlocSync(body: child!),
          );
        },
      ),
    );
  }
}
