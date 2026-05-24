# TaleemMate — Documentation Index

Start here for any deep-dive. Each doc covers one concern in full detail.
For the one-page orientation, see [CLAUDE.md](../CLAUDE.md) or [ARCHITECTURE.md](../ARCHITECTURE.md).

---

## Architecture

| Document | Read this when… |
|---|---|
| [architecture/OVERVIEW.md](architecture/OVERVIEW.md) | You need the system map, layer rules, or startup sequence |
| [architecture/FLUTTER.md](architecture/FLUTTER.md) | You're building screens or cubits and need the full layer + dependency reference |
| [architecture/FIREBASE.md](architecture/FIREBASE.md) | You're wiring Firebase Auth, Gemini AI, Crashlytics, Remote Config, or Performance |
| [architecture/DECISIONS.md](architecture/DECISIONS.md) | You want to understand *why* a technology or pattern was chosen (ADR log) |

---

## Conventions

| Document | Read this when… |
|---|---|
| [conventions/DART.md](conventions/DART.md) | You want the Dart style rules and pre-completion checklist |
| [conventions/STATE_MANAGEMENT.md](conventions/STATE_MANAGEMENT.md) | You're writing a `_ScreenState`, a Cubit, a `BlocConsumer`, or a listener |
| [conventions/CONFIGS.md](conventions/CONFIGS.md) | You need design tokens — spacing (`Space.*`), colours (`AppTheme.c.*`), typography (`AppText.*`), navigation extensions |

---

## Features

| Document | Read this when… |
|---|---|
| [features/CATALOGUE.md](features/CATALOGUE.md) | You need to know what a feature does, its v1 scope, key data, and how AI fits in — read before building any screen or cubit |

---

## Screens

| Document | Read this when… |
|---|---|
| [screens/FLOWS.md](screens/FLOWS.md) | You need a map of all screens and the user flows between them |
| [screens/STRUCTURE.md](screens/STRUCTURE.md) | You're building or modifying a screen and need the folder layout, part-file wiring, or router registration steps |

---

## Widgets

| Document | Read this when… |
|---|---|
| [widgets/CATALOGUE.md](widgets/CATALOGUE.md) | You need to know which shared widget to use, its API, and usage examples (`Screen`, `AppButton`, `AppFormTextInput`, etc.) |

---

## Tooling

| Document | Read this when… |
|---|---|
| [tooling/HYGEN.md](tooling/HYGEN.md) | You're scaffolding a screen, adding a listener, or running build_runner / Freezed |

---

## Execution Plans

Short-lived task breakdowns for larger features live in [exec-plans/](exec-plans/).
See [exec-plans/INDEX.md](exec-plans/INDEX.md) for the format.
