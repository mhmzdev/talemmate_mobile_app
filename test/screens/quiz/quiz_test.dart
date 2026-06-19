import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/quiz/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/repos/quiz/quiz_repo.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/screens/quiz/quiz.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_app.dart';

// `/quiz` is reached with generation params as route arguments, so the screen is
// mounted via onGenerateRoute (not a bare `routes:` entry). The driving QuizCubit
// stays real; its repo is mocked via the `ins` seam. UserCubit is seeded
// logged-in so the screen resolves a uid and kicks generation.

class _Stub extends StatelessWidget {
  const _Stub(this.name);
  final String name;
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('$name-stub')));
}

/// A UserCubit pre-seeded with a logged-in user so the screen has a uid.
class _SeededUserCubit extends UserCubit {
  _SeededUserCubit() {
    emit(state.loginSuccess());
  }
}

void main() {
  late MockQuizRepo repo;

  setUpAll(() => registerFallbackValue(<String, dynamic>{}));

  setUp(() {
    setupPlatformMocks();
    repo = MockQuizRepo();
    QuizRepo.ins = repo;
    when(() => repo.recordAnswer(any())).thenAnswer((_) async {});
  });

  Future<void> pumpQuiz(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final userCubit = _SeededUserCubit();
    addTearDown(userCubit.close);
    final quizCubit = QuizCubit();
    addTearDown(quizCubit.close);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<UserCubit>.value(value: userCubit),
          BlocProvider<QuizCubit>.value(value: quizCubit),
        ],
        child: MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          initialRoute: AppRoutes.quiz,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRoutes.quiz:
                return MaterialPageRoute(
                  builder: (_) => const QuizScreen(),
                  settings: const RouteSettings(
                    name: AppRoutes.quiz,
                    arguments: QuizArgs(subjectId: 'subj-maths'),
                  ),
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
    // Post-frame generation kick + the success emission.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// Unmounts the screen so the display stopwatch [Timer] is cancelled (a pending
  /// timer fails the invariant check).
  Future<void> disposeQuiz(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  }

  void stubGenerate() {
    when(
      () => repo.generate(
        userId: any(named: 'userId'),
        subjectId: any(named: 'subjectId'),
        topicId: any(named: 'topicId'),
        sourceItemIds: any(named: 'sourceItemIds'),
      ),
    ).thenAnswer((_) async => TestQuiz.rawJson());
  }

  testWidgets('renders the first question after a successful generate',
      (tester) async {
    stubGenerate();
    await pumpQuiz(tester);

    expect(find.byType(QuizScreen), findsOneWidget);
    expect(find.text('Question 1 of 2'), findsOneWidget);
    expect(find.text('What is 2 + 2?'), findsOneWidget);
    // Options render.
    expect(find.text('4'), findsOneWidget);

    await disposeQuiz(tester);
  });

  testWidgets('picking an option reveals the feedback card', (tester) async {
    stubGenerate();
    await pumpQuiz(tester);

    // No feedback before answering.
    expect(find.text('FEEDBACK'), findsNothing);

    await tester.tap(find.text('4'));
    await tester.pump();

    expect(find.text('FEEDBACK'), findsOneWidget);
    expect(find.text('Correct'), findsOneWidget);
    expect(find.text('Two plus two equals four.'), findsOneWidget);

    // The pick is also recorded via the cubit.
    verify(() => repo.recordAnswer(any())).called(1);

    await disposeQuiz(tester);
  });

  testWidgets('Next advances and finishing shows the results view',
      (tester) async {
    stubGenerate();
    await pumpQuiz(tester);

    // Q1: answer correctly, then advance.
    await tester.tap(find.text('4'));
    await tester.pump();
    await tester.tap(find.text('Next question'), warnIfMissed: false);
    await tester.pump();

    expect(find.text('Question 2 of 2'), findsOneWidget);
    expect(find.text('What is the capital of France?'), findsOneWidget);

    // Q2: answer correctly, then finish.
    await tester.tap(find.text('Paris'));
    await tester.pump();
    await tester.tap(find.text('See results'), warnIfMissed: false);
    await tester.pump();

    // Results view: 2/2 correct = 100%.
    expect(find.text('100%'), findsOneWidget);
    expect(find.text('You got 2 of 2 correct.'), findsOneWidget);

    await disposeQuiz(tester);
  });

  testWidgets('Skip records a skipped answer and reveals feedback',
      (tester) async {
    stubGenerate();
    await pumpQuiz(tester);

    await tester.tap(find.text('Skip'), warnIfMissed: false);
    await tester.pump();

    expect(find.text('FEEDBACK'), findsOneWidget);
    expect(find.text('Not quite'), findsOneWidget);
    verify(() => repo.recordAnswer(any())).called(1);

    await disposeQuiz(tester);
  });

  testWidgets('back mid-quiz asks to confirm; Keep going stays', (tester) async {
    stubGenerate();
    await pumpQuiz(tester);

    // Header back arrow → confirmation alert (explicit pumps: the display
    // stopwatch timer never lets pumpAndSettle settle while mounted).
    await tester.tap(find.byIcon(LucideIcons.arrow_left));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Leave the quiz?'), findsOneWidget);
    expect(find.text('Keep going'), findsOneWidget);
    expect(find.text('Leave'), findsOneWidget);

    // Keep going dismisses the alert and stays on the quiz.
    await tester.tap(find.text('Keep going'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Leave the quiz?'), findsNothing);
    expect(find.byType(QuizScreen), findsOneWidget);

    await disposeQuiz(tester);
  });
}
