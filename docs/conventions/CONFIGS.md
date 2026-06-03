# Configs Layer Reference — TaleemMate

> `lib/configs/` is the UI foundation layer. Everything that touches spacing, color, typography, navigation, or shared Dart extensions lives here.
> Read this before writing any UI code — most raw `EdgeInsets`, `SizedBox`, `TextStyle`, and `Navigator` calls are replaced by these APIs.

Import everything with a single import:
```dart
import 'package:taleemmate/configs/configs.dart';
```

---

## `App.init(context)`

Every `build()` method **must** call this first:

```dart
@override
Widget build(BuildContext context) {
  App.init(context);   // initializes AppMedia, AppTheme, Space, AppText, AppUnit
  ...
}
```

`App.init` is idempotent within a frame. Forgetting it causes `LateInitializationError` at runtime.

---

## Navigation

Routes are plain strings in `lib/router/routes.dart`. The string extension (from `lib/configs/extension/_string.dart`) adds named-navigation methods so you never call `Navigator.*Named` directly.

### AppRoutes

```dart
abstract class AppRoutes {
  static const splash         = '/splash';
  static const login          = '/login';
  static const createAccount  = '/create-account';
  static const home           = '/home';
  static const library        = '/library';
  static const tutor          = '/tutor';
  static const plan           = '/plan';
  static const progress       = '/progress';
}
```

### Navigation methods

| Method | Underlying call |
|---|---|
| `.push(context)` | `Navigator.pushNamed` |
| `.pushReplace(context)` | `Navigator.pushReplacementNamed` |
| `.pushAndClear(context)` | `Navigator.pushNamedAndRemoveUntil(…, (r) => false)` — wipes the whole stack; use at session boundaries (sign-in / sign-out) |
| `.pop(context, [result])` | `Navigator.pop` |
| `.popUntil(context)` | `Navigator.popUntil(ModalRoute.withName(this))` |
| `.sameRoute()` | `NavigationHistoryObserver` — `true` if already on top |

**Examples:**

```dart
AppRoutes.home.push(context);
AppRoutes.login.pushReplace(context);
AppRoutes.home.popUntil(context);

// Guard against double-push
if (!AppRoutes.home.sameRoute()) {
  AppRoutes.home.push(context);
}
```

---

## Space System

Three cooperating parts: tokens → models → the `Space` class.

### SpaceToken — raw double values

Named by pixel value: `t04 = 4.0`, `t08 = 8.0`, `t12 = 12.0`, `t16 = 16.0`, `t24 = 24.0`, `t32 = 32.0`, `t48 = 48.0`, `t64 = 64.0`.

Use `SpaceToken.*` only when you need a raw `double` (e.g. icon sizes, border widths). For layout use `Space.*`.

### Space — SizedBox widgets and EdgeInsets

| Property | Type | What it produces |
|---|---|---|
| `Space.x.t16` | `Widget` (SizedBox) | Horizontal gap of 16 px — use in `Row` |
| `Space.y.t16` | `Widget` (SizedBox) | Vertical gap of 16 px — use in `Column` |
| `Space.a.t20` | `EdgeInsets` | `EdgeInsets.all(20)` |
| `Space.h.t20` | `EdgeInsets` | `EdgeInsets.symmetric(horizontal: 20)` |
| `Space.v.t20` | `EdgeInsets` | `EdgeInsets.symmetric(vertical: 20)` |
| `Space.t.t20` | `EdgeInsets` | `EdgeInsets.only(top: 20)` |
| `Space.b.t20` | `EdgeInsets` | `EdgeInsets.only(bottom: 20)` |
| `Space.l.t20` | `EdgeInsets` | `EdgeInsets.only(left: 20)` |
| `Space.r.t20` | `EdgeInsets` | `EdgeInsets.only(right: 20)` |
| `Space.sym([h, v])` | `EdgeInsets` | `EdgeInsets.symmetric` |
| `Space.only([t,r,b,l])` | `EdgeInsets` | `EdgeInsets.only` |

```dart
// Column gaps
Column(children: [
  _Header(),
  Space.y.t24,
  _Body(),
  Space.y.t16,
  _Footer(),
]);

// Padding
Padding(padding: Space.h.t20, child: ...);
Padding(padding: Space.a.t16, child: ...);
```

---

## Theme

### `AppTheme.c` — semantic color tokens

Always use these — never hardcode `Color(0xff...)` in UI code. Auto-resolves light/dark.

| Token | Purpose |
|---|---|
| `AppTheme.c.primary` | Brand dark blue |
| `AppTheme.c.accent` | Brand gold/tan |
| `AppTheme.c.text` | Primary text |
| `AppTheme.c.subText` | Secondary / hint text |
| `AppTheme.c.background` | Page background |
| `AppTheme.c.subBackground` | Card / elevated surface |
| `AppTheme.c.specBackground` | Distinct surface (white in light, dark card in dark) |
| `AppTheme.c.error` | Destructive / error |

### Static colors (`AppColors`)

Use when you need a color independent of theme (e.g. inside a gradient):

```dart
AppColors.primary    // Color(0xff0F2027)
AppColors.accent     // Color(0xffD4A574)
AppColors.error      // Color(0xffA35C5C)
AppColors.success    // Color(0xff4F7A5C)
AppColors.warning    // Color(0xffD4860A)
```

---

## Typography (`AppText`)

All styles use **Geist** by default.

| Token | Use for |
|---|---|
| `AppText.b1` | Primary body text |
| `AppText.b2` | Secondary body, captions, labels |

**Modifiers** (chainable):

```dart
AppText.b1.cl(AppTheme.c.text)          // set color
AppText.b1.w(500)                       // font weight (100–700)
AppText.b1.w(3)                         // shorthand: 3 = 300
AppText.b1.gm()                         // switch to GeistMono font
AppText.b2.cl(AppTheme.c.subText).w(3)  // chain multiple
```

**Font families:**

| Font | Use for |
|---|---|
| Geist | Default body text |
| Fraunces | Display / headings |
| GeistMono | Code, monospace content (via `.gm()`) |
| NotoNastaliqUrdu | Urdu / Arabic-script text |

---

## AppProps — shared durations

```dart
AppProps.quick   // 100 ms
AppProps.medium  // 300 ms (most animations)
AppProps.normal  // 500 ms
```

---

## Extensions Reference

### `SuperString` on `String`

| Extension | What it does |
|---|---|
| `.push(context)` | Navigate via `pushNamed` |
| `.pushReplace(context)` | Navigate via `pushReplacementNamed` |
| `.pushAndClear(context)` | Navigate and remove all routes beneath (session boundaries) |
| `.sameRoute()` | `true` if this route is currently on top |
| `.available` (on `String?`) | `true` if non-null and non-empty |
| `.splitError` | Returns last segment after `': '` — strips Firebase error prefixes |

### `SuperInt` / `SuperDouble` on `int` / `double`

| Extension | What it does |
|---|---|
| `n.radius()` | `BorderRadius.circular(n)` |
| `n.milliseconds` | `Duration(milliseconds: n)` (supercharged) |
| `n.seconds` | `Duration(seconds: n)` |

```dart
Container(decoration: BoxDecoration(borderRadius: 12.radius()));
AnimatedContainer(duration: 100.milliseconds, ...);
```

### `SuperContext` on `BuildContext`

| Extension | What it does |
|---|---|
| `.currentPath` | Current route name from `ModalRoute` |
| `.canPop` | `Navigator.canPop` |
| `.dismissKeyboard()` | Unfocuses active `FocusNode` |
| `.topSafe()` | Top safe area height in logical px |
| `.bottomSafe()` | Bottom safe area height in logical px |

### Collection extensions

| Extension | What it does |
|---|---|
| `List?.available` | `true` if non-null and non-empty |
| `Map?.isAvailable` | `true` if non-null and non-empty |
| `Iterable<T>.firstWhereOrNull(test)` | Safe `firstWhere` — returns `null` instead of throwing |

### `AppMedia` — device dimensions

Read-only after `App.init(context)` has been called.

| Field | What it is |
|---|---|
| `AppMedia.width` | Screen width in logical px |
| `AppMedia.height` | Screen height in logical px |
| `AppMedia.padding` | Safe area `EdgeInsets` |
| `AppMedia.safeWidth` | Width minus horizontal safe area |
| `AppMedia.safeHeight` | Height minus vertical safe area |

---

## Quick-Reference Cheat Sheet

```dart
// Navigation
AppRoutes.home.push(context);
AppRoutes.login.pushReplace(context);
AppRoutes.home.popUntil(context);

// Spacing
Space.y.t24          // vertical SizedBox(24)
Space.x.t16          // horizontal SizedBox(16)
Space.h.t20          // EdgeInsets.symmetric(horizontal: 20)
Space.a.t16          // EdgeInsets.all(16)
12.radius()          // BorderRadius.circular(12)

// Colors
AppTheme.c.primary
AppTheme.c.accent
AppTheme.c.background
AppTheme.c.error

// Typography
AppText.b1                               // body 1
AppText.b2.cl(AppTheme.c.subText)       // body 2 in subtext color
AppText.b1.w(500).cl(AppTheme.c.text)   // medium weight

// Durations
AppProps.quick    // 100 ms
AppProps.medium   // 300 ms
100.milliseconds  // supercharged extension
```
