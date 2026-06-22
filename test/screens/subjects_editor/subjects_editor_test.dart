import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/blocs/quotes/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/core/models/subject/subject.dart';
import 'package:taleemmate/repos/user/user_repo.dart';
import 'package:taleemmate/router/routes.dart';
import 'package:taleemmate/ui/screens/subjects_editor/subjects_editor.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';
import '../../helpers/test_app.dart';

// The editor reads its initial drafts from LibraryCubit.state.subjects and
// commits via LibraryCubit.commitSubjects (through the mock repo seam).

final _seeded = [
  const Subject(
    id: 's1',
    code: 'MATH',
    name: 'Mathematics',
    colorHex: '#4F7A5C',
    confidenceLevel: 0.6,
  ),
  const Subject(
    id: 's2',
    code: 'PHY',
    name: 'Physics',
    colorHex: '#A35C5C',
    confidenceLevel: 0.3,
  ),
];

class _SeededLibraryCubit extends LibraryCubit {
  _SeededLibraryCubit(MockLibraryRepo repo) : super(repo: repo) {
    emit(state.copyWith(userId: TestUser.uid, subjects: _seeded));
  }

  // The screen is pushed directly; no auth listener should reset the session.
  @override
  void initUid(String uid) {}
}

class _SeededUserCubit extends UserCubit {
  _SeededUserCubit() {
    emit(state.loginSuccess());
  }
}

/// Records `generate` calls and settles them synchronously (no Gemini / repo)
/// so the rebuild path can be asserted in isolation.
class _SpyPlanCubit extends PlanCubit {
  int generateCalls = 0;
  String? lastUid;

  @override
  void initUid(String uid) {}

  @override
  Future<void> generate(String userId) async {
    generateCalls++;
    lastUid = userId;
    emit(state.copyWith(generate: state.generate.toSuccess()));
  }
}

void main() {
  late MockLibraryRepo repo;

  setUpAll(() => registerFallbackValue(<String, dynamic>{}));

  setUp(() {
    setupPlatformMocks();
    UserRepo.ins = MockUserRepo();
    repo = MockLibraryRepo();
    when(() => repo.upsertSubject(any())).thenAnswer((_) async {});
    when(() => repo.removeSubject(any())).thenAnswer((_) async {});
    when(() => repo.materials(any())).thenAnswer((_) async => const []);
    when(
      () => repo.subjects(any()),
    ).thenAnswer((_) async => _seeded.map((s) => s.toJson()).toList());
  });

  Future<_SpyPlanCubit> pumpEditor(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final userCubit = _SeededUserCubit();
    addTearDown(userCubit.close);
    final quotesCubit = QuotesCubit();
    addTearDown(quotesCubit.close);
    final libraryCubit = _SeededLibraryCubit(repo);
    addTearDown(libraryCubit.close);
    final chatCubit = FakeChatCubit();
    addTearDown(chatCubit.close);
    final planCubit = _SpyPlanCubit();
    addTearDown(planCubit.close);

    await tester.pumpWidget(
      TestApp(
        initialRoute: AppRoutes.subjectsEditor,
        userCubit: userCubit,
        quotesCubit: quotesCubit,
        libraryCubit: libraryCubit,
        chatCubit: chatCubit,
        planCubit: planCubit,
        routes: {
          ...stubRoutes,
          AppRoutes.subjectsEditor: (_) => const SubjectsEditorScreen(),
        },
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
    return planCubit;
  }

  testWidgets('renders pre-filled with the loaded subjects', (tester) async {
    await pumpEditor(tester);

    expect(find.byType(SubjectsEditorScreen), findsOneWidget);
    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.text('Physics'), findsOneWidget);
  });

  testWidgets('opens the add-subject sheet and appends a row', (tester) async {
    await pumpEditor(tester);

    await tester.tap(find.text('Add a subject'));
    await tester.pumpAndSettle();
    expect(find.text('Add a subject'), findsWidgets); // tile + sheet title

    await tester.enterText(find.widgetWithText(TextField, 'Subject name').last,
        'Chemistry');
    await tester.tap(find.text('Add subject'));
    await tester.pumpAndSettle();

    expect(find.text('Chemistry'), findsOneWidget);
  });

  testWidgets('Save changes always offers the rebuild prompt', (tester) async {
    await pumpEditor(tester);

    await tester.tap(find.text('Save changes'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Rebuild this week\'s plan?'), findsOneWidget);
    // Nothing is written until the user commits to a rebuild.
    verifyNever(() => repo.upsertSubject(any()));
    verifyNever(() => repo.removeSubject(any()));
  });

  testWidgets('Rebuild persists the edits then regenerates', (tester) async {
    final plan = await pumpEditor(tester);

    // Remove the first subject (Mathematics).
    await tester.tap(find.byIcon(LucideIcons.x).first);
    await tester.pump();
    expect(find.text('Mathematics'), findsNothing);

    await tester.tap(find.text('Save changes'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.text('Rebuild'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Now the removal is persisted and a rebuild fired for the signed-in user.
    verify(() => repo.removeSubject('s1')).called(1);
    expect(plan.generateCalls, 1);
    expect(plan.lastUid, TestUser.uid);
  });

  testWidgets('Later discards the edits — no write, no rebuild', (tester) async {
    final plan = await pumpEditor(tester);

    await tester.tap(find.byIcon(LucideIcons.x).first);
    await tester.pump();
    await tester.tap(find.text('Save changes'), warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.text('Later'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    verifyNever(() => repo.removeSubject(any()));
    verifyNever(() => repo.upsertSubject(any()));
    expect(plan.generateCalls, 0);
    expect(find.text('Rebuild this week\'s plan?'), findsNothing);
  });
}
