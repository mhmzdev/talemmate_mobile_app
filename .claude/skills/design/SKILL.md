---
name: design
description: Design system reference for TaleemMate. Use when building UI — colors, typography, spacing, icons, layout patterns, and reusable components.
when_to_use: Triggered when building screens, widgets, or components. Use when asked about colors, fonts, spacing, icons, card layouts, or any visual element.
---

# TaleemMate Design System

## Colors

```dart
// Static brand colors (use in non-themed contexts)
AppColors.primary     // Color(0xff0F2027)
AppColors.accent      // Color(0xffD4A574)
AppColors.error       // Color(0xffA35C5C)
AppColors.success     // Color(0xff4F7A5C)
AppColors.warning     // Color(0xffD4860A)

// Theme-aware colors (preferred — auto light/dark)
AppTheme.c.primary
AppTheme.c.accent
AppTheme.c.text
AppTheme.c.subText
AppTheme.c.background
AppTheme.c.subBackground
AppTheme.c.specBackground
AppTheme.c.error
```

Always prefer `AppTheme.c.*` over hardcoded colors so dark mode works.

## Typography

```dart
AppText.b1   // body 1 — primary body text
AppText.b2   // body 2 — secondary/caption text

// Modifiers (chainable)
AppText.b1.cl(color)          // set color
AppText.b1.w(500)             // font weight (100–700)
AppText.b1.gm()               // switch to GeistMono font
AppText.b1.cl(AppTheme.c.text).w(3)   // weight shorthand: 3 = 300
```

Display headings use Fraunces. Body uses Geist. Code uses GeistMono. Urdu uses NotoNastaliqUrdu.

## Spacing

Token scale: t04=4, t08=8, t12=12, t16=16, t24=24, t32=32, t48=48, t64=64

```dart
// Widgets (SizedBox shortcuts)
Space.y.t04    // vertical 4px gap
Space.x.t08    // horizontal 8px gap
Space.a.t12    // all-sides padding 12px (Padding widget)
Space.h.t04    // horizontal padding
Space.v.t08    // vertical padding
Space.t.t08    // top padding only

// Raw values for manual use
SpaceToken.t04   // = 4.0
SpaceToken.t12   // = 12.0
SpaceToken.t16   // = 16.0

// Border radius
12.radius()    // BorderRadius.circular(12)
8.radius()
```

## Icons

```dart
import 'package:flutter_lucide/flutter_lucide.dart';

LucideIcons.eye
LucideIcons.eye_off
LucideIcons.x
LucideIcons.check
// etc. — full Lucide icon set
```

## Layout Patterns

### Screen Root

```dart
return Screen(
  formKey: screenState.formKey,      // optional
  initialFormValue: _FormData.initialValues(),
  keyboardHandler: true,
  child: SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [...],
    ),
  ),
);
```

Import: `package:taleemmate/ui/widgets/core/screen/screen.dart`

### Typical Card

```dart
AnimatedContainer(
  duration: 100.milliseconds,
  decoration: BoxDecoration(
    color: AppTheme.c.subBackground,
    borderRadius: 12.radius(),
    border: Border.all(width: 1, color: AppTheme.c.primary.withOpacity(0.1)),
  ),
  padding: Space.a.t12.padding,  // if needed as EdgeInsets
  child: ...,
)
```

### Animations (available in `lib/ui/animations/`)

```dart
EntranceFader(child: widget)              // fade in on mount
ScaleAnimation(child: widget)             // scale in
BottomAnimation(child: widget)            // slide up from bottom
LinearProgressWidget()                    // animated linear bar
```

## Common Widget Conventions

- Always call `App.init(context)` at the top of `build()` — it sets up theme, media, spacing.
- Use `CrossAxisAlignment.stretch` on Column for full-width children.
- Prefer `Flexible` / `Expanded` over hardcoded widths.
- Tap targets: wrap with `AppTouch` (from `lib/ui/widgets/headless/app_touch.dart`) instead of `GestureDetector` for consistent hit area and ripple.
