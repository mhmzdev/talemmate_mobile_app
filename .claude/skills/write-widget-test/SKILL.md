---
name: write-widget-test
description: Write widget tests for TaleemMate screens and components. Use when testing UI rendering, form interactions, tap events, and navigation behaviour.
when_to_use: Triggered when asked to write widget tests, test a screen, test a form widget, test tap/input interactions, or verify UI state changes in response to cubit state.
allowed-tools: Read Write Edit Bash
---

# Writing Widget Tests in TaleemMate

Widget tests render a screen and interact with it via `WidgetTester`.
Stack: **`flutter_test` + `mocktail`** (no `bloc_test`). Full reference and the
rationale behind every gotcha below: [docs/TESTING.md](../../../docs/TESTING.md).

## Location & naming

- `test/screens/<screen>/<screen>_test.dart` — mirrors `lib/ui/screens/<screen>/`.
- File names are `snake_case`. `hygen screen new <name>` already scaffolds this
  file — flesh it out rather than hand-creating it.

## The harness — real driving cubit + mock repo

`TestApp` (helpers/test_app.dart) wires every cubit a signed-in shell touches,
plus `AppProvider`, under a themed `MaterialApp`. The cubit that **drives** the
screen stays REAL, fed through its mock repo via the `XRepo.ins` test seam. The
bystanders (`Library`/`Chat`/`Plan`) are **Fake** cubits whose `initUid` no-ops,
so restoring a session doesn't subscribe to Firestore.

```dart
late MockUserRepo userRepo;
setUpAll(() => registerFallbackValue(<String, dynamic>{}));
setUp(() {
  setupPlatformMocks();        // SharedPreferences for AppProvider
  userRepo = MockUserRepo();
  UserRepo.ins = userRepo;     // real UserCubit will reach the mock
});

Future<void> pumpLogin(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(1200, 2600));     // avoid overflow
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final userCubit = UserCubit();        addTearDown(userCubit.close);
  final quotesCubit = QuotesCubit();    addTearDown(quotesCubit.close);
  final libraryCubit = FakeLibraryCubit(); addTearDown(libraryCubit.close);
  final chatCubit = FakeChatCubit();    addTearDown(chatCubit.close);
  final planCubit = FakePlanCubit();    addTearDown(planCubit.close);

  await tester.pumpWidget(TestApp(
    initialRoute: AppRoutes.login,
    userCubit: userCubit, quotesCubit: quotesCubit,
    libraryCubit: libraryCubit, chatCubit: chatCubit, planCubit: planCubit,
    routes: { ...stubRoutes, AppRoutes.login: (_) => const LoginScreen() },
  ));
  await tester.pump(const Duration(milliseconds: 400));
}
```

## Test groups

```dart
group('LoginScreen — rendering', () {
  testWidgets('shows headings and field labels', (tester) async {
    await pumpLogin(tester);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
  });
});

group('LoginScreen — sign in flow', () {
  testWidgets('signing in routes an onboarded user home', (tester) async {
    when(() => userRepo.login(any())).thenAnswer((_) async => fakeFirebaseUser());
    when(() => userRepo.fetchProfile(any()))
        .thenAnswer((_) async => TestUser.rawJson(onboarded: true));

    await pumpLogin(tester);
    await tester.tap(find.text('Login'), warnIfMissed: false);
    await tester.pumpAndSettle();

    verify(() => userRepo.login(any())).called(1);
    expect(find.text('home-stub'), findsOneWidget);   // a stubRoutes destination
  });
});
```

## Gotchas (all handled by the helpers — keep them in mind)

- **Tall surface.** `setSurfaceSize` before pumping; un-scrolled screen Columns
  overflow the default 800×600 viewport, and an overflow fails the test.
- **Screens need a named route.** `Screen` reads `ModalRoute.of(context)!.name`,
  so the screen must be under `routes:`/`initialRoute`. Spread `stubRoutes`
  first, then the real route last (later keys win) so it isn't overwritten.
- **Plain `ThemeData`,** not `materialLightTheme` — that getter reads `AppText.*`
  which is only initialised once a screen runs `App.init(context)`.
- **Forms are pre-seeded in debug mode** (`kDebugMode` is true under test), so
  tapping submit validates and reaches the cubit without entering text.
- **Don't `pumpAndSettle` over long/infinite timers.** Splash delays `init()` by
  1s: `pump(const Duration(seconds: 1))` then settle. Pump explicit durations to
  drain entry-animation timers so none leak past the test.
- **Tap noise.** Some button labels render with `height: 0` text; tap with
  `warnIfMissed: false` (or target `find.byType(AppButton)`).

## Finders & interactions

```dart
find.text('Login')                       find.byType(AppFormTextInput)
await tester.enterText(find.byType(AppFormTextInput).first, 'x@y.com');
await tester.tap(find.text('Login'), warnIfMissed: false);
await tester.pumpAndSettle();            // or pump(Duration) past known timers
```

## Run

```bash
flutter test test/screens/login/login_test.dart   # one file
flutter test                                       # everything
```
