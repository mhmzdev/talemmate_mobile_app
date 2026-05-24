# TaleemMate — System Overview

TaleemMate is an AI-powered tutoring mobile app built with Flutter. It targets iOS and Android and supports English and Urdu. The app is **offline-first** — all learning content and progress is stored locally using Drift (SQLite). Firebase is used only for Auth, Gemini AI, and user-account cloud data. No custom backend server exists.

## System Map

```
┌─────────────────────────────────────────────────────┐
│  Flutter App (iOS + Android)                        │
│  lib/ — UI, Cubits, Services, Configs               │
└──────────┬──────────────────────────┬───────────────┘
           │ Firebase SDKs            │ Drift (SQLite)
┌──────────▼──────────┐   ┌──────────▼───────────────┐
│  Firebase Services  │   │  Local Database           │
│  Auth · AI (Gemini) │   │  Learning content         │
│  Crashlytics        │   │  Progress & exercises     │
│  Remote Config      │   │  (offline-first, v1)      │
└─────────────────────┘   └──────────────────────────-┘
```

> Cloud sync of local data to Firestore is deferred. Until that feature is built, Drift is the sole source of truth for all app content.

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
