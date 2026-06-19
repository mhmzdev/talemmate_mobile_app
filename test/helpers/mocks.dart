import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/chat/cubit.dart';
import 'package:taleemmate/blocs/library/cubit.dart';
import 'package:taleemmate/blocs/plan/cubit.dart';
import 'package:taleemmate/repos/plan/plan_repo.dart';
import 'package:taleemmate/repos/progress/progress_repo.dart';
import 'package:taleemmate/repos/quiz/quiz_repo.dart';
import 'package:taleemmate/repos/quotes/quotes_repo.dart';
import 'package:taleemmate/repos/user/user_repo.dart';

// ---------------------------------------------------------------------------
// Repo mocks — for cubit UNIT tests AND cubit-driven WIDGET tests.
//
// Cubits reach their repo through the `XRepo.ins` singleton (no constructor
// injection), so install a mock via the `@visibleForTesting` setter:
//
//   final repo = MockUserRepo();
//   UserRepo.ins = repo;            // swap the singleton
//   when(() => repo.login(any())).thenAnswer((_) async => fakeFirebaseUser());
// ---------------------------------------------------------------------------

class MockUserRepo extends Mock implements UserRepo {}

class MockQuotesRepo extends Mock implements QuotesRepo {}

class MockPlanRepo extends Mock implements PlanRepo {}

class MockQuizRepo extends Mock implements QuizRepo {}

class MockProgressRepo extends Mock implements ProgressRepo {}

// ---------------------------------------------------------------------------
// Firebase Auth user mock — cubits only ever read `.uid`. Use
// `fakeFirebaseUser()` (fixtures.dart) which returns one with `.uid` stubbed.
// ---------------------------------------------------------------------------

class MockFirebaseUser extends Mock implements User {}

// ---------------------------------------------------------------------------
// Fake peripheral cubits — for WIDGET tests of signed-in shells.
//
// The auth listeners call `LibraryCubit/ChatCubit/PlanCubit.initUid(uid)` on
// login/restore, which (for chat/plan) subscribe to Firestore/drift streams.
// These fakes neutralise that side effect so the screen under test renders and
// routes without touching the backend. The cubit under test stays REAL (driven
// through its mock repo) — only the bystanders are faked.
// ---------------------------------------------------------------------------

class FakeLibraryCubit extends LibraryCubit {
  @override
  void initUid(String uid) {}
}

class FakeChatCubit extends ChatCubit {
  @override
  void initUid(String uid) {}
}

class FakePlanCubit extends PlanCubit {
  @override
  void initUid(String uid) {}
}
