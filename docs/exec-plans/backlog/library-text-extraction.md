---
title: "Library Text Extraction (Gemini-based) & Indexing"
status: backlog
created: 2026-06-14
---

📋 BACKLOG — Not yet started

# Library Text Extraction (Gemini-based) & Indexing — Implementation Plan

## Overview
Turn picked library materials into stored, queryable **text** so the Chat agent can ground answers in the student's own materials. Instead of native OCR/PDF libraries, we use **`firebase_ai` (Gemini) multimodally** — send the file bytes to Gemini and get text back. This introduces the shared Gemini service the Chat plan also reuses. A dedicated **`MaterialCubit` + `MaterialRepo`** owns the extraction/indexing pipeline; `processingStatus` becomes real (`pending → processing → indexed | failed`).

This is the **prerequisite** for `chat-agent.md`.

## Current State Analysis

**Materials are local-only; no text is stored, indexing is mocked.**

Key files:
- `lib/services/material_picker/material_picker.dart:84-100` — `libraryItemForPick(...)` hardcodes `processingStatus: ProcessingStatus.indexed` (comment: *"no real OCR/indexing yet"*) and stores the **local file path** in `LibraryItem.metadata` (`metadata: pick.path`).
- `lib/core/models/library/library_item.dart:14-26` — `LibraryItem` has `kind` (pdf/img/slide/note/video/voice), `processingStatus`, `indexedPageCount`, `metadata` (path). **No text/content field.**
- `lib/core/db/tables/library_table.dart` — `LibraryItems` Drift table; no text storage.
- `lib/repos/library/library_repo.dart` + `library_data_provider.dart` — Drift-backed, ADR-013-compliant (returns `Map`/`List<Map>`). `add(values)` → `AppDatabase.ins.saveLibraryItem(values)`.
- `lib/blocs/library/cubit.dart` — existing `LibraryCubit` (list/add/remove; stays the list UI owner).
- `firebase_ai: 3.6.0` declared (`pubspec.yaml:40`) but **never used** in `lib/`.
- `Firebase.initializeApp()` at `lib/main.dart:20` (Gemini piggybacks on this; no separate init).

**firebase_ai 3.6.0 API verified** (`~/.pub-cache/.../firebase_ai-3.6.0`):
- `Content.multi([TextPart(...), InlineDataPart(mimeType, bytes)])` and `Content.inlineData(mimeType, bytes)` — multimodal input (`lib/src/content.dart:42-46,230`).
- `FirebaseAI...generativeModel(model:, systemInstruction:, generationConfig:, safetySettings:)` (`lib/src/firebase_ai.dart:133-152`).
- `GenerativeModel.generateContent(Iterable<Content>)` — single-shot.

## Desired End State
Adding a PDF/image/note material runs Gemini extraction in the background; the extracted text + page count are persisted; `processingStatus` reflects reality; and a repo method can return all extracted text for a given subject (consumed by the Chat plan). Verify: add a PDF → row shows `processing` then `indexed` with a page count, and `MaterialRepo.textsForSubject(userId, subjectId)` returns the text.

## What We're NOT Doing
- **No native OCR / PDF parsing libraries** — Gemini does extraction.
- **No Firebase Storage upload** — extraction runs on-device from the local `metadata` path at add-time.
- **No vector DB / embeddings / RAG retrieval** — retrieval is "all text for the subject," truncated to a token budget (the Chat plan owns budgeting).
- **Supported text sources:** PDF + image (via Gemini) and **plain-text notes (`.md` / `.txt`)** read directly. **Slides (ppt/pptx/key), video, voice, and non-text note formats (e.g. `.docx`) are out of scope for text** — they still list; `processingStatus` is set to `failed` (unsupported) and they contribute no grounding.
- **No re-extraction/backfill of already-added items** — extraction applies to newly added materials (a manual "re-index" affordance is out of scope).

## Implementation Approach
- A shared low-level Gemini wrapper at `lib/services/firebase/ai/ai_service.dart` exposes a configured extraction model. It returns raw text / throws `FirebaseAIException`; the repo converts to a typed `Fault` (a new `AiFault`).
- `MaterialRepo` (ADR-013: `Map`/primitives only) reads file bytes from the local path, calls the AI service, writes text via a new `MaterialTextsDao`, and updates `processingStatus`/`indexedPageCount` on the existing `LibraryItems` row.
- `MaterialCubit` exposes `process(itemMap)` and tracks per-item progress in a `BlocState`-keyed map; the existing add-flows (Library add + onboarding Step 4) call it after `LibraryRepo.add`.

---

## Phase 1: Text storage schema + DAO

### Overview
Add Drift storage for extracted text and a retrieval path, with a schema-version migration.

### Changes Required

#### 1. New Drift table
**File**: `lib/core/db/tables/material_texts_table.dart`
```dart
import 'package:drift/drift.dart';
import 'library_table.dart';

@DataClassName('MaterialTextRow')
class MaterialTexts extends Table {
  TextColumn get itemId => text().references(LibraryItems, #id)();
  TextColumn get content => text()();
  IntColumn get pageCount => integer().withDefault(const Constant(0))();
  IntColumn get charCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get extractedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {itemId};
}
```

#### 2. DAO
**File**: `lib/core/db/daos/material_texts_dao.dart`
```dart
part of '../database.dart';

@DriftAccessor(tables: [MaterialTexts, LibraryItems])
class MaterialTextsDao extends DatabaseAccessor<AppDatabase>
    with _$MaterialTextsDaoMixin {
  MaterialTextsDao(super.db);

  Future<void> upsert(MaterialTextsCompanion c) =>
      into(materialTexts).insertOnConflictUpdate(c);

  Future<MaterialTextRow?> forItem(String itemId) =>
      (select(materialTexts)..where((t) => t.itemId.equals(itemId)))
          .getSingleOrNull();

  /// All extracted text for a user's items in a subject (grounding source).
  Future<List<MaterialTextRow>> forSubject(String userId, String subjectId) {
    final q = select(materialTexts).join([
      innerJoin(libraryItems, libraryItems.id.equalsExp(materialTexts.itemId)),
    ])
      ..where(libraryItems.userId.equals(userId) &
          libraryItems.subjectId.equals(subjectId));
    return q.map((r) => r.readTable(materialTexts)).get();
  }
}
```

#### 3. Register table/DAO + bump schema version
**File**: `lib/core/db/database.dart`
**Changes**: add `MaterialTexts` to `@DriftDatabase(tables: [...], daos: [...])`, add `MaterialTextsDao` accessor, increment `schemaVersion`, and add a migration step that creates the new table (`m.createTable(materialTexts)`).

### Hygen Commands
_None — Drift tables/DAOs are hand-written (consistent with existing `tutor_table.dart` / `library_table.dart`)._

### Success Criteria

#### Automated Verification
- [ ] Code gen clean: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Zero new analysis errors: `flutter analyze`

#### Manual Verification
- [ ] App launches without a Drift migration crash on an existing install (schema bump applies).
- [ ] `MaterialTextsDao` is reachable via `AppDatabase.ins`.

**Implementation Note**: After this phase + automated verification passes, pause for manual confirmation.

---

## Phase 2: Shared Gemini AI service (extraction model)

### Overview
Introduce the reusable `firebase_ai` wrapper with an extraction-configured model and a typed `AiFault`.

### Changes Required

#### 1. Typed fault
**File**: `lib/services/fault/faults.dart`
**Changes**: add an `AiFault` subtype of `Fault` (mirrors `HttpFault`/`UnknownFault`), with a `fromAiException(FirebaseAIException, StackTrace)` factory and a user-facing message.

#### 2. Gemini service wrapper
**File**: `lib/services/firebase/ai/ai_service.dart`
```dart
import 'dart:typed_data';
import 'package:firebase_ai/firebase_ai.dart';

class AiService {
  AiService._();
  static final AiService ins = AiService._();

  static const _extractionModel = 'gemini-2.5-flash'; // confirm available id

  GenerativeModel? _extractor;
  GenerativeModel get extractor => _extractor ??= FirebaseAI.googleAI()
      .generativeModel(
        model: _extractionModel,
        systemInstruction: Content.system(
          'You extract the plain text content of the provided document. '
          'Return ONLY the text, preserving reading order. No commentary.',
        ),
      );

  /// Sends [bytes] of [mimeType] to Gemini and returns extracted plain text.
  Future<String> extractText(Uint8List bytes, String mimeType) async {
    final res = await extractor.generateContent([
      Content.multi([
        TextPart('Extract all readable text from this file.'),
        InlineDataPart(mimeType, bytes),
      ]),
    ]);
    return res.text ?? '';
  }
}
```
**Notes**: confirm the exact `FirebaseAI` entry-point (`googleAI()` vs `vertexAI()`) and current model id against the installed SDK before coding. Inline data has a size ceiling (~20 MB) — larger files are caught and surfaced as a handled failure (see Phase 3).

### Hygen Commands
_None._

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` clean.

#### Manual Verification
- [ ] A throwaway call `AiService.ins.extractText(pdfBytes, 'application/pdf')` against a real PDF returns non-empty text on device/emulator.

**Implementation Note**: Pause for manual confirmation after verifying a real extraction round-trip.

---

## Phase 3: MaterialCubit + MaterialRepo (extraction pipeline)

### Overview
The cubit/repo that reads a material's bytes, extracts via Gemini, persists text, and drives real `processingStatus`.

### Changes Required

#### 1. Scaffold cubit + repo
Run hygen (see commands), then customize.

#### 2. Repo
**File**: `lib/repos/material/material_repo.dart` (+ `_data_provider`, `_mocks`, `_parser` parts)
Public methods (ADR-013 — `Map`/primitives only):
```dart
class MaterialRepo {
  static MaterialRepo get ins => _instance;

  /// Extract + persist text for one item. Returns the updated item map
  /// (with real processingStatus + indexedPageCount). Throws Fault on failure.
  Future<Map<String, dynamic>> extract(Map<String, dynamic> item);

  /// Grounding source: extracted text maps for a subject's items.
  Future<List<Map<String, dynamic>>> textsForSubject(
      String userId, String subjectId);
}
```
`_MaterialProvider.extract`:
1. Read `kind`/`metadata`(path) from the item map. Classify by **path extension** (the picker collapses `.md`/`.txt`/`.docx`/… all into `kind = note`, so the specific format is recovered from the path):
   - `pdf` / image → Gemini path (mime `application/pdf`, `image/jpeg`, `image/png`).
   - **plain-text note (`.md`, `.txt`) → direct read** (`File(path).readAsString()`), no AI call.
   - **unsupported (slide/video/voice, and non-text notes like `.docx`) → mark `failed`, return early**.
2. Set `processingStatus = processing` via `LibraryDao` update.
3. Run the chosen path: direct UTF-8 read for `.md`/`.txt`; otherwise read bytes and call `AiService.ins.extractText`.
4. Persist via `MaterialTextsDao.upsert` (content, charCount, pageCount estimate — `1` for plain-text notes).
5. Update `LibraryItems` row: `processingStatus = indexed`, `indexedPageCount`.
6. `try/catch` → on any error set `processingStatus = failed` and throw `AiFault`/`UnknownFault`.

#### 3. Cubit
**File**: `lib/blocs/material/cubit.dart`
`MaterialCubit.process(Map item)` → emits per-item `BlocState` (keyed by item id in `meta`), calls `MaterialRepo.ins.extract`, converts result to `LibraryItem.fromJson`, emits success/failed. Existing `LibraryCubit` re-reads its list (its DAO stream already reflects the row update).

#### 4. Trigger extraction from add-flows
**Files**: the Library "add material" path and onboarding Step 4 (`lib/ui/screens/onboarding/pages/_4_material.dart` flow).
**Changes**: after `LibraryRepo.add(item)`, call `MaterialCubit.c(context).process(item)` (fire-and-forget; UI reflects status via the library stream). Set initial `processingStatus = pending` in `libraryItemForPick` (replace the hardcoded `indexed`).

### Hygen Commands
```bash
hygen cubit nested material   # MaterialCubit + lib/repos/material/, auto-registers in app.dart
```

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` clean; `build_runner` clean.

#### Manual Verification (via `dart` MCP driver — see Verification Strategy)
- [ ] Add a PDF → status transitions `pending → processing → indexed`, `indexedPageCount` set, `MaterialTexts` row present.
- [ ] Add an image → OCR text stored.
- [ ] Add a `.md` (and `.txt`) note → text stored via direct read (no AI call), status `indexed`.
- [ ] Add a `.pptx` → status `failed`, no crash, item still lists.
- [ ] `MaterialRepo.ins.textsForSubject(uid, subjectId)` returns the stored text.

**Implementation Note**: Pause for manual confirmation.

---

## Phase 4: Library UI — real processing status

### Overview
Surface the now-real `processingStatus` on library item rows.

### Changes Required

#### 1. Status indicator on item rows
**File**: existing library item row widget under `lib/ui/screens/library/widgets/` (or shared item widget).
**Changes**: render a small badge/spinner per `processingStatus` — `processing` → spinner; `indexed` → subtle check/page-count; `failed` → muted "couldn't read" with a tap-to-retry calling `MaterialCubit.process`. Use `/design` tokens; respect widget-extraction threshold (rule 7) and `.map()` rule (rule 11).

### Hygen Commands
```bash
hygen screen _widget library <name>   # only if a new ≥5-child/≥30-line widget is warranted
```

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` clean.

#### Manual Verification
- [ ] Library list shows live status while extraction runs and settles to `indexed`/`failed`.
- [ ] Retry on a `failed` item re-runs extraction.

**Implementation Note**: Pause for manual confirmation.

---

## Verification Strategy

**No automated tests for now** (deferred). Each phase is verified by driving the running app in **driver mode** via the `dart` MCP (see CLAUDE.md → "Driving the App"). Static checks (`flutter analyze`, `build_runner`) still gate every phase.

### Driver-mode flow checks
1. Launch the **`Driver (MCP) — <device>`** entrypoint (`flutter run --flavor stage -t test_driver/app.dart`); `connect_dart_tooling_daemon` with the DTD URI.
2. Navigate to Library; use `flutter_driver` to add a real **PDF**, **image**, **`.md` note**, **`.txt` note**, and a **`.pptx`**.
3. Confirm via `get_widget_tree` / `screenshot`: PDF + image + `.md` + `.txt` settle to `indexed` (`.md`/`.txt` via direct read, no AI call); `.pptx` → `failed`, still listed, no crash.
4. `get_runtime_errors` after each add — zero unhandled errors; failures surface as handled `Fault`s.
5. Kill/relaunch mid-extraction → item stays `processing`/`pending` and retry works (no corrupt state).
6. Spot-check grounding output: after indexing, confirm `MaterialRepo.textsForSubject(uid, subjectId)` returns text (temporary `log()`/debug surface, or inspect Drift).

## Architecture Checklist
- [ ] `App.init(context)` at top of every `build()`
- [ ] UI (`_state.dart`) does not call Firebase/AI directly — goes through `MaterialCubit`
- [ ] Cubits do not import from `lib/ui/`
- [ ] State via `MaterialCubit.c(context)` / `_ScreenState.s(context)`
- [ ] `firebase_ai`/Drift exceptions converted to typed `Fault` (`AiFault`/`UnknownFault`) before emit
- [ ] `MaterialRepo` returns `Map`/`List<Map>`/primitives only (ADR-013)
- [ ] Cubit/repo scaffolded via `hygen cubit nested material`

## References
- Research: `docs/research/2026-06-14-chat-agent-integration.md`
- Next plan (depends on this): `docs/exec-plans/backlog/chat-agent.md`
- Picker/local-path source: `lib/services/material_picker/material_picker.dart:84-100`
- firebase_ai multimodal: `~/.pub-cache/hosted/pub.dev/firebase_ai-3.6.0/lib/src/content.dart:42-46`
