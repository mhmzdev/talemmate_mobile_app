# Feature Checklist — Library Text Extraction (Gemini)

> A living test-plan + edge-case list for the background text-extraction pipeline
> that turns picked materials into stored, queryable text (`MaterialCubit` +
> `MaterialRepo`, Drift `MaterialTexts`, shared `AiService`). Re-run the relevant
> rows before merging any change that touches `lib/blocs/material/`,
> `lib/repos/material/`, `lib/services/firebase/ai/ai_service.dart`,
> `AppDatabase` material helpers / `MaterialTextsDao`, `LibraryDao.setStatus`,
> the `MaterialPicker` copy-to-stable-storage path, the library `_MaterialStatus`
> badge, or the add-flows that call `MaterialCubit.process`.
>
> Status legend: ✅ verified on simulator (Dart MCP) · 🔒 guard / invariant to
> keep · 🚧 by-design gap (not implemented yet) · ⏳ not driver-tested (inferred
> from a shared code path).
>
> Related: [exec-plan](../exec-plans/completed/library-text-extraction.md),
> [library-materials-module checklist](library-materials-module.md),
> [ADR-013](../architecture/DECISIONS.md),
> [extraction system prompt](../../assets/library_extraction_sys_prompt.md).

## How to run

1. Ensure the Firebase project has **Firebase AI Logic / Gemini** enabled and
   billing active (extraction is a live `firebase_ai` call — no emulator).
2. `flutter run --flavor stage -t test_driver/app.dart`; `connect_dart_tooling_daemon`
   with the DTD URI.
3. Sign in, open the **Library** tab. Add materials via **Add new material** →
   Files/Photos/Camera (native picker — pause the driver and pick manually).

---

## 1. Storage schema + migration (Phase 1)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 1.1 | Launch on an existing (v1) install | Schema bumps v1→v2; `onUpgrade` creates `material_texts`; no migration crash | ✅ |
| 1.2 | `MaterialTextsDao` reachable | `AppDatabase.ins.materialTextsDao` / material helpers callable | ✅ |
| 1.3 | One row per item | `MaterialTexts` PK is `itemId`; re-extract upserts (no dupes) | 🔒 |

## 2. Extraction pipeline — supported kinds (Phase 3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 2.1 | Add a **PDF** (<20 MB) | `pending`→spinner→`indexed`; Gemini OCR; `MaterialTexts` row; real page count | ✅ (804 KB→1 page, 1.3 MB→2 pages) |
| 2.2 | Add a **`.md`** note | `indexed` via **direct read** (no AI call); page count 1 | ✅ |
| 2.3 | Add a **`.txt`** note | same direct-read path as `.md` | ⏳ |
| 2.4 | Add an **image** (jpg/png/heic) | `indexed` via Gemini OCR (same path as PDF; mime from file ext) | ⏳ |
| 2.5 | Page count is honest | `indexedPageCount` set; only written **after** `saveMaterialText` succeeds | ✅ |

## 3. Extraction pipeline — unsupported & failures (Phase 3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 3.1 | Add a **`.pptx`** / `.key` / video / voice / `.docx` | early `markLibraryFailed` (no AI call, no throw); item still lists | ⏳ |
| 3.2 | File >20 MB (inline ceiling) | `AiFault` "too large", row `failed`, no crash | 🔒 |
| 3.3 | Gemini error (API off / quota / network) | `AiFault.fromAiException`, row `failed`, handled flash on the cubit state | ✅ (observed pre-billing-fix; handled, no crash) |
| 3.4 | Missing/unreadable file path | `UnknownFault`, row `failed` (no uncaught `PathNotFoundException`) | ✅ (see §6) |
| 3.5 | `get_runtime_errors` after any add | zero **unhandled** errors; all failures are typed `Fault`s | ✅ |

## 4. Status UI + reload (Phase 4)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 4.1 | While extracting | `_MaterialStatus` shows spinner + "Reading…" (pending+processing render identically) | ✅ |
| 4.2 | Indexed | gold `AI INDEXED` pill + "N page(s)" when `indexedPageCount != null` | ✅ |
| 4.3 | Failed | muted `circle_alert` + "Couldn't read · retry" (tap re-runs `MaterialCubit.process`) | ✅ (badge + affordance) |
| 4.4 | Live settle | list re-reads when any item's `process` state changes; row updates without manual refresh | ✅ |
| 4.5 | Concurrent adds settle on same action | `listenWhen` compares the whole `process` state, so e.g. `failed→failed` still re-reads (no stuck spinner) | 🔒 (regression-fixed — see §6) |
| 4.6 | Retry on a properly-stored failed item | re-runs extraction → `indexed` | ⏳ (pre-fix test rows carry dead `/tmp/` paths) |

## 5. Add-flow triggers (Phase 3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 5.1 | Library "Add to library" | each item persisted (`pending`) then `MaterialCubit.process` fired (fire-and-forget) | ✅ |
| 5.2 | Onboarding finish | `_CompleteListener` fires `process` for each `uploadedMaterials` item before routing | ⏳ |
| 5.3 | Grounding retrieval | `MaterialRepo.textsForSubject(uid, subjectId)` returns stored text maps | ⏳ (consumed by the Chat plan) |

---

## Invariants / regression guards 🔒

- **Repo stays Map/primitives-only (ADR-013)** — `MaterialRepo.extract(Map)` /
  `textsForSubject(...)` take/return `Map`/`List<Map>`/primitives. The
  `ProcessingStatus` enum + row→Map conversion live in `AppDatabase`
  (`markLibrary*`, `saveMaterialText`, `materialTextsForSubject`), not the repo.
  `lib/repos/material/` must not import `core/models/`.
- **Copy picked files to stable storage** — `libraryItemForPick` is **async** and
  copies the OS-temp pick into `<appDocs>/library/<id><ext>` (iOS purges `/tmp/`).
  `metadata` stores the persistent path. Don't revert it to `pick.path`, and keep
  both add-flows awaiting it (`Future.wait`).
- **`indexed` only after text persists** — the provider writes `saveMaterialText`
  **then** `markLibraryIndexed`; on any error it `markLibraryFailed`. So an
  `indexed` row always has a `MaterialTexts` row.
- **Classify by path extension** — the picker collapses `.md`/`.txt`/`.docx`/… to
  `kind = note`; the repo recovers the real format from the path ext
  (`p.extension`). `.md`/`.txt` → direct read; pdf/img → Gemini; everything else
  → `failed`.
- **Reload trigger compares whole `process` state** — `BlocListener.listenWhen`
  uses `a.process != b.process`, not `.action`, because concurrent items share
  one `BlocState` (meta carries the item id).
- **Failures are typed `Fault`s** — `FirebaseAIException` → `AiFault`; other errors
  → `UnknownFault`. Never let an extraction error escape uncaught.
- **System prompt is an asset** — `AiService` loads
  `assets/library_extraction_sys_prompt.md` via `rootBundle` (matches
  `chat_sys_prompt.md`). Don't inline it.
- **`material_mocks.dart` / `material_parser.dart` kept** — scaffold parts with
  `// ignore_for_file: unused_element` (rule 12). Don't prune.
- **Dialogs/sheets pass `routeName`** — the add sheet is `/modal/add-material`.

## By-design gaps 🚧 (not implemented — don't treat as bugs)

- **No backfill / re-extraction of pre-existing items** — extraction only runs on
  newly added materials. Items added before this feature keep their mock
  `indexed` status (no `MaterialTexts` row, no page count) and aren't re-indexed.
- **No vector DB / embeddings / RAG** — grounding is "all text for the subject",
  truncated to a token budget by the Chat plan (not here).
- **No Firebase Storage upload** — files live on-device only.
- **Slides / video / voice / non-text notes (`.docx`) are `failed`** — out of
  scope for text; they list but contribute no grounding.
- **Page count for documents is an estimate** — `charCount / 1800` (images = 1);
  Gemini doesn't report source page counts.
- **`pending` vs `processing` look identical** — both render the "Reading…"
  spinner by design.
