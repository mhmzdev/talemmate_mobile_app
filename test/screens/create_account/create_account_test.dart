import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/quotes/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/repos/user/user_repo.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/screens/create_account/create_account.dart';

import '../../helpers/mocks.dart';
import '../../helpers/test_app.dart';

void main() {
  setUpAll(() => registerFallbackValue(<String, dynamic>{}));

  setUp(() {
    setupPlatformMocks();
    UserRepo.ins = MockUserRepo();
  });

  Future<void> pumpCreateAccount(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2800));
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
        initialRoute: AppRoutes.createAccount,
        userCubit: userCubit,
        quotesCubit: quotesCubit,
        libraryCubit: libraryCubit,
        chatCubit: chatCubit,
        planCubit: planCubit,
        routes: {
          ...stubRoutes,
          AppRoutes.createAccount: (_) => const CreateAccountScreen(),
        },
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('renders the step header and title', (tester) async {
    await pumpCreateAccount(tester);

    expect(find.text('CREATE ACCOUNT'), findsOneWidget);
    expect(find.text('01 / 03'), findsOneWidget);
    expect(find.text("Let's set you up."), findsOneWidget);
  });

  testWidgets('renders all four input field labels', (tester) async {
    await pumpCreateAccount(tester);

    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
  });

  testWidgets('renders the submit button', (tester) async {
    await pumpCreateAccount(tester);

    expect(find.text('Create account'), findsOneWidget);
  });
}
