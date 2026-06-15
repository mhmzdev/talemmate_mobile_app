# Widget Catalogue — TaleemMate

> Always check this catalogue before writing custom UI. If a widget already exists, use it.

All widgets live in `lib/ui/widgets/`. Import via direct path.

---

## Core Widgets

### `Screen` — `lib/ui/widgets/core/screen/screen.dart`

**Every screen must use this wrapper.** Provides: Scaffold, status bar styling, `FormBuilder` integration, keyboard dismissal, back-button interception, and automatic `BottomBar` for the five main nav routes.

```dart
Screen(
  formKey: screenState.formKey,              // wraps child in FormBuilder
  initialFormValue: _FormData.initialValues(),
  keyboardHandler: true,                     // dismiss keyboard on tap outside
  canPop: false,                             // prevent back navigation
  onBackPressed: () => ...,                  // called when back attempted
  overlayBuilders: const [_MyListener()],    // listeners float above content
  belowBuilders: const [...],                // rendered behind content
  appBar: /* optional PreferredSizeWidget */,
  floatingActionButton: /* optional */,
  child: _Body(),
)
```

The five bottom-bar routes (`/home`, `/library`, `/tutor`, `/plan`, `/progress`) render `BottomBar` automatically — no manual wiring needed.

---

### `AppButton` — `lib/ui/widgets/core/button/button.dart`

**The only button in the app.** Never use `ElevatedButton`, `TextButton`, or `InkWell` for primary actions.

> **Extending AppButton** — the button follows the data-driven widget pattern (ADR-010). Files: `_enums.dart` (styles/sizes/states), `_model.dart` (surface + text color holders), `_data.dart` (theme-aware map functions). To add a new style, add the enum value and a new entry in `_mapPropsToData()` — the widget itself is not touched.

```dart
AppButton(
  label: 'Continue',
  icon: LucideIcons.arrow_right,
  style: .primary,
  size: .medium,
  state: isLoading ? .disabled : .def,
  onTap: _onSubmit,
)
```

| Param | Type | Notes |
|---|---|---|
| `style` | `AppButtonStyle` | `.primary`, `.secondary`, `.creamy` |
| `size` | `AppButtonSize` | `.small`, `.medium`, `.large` |
| `state` | `AppButtonState` | `.def`, `.disabled`, `.pressed` |
| `borderRadius` | `AppButtonRadius` | `.normal`, `.round` |
| `label` | `String?` | Supply at least one of `label` or `icon` |
| `icon` | `IconData?` | Lucide icon |
| `mainAxisSize` | `MainAxisSize` | `.max` (full width) or `.min` (hug content) |
| `onTap` | `VoidCallback?` | Null = disabled appearance |

---

### `AppIconButton` — `lib/ui/widgets/core/buttons/app_icon_button.dart`

**The standard icon-only button.** A circular `subBackground` tap target wrapping a single Lucide icon. Use for header/toolbar actions and any standalone icon affordance — don't hand-roll an `AppTouch` + `Container` + `Icon`.

```dart
AppIconButton(
  icon: LucideIcons.settings_2,
  onTap: () => _openSettings(),
  padding: Space.a.t12,   // optional — defaults to Space.a.t12
)
```

| Param | Type | Notes |
|---|---|---|
| `icon` | `IconData` | Lucide icon (24px) |
| `onTap` | `VoidCallback` | Required |
| `padding` | `EdgeInsets?` | Defaults to `Space.a.t12` |

---

### `BottomBar` — `lib/ui/widgets/core/bottom_bar/bottom_bar.dart`

Tab navigation bar for the five main routes. Rendered automatically by `Screen` — never instantiate directly.

Main nav routes: `home`, `library`, `tutor`, `plan`, `progress`.

---

## Design Widgets

### `FullScreenLoader` — `lib/ui/widgets/design/full_screen_loader/full_screen_loader.dart`

Full-screen overlay loader. Used inside `overlayBuilders` via `BlocConsumer`:

```dart
// In a BlocConsumer builder
builder: (context, state) {
  return FullScreenLoader(loading: state.someAction.isLoading);
}
```

---

### `AppAiPill` — `lib/ui/widgets/design/misc/app_ai_pill.dart`

Small gold pill (dot + label) flagging an AI affordance. Used across the app — Profile aside, Library "AI INDEXED" badges, the Tutor header. Default label is `AI`.

```dart
const AppAiPill()              // "● AI"
const AppAiPill(text: 'AI INDEXED')
```

---

### `AppProgressDots` — `lib/ui/widgets/design/misc/progress_dots.dart`

Three staggered pulsing dots — a subtle "working" indicator. Used by `FullScreenLoader` and the Tutor typing bubble.

```dart
const AppProgressDots()                    // text-coloured, 5px
AppProgressDots(color: AppTheme.c.subText) // muted variant
```

---

## Form Widgets

Full details in the `/building-forms` skill. Quick reference:

### `AppFormTextInput` — `lib/ui/widgets/forms/text_input/text_input.dart`

Text input for `FormBuilder` forms. Always use a `_FormKeys` constant for `name`.

```dart
AppFormTextInput(
  name: _FormKeys.email,
  heading: 'Email',
  placeholder: 'you@example.com',
  prefixIcon: LucideIcons.mail,
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
  validators: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
    FormBuilderValidators.email(),
  ]),
)
```

Password field:

```dart
AppFormTextInput(
  name: _FormKeys.password,
  heading: 'Password',
  obscureText: true,
  onObscureTap: () {},   // toggles visibility — icon handled internally
  prefixIcon: LucideIcons.lock,
  validators: FormBuilderValidators.minLength(8),
)
```

---

### `AppFormDateInput` — `lib/ui/widgets/forms/date/date_input.dart`

Date picker input for `FormBuilder` forms.

```dart
AppFormDateInput(
  name: _FormKeys.dob,
  heading: 'Date of Birth',
)
```

---

### `AppFormChipsInput` — `lib/ui/widgets/forms/chips_input/chips_input.dart`

Multi-select chip input for `FormBuilder` forms.

```dart
AppFormChipsInput(
  name: _FormKeys.subjects,
  heading: 'Subjects',
  // options configured internally or passed as needed
)
```

---

### Creating a New Form Input

Pick the right starting point based on what the input does:

| The new input… | Starting point |
|---|---|
| Triggers a picker/modal to select a value (date, time, colour, location…) | Copy `date_input.dart` — it wraps `AppFormTextInputContent` with a read-only controller and a custom `_handleTap` |
| Accepts free text but with a custom keyboard type, mask, or suffix | Add props to `AppFormTextInput` directly, or use `AppFormTextInputContent` standalone |
| Has a fundamentally different interaction model (chips, toggle grid, slider, rating…) | Build a new widget wrapping `FormBuilderField<T>` directly, like `chips_input.dart` |

**Rule:** always embed the new widget in a `FormBuilderField<T>` so it participates in `saveAndValidate()`, validation, and reset. Never manage form state manually.

The forms system also follows the data-driven pattern (ADR-010). State colours (`def`, `pressed`, `disabled`) live in `_data.dart` — extend that map when adding new states, not the widget's `build()` method.

---

## Headless Widgets

These render no UI — they manage behavior only.

### `FocusHandler` — `lib/ui/widgets/headless/focus_handler.dart`

Dismisses keyboard when tapping outside a text field.

```dart
FocusHandler(child: Column(...))
```

`Screen(keyboardHandler: true)` wraps the child in `FocusHandler` automatically — no manual wrapping needed at screen level.

---

### `AppTouch` — `lib/ui/widgets/headless/app_touch.dart`

Consistent tap target with ripple. Use instead of raw `GestureDetector` for interactive elements that aren't buttons.

```dart
AppTouch(
  onTap: () => ...,
  child: _MyCard(),
)
```

---

### `ScrollColumnExpandable` — `lib/ui/widgets/headless/scroll_column_expandable.dart`

A `Column` inside a `SingleChildScrollView` that always fills available height. Use when the CTA button should stick to the bottom but content above should scroll.

```dart
ScrollColumnExpandable(
  children: [
    _Header(),
    _FormFields(),
    const Spacer(),
    _SubmitButton(),
  ],
)
```

---

### `KeepAlivePageView` — `lib/ui/widgets/headless/keep_alive_page_view.dart`

Keeps tab/page widgets alive when switching tabs. Prevents rebuild on re-visit.

```dart
KeepAlivePageView(
  pageController: _controller,
  children: const [_Tab1(), _Tab2(), _Tab3()],
)
```

---

## Animations

All in `lib/ui/animations/`.

| Widget | Purpose |
|---|---|
| `EntranceFader` | Fades child in on mount |
| `ScaleAnimation` | Scales child in on mount |
| `BottomAnimation` | Slides child up from below on mount |
| `LinearProgressWidget` | Animated linear progress bar |
| `RippleEffect` | Expanding ripple overlay |

Usage:

```dart
EntranceFader(child: _MyWidget())
ScaleAnimation(child: _MyCard())

// Or via extension
widget.withBottomAnimation()  // from BottomAnimation extension
```
