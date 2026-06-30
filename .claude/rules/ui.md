---
paths:
  - "lib/ui/**"
---

# UI rules — auto-loaded when editing anything under `lib/ui/`

These are non-negotiable. They mirror the global rules in `CLAUDE.md` but only load when you touch UI files.

- **`App.init(context)` first** — the first line of every `build()`. Skipping it breaks theme, spacing, and typography.
- **State accessors** — never `context.read<X>()` / `context.watch<X>()`. Always `XCubit.c(context)` / `_ScreenState.s(context)`.
- **No business logic in UI** — a `_state.dart` / widget never calls Firebase or HTTP. That belongs in a cubit.
- **Spacing tokens are 4-multiples only** — `t04, t08, t12, t16, t24, t32, t48, t64`. Snap any design value to the nearest token (10→8, 17→16, 19→20, 22→24). Never use `Spacer()` — use `Space.x.t*` / `Space.y.t*` with the explicit token.
- **Pick the `Space` shape you need** — `Space.a.t*` (all), `Space.h.t*` / `Space.v.t*` (one axis), `Space.t/b/l/r.t*` (one side). Reserve `Space.sym(h, v)` for genuinely asymmetric padding only.
- **Widget extraction threshold** — only extract a private widget at **≥5 child widgets OR ≥30 lines**. A single `Row`/`Container`/one-line wrapper does NOT earn its own class. Inline it. Never return a widget from a function — always a private class.
- **No `for` loops in the widget tree** — always `.map()` (and `.asMap().entries.expand(...)` for index/separators). Applies to every widget-list build, including fixed-count ones.
- **Dialogs/sheets need `routeName`** — `showAppAlert` / `showDialog` / `showModalBottomSheet` must set `RouteSettings(name: ...)` so navigation logs are investigable (no `unknown` routes).
- **FocusNodes are opt-in** — forms do NOT use `FocusNode` by default; the keyboard's "next" action moves focus on its own. Add one only for a concrete need: jumping to a non-text field, programmatic focus on mount, or focusing after a non-tap event.

Authoritative detail (read on demand): [CONFIGS.md](../../docs/conventions/CONFIGS.md) and [DART.md](../../docs/conventions/DART.md).
For form construction specifically, invoke the `/building-forms` skill.
