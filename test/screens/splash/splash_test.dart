import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/quotes/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/repos/user/user_repo.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/screens/splash/splash.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockUserRepo userRepo;

  setUp(() {
    setupPlatformMocks();
    userRepo = MockUserRepo();
    UserRepo.ins = userRepo;
    // No restored session — splash should route to login after init resolves.
    when(() => userRepo.authChanges()).thenAnswer((_) => Stream.value(null));
    when(() => userRepo.currentUser).thenReturn(null);
  });

  Future<void> pumpSplash(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final userCubit = UserCubit();
    addTearDown(userCubit.close);
    final quotesCubit = QuotesCubit();
    addTearDown(quotesCubit.close);
    final libraryCubit = FakeLibraryCubit();
    addTearDown(libraryCubit.close);
    final chatCubit = FakeChatCubit();
    addTearDown(chatCubit.close);
    final planCubit = FakePlanCubit();
    addTearDown(planCubit.close);

    await tester.pumpWidget(
      TestApp(
        initialRoute: AppRoutes.splash,
        userCubit: userCubit,
        quotesCubit: quotesCubit,
        libraryCubit: libraryCubit,
        chatCubit: chatCubit,
        planCubit: planCubit,
        routes: {
          ...stubRoutes,
          AppRoutes.splash: (_) => const SplashScreen(),
        },
      ),
    );
  }

  testWidgets('renders the splash logo on first frame', (tester) async {
    await pumpSplash(tester);
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);

    // Drain the 1s delayed init() + animation timers so none leak past the test.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
  });

  testWidgets('routes to login once init resolves with no session', (tester) async {
    await pumpSplash(tester);

    // init() fires ~1s after first frame; advance past it, then settle the swap.
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('login-stub'), findsOneWidget);
  });
}
