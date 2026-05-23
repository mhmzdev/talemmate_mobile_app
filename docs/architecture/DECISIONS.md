# Architecture Decisions — TaleemMate

Lightweight ADR log. Each decision records what was chosen, why, and what it rules out.
New decisions go here when made — not in chat. This is what the agent reads.

---

## ADR-001: Layer-first, not feature-first organization

**Decision:** Code is organized by what it is (`ui`, `blocs`, `services`, `configs`), not by feature (`auth`, `tutoring`, etc.)
**Why:** Feature-first creates circular imports as features share state. Layer-first enforces one-directional dependencies from day 0. File locations are predictable for both humans and AI agents.
**Rules out:** Feature folders (e.g. `lib/features/auth/`).
**Date:** 2026-01

---

## ADR-002: Cubit over Riverpod for app state

**Decision:** `flutter_bloc/Cubit` for all business logic state.
**Why:** More prescriptive than Riverpod — the structure is opinionated enough that code is consistent across sessions. flutter_bloc has better Firebase stream integration and DevTools support.
**Rules out:** Riverpod, `setState` for anything beyond trivial UI toggles.
**Date:** 2026-01

---

## ADR-003: BlocState\<T\> as the shared state wrapper

**Decision:** Every async action in a Cubit is a `BlocState<T>` field — no hand-rolled sealed state hierarchies.
**Why:** Consistent transitions (`.toLoading()`, `.toSuccess()`, `.toFailed()`), boolean getters (`.isLoading`, `.isSuccess`, `.isFailed`), and `.when()` functional rendering across all cubits without boilerplate.
**Rules out:** Per-cubit sealed class hierarchies (`UserLoading extends UserState`, etc.).
**Date:** 2026-01

---

## ADR-004: flutter_form_builder for all forms

**Decision:** All form screens use `flutter_form_builder` + `form_builder_validators` with custom wrapper widgets (`AppFormTextInput`, `AppFormDateInput`, `AppFormChipsInput`).
**Why:** Declarative validation, built-in reset, `saveAndValidate()`, consistent field state management. The `_FormKeys` / `_FormData` pattern makes field names refactor-safe.
**Rules out:** Hand-rolled form state, raw `TextEditingController` grids, `TextField` without `FormBuilderField`.
**Date:** 2026-01

---

## ADR-005: Private widget classes — never function widgets

**Decision:** All widget extraction must be a private class (`class _Foo extends StatelessWidget`), never a function returning a `Widget`.
**Why:** Function widgets don't participate in Flutter's element tree correctly — they skip const constructors, prevent rebuild optimizations, and show poorly in DevTools.
**Rules out:** `Widget _buildFoo() => ...`, helper functions returning `Widget`.
**Date:** 2026-01

---

## ADR-006: Freezed for all data models

**Decision:** All data classes use `@freezed sealed class` with `const factory` constructors.
**Why:** Immutability by default. Built-in `copyWith`, `fromJson`, `toJson`. Generated equality and `toString`. Consistent with `BlocState<T>` which is also Equatable-based.
**Rules out:** Mutable data classes, hand-rolled JSON serialization.
**Date:** 2026-01

---

## ADR-007: Three flavors — stage / qa / prod

**Decision:** Three Flutter flavors with separate Firebase projects and bundle IDs.
**Why:** Stage for active development, QA for stakeholder testing, Prod for users. Separate Firebase projects prevent dev data leaking into production.
**Rules out:** Single Firebase project with environment flags.
**Date:** 2026-01

---

## ADR-008: firebase_ai for AI tutoring

**Decision:** Use `firebase_ai` (Gemini) for all AI tutoring features rather than a third-party LLM API.
**Why:** Stays within the Firebase ecosystem — same auth context, same billing, same performance monitoring. No custom backend needed to proxy API keys. Direct SDK access simplifies the architecture.
**Rules out:** OpenAI API, custom proxy server, on-device models for primary tutoring.
**Date:** 2026-01

---

## ADR-009: Sealed Fault hierarchy for all errors

**Decision:** All thrown errors use a subtype of `Fault` from `lib/services/fault/faults.dart`. Never `throw Exception(...)` or raw strings.
**Why:** Typed faults give consistent `.message` access for UI display, structured logging, and exhaustive pattern matching. `FirebaseAuthFault` maps Firebase error codes to user-friendly Urdu/English strings at the boundary.
**Rules out:** Raw exceptions, string throws, per-cubit error models.
**Date:** 2026-01
