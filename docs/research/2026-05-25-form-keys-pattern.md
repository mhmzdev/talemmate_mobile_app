---
date: 2026-05-25T00:00:00+05:00
researcher: Claude (claude-sonnet-4-6)
git_commit: 9f0f2944f3dd2fc12acba2f250bfac4687c1b454
branch: main
repository: taleemmate
topic: "How form keys are defined in static/ folders, how they're used, and how form data flows in create_account / login screens"
tags: [research, codebase, forms, conventions, create_account, login]
status: complete
last_updated: 2026-05-25
---

# Research: Form Keys + Form Data convention in `static/` folders

**Date**: 2026-05-25
**Git Commit**: `9f0f2944f3dd2fc12acba2f250bfac4687c1b454`
**Branch**: `main`

## Research Question
How are form keys defined in `static/` folders, how are they used in state and widgets, and how is form data read — using create_account and login screens as the canonical examples.

## Summary
Every screen that owns a `flutter_form_builder` form puts two files in a sibling `static/` directory: `_form_keys.dart` (a `_FormKeys` class with `static const` string fields, one per field) and `_form_data.dart` (a `_FormData` class with a single `static Map<String, dynamic> initialValues()` method that returns debug prefill values, guarded by `kDebugMode`). Both files are `part of` the root screen file. Widgets reference fields with `name: _FormKeys.<x>`. Submit pulls `form.value` from the `GlobalKey<FormBuilderState>` on `_ScreenState` and passes the raw map directly to the cubit — no key-by-key extraction at the screen layer.

## Detailed Findings

### `static/_form_keys.dart` — field name constants

Both screens follow the exact same shape.

**`lib/ui/screens/create_account/static/_form_keys.dart`**
```dart
part of '../create_account.dart';

class _FormKeys {
  static const fullName = 'fullName';
  static const email = 'email';
  static const password = 'password';
  static const confirm = 'confirm';
  static const termsAccepted = 'termsAccepted';
}
```

**`lib/ui/screens/login/static/_form_keys.dart`**
```dart
part of '../login.dart';

class _FormKeys {
  static const email = 'email';
  static const password = 'password';
}
```

Conventions:
- Class name: `_FormKeys` (underscore-prefixed, PascalCase, plural).
- Fields: `static const` (untyped — Dart infers `String`), camelCase, value string matches the constant identifier.
- One file per screen; declared as `part of '../<screen>.dart';`.

### `static/_form_data.dart` — debug-only prefill values

**`lib/ui/screens/create_account/static/_form_data.dart`**
```dart
part of '../create_account.dart';

class _FormData {
  static Map<String, dynamic> initialValues() {
    if (!kDebugMode) {
      return {};
    }

    return {
      _FormKeys.fullName: 'Muhammad Hamza',
      _FormKeys.email: 'hamza@cui.edu.pk',
      _FormKeys.password: 'Hamza@123',
      _FormKeys.confirm: 'Hamza@123',
      _FormKeys.termsAccepted: false,
    };
  }
}
```

**`lib/ui/screens/login/static/_form_data.dart`**
```dart
part of '../login.dart';

class _FormData {
  static Map<String, dynamic> initialValues() {
    if (!kDebugMode) {
      return {};
    }
    return {
      _FormKeys.email: 'test@taleemmate.com',
      _FormKeys.password: 'test1234',
    };
  }
}
```

Conventions:
- Class name: `_FormData` (underscore-prefixed, PascalCase, singular).
- Single static method `initialValues() -> Map<String, dynamic>`.
- Guards `kDebugMode` (from `package:flutter/foundation.dart`); returns `{}` in release builds.
- Keys are always `_FormKeys.x` constants — never raw string literals.
- `_FormData` is NEVER used to extract data after submit. It is **only** prefill.

### `part` directive ordering in screen file

Both screens declare static parts first, then state, then listeners, then widgets:

**`lib/ui/screens/create_account/create_account.dart:23–30`**
```dart
part 'static/_form_data.dart';
part 'static/_form_keys.dart';
part '_state.dart';
part 'listeners/_register.dart';
part 'widgets/_tagline.dart';
part 'widgets/_password_strength.dart';
```

This makes `_FormKeys` / `_FormData` visible to all subsequent part files.

### Widget references to `_FormKeys`

`AppFormTextInput.name:` always uses a `_FormKeys.*` constant.

**`lib/ui/screens/login/login.dart:85–97`**
```dart
AppFormTextInput(
  name: _FormKeys.email,
  heading: 'Email',
  placeholder: 'you@example.com',
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
  ...
),
```

**`lib/ui/screens/create_account/create_account.dart:91`** — `name: _FormKeys.fullName`
**`lib/ui/screens/create_account/create_account.dart:99`** — `name: _FormKeys.email`
**`lib/ui/screens/create_account/create_account.dart:112`** — `name: _FormKeys.password`
**`lib/ui/screens/create_account/create_account.dart:127`** — `name: _FormKeys.confirm`
**`lib/ui/screens/create_account/create_account.dart:145`** — `FormBuilderField<bool>(name: _FormKeys.termsAccepted, ...)` (raw FormBuilderField for the terms checkbox).

Cross-field validator lookup also uses keys (`create_account.dart:136–141`):
```dart
final pw = formKey?.fields[_FormKeys.password]?.value as String?;
```

### Where `_FormData.initialValues()` is consumed

Both screens pass the prefill map through the project's `Screen` widget via `initialFormValue:`.

**`lib/ui/screens/login/login.dart:53`**
```dart
initialFormValue: _FormData.initialValues(),
```

**`lib/ui/screens/create_account/create_account.dart:56`**
```dart
initialFormValue: _FormData.initialValues(),
```

The `Screen` widget forwards this to the underlying `FormBuilder.initialValue`.

### `_state.dart` submit pattern — `form.value` passed raw

**`lib/ui/screens/login/_state.dart:11–23`**
```dart
void submit(BuildContext context) {
  try {
    final form = formKey.currentState!;
    final isValid = form.saveAndValidate();
    if (!isValid) return;

    final values = form.value;

    UserCubit.c(context).login(values);
  } catch (e) {
    UIFlash.error(context, 'Something went wrong on submit!');
  }
}
```

**`lib/ui/screens/create_account/_state.dart:19–29`**
```dart
void submit(BuildContext context) {
  try {
    final form = formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    context.dismissKeyboard();
    UserCubit.c(context).register(form.value);
  } catch (e, st) {
    'create_account.submit error: $e\n$st'.appLog(level: AppLogLevel.error);
    UIFlash.error(context, 'Something went wrong. Please try again.');
  }
}
```

Pattern:
1. `formKey.currentState` → `FormBuilderState`.
2. `form.saveAndValidate()` runs every field validator + saves into `form.value`.
3. Early return on `false` / `null`.
4. Pass `form.value` (raw `Map<String, dynamic>`) directly to the cubit. No key-by-key extraction, no `_FormData.fromForm()` wrapper.

### `formKey` ownership

`_ScreenState` owns the form key (`create_account/_state.dart:8`, `login/_state.dart:8`):
```dart
final formKey = GlobalKey<FormBuilderState>();
```

The Screen widget wires `formKey:` (parameter) → forwards to `FormBuilder`.

## Code References
- `lib/ui/screens/create_account/static/_form_keys.dart:1–9` — `_FormKeys` class for create account
- `lib/ui/screens/create_account/static/_form_data.dart:1–16` — `_FormData.initialValues()` for create account
- `lib/ui/screens/login/static/_form_keys.dart:1–6` — `_FormKeys` class for login
- `lib/ui/screens/login/static/_form_data.dart:1–14` — `_FormData.initialValues()` for login
- `lib/ui/screens/create_account/create_account.dart:23–30` — `part` declarations including both static files
- `lib/ui/screens/create_account/create_account.dart:56` — `_FormData.initialValues()` passed to `Screen.initialFormValue`
- `lib/ui/screens/login/login.dart:53` — same pattern for login
- `lib/ui/screens/login/_state.dart:11–23` — submit reads `form.value` and forwards to cubit
- `lib/ui/screens/create_account/_state.dart:19–29` — same submit shape with try/catch + logging

## Architecture Documentation
- The `static/` directory is the convention home for screen-scoped constants and reference data that should not live in `_state.dart`.
- `_FormKeys` exists to give a single source of truth for `name:` strings — referenced by every widget AND by `_FormData.initialValues()`. Cross-field validators look up sibling fields by the same constants.
- `_FormData` is a debug-only convenience — it is not part of the runtime data flow. The single API contract is `Map<String, dynamic>` flowing through `Screen.initialFormValue → FormBuilder.initialValue`.
- Screens never decompose `form.value` into a typed model at the screen layer; the cubit consumes the raw map.

## Related Docs
- `docs/conventions/STATE_MANAGEMENT.md` — Provider + Cubit boundaries
- `docs/screens/STRUCTURE.md` — Screen anatomy

## Open Questions
None — the pattern is consistent across both reference screens.
