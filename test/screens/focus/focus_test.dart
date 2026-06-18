import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/chat/cubit.dart';
import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/core/models/schedule/study_block.dart';
import 'package:taleemmate/repos/plan/plan_repo.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/screens/focus/focus.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_app.dart';

// `/focus` is reached with the chosen StudyBlock as route arguments, so the
// screen is mounted via onGenerateRoute (not a bare `routes:` entry).

class _Stub extends StatelessWidget {
  const _Stub(this.name);
  final String name;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('$name-stub')));
}

void main() {
  late MockPlanRepo repo;

  setUpAll(() => registerFallbackValue(<String, dynamic>{}));

  setUp(() {
    setupPlatformMocks();
    repo = MockPlanRepo();
    PlanRepo.ins = repo;
    when(() => repo.updateBlock(any())).thenAnswer((_) async {});
    when(() => repo.recordSession(any())).thenAnswer((_) async {});
  });

  Future<void> pumpFocus(
    WidgetTester tester, {
    required StudyBlock block,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1000, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final planCubit = PlanCubit();
    addTearDown(planCubit.close);
    final chatCubit = ChatCubit();
    addTearDown(chatCubit.close);
    final libraryCubit = FakeLibraryCubit();
    addTearDown(libraryCubit.close);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<PlanCubit>.value(value: planCubit),
          BlocProvider<ChatCubit>.value(value: chatCubit),
          BlocProvider<LibraryCubit>.value(value: libraryCubit),
        ],
        child: MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          initialRoute: AppRoutes.focus,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.focus:
                return MaterialPageRoute(
                  builder: (_) => const FocusScreen(),
                  settings: RouteSettings(
                    name: AppRoutes.focus,
                    arguments: block,
                  ),
                );
              case AppRoutes.tutor:
                return MaterialPageRoute(
                  builder: (_) => const _Stub('tutor'),
                  settings: settings,
                );
              default:
                return MaterialPageRoute(
                  builder: (_) => const _Stub('home'),
                  settings: settings,
                );
            }
          },
        ),
      ),
    );
    // Let the button entry animations finish so they accept taps (they gate
    // pointer events until settled). Explicit pumps — the countdown timer
    // never idles, so pumpAndSettle would hang.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  /// Unmounts the screen so its countdown [Timer] is cancelled — call at the
  /// end of every test (a pending timer fails the invariant check). Settling
  /// afterwards drains any in-flight route transition.
  Future<void> disposeFocus(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  }

  testWidgets('renders the block guidance and timer chrome', (tester) async {
    await pumpFocus(
      tester,
      block: TestBlock.sample(
        title: 'Quadratic equations — practice',
        activities: 'Read + 5 questions',
      ),
    );

    expect(find.text('FOCUS SESSION'), findsOneWidget);
    expect(find.text('Quadratic equations — practice'), findsOneWidget);
    expect(find.text('Read + 5 questions'), findsOneWidget);

    await disposeFocus(tester);
  });

  testWidgets('Mark block done writes status:done via PlanCubit',
      (tester) async {
    await pumpFocus(tester, block: TestBlock.sample());

    // Let the button entry animation settle so the tap lands on it.
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.text('Mark block done'), warnIfMissed: false);
    await tester.pump();

    final patch = verify(() => repo.updateBlock(captureAny())).captured.single
        as Map<String, dynamic>;
    expect(patch['status'], BlockStatus.done.name);

    // Let the return-pop transition finish before tearing down.
    await tester.pump(const Duration(milliseconds: 400));
    await disposeFocus(tester);
  });

  testWidgets('I\'m stuck navigates into the tutor', (tester) async {
    await pumpFocus(tester, block: TestBlock.sample());

    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.text('I\'m stuck'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('tutor-stub'), findsOneWidget);

    await disposeFocus(tester);
  });
}
