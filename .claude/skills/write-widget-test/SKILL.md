---
description: Write widget tests for TaleemMate screens and components. Use when testing UI rendering, form interactions, tap events, and navigation behaviour.
when_to_use: Triggered when asked to write widget tests, test a screen, test a form widget, test tap/input interactions, or verify UI state changes in response to cubit state.
allowed-tools: Read Bash
---

# Writing Widget Tests in TaleemMate

Widget tests render a subtree and interact with it via `WidgetTester`.

## Setup

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:taleemmate/configs/configs.dart';
```

File location: `test/widget/<feature>/<name>_test.dart`

## Minimal Test Harness

Screens need `MaterialApp`, theme, and their providers:

```dart
Widget buildSubject({YourCubit? cubit}) {
  return MaterialApp(
    theme: AppThemeData.light(),  // from lib/configs/theme/_theme_data.dart
    home: BlocProvider<YourCubit>(
      create: (_) => cubit ?? YourCubit(),
      child: ChangeNotifierProvider(
        create: (_) => _ScreenState(),  // if testing full screen
        child: const YourScreen(),
      ),
    ),
  );
}
```

For form screens add `FormBuilder` if the widget uses it internally (usually the Screen widget handles this).

## Basic Test Template

```dart
void main() {
  group('LoginScreen', () {
    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.byType(AppFormTextInput), findsNWidgets(2));
    });

    testWidgets('shows validation error on empty submit', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // tap submit
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('This field is required'), findsWidgets);
    });

    testWidgets('fills form and taps submit', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byWidgetPredicate((w) => w is AppFormTextInput &&
            (w as AppFormTextInput).name == 'email'),
        'test@example.com',
      );
      await tester.pumpAndSettle();

      // verify state or cubit was called
    });
  });
}
```

## Finding Widgets

```dart
find.byType(AppFormTextInput)          // by widget type
find.byKey(const Key('submit-btn'))    // by key (add Key to widget if needed)
find.text('Login')                     // by displayed text
find.descendant(of: find.byType(Form), matching: find.byType(TextField))
```

## Interactions

```dart
await tester.tap(find.text('Submit'));
await tester.enterText(find.byType(TextField).first, 'hello');
await tester.pump();              // single frame
await tester.pumpAndSettle();     // until no more frames (animations done)
await tester.drag(find.byType(ListView), const Offset(0, -300));
```

## Testing Cubit-Driven UI

Use a mock cubit or a real one with faked repository:

```dart
testWidgets('shows loading overlay when state is loading', (tester) async {
  final cubit = MockYourCubit();
  when(cubit.state).thenReturn(YourState(fetch: BlocState<Data>().toLoading()));
  when(cubit.stream).thenAnswer((_) => Stream.fromIterable([cubit.state]));

  await tester.pumpWidget(buildSubject(cubit: cubit));
  await tester.pump();

  expect(find.byType(FullScreenLoader), findsOneWidget);
});
```

## Testing Navigation

```dart
testWidgets('navigates to home after login success', (tester) async {
  final mockObserver = MockNavigatorObserver();

  await tester.pumpWidget(MaterialApp(
    navigatorObservers: [mockObserver],
    routes: {'/home': (_) => const HomeScreen()},
    home: BlocProvider(
      create: (_) => loginCubit,
      child: const LoginScreen(),
    ),
  ));

  // trigger the action that navigates
  loginCubit.emit(loginCubit.state.copyWith(login: BlocState().toSuccess()));
  await tester.pumpAndSettle();

  verify(mockObserver.didPush(any, any));
});
```

## Golden Tests (snapshots)

```dart
testWidgets('LoginScreen golden', (tester) async {
  await tester.pumpWidget(buildSubject());
  await tester.pumpAndSettle();
  await expectLater(
    find.byType(LoginScreen),
    matchesGoldenFile('goldens/login_screen.png'),
  );
});
```

Update goldens with `flutter test --update-goldens`.

## Conventions

- One test file per screen or component. Mirror the `lib/` path under `test/widget/`.
- Always call `pumpAndSettle()` after interactions that trigger animations.
- Name tests as `'<shows/renders/navigates> when <condition>'`.
- Add `Key` values to interactive widgets that are hard to find by type or text.
- Keep `buildSubject` at the top of each `group` file — one helper per file.
