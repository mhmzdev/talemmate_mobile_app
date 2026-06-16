---
name: write-unit-test
description: Write unit tests for TaleemMate cubits, services, and pure Dart logic. Use when testing BlocState transitions, fault handling, or any business logic.
when_to_use: Triggered when asked to write unit tests, test a cubit, test a service, or verify business logic in isolation.
allowed-tools: Read Write Edit Bash
---

# Writing Unit Tests in TaleemMate

Unit tests cover cubits, services, and pure Dart logic — no widget tree.
Stack: **`flutter_test` + `mocktail`** (no `bloc_test`, no `mockito`/codegen).
Full reference: [docs/TESTING.md](../../../docs/TESTING.md).

## Location & naming

- `test/blocs/<feature>/<feature>_cubit_test.dart` — mirrors `lib/blocs/<feature>/cubit.dart`.
- File names are `snake_case` (the `file_names` lint forbids dashes).
- `group('<methodName>', …)`; cases named `'<does what> when <condition>'`.

## The repo seam — mock the singleton

Cubits reach their repo through a singleton (`UserRepo.ins.login(...)`), not a
constructor. Each repo exposes a `@visibleForTesting` setter so tests can swap
in a mock. **If the repo lacks one, add it** (next to `get ins`):

```dart
static UserRepo _instance = UserRepo._();
static UserRepo get ins => _instance;
@visibleForTesting
static set ins(UserRepo repo) => _instance = repo;
```

Then in the test:

```dart
class MockUserRepo extends Mock implements UserRepo {}   // helpers/mocks.dart

late MockUserRepo repo;
setUpAll(() => registerFallbackValue(<String, dynamic>{})); // for any() on Maps
setUp(() {
  repo = MockUserRepo();
  UserRepo.ins = repo;        // every cubit now reaches the mock
});
```

## Collect emissions, then flush

States emit asynchronously. Record off the stream and **hop a macrotask** before
asserting, or the final state is lost:

```dart
Future<List<UserState>> record(Future<void> Function(UserCubit) act) async {
  final cubit = UserCubit();
  addTearDown(cubit.close);
  final states = <UserState>[];
  final sub = cubit.stream.listen(states.add);
  await act(cubit);
  await Future<void>.delayed(Duration.zero);   // ← flush
  await sub.cancel();
  return states;
}
```

## Test template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taleemmate/blocs/user/cubit.dart';
import 'package:taleemmate/repos/user/user_repo.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  // setUpAll / setUp installing MockUserRepo (see above) + the `record` helper.

  group('login', () {
    test('emits [loading, success] and populates user', () async {
      when(() => repo.login(any())).thenAnswer((_) async => fakeFirebaseUser());
      when(() => repo.fetchProfile(any())).thenAnswer((_) async => TestUser.rawJson());

      final states = await record((c) => c.login({'email': 'a@b.com', 'password': 'x'}));

      expect(states.first.login.isLoading, isTrue);
      expect(states.last.login.isSuccess, isTrue);
      expect(states.last.user, isNotNull);
      verify(() => repo.login(any())).called(1);
    });

    test('emits [loading, failed] on bad credentials', () async {
      when(() => repo.login(any())).thenThrow(testFault('wrong-password'));
      final states = await record((c) => c.login({'email': 'a@b.com', 'password': 'no'}));
      expect(states.last.login.isFailed, isTrue);
      expect(states.last.login.fault, isNotNull);
    });
  });
}
```

## Conventions

- Assert on `BlocState<T>` getters: `isLoading` / `isSuccess` / `isFailed`, and
  on `.data` / `.fault`.
- Build faults with the **raw** subtype: `UnknownFault('msg', StackTrace.empty)`
  — the `Fault.fromX` factories log to Crashlytics (not initialised in tests).
  The `testFault()` fixture wraps this.
- Stub with `thenAnswer((_) async => …)` / `thenThrow(testFault())`; verify with
  `verify(() => repo.x()).called(1)`.
- Put reusable doubles in `helpers/mocks.dart` and data/state builders in
  `helpers/fixtures.dart` — don't redefine per file.
- Close cubits in `addTearDown(cubit.close)`.

## Run

```bash
flutter test test/blocs/user/user_cubit_test.dart   # one file
flutter test                                         # everything
```
