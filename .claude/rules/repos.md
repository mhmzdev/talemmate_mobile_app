---
paths:
  - "lib/repos/**"
---

# Repo rules — auto-loaded when editing anything under `lib/repos/`

- **Repo layer purity** — `*_repo.dart` public methods accept and return `Map<String, dynamic>` / `List<Map<String, dynamic>>` / primitives only. Never return Dart model classes (e.g. `UserData`). Exception: a single-purpose function with 1–2 primitive params (e.g. `Future<bool> exists(String id)`). Cubits do the `Model.fromJson(raw)` conversion.
- **Catch and convert** — catch Firebase/HTTP exceptions in the repo boundary and surface them as typed `Fault` subtypes; never let a raw provider exception escape to the cubit untyped.
- **Never delete `*_mocks.dart` / `*_parser.dart`** — they are part of the repo scaffold, kept for future/test wiring even when a real provider is live. Keep them as `part of` with `// ignore_for_file: unused_element`.
- **Don't prune the method surface** — `forgot`, `update`, `fetch`, `deleteAccount`, … stay even when nothing calls them yet. Unused ≠ deletable.
- **Test seam** — the repo `.ins` instance seam is how cubit tests swap in mocks. Preserve it.

Authoritative detail (read on demand): ADR-013 in [DECISIONS.md](../../docs/architecture/DECISIONS.md).
