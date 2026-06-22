import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/blocs/quotes/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/core/models/subject/subject.dart';
import 'package:taleemmate/repos/plan/plan_repo.dart';
import 'package:taleemmate/repos/user/user_repo.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/screens/schedule_editor/schedule_editor.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_app.dart';

// The schedule editor seeds from PlanCubit (schedule + exams) and LibraryCubit
// (subjects), and commits via PlanCubit.commitSchedule (mock repo seam).

const _subjects = [
  Subject(
    id: 'subj-maths',
    code: 'MATH',
    name: 'Mathematics',
    colorHex: '#4F7A5C',
    confidenceLevel: 0.6,
  ),
];

Map<String, dynamic> _scheduleMap() => {
  'id': TestBlock.scheduleId,
  'userId': TestUser.uid,
  'dailyTargetHours': 2.0,
  'enabledWindowIds': const ['morning'],
  'weekStartDate': null,
  'aiReasoning': 'r',
  'isAIGenerated': true,
};

Map<String, dynamic> _examMap() => {
  'id': 'e1',
  'subjectId': 'subj-maths',
  'date': DateTime.now().add(const Duration(days: 20)).toIso8601String(),
  'label': 'Midterm',
};

class _SeededLibraryCubit extends LibraryCubit {
  _SeededLibraryCubit() {
    emit(state.copyWith(userId: TestUser.uid, subjects: _subjects));
  }

  @override
  void initUid(String uid) {}
}

class _SeededUserCubit extends UserCubit {
  _SeededUserCubit() {
    emit(state.loginSuccess());
  }
}

/// Records `generate` calls and settles them synchronously (no Gemini) — the
/// rest of the cubit (watchForUser, commitSchedule) stays real over the mock
/// repo so the rebuild path can be asserted in isolation.
class _SpyPlanCubit extends PlanCubit {
  int generateCalls = 0;
  String? lastUid;

  @override
  Future<void> generate(String userId) async {
    generateCalls++;
    lastUid = userId;
    emit(state.copyWith(generate: state.generate.toSuccess()));
  }
}

void main() {
  late MockPlanRepo repo;

  setUpAll(() => registerFallbackValue(<String, dynamic>{}));

  setUp(() {
    setupPlatformMocks();
    UserRepo.ins = MockUserRepo();
    repo = MockPlanRepo();
    PlanRepo.ins = repo;
    when(
      () => repo.currentSchedule(any()),
    ).thenAnswer((_) async => _scheduleMap());
    when(() => repo.exams(any())).thenAnswer((_) async => [_examMap()]);
    when(() => repo.watchBlocks(any())).thenAnswer((_) => Stream.value(const []));
    when(() => repo.updateSchedule(any())).thenAnswer((_) async {});
    when(() => repo.upsertExam(any())).thenAnswer((_) async {});
    when(() => repo.removeExam(any())).thenAnswer((_) async {});
  });

  Future<_SpyPlanCubit> pumpEditor(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final userCubit = _SeededUserCubit();
    addTearDown(userCubit.close);
    final quotesCubit = QuotesCubit();
    addTearDown(quotesCubit.close);
    final libraryCubit = _SeededLibraryCubit();
    addTearDown(libraryCubit.close);
    final chatCubit = FakeChatCubit();
    addTearDown(chatCubit.close);
    final planCubit = _SpyPlanCubit();
    addTearDown(planCubit.close);
    // Seed schedule + exams into the cubit's caches before the editor builds.
    await planCubit.watchForUser(TestUser.uid);

    await tester.pumpWidget(
      TestApp(
        initialRoute: AppRoutes.scheduleEditor,
        userCubit: userCubit,
        quotesCubit: quotesCubit,
        libraryCubit: libraryCubit,
        chatCubit: chatCubit,
        planCubit: planCubit,
        routes: {
          ...stubRoutes,
          AppRoutes.scheduleEditor: (_) => const ScheduleEditorScreen(),
        },
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    return planCubit;
  }

  testWidgets('renders windows, target, and the seeded exam', (tester) async {
    await pumpEditor(tester);

    expect(find.byType(ScheduleEditorScreen), findsOneWidget);
    expect(find.text('Morning'), findsOneWidget);
    expect(find.text('Evening'), findsOneWidget);
    expect(find.text('2.0 hrs'), findsOneWidget);
    // Exam row resolves its subject name from the library subjects.
    expect(find.text('Mathematics'), findsOneWidget);
  });

  testWidgets('Save changes offers the rebuild prompt (no write yet)',
      (tester) async {
    await pumpEditor(tester);

    await tester.tap(find.text('Evening'));
    await tester.pump();

    await tester.tap(find.text('Save changes'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Rebuild this week\'s plan?'), findsOneWidget);
    verifyNever(() => repo.updateSchedule(any()));
  });

  testWidgets('Rebuild persists the schedule then regenerates', (tester) async {
    final plan = await pumpEditor(tester);

    await tester.tap(find.text('Evening'));
    await tester.pump();
    await tester.tap(find.text('Save changes'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.text('Rebuild'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    final sent = verify(() => repo.updateSchedule(captureAny())).captured.single
        as Map<String, dynamic>;
    expect(sent['enabledWindowIds'], containsAll(['morning', 'evening']));
    expect(plan.generateCalls, 1);
    expect(plan.lastUid, TestUser.uid);
  });

  testWidgets('Later discards the edits — no write, no rebuild',
      (tester) async {
    final plan = await pumpEditor(tester);

    await tester.tap(find.text('Evening'));
    await tester.pump();
    await tester.tap(find.text('Save changes'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.text('Later'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    verifyNever(() => repo.updateSchedule(any()));
    expect(plan.generateCalls, 0);
    expect(find.text('Rebuild this week\'s plan?'), findsNothing);
  });

  testWidgets('blocks saving when no study window is selected', (tester) async {
    await pumpEditor(tester);

    // Disable the only enabled window.
    await tester.tap(find.text('Morning'));
    await tester.pump();

    await tester.tap(find.text('Save changes'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    verifyNever(() => repo.updateSchedule(any()));
    expect(find.text('Rebuild this week\'s plan?'), findsNothing);
  });
}
