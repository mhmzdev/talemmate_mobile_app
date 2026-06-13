# Feature Checklist — Library / App-wide Materials Module

> A living test-plan + edge-case list for the Library screen and the app-wide
> materials module (`LibraryCubit` + `LibraryRepo`, Drift-backed). Re-run the
> relevant rows before merging any change that touches `lib/ui/screens/library`,
> `LibraryCubit`/`LibraryRepo`, `LibraryDao`/`SubjectDao` reads,
> `AppDatabase.saveLibraryItem`, the shared `lib/ui/widgets/design/library/*`
> widgets, the `MaterialPicker` service, or the auth-listener `initUid`/`resetUid`
> wiring.
>
> Status legend: ✅ verified on emulator (Dart MCP) · 🔒 guard / invariant to
> keep · 🚧 by-design gap (not implemented yet).
>
> Related: [exec-plan](../exec-plans/completed/library-materials-module.md),
> [research](../research/2026-06-13-library-feature-materials-module.md),
> [ADR-013 / ADR-014](../architecture/DECISIONS.md), [FLOWS](../screens/FLOWS.md).

## How to run

1. `firebase emulators:start` (Auth :9099, Firestore :8080, UI :4000).
2. `flutter run --flavor stage` (driver: `test_driver/app.dart`). Ensure
   `useFirebaseEmulators = true` in `lib/main.dart` for local emulator runs.
3. Sign in as a user that has seeded materials (e.g. `verify6`), then tap the
   **Library** bottom-bar tab.

---

## 1. Screen render & grouping (Phase 3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 1.1 | Open Library tab | Loads once on mount; header serif "Library" + "N documents · size" (real `fileSize` sum) | ✅ (4 documents · 4.4 MB) |
| 1.2 | Materials with a subject | grouped under a per-subject section (colour dot · serif name · mono code · "N items"), ordered by `Subject.order` | ✅ (Linear Algebra · MT-204 · 2 items) |
| 1.3 | Materials with no subject (or orphan FK) | collected in an **Unsorted** section rendered **last** | ✅ (Unsorted · 2 PDFs) |
| 1.4 | Row meta | kind badge (colour per `ItemKind`) · size · "added Xd ago" (real `uploadedAt`) · mock status · `AI INDEXED` pill when `processingStatus == indexed` | ✅ |
| 1.5 | Empty (no materials at all) | "No materials yet — add from onboarding or the button below." | 🔒 |
| 1.6 | Load failure | `UIFlash.error` (via `BlocConsumer` listener) + inline retry when list is empty | 🔒 (Fault → flash) |

## 2. In-state search (Phase 3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 2.1 | Type a query | filters visible rows by name (contains, case-insensitive), **in memory** — no DB query | ✅ ("resume" → 2 PDFs) |
| 2.2 | Header count while searching | header keeps the **true total**, not the filtered count | ✅ (stayed "4 documents") |
| 2.3 | Clear the query | full grouped list restored | ✅ |
| 2.4 | Query with no matches | "No materials match your search." | ✅ |

## 3. Filter chips (Phase 3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 3.1 | Tap a subject chip | narrows to that subject's section; chip fills (selected) | ✅ |
| 3.2 | Filter to a subject with no items | "No materials match your search." | ✅ (Discrete Mathematics) |
| 3.3 | Tap "All" | restores every section | ✅ |
| 3.4 | No subjects exist | chip row hidden (`SizedBox.shrink`) | 🔒 |

## 4. Load lifecycle & pull-to-refresh (Phase 2/3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 4.1 | Pull down to refresh | `RefreshIndicator` re-runs the one-shot `load()`; no error, no duplication | ✅ |
| 4.2 | `load()` with no session uid | no-ops (returns early) — never queries with an empty uid | 🔒 |
| 4.3 | Load populates state | `state.load.data` = items, `state.subjects` = all subjects (cubit does `fromJson`) | ✅ |

## 5. Material actions sheet — "…" menu (Phase 3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 5.1 | Tap "…" on a row | bottom sheet opens: kind badge + serif name + "subject · size" header | ✅ |
| 5.2 | Sheet actions | exactly **Open document**, **Ask the tutor about this**, **Delete from library** (rose) + Cancel | ✅ |
| 5.3 | Open document | sheet pops → `UIFlash.info` "Document viewer coming soon" | ✅ |
| 5.4 | Ask the tutor | sheet pops → `UIFlash.info` "Tutor coming soon" | ✅ (same popped-flash path as 5.3; not separately driven) |
| 5.5 | Cancel | sheet dismisses, no action | 🔒 |

## 6. Delete (Phase 3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 6.1 | Delete → confirm alert | centered alert (trash badge, "Delete this material?", Cancel \| Delete destructive) | ✅ |
| 6.2 | Alert → Delete | `LibraryCubit.remove(id)` → `deleteItem` + reload; row gone from list **and** DB; header count/size drop | ✅ (4→3 documents, 4.4→3.1 MB) |
| 6.3 | Alert → Cancel | nothing deleted | 🔒 |

## 7. Add new material — post-onboarding (Phase 4)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 7.1 | Tap "Add new material" | sheet opens: subject selector (`SubjectChips`, first pre-selected) + Files/Photos/Camera + "Add N to library"/Cancel | ✅ |
| 7.2 | Pick files/photos | `MaterialPicker` → `libraryItemForPick` → rows in "Added so far" (remove ×) | 🔒 (opens native picker; not driver-automatable) |
| 7.3 | "Add to library" | each built `LibraryItem` → `LibraryCubit.add` (uid from session, `subjectId` from selection); sheet closes; list refreshes | 🔒 |
| 7.4 | Added row persists | new `library_items` row with chosen `subject_id` (FK valid) + local path in `metadata` | 🔒 |
| 7.5 | Cancel | sheet dismisses, nothing added | 🔒 |

## 8. Session userId — ADR-014 (Phase 2)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 8.1 | Login success | `_login.dart` → `LibraryCubit.initUid(user.uid)` before routing | ✅ (Library loads the user's materials) |
| 8.2 | Session resume (splash) | `_init.dart` → `initUid(uid)` on resume success | 🔒 |
| 8.3 | Logout (profile / onboarding) | `_logout.dart` → `LibraryCubit.resetUid()` clears uid + materials + subjects | 🔒 |
| 8.4 | Cubit never reads `UserCubit` | uid only ever set via `initUid`/`resetUid` (no cross-cubit read) | 🔒 (ADR-014) |

## 9. Onboarding regression — shared widgets + picker refactor (Phase 1/4)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 9.1 | Onboarding Step 4 renders | subject pills (`SubjectChips`) + file rows (`LibraryItemTile`) render as before; subject attaches on pick | 🔒 (flip `isOnboardingComplete` to re-enter; shared impl unchanged) |
| 9.2 | Add-exam modal | subject chips still work (now `SubjectChips` + `_SubjectDraft.toChipData()`) | 🔒 |
| 9.3 | Profile "AI" pill | renders via shared `AppAiPill` | 🔒 |
| 9.4 | Onboarding still picks files | `addFiles`/`addImages`/`captureImage` route through shared `MaterialPicker` (behaviour-preserving) | 🔒 |

---

## Invariants / regression guards 🔒

- **Repo stays Map-only (ADR-013)** — `LibraryRepo` public methods take/return
  `Map`/`List<Map>`/primitives; `remove(String id)` is the 1-primitive exception.
  The cubit does `LibraryItem.fromJson` / `Subject.fromJson`; the add-write maps
  the model inside `AppDatabase.saveLibraryItem(Map)`. `lib/repos/library/` must
  not import `core/models/` (enforced by the repo-purity hook).
- **Drift `Row.toJson()` is NOT `fromJson`-compatible** — Drift serialises the
  `kind`/`processingStatus` enum-converter columns as raw enums and the date via
  its own serialiser. The provider must build the JSON map by hand
  (`_libraryItemJson`: `kind.name`, `processingStatus.name`,
  `uploadedAt.toIso8601String()`) so `LibraryItem.fromJson` round-trips. Do not
  replace it with `row.toJson()`.
- **Session uid via `initUid`/`resetUid` (ADR-014)** — the cubit owns `userId`;
  the auth listeners push it in. The cubit never reads `UserCubit`.
- **One-shot load + pull-to-refresh** — no live DB streams for the Library
  (`getByUser`/`getAll` are `Future` reads, not `watch`). `load()` re-runs on
  mount, pull-to-refresh, and after add/remove.
- **Search & filter are in-memory** — `groupMaterials` filters/groups the loaded
  list in Dart; no SQL `WHERE name LIKE`. Header count/size always reflect the
  full loaded set, not the filtered view.
- **Shared widgets are single-source** — `LibraryItemTile`, `SubjectChips`,
  `AppAiPill`, `AppChoiceChip` live in `lib/ui/widgets/design/` and are used by
  **both** onboarding and Library (fix-once-fixes-both). Don't re-privatise them.
- **Picking is one service** — onboarding Step 4 and the Library add-sheet both
  go through `MaterialPicker` + `libraryItemForPick`. Keep `itemKindForExtension`
  as the single extension→`ItemKind` mapping.
- **Cubit methods wrapped in `try { } on Fault catch`** — `load`/`add`/`remove`
  emit `toFailed(fault)` on a `Fault`; the provider wraps every Drift call in a
  typed `Fault` first, so a failure surfaces as a flash, never an uncaught crash.
- **Dialogs/sheets pass `routeName`** — the "…" sheet (`/modal/material-actions`),
  add sheet (`/modal/add-material`), and delete alert (`confirm-delete-material`)
  all set `RouteSettings(name:)` so nav logs aren't `unknown`.
- **`library_mocks.dart` / `library_parser.dart` are kept** — scaffold parts with
  `// ignore_for_file: unused_element` (rule 12); the mocks hold canned
  materials/subjects for a future cubit test. Don't prune them.

## By-design gaps 🚧 (not implemented — don't treat as bugs)

- **No real OCR / AI indexing** — the `AI INDEXED` pill and the status copy
  ("Annotated", "processed", "being read", page/word counts) are presentational
  **mocks**. Only "added Xd ago" derives from real `uploadedAt`.
- **Open document / Ask the tutor are placeholders** — both show a "coming soon"
  `UIFlash.info`; there is no in-app document viewer and the tutor module isn't
  built yet.
- **Local-only storage** — materials store a local path in `metadata`; no
  Firebase Storage upload or cloud sync.
- **Dropped from the design** — Move-to-another-subject, Rename, and Re-run AI
  indexing are intentionally out of scope (no rename / move / re-index path).
- **No live DB streaming** — the Library reloads on demand, not via a `watch`.
- **Duplicate subjects are a test-data artifact** — re-running onboarding mints
  fresh `subjects.id`s, so the chip row can show repeated subject names. The
  module renders whatever subjects exist; clear the local DB to dedupe.
</content>
