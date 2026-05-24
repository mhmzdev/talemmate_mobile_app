---
name: building-forms
description: Build forms in TaleemMate using flutter_form_builder and custom form widgets. Use when creating login, registration, or any data-entry screen.
when_to_use: Triggered when building forms, adding input fields, handling form validation, reading form values, or wiring up form submission.
allowed-tools: Read Bash
---

# Building Forms in TaleemMate

Forms use `flutter_form_builder` + `form_builder_validators` with custom wrappers.

## File Structure

Every form screen needs three artefacts alongside the screen:

```
lib/ui/screens/<name>/
  static/
    _form_keys.dart    # string field-name constants
    _form_data.dart    # debug prefill values
  _state.dart          # holds formKey
```

## Step 1 — Form Keys

```dart
// static/_form_keys.dart
part of '../<name>.dart';

class _FormKeys {
  static const email    = 'email';
  static const password = 'password';
  static const name     = 'name';
}
```

## Step 2 — Form Data (debug prefill)

```dart
// static/_form_data.dart
part of '../<name>.dart';

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

Only loads in debug mode — safe to commit.

## Step 3 — Screen State (formKey)

```dart
// _state.dart
class _ScreenState extends ChangeNotifier {
  static _ScreenState s(BuildContext context, [listen = false]) =>
      Provider.of<_ScreenState>(context, listen: listen);

  final formKey = GlobalKey<FormBuilderState>();
}
```

## Step 4 — Screen Wrapper

```dart
return Screen(
  formKey: screenState.formKey,
  initialFormValue: _FormData.initialValues(),
  keyboardHandler: true,
  child: ...,
);
```

## Step 5 — Text Input

```dart
AppFormTextInput(
  name: _FormKeys.email,
  heading: 'Email',
  placeholder: 'you@example.com',
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
  prefixIcon: LucideIcons.mail,
  validators: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.email(),
  ]),
)
```

Key props on `AppFormTextInput`:

| Prop | Type | Purpose |
|---|---|---|
| `name` | `String` | Must match a `_FormKeys` constant |
| `heading` | `String?` | Label above the field |
| `placeholder` | `String?` | Hint text |
| `obscureText` | `bool` | Password fields |
| `readOnly` | `bool` | Disabled appearance |
| `keyboardType` | `TextInputType?` | Input mode |
| `textInputAction` | `TextInputAction` | Keyboard action button |
| `prefixIcon` / `suffixIcon` | `IconData?` | Lucide icons |
| `validators` | `FormFieldValidator<String>?` | Use `FormBuilderValidators.compose([...])` |
| `state` | `AppFormState` | `.def`, `.focused`, `.disabled` |
| `onFieldSubmitted` | `Function(String)` | Move focus chain |
| `autofillHints` | `List<String>?` | e.g. `[AutofillHints.email]` |

## Other Input Types

```dart
// Date picker
AppFormDateInput(
  name: _FormKeys.dob,
  heading: 'Date of Birth',
  // uses DateFormat from intl
)

// Chips / multi-select
AppFormChipsInput(
  name: _FormKeys.subjects,
  heading: 'Subjects',
  options: ['Math', 'Science', 'Urdu'],
)
```

## Common Validators

```dart
import 'package:form_builder_validators/form_builder_validators.dart';

FormBuilderValidators.required()
FormBuilderValidators.email()
FormBuilderValidators.minLength(8)
FormBuilderValidators.maxLength(50)
FormBuilderValidators.numeric()
FormBuilderValidators.match(r'^[a-zA-Z]+$')
FormBuilderValidators.compose([v1, v2, v3])  // AND all validators
```

## Reading & Submitting

```dart
void _submit() {
  final form = screenState.formKey.currentState!;
  if (!form.saveAndValidate()) return;   // validates + triggers error display

  final values = form.value;             // Map<String, dynamic>
  final email = values[_FormKeys.email] as String;

  // dispatch to cubit / call API
}
```

## Focus Chain — Default: DO NOT use FocusNodes

**FocusNodes are opt-in, not default.** Flutter's keyboard `TextInputAction.next` already advances focus to the next form field for you — you do NOT need `FocusNode`s for the common case. Adding them creates lifecycle bugs (forgotten `dispose()`), bloats `_ScreenState`, and is pure ceremony for no behavior change.

```dart
// CORRECT default — no FocusNodes, no onFieldSubmitted plumbing
AppFormTextInput(
  name: _FormKeys.email,
  textInputAction: TextInputAction.next,
)

AppFormTextInput(
  name: _FormKeys.password,
  textInputAction: TextInputAction.done,
)
```

**Only add a FocusNode when ALL of the following are true:**
- You need to imperatively move focus from outside the field (e.g. after tapping a button, after a cubit response, on mount).
- The next field in tab order is NOT a TextFormField (Flutter's auto-advance only works text→text).
- You need to detect focus/blur for custom UI behavior (e.g. show/hide a hint).

If you DO need one, store it on `_ScreenState`, dispose it in `_ScreenState.dispose()`, and document the reason in a one-line comment above the field.

```dart
// _state.dart
class _ScreenState extends ChangeNotifier {
  // OTP field needs imperative focus after the phone-verify cubit succeeds
  final otpFocus = FocusNode();

  @override
  void dispose() {
    otpFocus.dispose();
    super.dispose();
  }
}
```

## Resetting a Form

```dart
screenState.formKey.currentState?.reset();
```
