---
paths:
  - "lib/blocs/**"
---

# Cubit / bloc rules — auto-loaded when editing anything under `lib/blocs/`

- **Error model** — always catch Firebase/HTTP exceptions and convert to typed `Fault` subtypes before emitting cubit state. Never emit on a raw, untyped exception.
- **Cubits never import from `lib/ui/`** — the dependency only points one way (UI → cubit). A cubit knowing about a screen is a layer violation.
- **Model conversion lives here** — repos return raw `Map` / `List<Map>` / primitives; the cubit does `Model.fromJson(raw)` before emitting.
- **Use the generators** — new cubit + repo via `hygen cubit nested <name>`; new actions via `hygen cubit update <name>`. Both auto-register under the `// bloc-initiate-start` marker in `lib/app.dart`. Don't hand-create these files.
- **State-driven navigation / side-effects** go through a `BlocListener` (generated via `hygen screen listener`/`consumer`), never imperatively from `_state.dart`.

Authoritative detail (read on demand): [STATE_MANAGEMENT.md](../../docs/conventions/STATE_MANAGEMENT.md).
