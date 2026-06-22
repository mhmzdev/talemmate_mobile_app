---
title: "Profile → Account section editors (Institution, Subjects, Schedule & exams)"
status: completed
created: 2026-06-20
completed: 2026-06-22
---

✅ COMPLETED — Merged + driver-verified

> **Implemented as apply-on-rebuild** (refined from the original "offer-to-regenerate"
> design): the editors hold edits locally and only persist on **Rebuild** — "Save
> changes" always prompts, **Rebuild** persists + regenerates, **Later** discards.
> So plan inputs and the generated week never drift apart. The Institution sheet
> owns its own success listener (a slow Firestore write can't pop an unrelated
> route). See [docs/feat-checklist/profile-account-editors.md](../../feat-checklist/profile-account-editors.md).

# Profile → Account Editors — Implementation Plan

## Overview

Make the three editor-backed rows in **Profile → Account** functional. Today they
display live data (already wired) but are not tappable to edit. This plan adds:

1. **Institution** — tap → edit sheet → persist to Firestore (`users/{uid}`) + local Drift, refresh `UserData`.
2. **Subjects & confidence** — tap → standalone editor screen → add / edit / remove subjects + confidence → persist.
3. **Schedule & exams** — tap → standalone editor screen → edit study windows, daily target, exams → persist.

Because subjects / confidence / schedule / exams are the **inputs** the AI study-plan
generator consumed at onboarding, saving an edit makes the existing plan stale. Per
the product decision (below), after a plan-affecting save we **offer to regenerate**
the week behind a loader, with an explicit warning that today's completed/rescheduled
blocks reset.

## Decisions locked

- **Editor reuse → Standalone editors.** Build new `subjects_editor` + `schedule_editor`
  screens. Reuse only the already-shared widgets (`AppChoiceChip`, `SubjectChips`,
  `SubjectSwatch`, the `kStudyWindowCatalog`). Re-implement the small subject/exam
  rows + add-modals locally. **Onboarding is not touched** (no regression risk; its
  editing widgets stay `part of onboarding.dart`).
- **Plan on edit → Offer to regenerate.** After a plan-affecting save, a
  `BlocListener` surfaces a confirm alert ("Rebuild this week? Today's completed/
  rescheduled blocks will reset."). On confirm, run the existing `PlanCubit.generate()`
  behind a `FullScreenLoader`. Non-destructive without consent.

## Current State Analysis

**Already done (committed `d752284`):** `_AccountSection`
(`lib/ui/screens/profile/widgets/_settings.dart`) reads live data — subject count
(`LibraryCubit.state.subjects`), daily target (`PlanCubit.state.schedule?.dailyTargetHours`),
material count + size (`LibraryCubit.state.load.data`), institution (`UserData.institution`).
"Material" navigates to Library. The three editor rows have no `onTap`.

**Persistence surface that already exists:**
- Subjects/exams DAO — `lib/core/db/daos/subject_dao.dart`: `upsertSubject(SubjectsCompanion)` (`:35`), `upsertExam(ExamsCompanion)` (`:41`), `deleteSubject(id)` (`:44`), `deleteExam(id)` (`:50`), `getByUser(userId)` (`:22`), `getExamsByUser(userId)` (`:29`). All `insertOnConflictUpdate`, so editing an existing row by id = upsert.
- Schedule DAO — `lib/core/db/daos/schedule_dao.dart`: `upsertSchedule(SchedulesCompanion)` (`:29`), `findByUser(userId)` (`:10`). Schedule `id` is PK → editing = upsert same id with new fields.
- Onboarding DAO — `lib/core/db/daos/onboarding_dao.dart`: `upsert(...)` (`:12`), `findByUser` (`:8`). Holds the local `institution`.
- `AppDatabase.saveOnboardingData(Map)` (`lib/core/db/database.dart:127`) is the **only** existing write path — a full-payload replace. There are **no** targeted Map-wrappers for single subject/exam/schedule edits yet → this plan adds them (repo purity, ADR-013).

**User profile persistence:**
- `_UserProvider.completeOnboarding(uid, extra)` (`lib/repos/user/user_data_provider.dart:~95`) merge-sets `users/{uid}` with `{isOnboardingComplete:true, ...extra}` — this is how `institution` reaches Firestore today.
- `_UserProvider.update()` (`:~118`) is **mocked, no-arg** → returns `_UserMocks.update()`. `UserCubit.update()` (`lib/blocs/user/cubit.dart:167`) drives the `update` `BlocState`. `UserData` display reads from Firestore via `fetchProfile(uid)`.
- `UserData` model — `lib/core/models/user/user.dart`: `institution` is `String?` (`:14`).

**Onboarding editors are coupled (why we go standalone):** every rich editing widget
(`_subject_entry`, `_add_subject_modal`, `_add_exam_modal`, `_exam_row`,
`_time_window_tile`, `_tag_color_picker`) and the `_SubjectDraft` / `_ExamDraft`
models are `part of onboarding.dart` (`lib/ui/screens/onboarding/`), bound to the
onboarding `_ScreenState`. Not importable. Confidence-label helper lives at
`lib/ui/screens/onboarding/utils.dart` (verify importability; if `part of`, replicate
the 3 thresholds: Shaky `<0.35` / Getting there `0.35–0.7` / Confident `≥0.7`).

**Plan generation (the regeneration target):**
- `PlanCubit.generate(userId)` (`lib/blocs/plan/cubit.dart:38`) is re-callable, no guard. Reads subjects/exams/schedule/windows from Drift, calls Gemini, then `replaceStudyBlocks(scheduleId, blocks)` (`lib/core/db/database.dart:421`) which **deletes every block for the schedule** and re-inserts — destroying `status` (done), and snooze/move/shorten/skip overrides. `SessionMetrics` (separate table) survive. The `_watchSchedule` Drift stream auto-emits the fresh `week`.
- `PlanCubit` caches `state.schedule` and private `_exams` (set during `watchForUser`); these go **stale** after an edit and are **not** refreshed by `generate()`. The `watchForUser` idempotency guard (`_watchingUserId == userId && _blocksSub != null`, `:56`) suppresses a naive re-watch.
- Only call site of `generate()` today: `lib/ui/screens/stepwise_loader/_state.dart:54`.

## Desired End State

- Tapping **Institution** opens a sheet to edit the value; saving persists to Firestore + Drift and the Account row + Profile-elsewhere reflect it immediately.
- Tapping **Subjects & confidence** opens an editor pre-loaded with the user's subjects; add/edit/remove/confidence all persist; the Library + Home + Plan see the change after reload.
- Tapping **Schedule & exams** opens an editor pre-loaded with windows/target/exams; changes persist.
- After a plan-affecting save, the user is offered a week rebuild; confirming regenerates behind a loader and refreshes the plan UIs; declining leaves the plan stale (no silent destruction).
- All new cubit/repo methods are unit-tested; editors have widget tests; flows are driver-verified; a `docs/feat-checklist/` entry exists.

## What We're NOT Doing

- **Not** touching the onboarding flow or its widgets (standalone decision).
- **Not** promoting onboarding widgets to shared (explicitly rejected).
- **Not** auto-regenerating or silently mutating the plan.
- **Not** wiring `forgot` / `deleteAccount` / Help / Rate / Cloud backup / notifications — out of scope (separate Profile sections).
- **Not** adding Firebase Storage / Firestore sync for subjects/schedule (stay local Drift per ADR-014, except the institution field which already lives in `users/{uid}`).
- **Not** adding topic-level editing (subjects only carry code/name/confidence/colour).
- **Not** changing `replaceStudyBlocks` semantics (regeneration stays a full week replace; we gate it behind consent instead).

## Implementation Approach

- **Repo purity (ADR-013):** new write methods on `LibraryRepo` / `PlanRepo` / `UserRepo`
  take/return `Map`/primitives. The Map→Companion conversion lives in new `AppDatabase`
  wrappers (`database.dart` may import models; repos may not).
- **Ownership:** `LibraryCubit` already owns the app-wide `subjects` list → it gains
  subject CRUD + `load()` refresh. `PlanCubit` owns `schedule`/`_exams` → it gains
  schedule/exam writes + an in-memory cache refresh. `UserCubit` gains a real
  `updateProfile(Map)`.
- **Editors are ephemeral-state screens** (`_ScreenState` `ChangeNotifier`, generated
  via hygen). They never touch Firebase/Drift directly — they read initial data from
  the owning cubits and dispatch saves to them. Save side-effects (regenerate prompt,
  pop) run through `BlocListener`, never imperatively in `_state.dart`.
- **State accessors** via `XCubit.c(context)` / `_ScreenState.s(context)` only.

---

## Phase 1: Institution edit

### Overview
Smallest, self-contained slice — make `UserCubit.update` real and add an edit sheet on
the Institution row. Ships value independently of the editors.

### Changes Required

#### 1. Real profile update — repo + provider
**File**: `lib/repos/user/user_data_provider.dart`, `lib/repos/user/user_repo.dart`
**Changes**: Replace the mocked no-arg `update()` with `update(String uid, Map<String,dynamic> fields)`:
```dart
// _UserProvider
static Future<Map<String, dynamic>> update(
  String uid, Map<String, dynamic> fields,
) async {
  try {
    await _firestore.collection(FireCollections.users)
        .doc(uid).set(fields, SetOptions(merge: true));
    return await fetchProfile(uid); // return the fresh profile map
  } on FirebaseException catch (e, s) {
    throw FirebaseFault.fromFirebase(e, s);
  } catch (e, st) {
    if (e is Fault) rethrow;
    throw UnknownFault('Something went wrong!', st);
  }
}
```
`UserRepo.update(uid, fields) => _UserProvider.update(uid, fields)`. Keep
`user_mocks.dart` / `user_parser.dart` (rule 12) — leave the mock method present.
Mirror the institution into local Drift via a new `AppDatabase.updateInstitution(uid, value)`
(new `OnboardingDao.updateInstitution` — targeted `update(onboardingDataTable)..where(userId)..write(...)`, **not** upsert, to avoid an insert with a null `step`).

#### 2. Cubit
**File**: `lib/blocs/user/cubit.dart`
**Changes**: `Future<void> updateProfile(Map<String,dynamic> fields)` — wraps repo call, emits `state.update` loading→success(`UserData.fromJson(raw)`)→failed, and on success emits `userData` so all `UserCubit`-listening surfaces refresh. (Reuse the existing `update` `BlocState` field.)

#### 3. Edit sheet + row wiring
**File**: `lib/ui/screens/profile/widgets/_settings.dart` (and a new `_institution_sheet.dart` part)
**Changes**: Institution `_SettingRow` gets `onTap` → opens an `showModalBottomSheet` (with `RouteSettings(name: '/modal/edit-institution')`, rule 14) holding a single text field (seeded with the current value) + Save. Save dispatches `UserCubit.updateProfile({'institution': value})`. A `BlocListener<UserCubit,UserState>` (in the profile `belowBuilders`) on `state.update` closes the sheet + flashes on success, flashes on failure.

### Hygen Commands
_None_ — extends existing cubit/repo; the sheet is a private widget part of the profile screen.

### Success Criteria
#### Automated
- [ ] `flutter analyze` clean
- [ ] `flutter test test/blocs/user/` (new `updateProfile` transitions)
#### Manual
- [ ] Edit institution → value persists to `users/{uid}` (emulator UI) + survives relaunch
- [ ] Account row + any other `UserData` surface update without manual refresh
- [ ] Firestore failure surfaces a flash, sheet stays open, no crash

**Implementation Note**: pause for manual confirmation after this phase.

---

## Phase 2: Subject / exam / schedule write plumbing

### Overview
Add the Map-based write surface the editors will call. No UI yet — pure data layer +
cubit methods + unit tests.

### Changes Required

#### 1. AppDatabase Map-wrappers
**File**: `lib/core/db/database.dart`
**Changes**: New methods converting Map→Companion (models stay out of repos):
- `Future<void> upsertSubject(Map<String,dynamic> json)` → `subjectDao.upsertSubject(SubjectsCompanion(...))` (id, userId, code, name, colorHex, confidenceLevel, order)
- `Future<void> deleteSubject(String id)` → `subjectDao.deleteSubject(id)` (note FK: exams reference subjects — delete/guard exams for that subject first, or block deletion of a subject that has exams; decide in editor UX → simplest: cascade-delete its exams in a transaction)
- `Future<void> upsertExam(Map<String,dynamic> json)` / `Future<void> deleteExam(String id)`
- `Future<void> updateSchedule(Map<String,dynamic> json)` → `scheduleDao.upsertSchedule(...)` with existing id + new `dailyTargetHours` / `enabledWindowIds`

#### 2. Subject CRUD on Library layer
**File**: `lib/repos/library/library_repo.dart`, `lib/blocs/library/cubit.dart`
**Changes**: `LibraryRepo`: `upsertSubject(Map)`, `removeSubject(String id)` (Map/primitive in). `LibraryCubit`: `Future<void> saveSubject(Subject)` / `removeSubject(String id)` doing `Model.toJson` then `await load()` to refresh the app-wide `subjects`. Keep `library_mocks`/`library_parser` (rule 12).

#### 3. Schedule + exam writes on Plan layer
**File**: `lib/repos/plan/plan_repo.dart`, `lib/blocs/plan/cubit.dart`
**Changes**: `PlanRepo`: `updateSchedule(Map)`, `upsertExam(Map)`, `removeExam(String id)`, plus a read `exams(uid)` (already used in `watchForUser`). `PlanCubit`: `saveSchedule({double dailyTargetHours, List<String> enabledWindowIds})`, `saveExam(Exam)`, `removeExam(String id)`. After a successful write, **refresh the cubit's cached state in-memory** (update `state.schedule` and reload `_exams` via `PlanRepo.exams(uid)`) so Home/Plan `nextExam` + available-hours reflect the change without a full `reset()`. Add `List<Exam> get exams => List.unmodifiable(_exams);` for the editor to read.

### Hygen Commands
```bash
hygen cubit update library     # inject saveSubject / removeSubject actions
hygen cubit update plan        # inject saveSchedule / saveExam / removeExam actions
```
(If the `cubit update` generator doesn't fit hand-extend, following the existing method style.)

### Success Criteria
#### Automated
- [ ] `flutter analyze` clean
- [ ] `flutter test test/blocs/library/` + `test/blocs/plan/` — new methods, success + `Fault` paths, ADR-014 uid scoping
- [ ] `flutter pub run build_runner build --delete-conflicting-outputs` clean (no model changes expected, but confirm)
#### Manual
- [ ] Unit tests assert subjects/exams/schedule rows change in a seeded in-memory DB

---

## Phase 3: Subjects & confidence editor

### Overview
New standalone screen, pre-loaded from `LibraryCubit.state.subjects`, editing
code/name/confidence (and colour), saving via Phase-2 cubit methods.

### Changes Required

#### 1. New screen
**File**: `lib/ui/screens/subjects_editor/`
**Changes**: `hygen screen new subjects_editor` (root, `_state.dart`, widgets, route). `_ScreenState` holds a local editable list of subject drafts seeded from `LibraryCubit.c(context).state.subjects` on construction. Add/edit/remove rows locally; Save diffs against the loaded set and dispatches `LibraryCubit.saveSubject` / `removeSubject` per change.

#### 2. Local rows + modal (standalone, reuse shared)
**File**: `lib/ui/screens/subjects_editor/widgets/`
**Changes**: A subject row (code/name fields + confidence slider + colour) and an "add subject" modal — re-implemented locally, reusing `SubjectSwatch`, `AppChoiceChip`, the confidence-label helper (import from `onboarding/utils.dart` if importable, else replicate thresholds), and `AppTextField`/form widgets. Use `Space.*` tokens; `.map()` for the list; extract a row widget only at the ≥5-child/≥30-line threshold.

#### 3. Wire the Profile row
**File**: `lib/ui/screens/profile/widgets/_settings.dart`
**Changes**: "Subjects & confidence" `_SettingRow.onTap` → `AppRoutes.subjectsEditor.push(context)`.

#### 4. Save → regenerate handoff
Save success emits via `LibraryCubit`; a `BlocListener` (Phase 5) decides the regenerate prompt. The editor pops on success.

### Hygen Commands
```bash
hygen screen new subjects_editor
hygen screen _widget subjects_editor   # per private widget (row, modal)
```

### Success Criteria
#### Automated
- [ ] `flutter analyze` clean
- [ ] `flutter test test/ui/screens/subjects_editor/` (render, add/edit/remove, save dispatch)
#### Manual
- [ ] Opens pre-filled with real subjects; add/edit/remove persists; reflected in Library + Account count
- [ ] `App.init(context)` at top of every `build()`; no `context.read`; no Firebase in `_state.dart`

**Implementation Note**: pause for manual confirmation.

---

## Phase 4: Schedule & exams editor

### Overview
New standalone screen, pre-loaded from `PlanCubit.state.schedule` + `PlanCubit.exams`,
editing study windows, daily target, and exams.

### Changes Required

#### 1. New screen
**File**: `lib/ui/screens/schedule_editor/`
**Changes**: `hygen screen new schedule_editor`. `_ScreenState` seeded from `PlanCubit.state.schedule` (`enabledWindowIds`, `dailyTargetHours`) + `PlanCubit.exams`. Window multi-select from `kStudyWindowCatalog` (`lib/core/constants/study_windows.dart`); daily target slider (0.5–6, 11 divisions, matching onboarding); exam list with add/remove (subject picker via `SubjectChips`, date picker). Save dispatches `PlanCubit.saveSchedule(...)` + exam upserts/deletes. Enforce the FK invariant (exam.subjectId must be an existing subject id).

#### 2. Local widgets
**File**: `lib/ui/screens/schedule_editor/widgets/`
**Changes**: Window toggle tile, exam row, add-exam modal — local, reusing `AppChoiceChip`, `SubjectChips`, `SubjectSwatch`.

#### 3. Wire the Profile row
**File**: `lib/ui/screens/profile/widgets/_settings.dart`
**Changes**: "Schedule & exams" `_SettingRow.onTap` → `AppRoutes.scheduleEditor.push(context)`.

### Hygen Commands
```bash
hygen screen new schedule_editor
hygen screen _widget schedule_editor
```

### Success Criteria
#### Automated
- [ ] `flutter analyze` clean
- [ ] `flutter test test/ui/screens/schedule_editor/`
#### Manual
- [ ] Opens pre-filled with current windows/target/exams; edits persist; Account "hrs/day" updates
- [ ] At least one window stays required (mirror onboarding Step-3 gate)

**Implementation Note**: pause for manual confirmation.

---

## Phase 5: Offer-to-regenerate flow

### Overview
After a plan-affecting save (Phase 3 or 4), offer a week rebuild. Shared, state-driven.

### Changes Required

#### 1. Regenerate affordance
**File**: new shared helper, e.g. `lib/ui/screens/.../listeners/_regenerate.dart` or a small shared widget
**Changes**: A `BlocListener` on the relevant save `BlocState` (subjects save / schedule save) that, on success, shows `showAppAlert` (routeName `/alert/regenerate-plan`): title "Rebuild this week's plan?", subtitle warns "Your new subjects/schedule will be used. Blocks you've completed or moved today will reset." Actions: **Later** (dismiss) / **Rebuild** (destructive-styled).

#### 2. Run generation behind a loader
**Changes**: On **Rebuild**, resolve `uid` from `UserCubit` and call `PlanCubit.generate(uid)`. A `BlocListener<PlanCubit,PlanState>` on `state.generate` drives a `FullScreenLoader.modal` (title "Rebuilding your plan…") — success → dismiss + flash + ensure `state.schedule`/`_exams` fresh (Phase 2 refresh already ran on save); failure → dismiss + error flash (plan left intact, since `replaceStudyBlocks` only runs on a successful Gemini parse). Navigation/side-effects stay in the listener, never in `_state.dart`.

#### 3. "Plan-affecting" gate
**Changes**: Only prompt when something the generator uses actually changed (subjects added/removed, confidence changed, windows/target changed, exams changed) — not on a no-op save. Editors expose a `bool changedPlanInputs` from their diff.

### Hygen Commands
_None_ (listeners are hand-written per the state-driven-nav convention; generate via `hygen screen listener <name>` if a fresh listener scaffold helps).

### Success Criteria
#### Automated
- [ ] `flutter analyze` clean
- [ ] `flutter test` — listener/regeneration unit coverage where feasible
#### Manual
- [ ] Edit a subject → prompt appears → **Rebuild** → loader → Home shows a fresh week; a previously-`done` block today is reset (expected); streak/session metrics intact
- [ ] **Later** → plan unchanged, no Gemini call
- [ ] Gemini failure → old plan intact, error flash

**Implementation Note**: pause for manual confirmation.

---

## Phase 6: Tests, verification & docs

### Changes Required
- Fill any gaps in unit/widget coverage from Phases 1–5.
- Driver-verify the three flows end-to-end (Dart MCP, stage flavor) per CLAUDE.md.
- Add `docs/feat-checklist/profile-account-editors.md` (status legend ✅/🔒/🚧) covering: institution edit + persistence, subjects add/edit/remove + confidence, schedule/window/target/exam edits, FK invariant (exam→subject), regenerate prompt + destructive rebuild + decline path, ADR-014 uid scoping, repo purity. Add its row to `docs/feat-checklist/INDEX.md`.
- Update `docs/features/CATALOGUE.md` Implementation Status: Profile Account rows move from "display-only" to functional; note the regenerate-on-edit behaviour.

### Success Criteria
#### Automated
- [ ] Full `flutter test` green
- [ ] `flutter analyze` clean
#### Manual
- [ ] All three editors verified on the simulator via the driver
- [ ] No `unknown` routes in nav logs (all sheets/alerts/screens carry `RouteSettings`/routes)

---

## Testing Strategy

### Unit Tests
- `UserCubit.updateProfile` — success emits fresh `userData`; `Fault` → failed.
- `LibraryCubit.saveSubject` / `removeSubject` — DB row mutated, `subjects` reloaded, uid-scoped.
- `PlanCubit.saveSchedule` / `saveExam` / `removeExam` — schedule/exam rows mutated; cached `schedule`/`_exams` refreshed; FK respected.
- `AppDatabase` Map-wrappers — Map→Companion round-trip on a seeded in-memory DB.

### Widget Tests
- `subjects_editor` — renders seeded subjects; add/edit/remove; save dispatches expected cubit calls (mocktail).
- `schedule_editor` — renders seeded windows/target/exams; toggle/slider/add-exam; window-required gate.
- Institution sheet — seeded value, save dispatch, success/failure handling.
- Regenerate listener — success path shows alert; Rebuild calls `generate`; Later does nothing.

### Manual Testing Steps
1. Profile → Institution → edit → relaunch → persisted.
2. Profile → Subjects → add/edit/remove + change confidence → Library/Account reflect it.
3. Profile → Schedule & exams → change windows/target, add/remove exam → Account "hrs/day" reflects it.
4. After (2)/(3): accept rebuild → fresh week, today's done block reset, streak intact. Decline → plan untouched.
5. Force a Gemini failure (AI off) on rebuild → old plan intact + error flash.

## Architecture Checklist
- [ ] `App.init(context)` called at top of every `build()`
- [ ] UI layer (`_state.dart`) does not call Firebase or HTTP directly
- [ ] Cubits do not import from `lib/ui/`
- [ ] State accessed via `XCubit.c(context)` / `_ScreenState.s(context)` — not `context.read<X>()`
- [ ] Firebase/HTTP exceptions converted to typed `Fault` subtypes before emitting cubit state
- [ ] Repo methods take/return `Map`/primitives (ADR-013); Map→Companion lives in `AppDatabase`
- [ ] Per-user scoping (ADR-014) on every subject/exam/schedule read+write
- [ ] All boilerplate generated via `hygen` — no hand-created screen files
- [ ] Dialogs/sheets pass `RouteSettings(name:)` (rule 14); `.map()` not `for` in widget trees (rule 11); `Space.*` tokens (rule 8/13)
- [ ] `*_mocks.dart` / `*_parser.dart` and existing method surfaces kept (rule 12)

## References
- Already-committed wiring: `lib/ui/screens/profile/widgets/_settings.dart` (`_AccountSection`)
- Plan generation: `lib/blocs/plan/cubit.dart:38` (`generate`), `lib/core/db/database.dart:421` (`replaceStudyBlocks`)
- Onboarding persistence (pattern, not reused): `lib/core/db/database.dart:127` (`saveOnboardingData`), `lib/ui/screens/onboarding/_state.dart` (`buildData`/`finish`)
- DAOs: `lib/core/db/daos/subject_dao.dart`, `schedule_dao.dart`, `onboarding_dao.dart`
- User provider: `lib/repos/user/user_data_provider.dart`
- Study windows: `lib/core/constants/study_windows.dart`
- Conventions: `docs/conventions/*.md`, `docs/architecture/DECISIONS.md` (ADR-013/014), `docs/feat-checklist/study-plan-generation.md` (regeneration gaps)
