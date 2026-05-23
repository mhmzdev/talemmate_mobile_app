# TaleemMate — Claude Context

Flutter-based AI tutoring app (iOS + Android). Urdu/English. Firebase-only backend — no custom server.

## Non-Negotiable Rules

These apply to every task. Violating them breaks the architecture:

1. **`App.init(context)` first** — call it at the top of every `build()`. Skipping it breaks theme, spacing, and typography.
2. **Layer boundary** — UI (`_state.dart`) never calls Firebase or HTTP. Cubits never import from `lib/ui/`.
3. **State accessors** — never `context.read<X>()` / `context.watch<X>()`. Always `XCubit.c(context)` / `_ScreenState.s(context)`.
4. **Generators for all boilerplate** — never hand-create screen, cubit, or provider files. Always use `hygen`. See [docs/tooling/HYGEN.md](docs/tooling/HYGEN.md) for all generators.
5. **Error model** — always catch Firebase/HTTP exceptions and convert to typed `Fault` subtypes before emitting cubit state.

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

## Documentation

Full detail lives in **[docs/INDEX.md](docs/INDEX.md)**.

| I need to know… | Go to |
|---|---|
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
