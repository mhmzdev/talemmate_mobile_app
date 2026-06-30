---
paths:
  - "test/**"
---

# Test rules — auto-loaded when editing anything under `test/`

- **New features ship WITH tests** — don't punt. A feature flow is not done until its cubit/service has unit coverage and key screens have widget coverage.
- **mocktail only** — no `bloc_test`. Mock cubits/repos with mocktail and assert on emitted `BlocState<T>` transitions directly.
- **Swap real deps via the repo `.ins` seam** — inject mocks through it rather than reaching into Firebase.
- **Layout mirrors `lib/`** — `test/blocs/`, `test/screens/`, `test/core/`, with shared setup in `test/helpers/`.
- **Use the skills** — `/write-unit-test` for cubits/services/pure Dart, `/write-widget-test` for screens, forms, taps, and navigation.

Authoritative detail (read on demand): [TESTING.md](../../docs/TESTING.md).
