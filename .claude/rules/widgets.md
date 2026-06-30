---
paths:
  - "lib/ui/widgets/**"
---

# Atomic widget rules — auto-loaded when editing `lib/ui/widgets/`

Atomic / core widgets follow a **spec-driven architecture**. Reference: `lib/ui/widgets/core/button/`.

## File layout — one folder per atomic widget

Split every atomic widget into `part` files joined by the root file (no extra imports between them):

| File | Role |
|---|---|
| `<widget>.dart` (e.g. `button.dart`) | Root. The public `StatefulWidget` + its `State`. Declares `part '_enums.dart'; part '_model.dart'; part '_data.dart';`. Holds construction + `build()` only. |
| `_enums.dart` (`part of`) | The variant **enums** (`AppButtonStyle`, `AppButtonSize`, `AppButtonState`, `AppButtonRadius`) plus their `bool get isX` extensions. |
| `_model.dart` (`part of`) | Private spec model class(es) (`_AppButtonModel`) describing the per-variant data shape. |
| `_data.dart` (`part of`) | Pure `_mapXToY()` functions returning **enum-keyed maps** (variant → concrete colors / sizes / radii). This is the "spec". |

## Rules

- **Variants are enums, never bool/String flags** — expose them as constructor props with dot-shorthand defaults: `this.style = .primary`, `this.size = .medium`, `this.state = .def`.
- **Resolve variant → value through the `_data.dart` maps**, keyed by enum (`_mapPropsToData()[widget.style]!`). Do NOT branch with `if`/`switch` chains inside `build()`.
- **Allow explicit overrides** for the few values a caller may need to force (`Color? iconColor`, `Color? textColor`, `EdgeInsets? padding`) — fall back to the spec-derived value when null.
- **Enums carry `bool get isX` extensions** (`isPrimary`, `isDisabled`) for readable call sites.
- **Use `part` / `part of`** — never break an atomic widget into separately-imported libraries.
- Apply this same layout to every new atomic widget, regardless of nesting depth under `lib/ui/widgets/`.
