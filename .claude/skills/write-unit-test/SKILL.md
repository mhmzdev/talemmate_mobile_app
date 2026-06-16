---
description: Write unit tests for TaleemMate cubits, services, and pure Dart logic. Use when testing BlocState transitions, fault handling, or any business logic.
when_to_use: Triggered when asked to write unit tests, test a cubit, test a service, or verify business logic in isolation.
allowed-tools: Read Bash
---

# Writing Unit Tests in TaleemMate

Unit tests cover cubits, services, and pure Dart logic. No widget tree involved.

## Setup

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
// import the cubit + its dependencies
```

File location: `test/unit/<feature>/<name>_cubit_test.dart`

## BlocState Pattern

All cubit states use `BlocState<T>` from `lib/configs/bloc/_state.dart`:

```dart
// Check state
state.isLoading    // BlocAction.loading
state.isSuccess    // BlocAction.success
state.isFailed     // BlocAction.failed
state.isDefault    // BlocAction.def

state.data         // T? — the result
state.fault        // Fault? — error info
state.fault?.message  // user-facing error string
```

## Cubit Test Template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taleemmate/configs/configs.dart';

// @GenerateMocks([YourRepository])
// import '<name>_cubit_test.mocks.dart';

void main() {
  late YourCubit cubit;
  // late MockYourRepository mockRepo;

  setUp(() {
    // mockRepo = MockYourRepository();
    cubit = YourCubit(/* mockRepo */);
  });

  tearDown(() {
    cubit.close();
  });

  group('YourCubit', () {
    test('initial state is default', () {
      expect(cubit.state.someField.action, BlocAction.def);
    });

    test('fetch transitions through loading → success', () async {
      // when(mockRepo.fetch()).thenAnswer((_) async => someData);

      final states = <BlocState>[];
      cubit.stream.listen((_) => states.add(cubit.state.someField));

      await cubit.fetch();

      expect(states.first.isLoading, isTrue);
      expect(states.last.isSuccess, isTrue);
      expect(states.last.data, /* expected */);
    });

    test('fetch emits failed state on error', () async {
      // when(mockRepo.fetch()).thenThrow(SomeException());

      await cubit.fetch();

      expect(cubit.state.someField.isFailed, isTrue);
      expect(cubit.state.someField.fault, isNotNull);
    });
  });
}
```

## Generating Mocks

Use `mockito` with `@GenerateMocks`:

```dart
@GenerateMocks([UserRepository, AuthService])
void main() { ... }
```

Then run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This produces `<name>_cubit_test.mocks.dart` in the same directory.

## Stubbing with Mockito

```dart
// Stub return value
when(mockRepo.getUser(any)).thenAnswer((_) async => fakeUser);

// Stub exception
when(mockRepo.delete(any)).thenThrow(Exception('network error'));

// Verify call happened
verify(mockRepo.getUser('uid-123')).called(1);
verifyNever(mockRepo.delete(any));
```

## Testing Pure Functions / Extensions

```dart
test('string extension capitalises first letter', () {
  expect('hello'.capitalised, 'Hello');
});

test('BlocState.toFailed copies fault', () {
  final state = BlocState<String>();
  final fault = Fault(message: 'err', code: 'E001');
  final failed = state.toFailed(fault: fault);
  expect(failed.isFailed, isTrue);
  expect(failed.fault?.message, 'err');
});
```

## Conventions

- One test file per cubit. Mirror the `lib/` path under `test/unit/`.
- Group by method name: `group('fetch', () { ... })`.
- Name tests as `'<does what> when <condition>'`.
- Don't mock what you can instantiate cheaply (e.g. `BlocState`, `Fault`).
- Close cubits in `tearDown` to avoid stream leaks.
