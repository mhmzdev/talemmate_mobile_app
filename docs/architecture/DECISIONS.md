# Architecture Decisions — TaleemMate

Lightweight ADR log. Each decision records what was chosen, why, and what it rules out.
New decisions go here when made — not in chat. This is what the agent reads.

---

## ADR-001: Layer-first, not feature-first organization

**Decision:** Code is organized by what it is (`ui`, `blocs`, `services`, `configs`), not by feature (`auth`, `tutoring`, etc.)
**Why:** Feature-first creates circular imports as features share state. Layer-first enforces one-directional dependencies from day 0. File locations are predictable for both humans and AI agents.
**Rules out:** Feature folders (e.g. `lib/features/auth/`).
**Date:** 2026-05

---

## ADR-002: Cubit over Riverpod for app state

**Decision:** `flutter_bloc/Cubit` for all business logic state.
**Why:** More prescriptive than Riverpod — the structure is opinionated enough that code is consistent across sessions. flutter_bloc has better Firebase stream integration and DevTools support.
**Rules out:** Riverpod, `setState` for anything beyond trivial UI toggles.
**Date:** 2026-05

---

## ADR-003: BlocState\<T\> as the shared state wrapper

**Decision:** Every async action in a Cubit is a `BlocState<T>` field — no hand-rolled sealed state hierarchies.
**Why:** Consistent transitions (`.toLoading()`, `.toSuccess()`, `.toFailed()`), boolean getters (`.isLoading`, `.isSuccess`, `.isFailed`), and `.when()` functional rendering across all cubits without boilerplate.
**Rules out:** Per-cubit sealed class hierarchies (`UserLoading extends UserState`, etc.).
**Date:** 2026-05

---

## ADR-004: flutter_form_builder for all forms

**Decision:** All form screens use `flutter_form_builder` + `form_builder_validators` with custom wrapper widgets (`AppFormTextInput`, `AppFormDateInput`, `AppFormChipsInput`).
**Why:** Declarative validation, built-in reset, `saveAndValidate()`, consistent field state management. The `_FormKeys` / `_FormData` pattern makes field names refactor-safe.
**Rules out:** Hand-rolled form state, raw `TextEditingController` grids, `TextField` without `FormBuilderField`.
**Date:** 2026-05

---

## ADR-005: Private widget classes — never function widgets

**Decision:** All widget extraction must be a private class (`class _Foo extends StatelessWidget`), never a function returning a `Widget`.
**Why:** Function widgets don't participate in Flutter's element tree correctly — they skip const constructors, prevent rebuild optimizations, and show poorly in DevTools.
**Rules out:** `Widget _buildFoo() => ...`, helper functions returning `Widget`.
**Date:** 2026-05

---

## ADR-006: Freezed for all data models

**Decision:** All data classes use `@freezed sealed class` with `const factory` constructors.
**Why:** Immutability by default. Built-in `copyWith`, `fromJson`, `toJson`. Generated equality and `toString`. Consistent with `BlocState<T>` which is also Equatable-based.
**Rules out:** Mutable data classes, hand-rolled JSON serialization.
**Date:** 2026-05

---

## ADR-007: Three flavors — stage / qa / prod

**Decision:** Three Flutter flavors with separate Firebase projects and bundle IDs.
**Why:** Stage for active development, QA for stakeholder testing, Prod for users. Separate Firebase projects prevent dev data leaking into production.
**Rules out:** Single Firebase project with environment flags.
**Date:** 2026-05

---

## ADR-008: firebase_ai for AI tutoring

**Decision:** Use `firebase_ai` (Gemini) for all AI tutoring features rather than a third-party LLM API.
**Why:** Stays within the Firebase ecosystem — same auth context, same billing, same performance monitoring. No custom backend needed to proxy API keys. Direct SDK access simplifies the architecture.
**Rules out:** OpenAI API, custom proxy server, on-device models for primary tutoring.
**Date:** 2026-05

---

## ADR-011: Named routes + String extension navigation

**Decision:** All navigation uses `AppRoutes.*` string constants. Navigation calls are made via String extensions (`.push()`, `.pushReplace()`, `.popUntil()`, etc.) that wrap standard `Navigator.*` functions. The five main tab routes use `FadeRoute` via `onGenerateRoute`; auth and modal screens use the static `appRoutes` map. A `GlobalKey<NavigatorState>` (`navigator`) is available for imperative navigation outside the widget tree.
**Why:** Keeps call sites clean (`AppRoutes.home.push(context)` vs. `Navigator.pushNamed(context, '/home')`). String constants make route names refactor-safe. No third-party router dependency — Flutter's `Navigator` is the entire implementation. `FadeRoute` gives consistent cross-fade transitions without per-callsite setup.
**Rules out:** GoRouter, auto_route, Beamer, or any third-party navigation package. Raw `Navigator.pushNamed(context, '/route')` strings at call sites.
**Date:** 2026-05

---

## ADR-012: Offline-first — Drift (SQLite) for all local app data

**Decision:** All learning content, progress, and app data is stored locally using `drift` (SQLite + type-safe ORM with Freezed models). Firebase is used only for Auth, Gemini AI features, Crashlytics, and Firestore for user-profile/account data. Cloud sync of learning data is deferred to a future release.
**Why:** The core tutoring experience involves large amounts of structured local data (lessons, exercises, progress records) that should work without a network connection. SQLite gives relational queries and offline-first reliability. Drift integrates with Freezed and provides type-safe schema migrations. Firestore is not the right store for high-frequency local reads/writes at this data volume.
**Rules out:** Storing learning content or progress in Firestore (v1). Requiring network for any core tutoring feature. `shared_preferences` or `Hive` for structured relational data.
**Until:** Cloud sync feature is built — at that point Drift remains the source of truth and Firestore becomes the sync target, not the primary store.
**Date:** 2026-05

---

## ADR-010: Data-driven widget pattern for complex themed widgets

**Decision:** Widgets with multiple styles, sizes, or states split their logic across four files: `_enums.dart` (variants), `_model.dart` (data shape), `_data.dart` (theme-aware maps), and the widget file. The widget reads `_mapPropsToData()[style]!` — it never contains inline `if`/`switch` chains for theming.
**Why:** Theme-sensitive values (colors, text styles, radii) are computed once per map lookup rather than scattered across `build()`. Adding a new variant is a `_data.dart` change only — the widget is untouched. Static getters must not be used in `_data.dart` maps because they capture the initial theme value and break on runtime theme switch; use functions or evaluate `AppTheme.c.*` directly inside the map factory.
**Rules out:** Inline `if (style == .primary) color = ...` chains inside `build()`, static `BoxDecoration` getters that reference `AppTheme.c`, monolithic widget files that embed all style logic.
**Applies to:** `lib/ui/widgets/core/button/`, `lib/ui/widgets/forms/`. Follow the same structure for any new widget that has ≥ 2 style variants or theme-sensitive color maps.
**Date:** 2026-05

---

## ADR-009: Sealed Fault hierarchy for all errors

**Decision:** All thrown errors use a subtype of `Fault` from `lib/services/fault/faults.dart`. Never `throw Exception(...)` or raw strings.
**Why:** Typed faults give consistent `.message` access for UI display, structured logging, and exhaustive pattern matching. `FirebaseAuthFault` maps Firebase error codes to user-friendly Urdu/English strings at the boundary.
**Rules out:** Raw exceptions, string throws, per-cubit error models.
**Date:** 2026-05

---

## ADR-013: Repo layer is Map-only at its boundary

**Decision:** Public functions on a `*Repo` class in `lib/repos/<name>/<name>_repo.dart` accept and return only `Map<String, dynamic>`, `List<Map<String, dynamic>>`, or primitives (`bool`, `int`, `String`, `double`, `void`). They MUST NOT return Dart model classes such as `UserData` or `OnboardingData`. The only exception is a single-purpose function whose entire input/output is 1–2 primitive parameters (e.g. `Future<bool> exists(String id)`, `Future<String> uploadAvatar(File file)`).
**Why:** The repo is the boundary with the outside world (Firebase, HTTP, SQLite, mocks). Keeping the public signature Map-based means:
- Backend changes don't ripple into the cubit layer.
- The `_*Parser` part-file owns Map shape normalization (snake_case → camelCase, default values, dropping unknown keys).
- The cubit owns the Map→Freezed-model conversion via `Model.fromJson(raw)`, which is also where state typing already lives.
- Repos stay swappable: a `MockRepo` and `FirebaseRepo` have the same shape regardless of internal types.
**Rules out:**
- `Future<UserData> fetch()` in a repo public method.
- Importing `lib/core/models/...` inside `<name>_repo.dart`.
- Returning hand-rolled DTO classes from repo functions.
- Hiding the Map under a typedef to dodge the rule.
**How to apply:** Inside the repo: provider returns a `Map`, parser normalizes the `Map`, repo returns the `Map`. Inside the cubit: `final raw = await UserRepo.ins.fetch(); final data = UserData.fromJson(raw);`. Then `emit(state.copyWith(fetch: state.fetch.toSuccess(data: data)))`.
**Enforcement:** A `Stop` hook in `.claude/settings.json` greps the diff for newly-added `core/models/` imports in `lib/repos/` and blocks completion with a pointer to this ADR.
**Date:** 2026-05
