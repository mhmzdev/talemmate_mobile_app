import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/progress/cubit.dart';
import 'package:taleemmate/blocs/quotes/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/repos/progress/progress_repo.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/screens/progress/progress.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_app.dart';

// The real ProgressCubit drives the screen through a mock ProgressRepo (the
// `ins` seam). UserCubit is seeded logged-in so `startIfNeeded` resolves a uid.

class _SeededUserCubit extends UserCubit {
  _SeededUserCubit() {
    emit(state.loginSuccess());
  }
}

void main() {
  late MockProgressRepo repo;

  setUpAll(() => registerFallbackValue(<String, dynamic>{}));

  setUp(() {
    setupPlatformMocks();
    repo = MockProgressRepo();
    ProgressRepo.ins = repo;
    when(() => repo.refreshReadiness(any())).thenAnswer((_) async => null);
  });

  Future<void> pumpProgress(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final userCubit = _SeededUserCubit();
    addTearDown(userCubit.close);
    final quotesCubit = QuotesCubit();
    addTearDown(quotesCubit.close);
    final libraryCubit = FakeLibraryCubit();
    addTearDown(libraryCubit.close);
    final chatCubit = FakeChatCubit();
    addTearDown(chatCubit.close);
    final planCubit = FakePlanCubit();
    addTearDown(planCubit.close);
    final progressCubit = ProgressCubit();
    addTearDown(progressCubit.close);

    await tester.pumpWidget(
      TestApp(
        initialRoute: AppRoutes.progress,
        routes: {
          AppRoutes.progress: (_) => const ProgressScreen(),
          ...stubRoutes,
        },
        userCubit: userCubit,
        quotesCubit: quotesCubit,
        libraryCubit: libraryCubit,
        chatCubit: chatCubit,
        planCubit: planCubit,
        progressCubit: progressCubit,
      ),
    );
    // Post-frame load + the success/empty/failed emission.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('renders the five sections when populated', (tester) async {
    when(
      () => repo.dashboardData(any()),
    ).thenAnswer((_) async => TestProgress.rawDashboardData());
    when(() => repo.watchMetrics(any())).thenAnswer(
      (_) => Stream.value(TestProgress.rawMetrics(updatedAt: DateTime.now())),
    );

    await pumpProgress(tester);

    // Hero (nearest-exam subject = Physics) + mastery rows.
    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.text('Physics'), findsWidgets);
    expect(find.text('68%'), findsOneWidget);
    expect(find.text('42%'), findsOneWidget);
    // Quiz-history counter + stat row + insight.
    expect(find.text('3 quizzes · 24 questions'), findsOneWidget);
    expect(find.text('Study streak'), findsOneWidget);
    expect(find.text('You retain best in the morning.'), findsNothing);
  });

  testWidgets('shows the global insight once readiness returns it',
      (tester) async {
    when(
      () => repo.dashboardData(any()),
    ).thenAnswer((_) async => TestProgress.rawDashboardData());
    // Stale (empty) metrics → readiness pass runs and yields the insight.
    when(() => repo.watchMetrics(any())).thenAnswer((_) => Stream.value([]));
    when(
      () => repo.refreshReadiness(any()),
    ).thenAnswer((_) async => 'You retain best in the morning.');

    await pumpProgress(tester);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('You retain best in the morning.'), findsOneWidget);
  });

  testWidgets('shows the empty state when there is no data', (tester) async {
    when(
      () => repo.dashboardData(any()),
    ).thenAnswer((_) async => TestProgress.rawDashboardData(empty: true));
    when(() => repo.watchMetrics(any())).thenAnswer((_) => Stream.value([]));

    await pumpProgress(tester);

    expect(find.text('No progress yet'), findsOneWidget);
  });

  testWidgets('shows the error state and retries on tap', (tester) async {
    when(() => repo.dashboardData(any())).thenThrow(testFault('db down'));
    when(() => repo.watchMetrics(any())).thenAnswer((_) => Stream.value([]));

    await pumpProgress(tester);

    expect(find.text('Couldn\'t load your progress.'), findsOneWidget);

    await tester.tap(find.text('Try again'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    verify(() => repo.dashboardData(any())).called(greaterThanOrEqualTo(2));
  });
}
