# TaleemMate — System Overview

TaleemMate is an AI-powered tutoring mobile app built with Flutter. It targets iOS and Android, supports English and Urdu, and is backed entirely by Firebase — no custom backend server.

## System Map

```
┌────────────────────────────────────────────┐
│  Flutter App (iOS + Android)               │
│  lib/ — UI, Cubits, Services, Configs      │
└────────────────┬───────────────────────────┘
                 │ Firebase SDKs
┌────────────────▼───────────────────────────┐
│  Firebase Services                         │
│  Auth · AI (Gemini) · Crashlytics          │
│  Performance · Remote Config               │
└────────────────────────────────────────────┘
```

## Project Structure

```
taleemmate/
├── lib/              # Flutter app (iOS + Android)
├── _templates/       # Hygen scaffolding templates
├── docs/             # Project documentation (this directory)
├── CLAUDE.md         # AI agent context — points here
└── ARCHITECTURE.md   # Bird's-eye architecture reference
```

## Flutter App — Layer Rules

**Layer-first, not feature-first.** Code is organized by _what it is_ (UI, state, service, config) rather than _what it does_ (auth, tutoring, etc.). Dependencies flow strictly downward:

```
UI Layer       (lib/ui/)           — renders, handles input
    ↓ reads state, calls methods
State Layer    (lib/blocs/)        — business logic, Firebase
    ↓ raw calls
Service Layer  (lib/services/)     — Firebase, flavor, logging, faults
    ↓ shapes data
Config Layer   (lib/configs/)      — theme, spacing, extensions, BloC base types
```

**Hard rules:**
- `_state.dart` (Provider / ChangeNotifier) never calls Firebase or HTTP — delegates to Cubits
- Cubits never import anything from `lib/ui/`
- No `context.read<X>()` / `context.watch<X>()` directly — always use `X.c(context)` / `_ScreenState.s(context)`

## Key Documents

- Flutter layer patterns, screen anatomy, state management → `docs/architecture/FLUTTER.md`
- Firebase services in use and integration → `docs/architecture/FIREBASE.md`
- Why we made key technical decisions → `docs/architecture/DECISIONS.md`
- Dart code style and pre-completion checklist → `docs/conventions/DART.md`
- BlocState / Provider patterns with examples → `docs/conventions/STATE_MANAGEMENT.md`
- Space, theme, typography, navigation extensions → `docs/conventions/CONFIGS.md`
- All screens, status, user flows → `docs/screens/FLOWS.md`
- Screen file layout, listener/consumer wiring → `docs/screens/STRUCTURE.md`
- Hygen generators, build_runner, Freezed → `docs/tooling/HYGEN.md`
- Shared widget catalogue → `docs/widgets/CATALOGUE.md`
