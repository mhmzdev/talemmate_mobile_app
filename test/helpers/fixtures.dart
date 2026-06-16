import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/quotes/cubit.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/core/models/quotes/quote.dart';
import 'package:taleemmate/core/models/user/user.dart';
import 'package:taleemmate/services/fault/faults.dart';

import 'mocks.dart';

// ---------------------------------------------------------------------------
// Domain fixtures — canonical model instances + their raw Firestore/JSON form.
//
// Repos return raw `Map<String, dynamic>` (cubits do `Model.fromJson`), so the
// raw fixtures are what you stub `fetchProfile` etc. with; the model fixtures
// are what you assert against.
// ---------------------------------------------------------------------------

class TestUser {
  static const uid = 'test-uid';

  static Map<String, dynamic> rawJson({bool onboarded = true}) => {
    'uid': uid,
    'fullName': 'Test User',
    'email': 'test@example.com',
    'institution': null,
    'isOnboardingComplete': onboarded,
  };

  static UserData data({bool onboarded = true}) =>
      UserData.fromJson(rawJson(onboarded: onboarded));
}

class TestQuote {
  static Quote sample() => const Quote(
    q: 'The journey of a thousand miles begins with one step.',
    a: 'Lao Tzu',
    date: '2026-06-16',
  );
}

/// A Firebase [User] mock with `.uid` stubbed — the only field cubits read.
MockFirebaseUser fakeFirebaseUser({String uid = TestUser.uid}) {
  final user = MockFirebaseUser();
  when(() => user.uid).thenReturn(uid);
  return user;
}

/// A non-logging fault for failure-path tests. The `Fault.fromX` factories pipe
/// through `appLog` → Crashlytics (not initialised under test), so build the
/// raw subtype directly instead.
Fault testFault([String message = 'Something went wrong']) =>
    UnknownFault(message, StackTrace.empty);

// ---------------------------------------------------------------------------
// State builders — compose common composite states without boilerplate.
// Call on a `.def()` state: `UserState.def().loginSuccess()`.
// ---------------------------------------------------------------------------

extension UserStateX on UserState {
  UserState loginLoading() => copyWith(login: login.toLoading());

  UserState loginSuccess({bool onboarded = true}) => copyWith(
    user: fakeFirebaseUser(),
    userData: TestUser.data(onboarded: onboarded),
    login: login.toSuccess(data: TestUser.data(onboarded: onboarded)),
  );

  UserState loginFailed([String message = 'Incorrect email or password.']) =>
      copyWith(login: login.toFailed(fault: testFault(message)));

  UserState initSuccessLoggedIn({bool onboarded = true}) => copyWith(
    user: fakeFirebaseUser(),
    userData: TestUser.data(onboarded: onboarded),
    init: init.toSuccess(data: TestUser.data(onboarded: onboarded)),
  );

  UserState initSuccessLoggedOut() => copyWith(init: init.toSuccess());

  UserState initFailed([String message = 'Session restore failed']) =>
      copyWith(init: init.toFailed(fault: testFault(message)));
}

extension QuotesStateX on QuotesState {
  QuotesState todaySuccess([Quote? quote]) => copyWith(
    today: today.toSuccess(data: quote ?? TestQuote.sample()),
  );
}
