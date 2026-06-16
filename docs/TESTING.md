# TaleemMate — Testing

How the test layer is wired, the patterns to follow, and the seams that make
Firebase-backed code testable. Two skills generate the boilerplate:
[`/write-unit-test`](../.claude/skills/write-unit-test/SKILL.md) and
[`/write-widget-test`](../.claude/skills/write-widget-test/SKILL.md).

---

## Stack

| Purpose | Package | Notes |
|---|---|---|
| Test runner + widget harness | `flutter_test` | `testWidgets`, `WidgetTester`, finders |
| Mocks / stubs | `mocktail` | No codegen — `class MockX extends Mock implements X {}` |

> **Why not `bloc_test` / `mockito`?** `bloc_test` transitively pins the `test`
> package to a range whose `web_socket_channel ^2` conflicts with
> `firebase_ai`'s `^3`, so it cannot resolve in this app. `mockito` needs
> build_runner codegen for every mock. We use **`mocktail` only**: cubits are
> tested by collecting stream emissions; cubit-driven screens use the **real**
> cubit driven through a **mock repo**.

---

## Folder layout

`test/` mirrors `lib/`:

```
test/
  helpers/
    mocks.dart       # MockUserRepo, MockQuotesRepo, MockFirebaseUser, Fake*Cubit
    fixtures.dart    # TestUser / TestQuote data + State builder extensions
    test_app.dart    # setupPlatformMocks(), TestApp wrapper, stubRoutes
  blocs/
    <feature>/<feature>_cubit_test.dart   # mirrors lib/blocs/<feature>/cubit.dart
  screens/
    <screen>/<screen>_test.dart           # mirrors lib/ui/screens/<screen>/
```

- One test file per cubit / screen, file name in `snake_case` (Dart's
  `file_names` lint forbids dashes).
- Group unit tests by method name (`group('login', …)`); name cases
  `'<does what> when <condition>'`.

Run: `flutter test` · single file: `flutter test test/blocs/user/user_cubit_test.dart`.

---

## The repo test seam (key concept)

Cubits don't take their repo via constructor — they reach a singleton:
`UserRepo.ins.login(...)`. To mock that, each repo exposes a
`@visibleForTesting` setter:

```dart
class UserRepo {
  static UserRepo _instance = UserRepo._();
  static UserRepo get ins => _instance;

  @visibleForTesting
  static set ins(UserRepo repo) => _instance = repo;   // tests swap in a mock
}
```

In tests:

```dart
late MockUserRepo repo;
setUp(() {
  repo = MockUserRepo();
  UserRepo.ins = repo;   // every cubit now reaches the mock — no Firebase
});
```

> Adding this seam is the standard way to make a new repo testable. Keep it
> `@visibleForTesting` and never call the setter from production code.

---

## Unit-testing a cubit

States are emitted asynchronously, so collect them off the cubit's stream and
**flush the queue** before asserting (stream delivery is a microtask; a
macrotask hop drains the final emission):

```dart
Future<List<UserState>> record(Future<void> Function(UserCubit) act) async {
  final cubit = UserCubit();
  addTearDown(cubit.close);
  final states = <UserState>[];
  final sub = cubit.stream.listen(states.add);
  await act(cubit);
  await Future<void>.delayed(Duration.zero);   // ← flush, or you lose the last state
  await sub.cancel();
  return states;
}

test('login emits [loading, success] and populates user', () async {
  when(() => repo.login(any())).thenAnswer((_) async => fakeFirebaseUser());
  when(() => repo.fetchProfile(any())).thenAnswer((_) async => TestUser.rawJson());

  final states = await record((c) => c.login({'email': 'a@b.com', 'password': 'x'}));

  expect(states.first.login.isLoading, isTrue);
  expect(states.last.login.isSuccess, isTrue);
  expect(states.last.user, isNotNull);
});
```

Assert on the `BlocState<T>` action getters (`isLoading` / `isSuccess` /
`isFailed`) and on `.data` / `.fault`. Build faults with the **raw** subtype —
`UnknownFault('msg', StackTrace.empty)` (the `Fault.fromX` factories log to
Crashlytics, which isn't initialised under test). The `testFault()` helper does
this for you.

`mocktail` needs `registerFallbackValue(<String, dynamic>{})` in `setUpAll`
whenever you match a `Map` argument with `any()`.

---

## Widget-testing a screen

`TestApp` (helpers/test_app.dart) provides every cubit a signed-in shell touches
plus `AppProvider`, under a themed `MaterialApp`. The **driving** cubit stays
real (wired to a mock repo via the seam); the bystander cubits
(`Library`/`Chat`/`Plan`) are **Fake** subclasses whose `initUid` is a no-op, so
restoring a session doesn't subscribe to Firestore.

```dart
setUp(() {
  setupPlatformMocks();          // SharedPreferences for AppProvider
  userRepo = MockUserRepo();
  UserRepo.ins = userRepo;       // the real UserCubit drives the screen
});

testWidgets('signing in routes an onboarded user home', (tester) async {
  when(() => userRepo.login(any())).thenAnswer((_) async => fakeFirebaseUser());
  when(() => userRepo.fetchProfile(any()))
      .thenAnswer((_) async => TestUser.rawJson(onboarded: true));

  await pumpLogin(tester);                       // builds TestApp at AppRoutes.login
  await tester.tap(find.text('Login'), warnIfMissed: false);
  await tester.pumpAndSettle();

  expect(find.text('home-stub'), findsOneWidget); // stubRoutes destination
});
```

Gotchas baked into the helpers:

- **Set a tall surface** (`tester.binding.setSurfaceSize`) before pumping — the
  un-scrolled screen Columns overflow the default 800×600 viewport and an
  overflow is a test failure. Reset it in `addTearDown`.
- **Screens must be pushed as a named route.** `Screen` reads
  `ModalRoute.of(context)!.settings.name`, so put the screen under
  `routes:`/`initialRoute`. Spread `stubRoutes` first, then the real route last
  (later map keys win) so the screen under test isn't overwritten by its stub.
- **`MaterialApp.theme` is a plain `ThemeData`,** not the app's
  `materialLightTheme` — that getter reads `AppText.*`, which is only
  initialised once a screen calls `App.init(context)`. Screens derive their own
  tokens, so a plain light theme is enough.
- **Forms are pre-seeded in debug mode** (`kDebugMode` is true under test), so
  tapping submit validates and reaches the cubit without entering text.
- **Avoid `pumpAndSettle` on infinite/long timers.** Splash delays `init()` by
  1s — `pump(const Duration(seconds: 1))` to fire it, then settle. Pump explicit
  durations to drain entry-animation timers instead of leaking them.

---

## Adding tests for new code

- **New cubit?** Add the `@visibleForTesting` `ins` setter to its repo, a
  `MockXRepo` in `helpers/mocks.dart`, fixtures + a `XStateX` builder extension
  in `helpers/fixtures.dart`, then `flutter test`. Use `/write-unit-test`.
- **New screen?** `hygen screen new <name>` already scaffolds
  `test/screens/<name>/<name>_test.dart` from the template. Flesh out the
  render / interaction / routing groups with `/write-widget-test`.
