# Screen Structure — TaleemMate

> Never create screen files manually. Always use `hygen screen new` to generate the scaffold, then fill in the logic. See `docs/tooling/HYGEN.md` for exact commands.

---

## Choosing the Right Structure

```
Does the screen have text input / form fields?
  YES → With Forms (answer Yes to form prompt in hygen)
  NO  → Without Forms

Does ANY screen need a full-screen loading overlay or success/error listener?
  YES → Add Listeners/Consumers on top of whichever structure above
```

---

## Standard Screen Directory

```
lib/ui/screens/<screen_name>/
├── <screen_name>.dart      # Entry: imports, part declarations, ScreenClass + _Body
├── _state.dart             # _ScreenState extends ChangeNotifier (ephemeral UI state)
├── static/                 # (only if form screen)
│   ├── _form_keys.dart     # _FormKeys static constants
│   └── _form_data.dart     # _FormData.initialValues() — empty prod, dev prefill in debug
├── listeners/              # (only if cubit side-effects needed)
│   └── _{action}.dart      # BlocListener or BlocConsumer
└── widgets/                # private widget classes (part files)
    ├── _body.dart
    └── _header.dart
```

All files except the main `.dart` are `part of '<screen_name>.dart'`.

---

## 1. Without Forms

```dart
// home.dart
import 'package:flutter/material.dart';
import 'package:taleemmate/configs/configs.dart';
import 'package:provider/provider.dart';
import 'package:taleemmate/ui/widgets/core/screen/screen.dart';

part '_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final screenState = _ScreenState.s(context);

    return Screen(
      keyboardHandler: false,
      child: SafeArea(child: /* your UI */),
    );
  }
}
```

```dart
// _state.dart
part of 'home.dart';

class _ScreenState extends ChangeNotifier {
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  // local UI state here
}
```

---

## 2. With Forms

```dart
// login.dart
part '_state.dart';
part 'static/_form_keys.dart';
part 'static/_form_data.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    App.init(context);
    return ChangeNotifierProvider<_ScreenState>(
      create: (_) => _ScreenState(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final screenState = _ScreenState.s(context);

    return Screen(
      formKey: screenState.formKey,
      initialFormValue: _FormData.initialValues(),
      keyboardHandler: true,    // always true on form screens
      child: SafeArea(child: /* fields */),
    );
  }
}
```

```dart
// static/_form_keys.dart
part of '../login.dart';

class _FormKeys {
  static const email    = 'email';
  static const password = 'password';
}
```

```dart
// static/_form_data.dart
part of '../login.dart';

class _FormData {
  static Map<String, dynamic> initialValues() {
    if (!kDebugMode) return {};
    return {
      _FormKeys.email:    'test@example.com',
      _FormKeys.password: 'Password123!',
    };
  }
}
```

```dart
// _state.dart (form screen)
part of 'login.dart';

class _ScreenState extends ChangeNotifier {
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  final formKey = GlobalKey<FormBuilderState>();

  void onSubmit(BuildContext context) {
    final form = formKey.currentState!;
    if (!form.saveAndValidate()) return;
    context.dismissKeyboard();
    // UserCubit.c(context).login(form.value[_FormKeys.email], form.value[_FormKeys.password]);
  }
}
```

See `/building-forms` skill for the full form widget API.

---

## 3. Listeners and Consumers

### BlocConsumer (loading overlay + react to result)

Use when the action has a loading state the screen should display.

```bash
hygen screen consumer login
# Prompts for: cubit:module:state (e.g. user:login:login)
# Generates: lib/ui/screens/login/listeners/_login.dart
```

Generated `_login.dart`:

```dart
part of '../login.dart';

class _LoginListener extends StatelessWidget {
  const _LoginListener();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listenWhen: (a, b) => a.login != b.login,
      listener: (_, state) {
        if (state.login.isFailed) {
          UIFlash.error(context, state.login.fault?.message ?? 'Failed');
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

Attach in the main screen file:

```dart
part 'listeners/_login.dart';

// In _Body.build:
Screen(
  overlayBuilders: const [_LoginListener()],
  ...
)
```

### BlocListener (react only, no loading UI)

```bash
hygen screen listener home
# Generates: lib/ui/screens/home/listeners/_fetch.dart
```

---

## 4. Private Widgets

```bash
hygen screen _widget home
# Prompts for widget names
# Generates: widgets/_header.dart, _body.dart, etc.
```

Rules:
- All widget classes are **private** (`class _Header extends StatelessWidget`)
- Never extract to function widgets — always named classes
- `part of '../<screen_name>.dart'` at the top

---

## Screen Widget API

All screens use `Screen` (not raw `Scaffold`) from `lib/ui/widgets/core/screen/screen.dart`:

```dart
Screen(
  formKey: screenState.formKey,               // pass for form screens
  initialFormValue: _FormData.initialValues(),
  keyboardHandler: true,                      // true on ALL form screens
  overlayBuilders: const [                    // ALL listeners/consumers
    _LoginListener(),
  ],
  belowBuilders: const [...],                 // behind the content stack
  appBar: /* optional PreferredSizeWidget */,
  floatingActionButton: /* optional */,
  child: /* your screen body */,
)
```

---

## Adding a Screen to the Router

After generating:

1. **Add route constant** in `lib/router/routes.dart`:
```dart
static const myScreen = '/my-screen';
```

2. **Register route** in `lib/router/router.dart`:
```dart
// Static route (simple push)
AppRoutes.myScreen: (_) => const MyScreen(),

// Or FadeRoute (for main nav screens)
case AppRoutes.myScreen:
  return FadeRoute(child: const MyScreen(), settings: settings);
```

3. **Register cubit** (if new) in `lib/app.dart` under `// bloc-initiate-start`:
```dart
BlocProvider(create: (_) => MyCubit()),
```

---

## Common Pitfalls

| Mistake | Fix |
|---|---|
| Creating files manually | Always use `hygen screen new` |
| Inline field name strings (`'email'`) | Move to `_FormKeys.email` |
| Firebase/HTTP in `_ScreenState` | Move to a Cubit |
| Missing `keyboardHandler: true` on form screens | Always set it |
| Using raw `Scaffold` | Use `Screen` from `lib/ui/widgets/core/screen/` |
| Loading state in a `BlocListener` | Switch to `BlocConsumer` with `FullScreenLoader` |
| Not calling `App.init(context)` at top of build | Always call it first |
