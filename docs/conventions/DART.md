# Dart Code Conventions — TaleemMate

Follow these rules for every file you touch.

---

## Widgets

### Private Widget Classes — Always, No Exceptions

Never return a widget from a function. Always create a private class:

```dart
// WRONG
Widget _buildHeader() => Text('Hello');

// CORRECT
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Text('Hello');
}
```

### File Organization

Split large screens into `part` widget files:

```
lib/ui/screens/login/
  login.dart            — assembles _Body; holds part declarations
  _state.dart           — _ScreenState extends ChangeNotifier
  widgets/
    _body.dart          — class _Body extends StatelessWidget
    _header.dart        — class _Header extends StatelessWidget
```

### Widget Extraction Threshold

The "always a private class" rule above governs HOW to extract, not WHEN. **Don't extract widgets that aren't worth extracting** — a single Row or a one-line Container should be inlined in its parent.

Extract a private widget only when **at least one** of these is true:
- The subtree has **≥5 child widgets** (counting every node — `Padding`, `SizedBox`, `Icon`, `Text` all count)
- The subtree is **≥30 lines** of build code
- The subtree is reused in ≥2 places (then move it to `lib/ui/widgets/` with an `App` prefix)

If none apply: inline it. A screen with three children (header text, form, button) should NOT have three widget classes.

### Shared / Global Widgets

Use the `App` prefix for any widget shared across screens:
- `AppButton`, `AppFormTextInput`, `AppFormDateInput`
- Place in `lib/ui/widgets/` under the appropriate subdirectory

---

## File Size Limits

| File type | Max lines | Action if exceeded |
|---|---|---|
| UI / screen files | 200–250 | Split into `part` files or extract private widget classes |
| Functions / methods | 30–50 | Refactor into smaller helpers or private methods |

Use `part` / `part of` to split large files while keeping them in the same compile unit.

---

## Dart Style

### Always Use

```dart
// Trailing commas (enables auto-formatting)
MyWidget(
  child: Text('hello'),
)

// Arrow syntax for simple single-expression functions
String get label => 'Hello';

// const wherever possible
const SizedBox(height: 16)
const Text('Static text')

// Getters instead of no-param methods that return values
String get formattedDate => ...   // correct
String formattedDate() => ...     // avoid
```

### Dot Shorthands for Enums and Static Members

Use leading-dot shorthand (`.value`) when the type is inferred from context:

```dart
AppButton(
  style: .primary,
  size: .medium,
  state: isExpired ? .disabled : .def,
)
```

**Rules:**
- Works when the expected type is unambiguous from the parameter or variable declaration
- Works in ternary expressions: `condition ? .valueA : .valueB`
- Works in equality comparisons on the right-hand side: `style == .primary` ✓
- Does NOT work as a standalone expression statement

**TaleemMate enums to always use shorthands for:**

| Enum | Values |
|---|---|
| `AppButtonStyle` | `.primary` `.secondary` `.creamy` |
| `AppButtonSize` | `.small` `.medium` `.large` |
| `AppButtonState` | `.def` `.disabled` `.pressed` |
| `AppButtonRadius` | `.normal` `.round` |
| `AppFormState` | `.def` `.focused` `.disabled` |
| `BlocAction` | `.def` `.loading` `.success` `.failed` `.cancelled` |

### Never Use

```dart
// Deprecated color API
color.withOpacity(0.5)   // WRONG — deprecated

// Use instead:
color.withValues(alpha: 0.5)   // correct
```

---

## State Management

- Only BLoC/Cubit for business logic — no Riverpod, no `setState` for API calls
- UI widgets are pure view: they read cubit state and call methods, nothing else
- Never put API calls, Firebase calls, or formatting logic in a widget's `build()` method

```dart
// WRONG — Firebase in build
@override
Widget build(BuildContext context) {
  final snap = await FirebaseFirestore.instance.collection('x').get(); // NO
  return Text(snap.docs.first.id);
}

// CORRECT — cubit handles it, widget just reads state
@override
Widget build(BuildContext context) {
  return BlocBuilder<MyCubit, MyState>(
    builder: (context, state) => Text(state.someField.data?.label ?? ''),
  );
}
```

---

## Forms

- Use `flutter_form_builder` for all form handling — no custom form state
- Keep field name strings in `static/_form_keys.dart` — never inline strings
- Always use `Screen(keyboardHandler: true)` on form screens
- Call `form.saveAndValidate()` before reading `form.value`
- Call `context.dismissKeyboard()` before dispatching to cubit

---

## Async / Error Handling

### Every async cubit method must be wrapped in try/catch

```dart
// WRONG
Future<void> login(String email, String password) async {
  final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(...);
  emit(state.copyWith(login: state.login.toSuccess(data: cred.user)));
}

// CORRECT
Future<void> login(String email, String password) async {
  emit(state.copyWith(login: state.login.toLoading()));
  try {
    final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(...);
    emit(state.copyWith(login: state.login.toSuccess(data: cred.user)));
  } on FirebaseAuthException catch (e, st) {
    emit(state.copyWith(login: state.login.toFailed(
      fault: FirebaseAuthFault.fromFirebaseAuthException(e, st),
    )));
  } catch (e, st) {
    if (e is Fault) {
      emit(state.copyWith(login: state.login.toFailed(fault: e)));
    } else {
      emit(state.copyWith(login: state.login.toFailed(
        fault: Fault.fromObjectAndStackTrace(e, st),
      )));
    }
  }
}
```

### Always throw typed Fault subclasses — never raw exceptions

| Situation | Fault to throw |
|---|---|
| `FirebaseAuthException` | `FirebaseAuthFault.fromFirebaseAuthException(e, st)` |
| `FirebaseException` | `FirebaseFault.fromFirebase(e, st)` |
| `DioException` (HTTP) | `HttpFault.fromDioException(e, st)` |
| Unknown / catch-all | `Fault.fromObjectAndStackTrace(object, st)` |
| Custom domain error | `CustomFault(faultInfo, st)` |

The `if (e is Fault) rethrow;` / re-emit guard prevents double-wrapping a `Fault` that propagated from a nested call.

### Never fire-and-forget in cubits

```dart
// WRONG — exception is swallowed
repository.doSomething();

// CORRECT
await repository.doSomething();
```

---

## Logging

Never use `print()`. Use the `.appLog()` extension:

```dart
'Something happened'.appLog(level: AppLogLevel.info, tag: 'MyTag');
someError.appLog(level: AppLogLevel.error, tag: 'CubitName');
```

---

## Documentation Comments

Use `///` only for non-obvious "why" — not "what":

```dart
// WRONG — narrates the obvious
/// Builds the widget tree
@override
Widget build(BuildContext context) { ... }

// CORRECT — explains a non-obvious constraint
/// Noto Nastaliq Urdu must be loaded before rendering Arabic-script text
Widget _buildUrduText(String text) { ... }
```

---

## Lists

Use `ListView.builder` for any list that could exceed ~5 items:

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => _ItemTile(item: items[index]),
)
```

---

## Equatable

All BLoC states must implement `Equatable` with a complete `props` list:

```dart
class MyState extends Equatable {
  final BlocState<User> login;
  final BlocState<UserData> fetchProfile;

  const MyState({required this.login, required this.fetchProfile});

  @override
  List<Object?> get props => [login, fetchProfile]; // EVERY field
}
```

Missing a field in `props` causes silent rebuild failures.

---

## Pre-Completion Checklist

Before marking any task done:

- [ ] `dart analyze` passes — zero new errors or warnings
- [ ] No functions returning widgets (use private classes)
- [ ] No `setState` / Firebase calls in `_ScreenState` — delegate to Cubits
- [ ] No `print()` statements — use `.appLog()`
- [ ] No hardcoded colors, font sizes, or pixel values
- [ ] `color.withOpacity()` replaced with `color.withValues(alpha:)`
- [ ] Enum named parameters use dot shorthands (`.primary` not `AppButtonStyle.primary`)
- [ ] All BLoC states include complete `props` list
- [ ] Every async cubit method is wrapped in try/catch
- [ ] All `throw` statements use a typed `Fault` subclass
- [ ] `App.init(context)` is called at the top of every `build()` method
