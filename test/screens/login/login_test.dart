import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/quotes/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/repos/user/user_repo.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/screens/login/login.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_app.dart';

void main() {
  late MockUserRepo userRepo;

  setUpAll(() => registerFallbackValue(<String, dynamic>{}));

  setUp(() {
    setupPlatformMocks();
    userRepo = MockUserRepo();
    // Real UserCubit drives the screen; its repo is mocked via the test seam.
    UserRepo.ins = userRepo;
  });

  Future<void> pumpLogin(WidgetTester tester) async {
    // Tall surface so the un-scrolled login Column never overflows in tests.
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
        initialRoute: AppRoutes.login,
        userCubit: userCubit,
        quotesCubit: quotesCubit,
        libraryCubit: libraryCubit,
        chatCubit: chatCubit,
        planCubit: planCubit,
        routes: {
          ...stubRoutes, // real route below wins (later key overrides)
          AppRoutes.login: (_) => const LoginScreen(),
        },
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }

  group('LoginScreen — rendering', () {
    testWidgets('shows headings and field labels', (tester) async {
      await pumpLogin(tester);

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('SIGN IN'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('shows Login button, Create account link and Forgot password',
        (tester) async {
      await pumpLogin(tester);

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Create account'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
    });
  });

  group('LoginScreen — sign in flow', () {
    testWidgets('signing in routes an onboarded user home', (tester) async {
      when(() => userRepo.login(any())).thenAnswer((_) async => fakeFirebaseUser());
      when(() => userRepo.fetchProfile(any()))
          .thenAnswer((_) async => TestUser.rawJson(onboarded: true));

      await pumpLogin(tester);

      // The form is pre-seeded in debug mode (kDebugMode is true under test),
      // so validation passes and submit reaches the cubit.
      await tester.tap(find.text('Login'), warnIfMissed: false);
      await tester.pumpAndSettle();

      verify(() => userRepo.login(any())).called(1);
      expect(find.text('home-stub'), findsOneWidget);
    });

    testWidgets('signing in routes a new user to onboarding', (tester) async {
      when(() => userRepo.login(any())).thenAnswer((_) async => fakeFirebaseUser());
      when(() => userRepo.fetchProfile(any()))
          .thenAnswer((_) async => TestUser.rawJson(onboarded: false));

      await pumpLogin(tester);

      await tester.tap(find.text('Login'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('onboarding-stub'), findsOneWidget);
    });
  });
}
