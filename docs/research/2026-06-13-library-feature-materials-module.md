---
date: 2026-06-13T17:30:00+05:00
researcher: Claude (claude-opus-4-8)
git_commit: dcf3fc5b131a9ded84642f8fa8a86fefa006fa63
branch: main
repository: taleemmate
topic: "Library feature as a separate app-wide materials module (cubit/bloc + repo): what exists today to build on"
tags: [research, codebase, library, materials, drift, cubit, repo, subjects]
status: complete
last_updated: 2026-06-13
---

# Research: Library Feature — Materials Module (cubit/bloc + repo)

**Date**: 2026-06-13
**Git Commit**: `dcf3fc5b131a9ded84642f8fa8a86fefa006fa63`
**Branch**: `main`

## Research Question
Research everything relevant to building the Library feature as a separate, app-wide "materials" module (its own cubit/bloc + repo). Library screen reached from bottom nav (`/library`, currently empty), shows materials **grouped by subject**, a header with total doc count + size, a **local in-memory search** over the loaded list (not a DB query), filter chips (All / per-subject), per-item rows (kind badge, metadata, AI-INDEXED tag, "…" menu), plus an "Add new material" affordance. Document how the slice works today and what already exists to build on.

## Summary
The local data layer is **largely ready**: `LibraryItems` and `Subjects` Drift tables exist with the exact fields the design needs, `LibraryDao`/`SubjectDao` already expose live `watch*` streams, and `LibraryItems.subjectId` is a real (nullable) FK to `Subjects.id` — so grouping by subject is a join of two existing streams. **No Library cubit, repo, or screen content exists yet** (`lib/blocs/` and `lib/repos/` contain only `onboarding/` and `user/`; `lib/ui/screens/library/` is an empty scaffold). The **onboarding repo → `AppDatabase` pattern is the exact template** for a Drift-backed `LibraryRepo` (Map-in/Map-out per ADR-013, model reconstruction inside the DB layer). Key gaps: there is **no Row→model mapper** (`LibraryItemRow`→`LibraryItem`), **no combined "all items grouped by subject" stream**, **no read method on a repo/DB for library**, **no in-state search/filter convention** (none exists anywhere yet), **no post-onboarding "add material" write path**, and several design labels (page count, "added 3d ago", status like "Annotated/being read", "AI INDEXED") are **mocked / have no data source**.

---

## Detailed Findings

### 1. Data layer — materials & subjects (mostly ready)

**Models** (`freezed`):
- `LibraryItem` — `lib/core/models/library/library_item.dart:14`. Fields: `id, userId, name, kind(ItemKind), fileSize(int), uploadedAt(DateTime), processingStatus(ProcessingStatus), subjectId?, metadata?, colorHex?, indexedPageCount?`. Enums in same file: `ItemKind { pdf, img, slide, note, video, voice }` (`:6`), `ProcessingStatus { pending, processing, indexed, failed }` (`:8`).
- `Subject` — `lib/core/models/subject/subject.dart:10`. Fields: `id, code, name, colorHex, confidenceLevel(double), order(int)`.
- `Topic` (`lib/core/models/subject/topic.dart:10`, has `TrendType { up,down,flat }`), `Exam` (`lib/core/models/subject/exam.dart:10`, has `daysUntil` getter).

**Tables** (`lib/core/db/tables/`):
- `LibraryItems` (`library_table.dart`, `@DataClassName('LibraryItemRow')`): every model field is a column. `kind`/`processingStatus` use `EnumConverter` (stores `.name`). `subjectId` = `text().references(Subjects, #id).nullable()` (`library_table.dart:19`) — **real FK**. PK `{id}`.
- `Subjects` (`subjects_table.dart:6`, `@DataClassName('SubjectRow')`): `id, code, name, colorHex, confidenceLevel, order(default 0)`. PK `{id}`, no FKs.
- `Topics` (`:19`), `Exams` (`:33`, `subjectId` FK to Subjects).
- FK enforcement is **on**: `migration.beforeOpen` runs `PRAGMA foreign_keys = ON` (`database.dart:92-94`).

**DAOs** — every method, with what's present vs absent:
- `LibraryDao` (`lib/core/db/daos/library_dao.dart`):
  - `watchByUser(String userId) → Stream<List<LibraryItemRow>>` (`:7`, ordered by `uploadedAt` desc) — **(a) load all items for a user ✓**
  - `watchBySubject(String subjectId) → Stream<List<LibraryItemRow>>` (`:13`) — **(b) by subject ✓**
  - `upsert(LibraryItemsCompanion) → Future<void>` (`:18`, `insertOnConflictUpdate`)
  - `deleteItem(String id) → Future<int>` (`:21`)
- `SubjectDao` (`lib/core/db/daos/subject_dao.dart`):
  - `watchAll() → Stream<List<SubjectRow>>` (`:7`, ordered by `order` asc) — **(c) all subjects ✓**
  - `watchBySubject(String subjectId) → Stream<List<TopicRow>>` (topics), `watchExams()`, `upsertSubject/Topic/Exam`, `deleteSubject/Topic/Exam`.

**`EnumConverter<T>`** (`lib/core/db/converters.dart:7-16`): stores `value.name`, reads via `values.firstWhere((e)=>e.name==fromDb)`. `StringListConverter` (`:18`) is jsonEncode/Decode (used by schedule, not library).

**Gaps in the data layer:**
- **No joined / grouped query** — no `watchAllWithSubject()`, no stream that returns items keyed by subject in one shot. Grouping must combine `SubjectDao.watchAll()` + `LibraryDao.watchByUser()` (or group an item list by `subjectId` in Dart).
- **No `LibraryItemRow` → `LibraryItem` mapper anywhere.** Row types and freezed models are independent classes with identical fields and **no conversion** exists in either direction except the write path inside `saveOnboardingData` (model→Companion). A read path (Row→model, or Row→Map→`LibraryItem.fromJson`) must be added.
- Drift generated `$$SubjectsTableReferences.libraryItemsRefs` in `database.g.dart:10108` (manager-API prefetch), but the hand-written DAOs use the legacy `select().watch()` API and never use it.

### 2. How materials are written today (the repo→DB template)

Write path (only path that exists): **`_ScreenState.finish()`** (`lib/ui/screens/onboarding/_state.dart:287`) → `OnboardingCubit.complete(OnboardingData)` (`lib/blocs/onboarding/cubit.dart:31`, calls `data.toJson()` then `OnboardingData.fromJson(raw)` on return) → `OnboardingRepo.ins.complete(Map)` (`lib/repos/onboarding/onboarding_repo.dart:21`) → `_OnboardingProvider.complete(Map)` (`onboarding_data_provider.dart:17`) → **`AppDatabase.ins.saveOnboardingData(Map)`** (`lib/core/db/database.dart:100`).

`saveOnboardingData` does `OnboardingData.fromJson(json)` then one `transaction` with ordered upserts: onboarding row → subjects → exams → schedule → **library items** (`database.dart:153-171`, maps every `LibraryItem` field incl. `subjectId`, `colorHex`, `metadata`, `processingStatus`, `indexedPageCount` into `LibraryItemsCompanion`). Subjects are written **before** library items so the `subjectId` FK resolves.

**This onboarding repo→`AppDatabase` shape is the template for `LibraryRepo`:**
- Repo public method: `Future<...Map/primitive...> name(Map/primitive)` — no model types (ADR-013).
- Data provider reaches `AppDatabase.ins` **directly by static reference** (`onboarding_data_provider.dart:21`), not via Provider.
- Model knowledge (`fromJson`) lives **inside the DB layer**, not the repo.
- Fault wrapping: `if (e is Fault) rethrow; throw UnknownFault(msg, st)` (`onboarding_data_provider.dart:23-25`).
- All DAO writes are `insertOnConflictUpdate` (idempotent on PK).

**DB plumbing confirmed:**
- `AppDatabase.ins` singleton — `lib/core/db/database.dart:84`.
- `Provider<AppDatabase>(create: (_) => AppDatabase.ins, dispose: (_,db)=>db.close())` — `lib/app.dart:37-40` (widget-tree access; repos use the static `.ins` directly).

How a material gets its subject (already implemented): `_materialFrom` (`onboarding/_state.dart:247`) stamps `subjectId: subject?.id` + `colorHex: subject?.colorHex` from the selected `_SubjectDraft`; `materialSubjectId` defaults to `subjects.first.id`. `processingStatus` is hard-coded `ProcessingStatus.indexed` (mock); `indexedPageCount` left null.

### 3. Cubit/repo module pattern (how to add a Library module)

**Cubit** (`lib/blocs/onboarding/cubit.dart` is the clean minimal example):
- `static X c(BuildContext, [bool listen=false]) => BlocProvider.of<X>(context, listen:listen)`.
- ctor `: super(State.def())`. Each action: `emit(state.copyWith(field: state.field.toLoading()))` → `final raw = await Repo.ins.method()` → `Model.fromJson(raw)` → `toSuccess(data:)` → `on Fault catch (e) { ...toFailed(fault:e) }`. Always a `reset()`.
- Richer example `UserCubit` (`lib/blocs/user/cubit.dart`) holds **plain data fields alongside BlocState fields** (`userData`, `user`) updated in one `copyWith` — relevant since Library state will hold the loaded materials/subjects lists + per-action BlocState.

**State** (`lib/blocs/onboarding/state.dart`): `@immutable extends Equatable`, `part of 'cubit.dart'`, `State.def()` inits each `BlocState()`, `copyWith` with `?? this.x`, all fields in `props`.

**`BlocState<T>`** (`lib/configs/bloc/_state.dart`): `data, fault, action, meta`; `toLoading/toSuccess/toFailed/toDefault/toCancelled`; getters `isLoading/isSuccess/isFailed/isDefault` + `errorMessage` + `getData` (via `BlocActionMixin`, `_action.dart`). Also `when/maybeWhen`.

**Repo 4-file scaffold** (`lib/repos/onboarding/`): `*_repo.dart` (singleton `ins`, `part` files, Map-only public methods, zero logic — delegates), `*_data_provider.dart` (`part of`, actual `AppDatabase.ins...` calls + Fault wrapping), `*_mocks.dart` + `*_parser.dart` (both `// ignore_for_file: unused_element`, kept per rule 12).

**ADR-013 (verbatim)** — `docs/architecture/DECISIONS.md:119-133`: repo public methods accept/return only `Map<String,dynamic>` / `List<Map<String,dynamic>>` / primitives; never model classes; never import `lib/core/models/...` in `*_repo.dart`. Exception: single-purpose 1–2 primitive functions (e.g. `Future<bool> exists(String id)`). Cubit does `Model.fromJson`. **Note for read flows:** a `List` of materials returned as `List<Map<String,dynamic>>`, cubit maps to `List<LibraryItem>` via `fromJson`.

**Generators** (`docs/tooling/HYGEN.md:121-196`): `hygen cubit nested library --args "load:LibraryItem,remove:LibraryItem"` creates the 6 files + injects `BlocProvider(create: (_) => LibraryCubit())` under `// bloc-initiate-start`. **Caveat (found in `app.dart`):** the `// bloc-imports-start` marker is **absent** from the current `lib/app.dart`, so the cubit import injection silently no-ops — the `import 'blocs/library/cubit.dart';` must be **added by hand** at the top (existing onboarding/user imports are hand-placed at `app.dart:1,4`). `hygen cubit update library --args "..."` adds actions later (requires nested markers).

### 4. Screen scaffold + state + cubit consumption

**Current `lib/ui/screens/library/`** (empty scaffold):
- `library.dart` — `LibraryScreen` (StatelessWidget) → `ChangeNotifierProvider<_ScreenState>` → `_Body` → `Screen(formKey:…, initialFormValue:_FormData.initialValues(), child: SafeArea(Column(children: [])))`. `part` files: `static/_form_data.dart`, `static/_form_keys.dart`, `_state.dart`. No `widgets/`, no `listeners/`.
- `_state.dart` — `_ScreenState extends ChangeNotifier`, the `static s(context,[listen])` accessor, one field `formKey = GlobalKey<FormBuilderState>()`. No other fields/methods.
- `static/_form_keys.dart` — `_FormKeys { static const search = 'search'; }` (anticipated search field, not wired).
- `static/_form_data.dart` — debug seeds `{search: 'Search'}`.

**`Screen` widget** (`lib/ui/widgets/core/screen/screen.dart`): `bottomBarRoutes` includes `/library` (`:75-81`) → `BottomBar` auto-shown; back-press on a bottom-bar route is forced to `pushReplace('/home')` (`:98-104`). `belowBuilders` render **behind** the body (for zero-UI `BlocListener`s); `overlayBuilders` render **in front** (for `FullScreenLoader`). `keyboardHandler`/`formKey`/`padding`/`scaffoldBackgroundColor` available.

**Ephemeral state**: `_ScreenState.s(context)` (listen:false) to read without rebuild; `_ScreenState.s(context, true)` to rebuild on `notifyListeners()` (profile body does this — `profile/profile.dart:43`). Mutators call `notifyListeners()`; profile uses a `_set(change){ change(); notifyListeners(); }` helper (`profile/_state.dart:40`).

**Cubit consumption**:
- Listener-only (navigation/side-effects): `BlocListener<C,S>(listenWhen:(a,b)=>a.x!=b.x, listener:…, child: SizedBox.shrink())` wired via `Screen(belowBuilders: const [_XListener()])` (splash `_InitListener`, profile `_LogoutListener`).
- Loader + side-effect: `BlocConsumer` returning `FullScreenLoader(loading: state.x.isLoading)` via `overlayBuilders` (login `_LoginListener`).
- **Fire an action on mount**: make `_Body` a `StatefulWidget` and in `initState` use `WidgetsBinding.instance.addPostFrameCallback((_){ if(!mounted) return; XCubit.c(context).load(); })` (splash does this with `UserCubit.init()` — `splash/splash.dart:39-44`). This is the pattern for "load library on screen open."
- Accessor `XCubit.c(context)` (`user/cubit.dart:16`); pass `listen:true` only when `build` should rebuild from cubit state (or use `BlocBuilder`).

**Routing/nav**: `/library` is tab #2 (`bottom_bar/_data.dart`, `LucideIcons.library`); tap → `tab.path.pushReplace(context)`. Router serves the 5 tab routes via `onGenerateRoutes` → `FadeRoute` (`router.dart:27-58`); `settings.name` flows through so `context.currentPath` resolves (drives `hasBottomBar`).

### 5. Reusable UI pieces (and the reuse boundary)

All of these are **onboarding-private `part of 'onboarding.dart'`** — NOT importable from a Library screen as-is. They are reuse *references*; a plan must either promote them to `lib/ui/widgets/` or re-implement:
- **Subject pill** — `_SubjectChips` (`lib/ui/screens/onboarding/widgets/_subject_chips.dart`): Wrap of pills (colored dot via `_hexColor(s.colorHex)` + name), selected = `selectedId==s.id` (filled `AppTheme.c.primary`), built on **private `_SubjectDraft`** (would need a public `Subject`-based variant for Library). Has built-in empty state.
- **Material row** — `_FileItem` (`lib/ui/screens/onboarding/widgets/_file_item.dart`): kind badge via `_badgeColor(ItemKind)` switch (pdf=red, img=blue, note=green, slide=amber, video=purple, voice=teal), `_readableSize` (KB/MB), subject dot+name, remove X. Takes a **public `LibraryItem`** + `subjectName` — closest to directly reusable, but private.
- **Filter-chip styles** — `_institution_chip.dart` / `_year_chip.dart` / `_source_chip.dart` (pill, selected = `AppTheme.c.text` fill).
- **Helpers** — `_hexColor(hex)` and `_kindForExtension(ext)` in `lib/ui/screens/onboarding/utils.dart` (private).
- **AI pill** — `_AiPill` (`lib/ui/screens/profile/widgets/_settings.dart:314`): gold pill (`accent` @ alpha .12 bg, border, `l1b` text) — reference for the "AI INDEXED" tag.
- **Eyebrow/section header** — `AppText.l1b.cl(subText).gm().copyWith(letterSpacing:…)` (profile `_Section`), and serif section titles `AppText.h3`/`h2` for the "Algorithms CS-301" header.

**Design tokens** (global, `lib/configs/`): `AppText` (`h1/h2/h3/b1/b2/l1` + `.cl(color)/.w(n)/.fra()/.gm()/.urdu()/.fs(size)`), `AppTheme.c` (`primary/accent/text/subText/background/specBackground/subBackground/border/success/error`), `Space` (`a/h/v/t/b/l/r` EdgeInsets, `x/y` SizedBox, `SpaceToken.tXX`, `sym/only`), `int.radius()`. `AppColors.onPrimary` for text-on-ink.

### 6. Search-in-state — no existing convention

`grep` confirms **no `_ScreenState` anywhere filters a list with `.where(...)`** and there is **no search-query/filter field** in any screen state today. The closest analogs:
- Derived getters over in-memory lists: `subjectNameFor(id)`, `isStep1Valid`, `isStep3Valid` (`onboarding/_state.dart`) — plain getters that compute from fields/lists.
- The `_set(change){ change(); notifyListeners(); }` single-field-mutation helper (`profile/_state.dart:40`).

So local search + chip filtering will be a **new (but trivial) ephemeral pattern**: a `String searchQuery` + `String? activeSubjectFilter` on `_ScreenState`, set via methods that `notifyListeners()`, and a derived filtered view computed in `_Body` over the cubit-loaded `List<LibraryItem>`. The materials list itself lives in the **cubit** (loaded from Drift); the **screen state** holds only the query/filter and derives the displayed subset.

---

## Code References
- `lib/core/models/library/library_item.dart:6,8,14` — ItemKind / ProcessingStatus / LibraryItem
- `lib/core/db/tables/library_table.dart:19` — `subjectId` FK to Subjects (nullable)
- `lib/core/db/daos/library_dao.dart:7,13,18,21` — watchByUser / watchBySubject / upsert / deleteItem
- `lib/core/db/daos/subject_dao.dart:7` — watchAll (subjects)
- `lib/core/db/database.dart:84,100,153-171` — `ins` singleton, saveOnboardingData, library upsert mapping
- `lib/core/db/database.g.dart:10108` — generated `libraryItemsRefs` (unused)
- `lib/app.dart:1,4,29-40` — hand-placed cubit imports; `// bloc-initiate-start` marker present, **`// bloc-imports-start` absent**; `Provider<AppDatabase>`
- `lib/repos/onboarding/onboarding_repo.dart:1-23`, `onboarding_data_provider.dart:17-27` — Drift-backed repo template
- `lib/blocs/onboarding/cubit.dart:31`, `state.dart` — minimal cubit/state template
- `lib/configs/bloc/_state.dart`, `_action.dart` — BlocState<T> + mixin
- `lib/ui/widgets/core/screen/screen.dart:35,36,75-81,98-104,135,145` — belowBuilders/overlayBuilders, bottomBarRoutes
- `lib/ui/screens/library/library.dart`, `_state.dart`, `static/_form_keys.dart` — current empty scaffold
- `lib/ui/screens/splash/splash.dart:39-44` — addPostFrameCallback action-on-mount
- `lib/ui/screens/onboarding/widgets/_subject_chips.dart`, `_file_item.dart`, `utils.dart` — reusable-but-private UI
- `lib/ui/screens/profile/widgets/_settings.dart:314` — `_AiPill`
- `lib/ui/widgets/core/bottom_bar/_data.dart` — /library tab
- `lib/router/router.dart:27-58`, `routes.dart:9` — FadeRoute for /library
- `docs/architecture/DECISIONS.md:119-133` — ADR-013
- `docs/tooling/HYGEN.md:121-196` — `cubit nested` / `cubit update`

## Architecture Documentation
- **Layer boundary**: UI(`_state.dart`) → Cubit(`lib/blocs`) → Repo(`lib/repos`, Map-only) → `AppDatabase`/DAOs (Drift). Models (`fromJson`) are reconstructed in the cubit (reads) or in the DB layer (the onboarding write). Repos never import `lib/core/models`.
- **State model**: per-screen ephemeral `ChangeNotifier` (`_ScreenState`) for view state; `Cubit` + `BlocState<T>` for business/data. A screen accesses both: `_ScreenState.s(context[,true])` and `XCubit.c(context)`.
- **Drift access**: `AppDatabase.ins` static singleton everywhere; live `Stream` queries via DAOs (`.watch()`); FKs enforced. The widget tree also has `Provider<AppDatabase>`.
- **Design target** (from `/tmp/design_bundle/.../screens/library.jsx`): `AppHeader(title:"Library", sub:"42 documents · 1.2 GB", right: search icon)`; search box; horizontally-scrolling filter chips (All + subjects); per-subject `SubjectGroup` (dot + serif name + mono code + "N items") of rows; row = kind badge + name + meta + "AI Indexed" pill + "in progress" + `…`; bottom dashed "Add new material" affordance + privacy note. Item statuses in the mock ("Annotated", "being read", "added 3d ago", page counts) are **presentational strings with no backing field today**.

## Related Docs
- `docs/exec-plans/completed/onboarding-local-persistence.md` — established the Drift write path + `subjectId` attachment this feature reads from.
- `docs/exec-plans/completed/onboarding-session-lifecycle.md` — auth/session gate + `AppAlertBase`.
- `docs/feat-checklist/onboarding-flow.md` — invariants for the material write path (FK: `library_items.subjectId` must equal a `subjects.id`).

## Open Questions
1. **Row→model mapping**: add a `LibraryItemRow → LibraryItem` (and `SubjectRow → Subject`) mapper, or have the repo return `List<Map>` via `.toJson()`-style row maps for the cubit to `fromJson`? (ADR-013 says Map crosses the repo boundary.)
2. **Grouped read shape**: combine `SubjectDao.watchAll()` + `LibraryDao.watchByUser()` (Dart-side group-by `subjectId`) vs. a new joined DAO query vs. the drift manager `libraryItemsRefs` prefetch. Also: how to surface materials whose `subjectId` is null (older items) — an "Unsorted" group?
3. **Stream vs one-shot**: cubit exposes a live stream (re-emits on DB change) vs. a `load()` that reads once. Onboarding uses one-shot writes; no read-stream cubit exists yet as a precedent.
4. **userId scoping**: `watchByUser` needs the current uid — sourced from `UserCubit.state.user?.uid`. How does `LibraryCubit` obtain it (passed in, or read from UserCubit)?
5. **Header counts / metadata**: "42 documents · 1.2 GB" derivable from the loaded list; but page counts, "added 3d ago" (uploadedAt exists → derivable), and status labels ("Annotated/being read") have **no data source** — mock vs. derive-from-`processingStatus`.
6. **Add-material path**: there is no post-onboarding write path; the "Add new material" affordance needs a new repo/DB write (reusing `LibraryDao.upsert`) + the same file_picker/subject-attach flow as onboarding Step 4.
7. **Widget promotion**: which onboarding-private widgets (`_FileItem`, `_SubjectChips`, `_hexColor`) get promoted to shared `lib/ui/widgets/` vs. re-implemented for Library.
