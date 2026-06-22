import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/repos/user/user_repo.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockUserRepo repo;

  setUpAll(() {
    // mocktail needs a fallback for Map<String, dynamic> when `any()` matches it.
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    repo = MockUserRepo();
    // Swap the singleton the cubit reaches through — no Firebase in tests.
    UserRepo.ins = repo;
  });

  /// Builds a cubit, records every emitted state, runs [act], then stops
  /// recording. The cubit is auto-closed at test teardown.
  Future<List<UserState>> record(
    Future<void> Function(UserCubit cubit) act,
  ) async {
    final cubit = UserCubit();
    addTearDown(cubit.close);
    final states = <UserState>[];
    final sub = cubit.stream.listen(states.add);
    await act(cubit);
    // Let the final emission flush through the broadcast stream before we stop
    // listening — stream delivery is a microtask, so a macrotask hop drains it.
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    return states;
  }

  group('register', () {
    test('emits [loading, success] and populates user + userData', () async {
      when(() => repo.register(any())).thenAnswer((_) async => fakeFirebaseUser());
      when(() => repo.fetchProfile(any())).thenAnswer((_) async => TestUser.rawJson());

      final states = await record(
        (c) => c.register({'email': 'a@b.com', 'password': 'pass1234'}),
      );

      expect(states.first.register.isLoading, isTrue);
      expect(states.last.register.isSuccess, isTrue);
      expect(states.last.user, isNotNull);
      expect(states.last.userData?.email, 'test@example.com');
    });

    test('emits [loading, failed] when the repo throws a Fault', () async {
      when(() => repo.register(any())).thenThrow(testFault('email-already-in-use'));

      final states = await record(
        (c) => c.register({'email': 'a@b.com', 'password': 'pass1234'}),
      );

      expect(states.first.register.isLoading, isTrue);
      expect(states.last.register.isFailed, isTrue);
      expect(states.last.register.fault, isNotNull);
    });
  });

  group('login', () {
    test('emits [loading, success] and populates user + userData', () async {
      when(() => repo.login(any())).thenAnswer((_) async => fakeFirebaseUser());
      when(() => repo.fetchProfile(any())).thenAnswer((_) async => TestUser.rawJson());

      final states = await record(
        (c) => c.login({'email': 'a@b.com', 'password': 'pass1234'}),
      );

      expect(states.first.login.isLoading, isTrue);
      expect(states.last.login.isSuccess, isTrue);
      expect(states.last.user, isNotNull);
      verify(() => repo.login(any())).called(1);
      verify(() => repo.fetchProfile(TestUser.uid)).called(1);
    });

    test('emits [loading, failed] on bad credentials', () async {
      when(() => repo.login(any())).thenThrow(testFault('wrong-password'));

      final states = await record(
        (c) => c.login({'email': 'a@b.com', 'password': 'nope'}),
      );

      expect(states.first.login.isLoading, isTrue);
      expect(states.last.login.isFailed, isTrue);
      expect(states.last.login.fault, isNotNull);
    });
  });

  group('init — session restore', () {
    test('emits success with no user when logged out', () async {
      when(() => repo.authChanges()).thenAnswer((_) => Stream.value(null));
      when(() => repo.currentUser).thenReturn(null);

      final states = await record((c) => c.init());

      expect(states.first.init.isLoading, isTrue);
      expect(states.last.init.isSuccess, isTrue);
      expect(states.last.user, isNull);
      expect(states.last.userData, isNull);
    });

    test('emits success with user + userData when a session is restored', () async {
      when(() => repo.authChanges()).thenAnswer((_) => Stream.value(fakeFirebaseUser()));
      when(() => repo.fetchProfile(any())).thenAnswer((_) async => TestUser.rawJson());

      final states = await record((c) => c.init());

      expect(states.last.init.isSuccess, isTrue);
      expect(states.last.user, isNotNull);
      expect(states.last.userData, isNotNull);
    });

    test('logs out and reports logged-out when the user has no profile doc', () async {
      when(() => repo.authChanges()).thenAnswer((_) => Stream.value(fakeFirebaseUser()));
      when(() => repo.fetchProfile(any())).thenAnswer((_) async => <String, dynamic>{});
      when(() => repo.logout()).thenAnswer((_) async {});

      final states = await record((c) => c.init());

      expect(states.last.init.isSuccess, isTrue);
      expect(states.last.userData, isNull);
      verify(() => repo.logout()).called(1);
    });
  });

  group('logout', () {
    test('emits [loading, success]', () async {
      when(() => repo.logout()).thenAnswer((_) async {});

      final states = await record((c) => c.logout());

      expect(states.first.logout.isLoading, isTrue);
      expect(states.last.logout.isSuccess, isTrue);
    });
  });

  group('updateProfile', () {
    test('emits [loading, success] and refreshes userData', () async {
      when(() => repo.login(any())).thenAnswer((_) async => fakeFirebaseUser());
      when(() => repo.fetchProfile(any())).thenAnswer((_) async => TestUser.rawJson());
      when(() => repo.update(any(), any())).thenAnswer(
        (_) async => {...TestUser.rawJson(), 'institution': 'NUST'},
      );

      final cubit = UserCubit();
      addTearDown(cubit.close);
      await cubit.login({'email': 'a@b.com', 'password': 'pass1234'});

      final states = <UserState>[];
      final sub = cubit.stream.listen(states.add);
      await cubit.updateProfile({'institution': 'NUST'});
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states.first.update.isLoading, isTrue);
      expect(states.last.update.isSuccess, isTrue);
      expect(states.last.userData?.institution, 'NUST');
      verify(() => repo.update(TestUser.uid, {'institution': 'NUST'})).called(1);
    });

    test('emits [loading, failed] when the repo throws a Fault', () async {
      when(() => repo.login(any())).thenAnswer((_) async => fakeFirebaseUser());
      when(() => repo.fetchProfile(any())).thenAnswer((_) async => TestUser.rawJson());
      when(() => repo.update(any(), any())).thenThrow(testFault('permission-denied'));

      final cubit = UserCubit();
      addTearDown(cubit.close);
      await cubit.login({'email': 'a@b.com', 'password': 'pass1234'});

      final states = <UserState>[];
      final sub = cubit.stream.listen(states.add);
      await cubit.updateProfile({'institution': 'NUST'});
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states.first.update.isLoading, isTrue);
      expect(states.last.update.isFailed, isTrue);
      expect(states.last.update.fault, isNotNull);
    });

    test('no-ops when there is no signed-in uid', () async {
      final states = await record((c) => c.updateProfile({'institution': 'NUST'}));

      expect(states, isEmpty);
      verifyNever(() => repo.update(any(), any()));
    });
  });

  group('reset', () {
    test('returns to a fresh default state', () async {
      when(() => repo.login(any())).thenAnswer((_) async => fakeFirebaseUser());
      when(() => repo.fetchProfile(any())).thenAnswer((_) async => TestUser.rawJson());

      final cubit = UserCubit();
      addTearDown(cubit.close);
      await cubit.login({'email': 'a@b.com', 'password': 'pass1234'});
      expect(cubit.state.user, isNotNull);

      cubit.reset();

      expect(cubit.state, UserState.def());
    });
  });
}
