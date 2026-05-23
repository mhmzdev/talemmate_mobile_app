# State Management — TaleemMate

## Two-tier system, strict rules

TaleemMate uses two state management tools with a clear, non-negotiable boundary:

| | `Provider` (ChangeNotifier) | `Cubit` (flutter_bloc) |
|---|---|---|
| **Layer** | UI layer | Business logic layer |
| **File** | `lib/ui/screens/{screen}/_state.dart` | `lib/blocs/{name}/` |
| **Scope** | One screen | Whole app |
| **Can call Firebase?** | **No** | Yes |
| **Can call HTTP?** | **No** | Yes |

---

## Provider — Ephemeral State

Used for UI-local concerns only: form key, password visibility, tab selection, local loading spinners.

### Pattern

```dart
// lib/ui/screens/login/_state.dart
part of 'login.dart';

class _ScreenState extends ChangeNotifier {
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  final formKey = GlobalKey<FormBuilderState>();

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  /// Delegates to a Cubit — never touches Firebase directly
  void onSubmit(BuildContext context) {
    final form = formKey.currentState!;
    if (!form.saveAndValidate()) return;
    context.dismissKeyboard();
    // SomeCubit.c(context).login(form.value);
  }
}
```

### Accessing in widgets

```dart
// Read-only (no rebuild)
final state = _ScreenState.s(context);

// Reactive (triggers rebuild on notifyListeners())
final state = _ScreenState.s(context, true);
```

---

## Cubit — Business Logic State

Handles all external dependencies: Firebase Auth, Firebase AI, Firestore, HTTP (Dio).

Cubits live in `lib/blocs/<name>/`. Register them in `TaleemMate`'s `MultiProvider` in `lib/app.dart` under the `// bloc-initiate-start` / `// bloc-initiate-end` comment anchors.

### BlocState\<T\> — the shared state wrapper

Every async action in a Cubit is a `BlocState<T>` field on the cubit's state class (from `lib/configs/bloc/_state.dart`). No hand-rolled sealed hierarchies.

```dart
// What BlocState<T> holds
BlocState<UserData>(
  action: BlocAction.loading,  // enum: def | init | preparing | loading | success | failed | cancelled
  data: null,                  // T? — success payload
  fault: null,                 // Fault? — error payload
  meta: null,                  // dynamic — optional extra context
)
```

**Transition methods** (return a new immutable `BlocState<T>`):

```dart
state.login.toLoading()
state.login.toSuccess(data: user)
state.login.toFailed(fault: fault)
state.login.toCancelled()
state.login.toDefault()
```

**Boolean getters** (from `BlocActionMixin`):

```dart
state.login.isLoading
state.login.isSuccess
state.login.isFailed
state.login.isDefault
state.login.isPreparing
state.login.isCancelled
```

**`when()` — functional UI rendering:**

```dart
state.login.when(
  loading: () => const CircularProgressIndicator(),
  success: () => Text('Welcome!'),
  failed: () => ErrorView(message: state.login.fault?.message),
  orElse: () => const SizedBox(),
)

// maybeWhen — orElse is required
state.login.maybeWhen(
  loading: () => const CircularProgressIndicator(),
  success: () => Text('Done'),
  orElse: () => const SizedBox.shrink(),
)
```

### Cubit state class pattern

```dart
// lib/blocs/user/state.dart
@immutable
class UserState extends Equatable {
  final BlocState<User>     login;
  final BlocState<UserData> fetchProfile;
  final BlocState<void>     logout;

  // Shared data hoisted to top level
  final UserData? userData;

  const UserState({
    required this.login,
    required this.fetchProfile,
    required this.logout,
    this.userData,
  });

  UserState.def()
    : login        = BlocState(),
      fetchProfile = BlocState(),
      logout       = BlocState(),
      userData     = null;

  UserState copyWith({
    BlocState<User>? login,
    BlocState<UserData>? fetchProfile,
    BlocState<void>? logout,
    UserData? userData,
  }) => UserState(
    login:        login        ?? this.login,
    fetchProfile: fetchProfile ?? this.fetchProfile,
    logout:       logout       ?? this.logout,
    userData:     userData     ?? this.userData,
  );

  @override
  List<Object?> get props => [login, fetchProfile, logout, userData];
}
```

### Cubit class pattern

```dart
// lib/blocs/user/cubit.dart
class UserCubit extends Cubit<UserState> {
  static UserCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<UserCubit>(context, listen: listen);

  UserCubit() : super(UserState.def());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(login: state.login.toLoading()));
    try {
      final user = await _doLogin(email, password);
      emit(state.copyWith(login: state.login.toSuccess(data: user)));
    } on FirebaseAuthException catch (e, st) {
      emit(state.copyWith(login: state.login.toFailed(
        fault: FirebaseAuthFault.fromFirebaseAuthException(e, st),
      )));
    } catch (e, st) {
      emit(state.copyWith(login: state.login.toFailed(
        fault: Fault.fromObjectAndStackTrace(e, st),
      )));
    }
  }
}
```

### Accessing Cubits

```dart
// Read-only — no rebuild
UserCubit.c(context).login(email, password);

// Reactive — triggers rebuild on state change
final state = UserCubit.c(context, true).state;
```

---

## Listeners — Reacting to Cubit State in UI

Listeners live in `lib/ui/screens/{screen}/listeners/_{action}.dart` as `part` files.

### BlocConsumer (loading overlay + react to result)

Use when the action needs a loading overlay visible in the screen.

```dart
// lib/ui/screens/login/listeners/_login.dart
part of '../login.dart';

class _LoginListener extends StatelessWidget {
  const _LoginListener();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listenWhen: (a, b) => a.login != b.login,
      listener: (_, state) {
        if (state.login.isFailed) {
          UIFlash.error(context, state.login.fault?.message ?? 'Login failed');
        }
        if (state.login.isSuccess) {
          AppRoutes.home.pushReplace(context);
        }
      },
      builder: (context, state) {
        return FullScreenLoader(loading: state.login.isLoading);
      },
    );
  }
}
```

### BlocListener (no loading overlay)

Use when you only need navigation/toast reactions with no loading UI.

```dart
part of '../home.dart';

class _FetchListener extends StatelessWidget {
  const _FetchListener();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContentCubit, ContentState>(
      listenWhen: (a, b) => a.fetch != b.fetch,
      listener: (_, state) {
        if (state.fetch.isFailed) {
          UIFlash.error(context, state.fetch.fault?.message ?? 'Failed');
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
```

Attach listeners to the screen via `overlayBuilders` on `Screen`:

```dart
Screen(
  overlayBuilders: const [_LoginListener(), _FetchListener()],
  child: ...,
)
```

---

## Anti-Patterns

```dart
// ❌ _ScreenState calling Firebase directly
class _HomeState extends ChangeNotifier {
  Future<void> fetch() async {
    final snap = await FirebaseFirestore.instance.collection('x').get(); // WRONG
  }
}

// ✅ Delegate to Cubit
class _HomeState extends ChangeNotifier {
  void fetch(BuildContext context) {
    ContentCubit.c(context).fetch(); // CORRECT
  }
}

// ❌ Function widget
Widget _body() => Container(); // WRONG

// ✅ Private widget class
class _Body extends StatelessWidget { // CORRECT
  @override
  Widget build(BuildContext context) => Container();
}

// ❌ Hand-rolled sealed state class
class UserLoading extends UserState {}
class UserLoaded extends UserState { final UserData data; ... } // WRONG

// ✅ BlocState<T> field on a flat state class
final BlocState<UserData> login; // CORRECT
```
