---
paths:
  - "lib/**"
  - "test/**"
---

# Dart conventions — auto-loaded when editing Dart under `lib/` or `test/`

## Enums over strings

- **Prefer an enum to a `String`/`bool` flag** anytime a value has a fixed set of variants. Strings are for free text only.
- Give enums `bool get isX` extension getters when call sites read better for it (see the button widget).

### Where enums live (by scope)

| Scope | Location |
|---|---|
| Private to one folder | `_enums.dart` in that folder, as `part of` its root file (e.g. `lib/ui/widgets/core/button/_enums.dart`). |
| Global / cross-cutting | `lib/utils/enums.dart`. |
| Tied to an entity | Co-located with the model, in `lib/core/models/<entity>/` (e.g. enums for `UserData` live beside `user.dart`). |

Don't scatter enums inline at the bottom of unrelated files — route them to the file their scope dictates.

## Widgets

- **Class-based `StatefulWidget` (or `StatelessWidget`), never functional widgets.** No `HookWidget`, no `functional_widget` codegen, and never return a widget from a function — extract a private class instead.

## Size budgets

- **Functions ≤ 30 lines.** Past that, break into smaller, named helpers (this generalizes the widget-extraction threshold).
- **Files ≤ 300 lines.** Past that, split by responsibility (e.g. the spec-driven `part` layout for widgets).

Authoritative detail (read on demand): [DART.md](../../docs/conventions/DART.md).
