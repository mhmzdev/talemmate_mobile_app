# TaleemMate — Claude Context

Flutter-based AI tutoring app (iOS + Android). Urdu/English. Firebase-only backend — no custom server.

## Non-Negotiable Rules

These apply to every task. Violating them breaks the architecture:

1. **`App.init(context)` first** — call it at the top of every `build()`. Skipping it breaks theme, spacing, and typography.
2. **Layer boundary** — UI (`_state.dart`) never calls Firebase or HTTP. Cubits never import from `lib/ui/`.
3. **State accessors** — never `context.read<X>()` / `context.watch<X>()`. Always `XCubit.c(context)` / `_ScreenState.s(context)`.
4. **Generators for all boilerplate** — never hand-create screen, cubit, or provider files. Always use `hygen`. See [docs/tooling/HYGEN.md](docs/tooling/HYGEN.md) for all generators.
5. **Error model** — always catch Firebase/HTTP exceptions and convert to typed `Fault` subtypes before emitting cubit state.
6. **Repo layer purity** — `lib/repos/**/*_repo.dart` public methods accept and return `Map<String, dynamic>` / `List<Map<String, dynamic>>` / primitives only. Never return Dart model classes (e.g. `UserData`). Exception: a single-purpose function with 1–2 primitive params (e.g. `Future<bool> exists(String id)`). Cubits do the `Model.fromJson(raw)` conversion. See [ADR-013](docs/architecture/DECISIONS.md).
7. **Widget extraction threshold** — Only extract a private widget when the child contains **≥5 child widgets OR ≥30 lines**. A single `Row`, single `Container`, or one-line wrapper does NOT earn its own class. Inline it.
8. **Spacing tokens are 4-multiples only** — `t04, t08, t12, t16, t24, t32, t48, t64`. Snap any design value to the nearest token (10→8, 17→16, 19→20, 22→24). Never use `Spacer()` — use `Space.x.t*` / `Space.y.t*` with the explicit token.
9. **FocusNodes are opt-in** — Forms do NOT use `FocusNode` by default. The keyboard's "next" action moves focus on its own. Only add a FocusNode when there is a concrete need: jumping to a non-text field, programmatic focus on mount, or focusing after a non-tap event.
10. **Read the conventions before generating code** — When touching UI, forms, state, or repos, the relevant `docs/conventions/*.md` file is authoritative. If you are unsure, read it first rather than inferring from siblings.

## Tech Stack

| Area | Detail |
|---|---|
| State — ephemeral | `provider` / `ChangeNotifier` (`_ScreenState` per screen) |
| State — business logic | `flutter_bloc` Cubits + `BlocState<T>` from `lib/configs/bloc/` |
| Forms | `flutter_form_builder` + `form_builder_validators` |
| Auth / AI / Crash | `firebase_auth`, `firebase_ai` (Gemini), `firebase_crashlytics` |
| Icons | `flutter_lucide` → `LucideIcons.*` |
| Routing | Named routes via `AppRoutes` + `FadeRoute` |
| Code gen | `freezed`, `json_serializable`, `build_runner`, `flutter_gen` |

## Quick Commands

```bash
flutter run --flavor stage                                          # run with stage config
flutter pub run build_runner build --delete-conflicting-outputs    # regen after model changes

# Hygen generators (all support non-interactive --flag mode)
hygen screen new <name>           # full screen scaffold (root, state, widgets, routes)
hygen screen consumer <name>      # BlocConsumer listener with loading overlay
hygen screen listener <name>      # BlocListener, no UI block
hygen screen _widget <name>       # add private widget to existing screen
hygen cubit nested <name>         # new cubit + repo (auto-registers in app.dart)
hygen cubit update <name>         # inject new actions into existing cubit
hygen provider new <name>         # new app-level ChangeNotifier provider
```

> Cubits live in `lib/blocs/<name>/`, repos in `lib/repos/<name>/`. Auto-registered in `lib/app.dart` under the `// bloc-initiate-start` marker.

## Driving the App (Dart MCP)

The `dart` MCP server (in `.mcp.json`) is a Playwright-equivalent: it can drive a **running debug build** — inspect the widget tree, screenshot, tap, type, scroll, navigate, hot reload, read runtime errors. Use it to **verify UI flows yourself** instead of asking the user to click through.

**Before claiming you can't test the UI, check whether driving is available:**

1. Call `mcp__dart__list_running_apps`. If it returns an app with a DTD URI, connect and drive.
2. If empty, the app may still be running from VS Code — ask the user to paste the **DTD URI** (Cmd+Shift+P → *"Dart: Copy DTD URI to Clipboard"*). **Not** the VM-service URI from the debug console — that connects but then fails every call.
3. If nothing is running, ask the user to launch the **`Driver (MCP) — <device>`** config (or `flutter run --flavor stage -t test_driver/app.dart`) and paste the DTD URI. You cannot launch it yourself — `launch_app` can't pass `--flavor stage`, which this app requires.

**Tapping/typing requires the driver entrypoint** (`test_driver/app.dart`, which calls `enableFlutterDriverExtension()`). A plain `lib/main.dart` run is **view-only** (widget tree + screenshots work; `flutter_driver` taps do not).

Then: `connect_dart_tooling_daemon` (DTD URI) → `get_widget_tree` to see real widgets → `flutter_driver` (`tap`, `enter_text`, `screenshot`, `scroll`).

Gotchas:
- **Don't pass `timeout`** to `flutter_driver` — the server mis-casts it and throws. Use the default.
- Find widgets by **visible text/value** (`ByText`). Login/CreateAccount forms are pre-seeded by `_FormData.initialValues()`, so placeholder/hint text is absent — don't finder on the placeholder. `enter_text` types into the focused field, so `tap` the field first.
- `PageBack` only matches a standard back button; custom back arrows won't match — tap an on-screen link instead.
- A `tap`/`waitFor` on a non-existent widget **times out** (waits for it) rather than failing fast.
- No disconnect tool — if a connection goes bad (e.g. wrong URI), run `/mcp` → reconnect `dart`, then connect again.

## Documentation

Full detail lives in **[docs/INDEX.md](docs/INDEX.md)**.

| I need to know… | Go to |
|---|---|
| What each feature does + v1 scope | [docs/features/CATALOGUE.md](docs/features/CATALOGUE.md) |
| How the layers fit together | [docs/architecture/OVERVIEW.md](docs/architecture/OVERVIEW.md) |
| Screen file anatomy + code examples | [docs/screens/STRUCTURE.md](docs/screens/STRUCTURE.md) |
| BlocState + Provider patterns | [docs/conventions/STATE_MANAGEMENT.md](docs/conventions/STATE_MANAGEMENT.md) |
| Design tokens, spacing, typography | [docs/conventions/CONFIGS.md](docs/conventions/CONFIGS.md) |
| Which screens exist + user flows | [docs/screens/FLOWS.md](docs/screens/FLOWS.md) |
| Shared widgets + form components | [docs/widgets/CATALOGUE.md](docs/widgets/CATALOGUE.md) |
| Hygen generators + build_runner | [docs/tooling/HYGEN.md](docs/tooling/HYGEN.md) |
| Firebase services + error handling | [docs/architecture/FIREBASE.md](docs/architecture/FIREBASE.md) |
| Why we made key decisions | [docs/architecture/DECISIONS.md](docs/architecture/DECISIONS.md) |

## Skills

- `/design` — design tokens, layout patterns, component usage
- `/building_forms` — form construction with flutter_form_builder
- `/write_unit_test` — cubit unit tests
- `/write_widget_test` — screen widget tests
- `/research-codebase` — documents how a slice of the codebase works today (writes to `docs/research/`)
- `/create-plan` — interactive multi-phase implementation plan (writes to `docs/exec-plans/backlog/`)

## Research & Plan Lifecycle

Research and plans are persistent artifacts — they live in `docs/` and outlive a single session. Keep them tidy.

### Research (`docs/research/`)
- Single flat folder. Filename: `YYYY-MM-DD-<kebab-slug>.md`.
- Always overwrite an existing artifact for the same slug — never duplicate.
- Add / update the row in `docs/research/INDEX.md` (ToC).

### Plans (`docs/exec-plans/`)
Plans move through four states by being **`git mv`**'d between subdirectories. The directory IS the status — also reflected in the file's frontmatter `status:` field.

| State | Directory | When it lives here |
|---|---|---|
| Backlog | `docs/exec-plans/backlog/` | Default home for any newly written plan. Not yet started. |
| Active | `docs/exec-plans/active/` | Implementation has begun. At most one plan per feature should be active at a time. |
| Completed | `docs/exec-plans/completed/` | All phases done, merged, verified. |
| Superseded | `docs/exec-plans/superseded/` | A different plan was chosen for the same problem, or scope changed enough that this plan no longer applies. Keep for context, don't delete. |

**Transitions:**
- `backlog → active` — when starting work. Update the banner from `📋 BACKLOG` to `🚧 ACTIVE` and the frontmatter `status: active`.
- `active → completed` — after merge + manual verification. Banner `✅ COMPLETED`, `status: completed`, add `completed: YYYY-MM-DD` to frontmatter.
- `* → superseded` — when abandoned. Banner `⛔ SUPERSEDED`, add `superseded_by: <slug>` pointing to the replacement plan (or `superseded_reason:` if none).

Each state directory has its own `INDEX.md` table. When moving a plan, **remove its row from the source `INDEX.md` and add it to the destination `INDEX.md`** in the same commit as the `git mv`.
