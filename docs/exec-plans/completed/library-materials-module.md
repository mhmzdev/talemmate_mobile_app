---
title: "Library — App-wide Materials Module (cubit/repo + screen)"
status: completed
created: 2026-06-13
completed: 2026-06-13
---

✅ COMPLETED — Phases 1–4 implemented, `flutter analyze` clean, flows verified end-to-end on emulator (Dart MCP). See [feat-checklist](../../feat-checklist/library-materials-module.md).

# Library — App-wide Materials Module — Implementation Plan

## Overview
Build the **Library** screen (`/library`, currently an empty scaffold) as the front end of a new **app-wide materials module**: a dedicated `LibraryCubit` + `LibraryRepo` that own reading and adding `library_items` from the local Drift DB. The screen shows materials **grouped by subject** (with an **Unsorted** bucket for items that have no subject), a header with total doc count + size, **in-state local search**, per-subject **filter chips**, **pull-to-refresh**, and an **"Add new material"** path that reuses the onboarding Step-4 picker UX. The module is the single access point for materials regardless of where they're added from (onboarding Step 4 today, the Library "Add" affordance after).

This plan is the direct continuation of the completed onboarding work, which already created the `library_items` table, the `subjectId` FK, and the write path. See research: `docs/research/2026-06-13-library-feature-materials-module.md`.

## Current State Analysis
The data layer is **largely ready**; the module + UI are **absent**.

Key files:
- `lib/core/db/tables/library_table.dart:19` — `LibraryItems.subjectId` is a nullable FK to `Subjects.id` (FK enforcement on via `PRAGMA foreign_keys = ON`, `database.dart:92`).
- `lib/core/db/daos/library_dao.dart:7,13,18,21` — `watchByUser` / `watchBySubject` (streams), `upsert`, `deleteItem`. **No one-shot `Future` reads.**
- `lib/core/db/daos/subject_dao.dart:7` — `watchAll()` (stream). **No one-shot read.**
- `lib/core/db/database.dart:84,100,153` — `AppDatabase.ins` singleton; `saveOnboardingData` writes materials transactionally (the model-in-DB-layer pattern).
- `lib/core/models/library/library_item.dart:6,8,14` — `LibraryItem`, `ItemKind`, `ProcessingStatus` (freezed, has `fromJson`/`toJson`).
- `lib/repos/onboarding/onboarding_repo.dart` + `onboarding_data_provider.dart:21` — the **Drift-backed repo template** (Map-in/Map-out, `AppDatabase.ins` by static ref, Fault wrapping) — model for `LibraryRepo`.
- `lib/ui/screens/library/{library.dart,_state.dart,static/*}` — empty scaffold (only a `formKey`); `/library` is a bottom-bar route (BottomBar auto-shows via `screen.dart:75`).
- Onboarding-private (must be **promoted to shared** per the user's directive): `lib/ui/screens/onboarding/widgets/_file_item.dart` (`_FileItem`), `widgets/_subject_chips.dart` (`_SubjectChips`, built on private `_SubjectDraft`), `utils.dart` (`_hexColor`, `_kindForExtension`); plus `lib/ui/screens/profile/widgets/_settings.dart:314` (`_AiPill`).

**What's missing:** any Library cubit/repo/screen content, a one-shot DB read, a `LibraryItemRow → LibraryItem` path (Row→Map via `.toJson()` → `fromJson`), a grouped/Unsorted view, an in-state search/filter convention (none exists anywhere yet), a session-`userId` mechanism for a cubit, and a post-onboarding add-material path.

## Desired End State
- Tapping the **Library** tab loads the signed-in user's materials once, groups them by subject (Unsorted last), and renders the design (header counts, search, filter chips, sections, rows with kind badge + size + "added Xd ago" + mock status + AI-INDEXED pill + `…`).
- **Search** filters the visible list in memory by name (no DB query). **Filter chips** narrow to one subject (or All). **Pull-to-refresh** re-runs the one-shot load.
- **"Add new material"** opens a sheet (subject selector + Files/Photos/Camera) that writes through `LibraryRepo` and refreshes the list.
- `LibraryCubit` holds the session `userId` (set/cleared by auth-transition listeners) — codified as **ADR-014**.
- The shared widgets (`LibraryItemTile`, `SubjectChips`, `AppAiPill`, `String.toColor()`, `AppChoiceChip`) are used by **both** onboarding and Library.
- Verify: `flutter analyze` clean; cubit unit test green; Dart MCP drive against emulators (login `verify6`, who has seeded materials → Linear Algebra section + Unsorted PDFs).

## What We're NOT Doing
- No real OCR / AI indexing / embeddings / `processingStatus` transitions — the "AI INDEXED" tag and statuses ("Annotated", "being read", "in progress", page/word counts) are **presentational mocks**. Only "added Xd ago" derives from real `uploadedAt`.
- No Firebase Storage upload / cloud sync (materials stay local, `metadata` = local path).
- No live DB streams — **one-shot load + pull-to-refresh** only (per locked decision #3).
- No search via SQL — in-memory only.
- The `…` menu ships **Open**, **Ask the tutor**, and **Delete** only. **Open** (no in-app document viewer yet) and **Ask the tutor** (tutor module not built) are **placeholders** for v1 (`UIFlash.info` "coming soon"); only **Delete** is wired (confirm alert → `LibraryCubit.remove`). The design's **Move to another subject**, **Rename**, and **Re-run AI indexing** are intentionally **dropped** for now (no rename / move-between-subjects / re-indexing).
- No change to onboarding's bundled `saveOnboardingData` transaction (stays atomic). Library owns reads + the *separate* add path.

## Implementation Approach
- **Layering** (mirrors the onboarding Drift template, ADR-013): `LibraryRepo` public methods take/return `Map`/`List<Map>`/primitives; the cubit does `LibraryItem.fromJson` / `Subject.fromJson`. Reads come back as `List<Map>` from Drift `Row.toJson()`. The add-write passes a `Map` to a new `AppDatabase.saveLibraryItem(Map)` that does `LibraryItem.fromJson` internally (repo stays model-free).
- **Grouping** is done in Dart after a one-shot load (cubit holds `items` + `subjects`); the **screen `_ScreenState`** holds only the ephemeral `searchQuery` + `activeSubjectFilter` and derives the displayed grouped/filtered view in `_Body`.
- **Session userId** lives in `LibraryState`; auth listeners drive `initUid`/`resetUid` (ADR-014) so the cubit always has the uid during an active session without reading `UserCubit`.
- **Tooling**: scaffold the module with `hygen cubit nested`, scaffold screen widgets/listeners with `hygen screen _widget` / `hygen screen consumer`. Shared widgets are hand-created (no generator) under `lib/ui/widgets/`.

---

## Phase 1: Promote shared widgets & helpers

### Overview
Lift the onboarding-private material/subject UI into shared, public-model-keyed widgets so onboarding and Library use one implementation (fix-once-fixes-both). No behaviour change for onboarding.

### Changes Required

#### 1. `String.toColor()` helper
**File**: `lib/configs/extension/_string.dart`
**Changes**: Add a hex→`Color` extension (replacing onboarding's private `_hexColor`).
```dart
Color toColor() => Color(int.parse(replaceFirst('#', '0xFF')));
```
Then in `lib/ui/screens/onboarding/utils.dart` remove `_hexColor` and repoint callers (`_subject_chips`, `_subject_entry`, `_exam_subject_chips`→now shared, `_file_item`) to `hex.toColor()`.

#### 2. `AppAiPill`
**File**: `lib/ui/widgets/design/misc/app_ai_pill.dart` (new), promoted from profile `_AiPill` (`_settings.dart:314`).
**API**: `AppAiPill({String text = 'AI'})` — gold pill (`accent` @ .12 bg, border, `AppText.l1b`). Repoint profile `_Section` aside to it; delete the private `_AiPill`.

#### 3. `SubjectChips` (+ `SubjectChipData`)
**File**: `lib/ui/widgets/design/library/subject_chips.dart` (new), promoted from onboarding `_SubjectChips`, keyed on a **public** view model (not `_SubjectDraft`).
```dart
class SubjectChipData {
  const SubjectChipData({required this.id, required this.label, required this.colorHex});
  final String id; final String label; final String colorHex;
}
class SubjectChips extends StatelessWidget {
  const SubjectChips({super.key, required this.subjects, required this.selectedId,
    required this.onSelect, this.emptyMessage});
  final List<SubjectChipData> subjects; final String? selectedId;
  final ValueChanged<String> onSelect; final String? emptyMessage;
  // ...same pill UI (dot via colorHex.toColor() + label, selected = primary fill)
}
```
Repoint onboarding **add-exam modal** (`_add_exam_modal.dart`) and **Step 4** (`_4_material.dart`) to `SubjectChips`, mapping `_SubjectDraft → SubjectChipData`. Delete `widgets/_subject_chips.dart`.

#### 4. `LibraryItemTile` (+ `ItemKind.badgeColor`)
**File**: `lib/ui/widgets/design/library/library_item_tile.dart` (new), promoted from onboarding `_FileItem`.
```dart
extension ItemKindBadge on ItemKind {
  Color get badgeColor => switch (this) { ItemKind.pdf => const Color(0xFFE05252), /* …existing map… */ };
}
class LibraryItemTile extends StatelessWidget {
  const LibraryItemTile({super.key, required this.item, this.subjectName,
    this.statusLabel, this.showAiIndexed = false, this.trailing, this.onTap});
  final LibraryItem item;
  final String? subjectName;   // resolved subject name → pill (dot via item.colorHex?.toColor())
  final String? statusLabel;   // MOCK ("Annotated"/"being read") — Library passes, onboarding null
  final bool showAiIndexed;    // → AppAiPill('AI INDEXED')
  final Widget? trailing;      // onboarding: remove X; library: "…" menu button
  final VoidCallback? onTap;
}
```
Meta row renders: subject pill (if `subjectName`) · `readableSize` · "added Xd ago" (from `item.uploadedAt`, derived) · `statusLabel` · `AppAiPill` (if `showAiIndexed`). Repoint onboarding Step 4 to pass `trailing:` a remove X (current behaviour). Delete `widgets/_file_item.dart`.

#### 5. `AppChoiceChip` (filter chips)
**File**: `lib/ui/widgets/design/misc/app_choice_chip.dart` (new), promoted from the `_institution_chip`/`_year_chip` style (label-only pill, selected = `text` fill). Used by the Library filter row (All + subjects). (Optional: repoint onboarding institution/year chips too — same style.)

### Hygen Commands
None — shared widgets are hand-created. (Generators don't cover `lib/ui/widgets/`.)

### Success Criteria
#### Automated
- [ ] `flutter analyze` clean (no unused-import/dead-code after deleting the private widgets).
- [ ] `dart fix --dry-run` shows nothing material.

#### Manual (Dart MCP, emulators)
- [ ] Onboarding Step 4 renders identically (subject pills + file rows with subject dot/size) and still attaches subject on pick.
- [ ] Add-exam modal subject chips still work.
- [ ] Profile "AI" pill still renders (now `AppAiPill`).

**Implementation Note**: Pause for manual confirmation after this phase.

---

## Phase 2: Library module — cubit + repo + one-shot DAO reads + ADR-014

### Overview
Scaffold `LibraryCubit` + `LibraryRepo` via hygen, add one-shot Drift reads, implement load/add/remove (Map boundary), hold the session `userId` in state via `initUid`/`resetUid`, and codify the session-uid pattern as ADR-014 + wire it into the auth listeners.

### Changes Required

#### 1. Generate the module (hygen)
```bash
hygen cubit nested library --args "load:LibraryItem,add:LibraryItem,remove:LibraryItem"
```
Creates `lib/blocs/library/{cubit,state}.dart` + `lib/repos/library/{library_repo,library_data_provider,library_mocks,library_parser}.dart`, and injects `BlocProvider(create: (_) => LibraryCubit())` under `// bloc-initiate-start` in `lib/app.dart`.

**Caveat (from research):** `lib/app.dart` is missing the `// bloc-imports-start` marker, so the import injection silently no-ops. **Hand-add** at the top of `lib/app.dart`:
```dart
import 'blocs/library/cubit.dart';
```
Verify the `BlocProvider` line was injected; if not, add it under `// bloc-initiate-start`.

#### 2. One-shot DAO reads
**Files**: `lib/core/db/daos/library_dao.dart`, `subject_dao.dart`
```dart
// LibraryDao
Future<List<LibraryItemRow>> getByUser(String userId) =>
    (select(libraryItems)..where((l) => l.userId.equals(userId))
      ..orderBy([(l) => OrderingTerm.desc(l.uploadedAt)])).get();
// SubjectDao
Future<List<SubjectRow>> getAll() =>
    (select(subjects)..orderBy([(s) => OrderingTerm.asc(s.order)])).get();
```

#### 3. DB add-write (model-in-DB-layer, keeps repo model-free)
**File**: `lib/core/db/database.dart`
```dart
Future<void> saveLibraryItem(Map<String, dynamic> json) async {
  final m = LibraryItem.fromJson(json);
  await libraryDao.upsert(LibraryItemsCompanion(
    id: Value(m.id), userId: Value(m.userId), name: Value(m.name), kind: Value(m.kind),
    fileSize: Value(m.fileSize), uploadedAt: Value(m.uploadedAt),
    processingStatus: Value(m.processingStatus), subjectId: Value(m.subjectId),
    metadata: Value(m.metadata), colorHex: Value(m.colorHex),
    indexedPageCount: Value(m.indexedPageCount)));
}
```

#### 4. `LibraryRepo` (edit generated files — Map boundary, ADR-013)
**File**: `lib/repos/library/library_repo.dart` + `_data_provider.dart`
```dart
// repo public surface
Future<List<Map<String, dynamic>>> materials(String userId) => _LibraryProvider.materials(userId);
Future<List<Map<String, dynamic>>> subjects() => _LibraryProvider.subjects();
Future<void> add(Map<String, dynamic> values) => _LibraryProvider.add(values);
Future<void> remove(String id) => _LibraryProvider.remove(id); // 1-primitive ADR-013 exception

// _data_provider (AppDatabase.ins by static ref; Row.toJson(); Fault wrapping)
static Future<List<Map<String,dynamic>>> materials(String userId) async {
  try { final rows = await AppDatabase.ins.libraryDao.getByUser(userId);
        return rows.map((r) => r.toJson()).toList(); }
  catch (e, st) { if (e is Fault) rethrow; throw UnknownFault('Could not load your library.', st); }
}
// subjects() likewise via SubjectDao.getAll(); add() → AppDatabase.ins.saveLibraryItem(values);
// remove(id) → AppDatabase.ins.libraryDao.deleteItem(id)
```
Keep `library_mocks.dart` / `library_parser.dart` as `// ignore_for_file: unused_element` (rule 12); give mocks a canned `materials`/`subjects` list for the cubit unit test.

#### 5. `LibraryState` + `LibraryCubit` (edit generated)
**File**: `lib/blocs/library/state.dart`
```dart
final String? userId;
final List<Subject> subjects;                 // for grouping/section headers
final BlocState<List<LibraryItem>> load;      // load.data == items
final BlocState<LibraryItem> add;
final BlocState<LibraryItem> remove;
```
**File**: `lib/blocs/library/cubit.dart`
```dart
void initUid(String uid) => emit(state.copyWith(userId: uid));
void resetUid() => emit(LibraryState.def());           // clears uid + items + subjects

Future<void> load() async {
  final uid = state.userId; if (uid == null) return;
  emit(state.copyWith(load: state.load.toLoading()));
  try {
    final rawItems = await LibraryRepo.ins.materials(uid);
    final rawSubs  = await LibraryRepo.ins.subjects();
    final items = rawItems.map(LibraryItem.fromJson).toList();
    final subs  = rawSubs.map(Subject.fromJson).toList();
    emit(state.copyWith(subjects: subs, load: state.load.toSuccess(data: items)));
  } on Fault catch (e) { emit(state.copyWith(load: state.load.toFailed(fault: e))); }
}

Future<void> add(LibraryItem item) async { /* toLoading → repo.add(item.toJson()) → toSuccess → load() */ }
Future<void> remove(String id) async { /* toLoading → repo.remove(id) → toSuccess → load() */ }
```

#### 6. ADR-014 + auth-listener wiring
**File**: `docs/architecture/DECISIONS.md` — add **ADR-014: Session userId via `initUid`/`resetUid` on cubits**.
> Cubits that need the signed-in user hold `userId` in their state and expose `initUid(uid)` / `resetUid()`. Auth-transition listeners set it on login / session-resume success and clear it on logout. Cubits never read another cubit to obtain the uid.

Wire (each listener already has `context`):
- `lib/ui/screens/login/listeners/_login.dart` — on `state.login.isSuccess`: `LibraryCubit.c(context).initUid(state.user!.uid)`.
- `lib/ui/screens/splash/listeners/_init.dart` — on init success (session resumed): `initUid(uid)`.
- `lib/ui/screens/profile/listeners/_logout.dart` + `lib/ui/screens/onboarding/listeners/_logout.dart` — on logout success: `LibraryCubit.c(context).resetUid()`.

### Hygen Commands
```bash
hygen cubit nested library --args "load:LibraryItem,add:LibraryItem,remove:LibraryItem"
# later, to add actions: hygen cubit update library --args "<module>:LibraryItem"
```

### Success Criteria
#### Automated
- [ ] `flutter analyze` clean; `flutter pub run build_runner build --delete-conflicting-outputs` clean (state/freezed unaffected, but run after edits).
- [ ] Unit test green: `flutter test test/blocs/library/library_cubit_test.dart` — using `_LibraryMocks`, assert `load()` populates `items`+`subjects`, `add`/`remove` flip `BlocState`, `resetUid()` clears.

#### Manual
- [ ] App builds; `LibraryCubit` registered (provider present); `initUid` fires on login (verify via a temporary log) — full UI verification lands in Phase 3.

**Implementation Note**: Pause for manual confirmation after this phase.

---

## Phase 3: Library screen UI (grouping, search-in-state, filters, pull-to-refresh)

### Overview
Build the Library screen body per the design: header counts, in-state search, filter chips, per-subject sections (Unsorted last), rows via `LibraryItemTile`, pull-to-refresh, loading/empty states. Load once on mount.

### Changes Required

#### 1. Screen widgets (hygen scaffold)
```bash
hygen screen _widget library --widgets "header,search_bar,filter_chips,subject_section,add_material_tile"
hygen screen consumer library --arg "library:load:load"   # load overlay/listener; fix BlocConsumer generics post-gen
```

#### 2. `_ScreenState` — ephemeral search/filter (new convention)
**File**: `lib/ui/screens/library/_state.dart`
```dart
String searchQuery = '';
String? activeSubjectFilter;            // null = All
void setQuery(String q) { searchQuery = q; notifyListeners(); }
void setFilter(String? subjectId) { activeSubjectFilter = subjectId; notifyListeners(); }
```

#### 3. `_Body` — load on mount + derive grouped/filtered view
**File**: `lib/ui/screens/library/library.dart`
- Convert `_Body` to `StatefulWidget`; `initState` → `addPostFrameCallback((_) { if (mounted) LibraryCubit.c(context).load(); })` (splash precedent).
- Read cubit via `BlocBuilder<LibraryCubit, LibraryState>` (items = `load.data`, subjects). Read `_ScreenState.s(context, true)` for query/filter.
- Derive in a pure helper: filter items by `searchQuery` (name contains, case-insensitive) and `activeSubjectFilter`; group by `subjectId` into `List<({Subject? subject, List<LibraryItem> items})>` ordered by `Subject.order`, with **Unsorted** (null subject) last.
- Header: count = items.length; size = sum(`fileSize`) → "X.X GB / MB" (shared readable-size helper).
- Wrap the scroll in `RefreshIndicator(onRefresh: () => LibraryCubit.c(context).load())`.
- States: `load.isLoading && items.isEmpty` → loader; success & empty → "No materials yet — add from onboarding or the button below."; failure → flash (via the generated listener) + retry.
- Rows: `LibraryItemTile(item:…, subjectName:…, showAiIndexed: item.processingStatus == ProcessingStatus.indexed, statusLabel: <mock>, trailing: "…" button)`. The `…` opens `_MaterialActionsSheet` (see #4 below).
- Bottom: `add_material_tile` (dashed "Add new material") → opens Phase 4 sheet. Privacy note text.
- Filter chips: `AppChoiceChip` row — `All` + one per subject (label = subject name).

#### 4. `_MaterialActionsSheet` — the `…` overflow menu
**File**: `lib/ui/screens/library/widgets/_material_actions_sheet.dart` (hygen `_widget`), shown via `showModalBottomSheet` with `RouteSettings(name: 'material-actions')`, built on `AppModalBase` (`dragger: true`).
- **Header**: the tapped item — kind badge + serif name + "‹Subject› · ‹meta›" (reuse `LibraryItemTile` in a compact, trailing-less mode, or a small inline header).
- **Three action rows** (icon + title + subtitle), matching the trimmed design:
  1. **Open document** — "Read & annotate" → v1 placeholder: `UIFlash.info(context, 'Document viewer coming soon')` (no in-app viewer yet).
  2. **Ask the tutor about this** — "Start a grounded chat" → v1 placeholder: `UIFlash.info(context, 'Tutor coming soon')` (tutor module not built).
  3. **Delete from library** (rose/error) → `Navigator.pop` the sheet, then `showAppAlert(routeName: 'confirm-delete-material', …, actions: [Cancel, Delete(isDestructive)])`; on confirm → `LibraryCubit.c(context).remove(item.id)` (which deletes the row + refreshes the list).
- **Cancel** button at the bottom (`Navigator.pop`).
- Dropped from the design: **Move to another subject**, **Rename**, **Re-run AI indexing** (out of scope — see "What We're NOT Doing").

### Hygen Commands
```bash
hygen screen _widget library --widgets "header,search_bar,filter_chips,subject_section,add_material_tile,material_actions_sheet"
hygen screen consumer library --arg "library:load:load"
```

### Success Criteria
#### Automated
- [ ] `flutter analyze` clean.
- [ ] Widget test green: `flutter test test/ui/screens/library/library_screen_test.dart` — seed cubit state with items across 2 subjects + 1 null-subject; assert sections render (incl. Unsorted), search narrows, chip filters.

#### Manual (Dart MCP, emulators — login `verify6` who has seeded materials)
- [ ] Library tab loads → "Linear Algebra" section (the 2 seeded images) + "Unsorted" section (the older null-subject PDFs); header count/size correct.
- [ ] Typing in search narrows rows live; clearing restores.
- [ ] Tapping a subject chip filters to that section; "All" restores.
- [ ] Pull-to-refresh re-runs load (no error, no duplication).
- [ ] `…` opens the actions sheet with the item header + 3 rows (Open / Ask the tutor / Delete) + Cancel.
- [ ] Open and "Ask the tutor" show the "coming soon" info flash (placeholders).
- [ ] Delete → confirm alert → on confirm the item is gone from the list and the DB (`library_items` row deleted).

**Implementation Note**: Pause for manual confirmation after this phase.

---

## Phase 4: Post-onboarding "Add new material" path

### Overview
Wire the "Add new material" affordance to a sheet that reuses the onboarding picker UX (subject selector + Files/Photos/Camera), writes via `LibraryCubit.add`, and refreshes the list. Extract the pick→`LibraryItem` logic into a shared service so onboarding and Library share one implementation (#7).

### Changes Required

#### 1. Shared material-picker service
**File**: `lib/services/material_picker/material_picker.dart` (new)
- Wraps `file_picker` / `image_picker`; exposes `pickFiles()`, `pickImages()`, `captureImage()` returning a small result list (name, sizeBytes, path, ext).
- A shared builder `libraryItemForPick({required pick, required String userId, String? subjectId, String? colorHex})` → `LibraryItem` (uses shared `ItemKind` mapping; `processingStatus: indexed` mock).
- Refactor onboarding `_state.dart` `addFiles/addImages/captureImage` + `_materialFrom` to call this service (behaviour-preserving) — fixes-once per #7.

#### 2. `AddMaterialSheet`
**File**: `lib/ui/screens/library/widgets/_add_material_sheet.dart` (hygen `_widget` or modal via `AppModalBase`)
- Subject selector (`SubjectChips` from `state.subjects`, mapped to `SubjectChipData`), Files/Photos/Camera buttons, "Added so far" list (`LibraryItemTile` with remove X), and an "Add to library" CTA.
- On confirm: for each built `LibraryItem` (uid from `LibraryCubit.state.userId`, subjectId from selection) → `LibraryCubit.c(context).add(item)`; close sheet; list refreshes (add() calls load()).

### Hygen Commands
```bash
hygen screen _widget library --widgets "add_material_sheet"   # if rendered as a screen part
```

### Success Criteria
#### Automated
- [ ] `flutter analyze` clean; onboarding still compiles after the picker refactor.

#### Manual (Dart MCP, emulators)
- [ ] From Library, "Add new material" → pick a subject → pick a file (manual native-picker step) → item appears in the correct subject section.
- [ ] DB: a new `library_items` row exists with the chosen `subject_id` (FK valid) and the local path in `metadata`.
- [ ] Onboarding Step 4 still adds materials correctly (picker refactor regression check).

**Implementation Note**: Final phase — confirm, then move the plan to `completed/`.

---

## Testing Strategy

### Unit Tests
- `LibraryCubit`: `load()` populates `items`+`subjects` (via `_LibraryMocks`); `add`/`remove` BlocState transitions + list refresh; `initUid`/`resetUid` set/clear `userId` and `resetUid` clears data; failure path → `toFailed` with `Fault`.
- Grouping helper (pure function): groups by `subjectId`, orders by `Subject.order`, null → Unsorted last; search + filter composition.

### Widget Tests
- Library screen: sections render (incl. Unsorted), search narrows, chip filter narrows, empty state, loading state.
- `LibraryItemTile`: badge color per `ItemKind`, AI-INDEXED pill toggled by `showAiIndexed`, subject pill when `subjectName` set.

### Manual Testing Steps (Dart MCP + emulators)
1. Login `verify6` → Library tab → verify grouped sections + header counts.
2. Search / filter-chip / pull-to-refresh.
3. `…` → Remove → gone from list + DB.
4. Add new material → subject + file → appears + persists (DB row, FK valid).
5. Re-run onboarding Step 4 (flip `isOnboardingComplete`) → picker still attaches subject (shared-widget + shared-service regression).
6. Logout → confirm `resetUid` cleared the cubit (Library empty on next login of a different user).

## Architecture Checklist
- [ ] `App.init(context)` at top of every new `build()`.
- [ ] UI (`_state.dart`) never calls Drift/Firebase directly — goes through `LibraryCubit`.
- [ ] `LibraryCubit`/repo never import `lib/ui/`.
- [ ] State via `LibraryCubit.c(context)` / `_ScreenState.s(context)` — never `context.read`.
- [ ] Repo returns `Map`/`List<Map>`/primitives only (ADR-013); cubit does `fromJson`; DB layer owns `LibraryItem.fromJson` for the write.
- [ ] DB/Drift exceptions wrapped in typed `Fault` before emitting.
- [ ] Boilerplate via `hygen` (cubit nested, screen _widget/consumer); shared widgets hand-created under `lib/ui/widgets/`.
- [ ] `.map()`/`.expand()` in widget trees (no `for`), spacing via `Space`/`SpaceToken`, `int.radius()`, design tokens.
- [ ] Session navigation/side-effects state-driven via listeners (incl. `initUid`/`resetUid` wiring — ADR-014).
- [ ] Dialogs/sheets pass `RouteSettings(name:)`.

## References
- Research: `docs/research/2026-06-13-library-feature-materials-module.md`
- Design: `/tmp/design_bundle/taleemmate/project/screens/library.jsx` (+ `shell.jsx`, `styles.css`)
- ADR-013 (repo Map boundary): `docs/architecture/DECISIONS.md:118`
- Onboarding Drift-repo template: `lib/repos/onboarding/onboarding_data_provider.dart:17`
- Material write/FK invariant: `docs/feat-checklist/onboarding-flow.md`
- Completed precedent: `docs/exec-plans/completed/onboarding-local-persistence.md`
