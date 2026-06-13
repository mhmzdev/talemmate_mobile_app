---
title: "Onboarding Local Persistence (Drift DB + file picker + validation + loader)"
status: completed
created: 2026-06-03
completed: 2026-06-13
---

✅ COMPLETED — 2026-06-13 (verified e2e on emulators: new-account run persists the onboarding payload + materials to Drift, profile to Firestore)

# Onboarding Local Persistence — Implementation Plan

## Overview
Make onboarding actually **save** end-to-end into the **local Drift database** (`lib/core/db/`), wire a **real file picker** for Step 4 (local file references — no remote upload yet), and tighten the two related gaps: **Step 1/3 validation** and a **real stepwise loader**. Today the onboarding UI assembles a fully-typed `OnboardingData` and then throws it away — `OnboardingCubit.complete` is the mock echo, and the Drift DAOs (which already exist for every onboarding entity) are **never called from anywhere outside `lib/core/db/`**. This plan turns the assembled payload into persisted local rows and replaces the hardcoded Step-4 material list with picked files.

## Scope decisions (locked)
- **Persistence target:** Local Drift DB only. Firestore sync is **deferred** (the `users/{uid}` flag from the session-lifecycle work already gates relaunch; payload sync to Firestore is a later plan).
- **File picker:** Local references only — `file_picker`/`image_picker` → `LibraryItem` rows with name/size/kind/local-path metadata. **No Firebase Storage upload.**
- **Also in scope:** G8 (validation gates) + G7 (real loader progress).

## Current State Analysis
Companion research: `docs/research/2026-06-03-onboarding-feature-state-and-gaps.md` (gaps G1–G9) and `…-onboarding-session-lifecycle-and-alerts.md`. Session-lifecycle plan (✅ completed) delivered **G1/G2/G4/G6**.

Key facts (verified 2026-06-03):
- **Drift DB is fully modeled but dead-wired.** Tables + DAOs exist for `onboarding_data`, `subjects`, `topics`, `exams`, `schedules`, `study_windows`, `study_blocks`, `library_items` (`lib/core/db/tables/*`, `daos/*`). Each DAO has `upsert*` methods. **`grep` confirms no DAO is referenced anywhere outside `lib/core/db/`.**
- **`AppDatabase` has no singleton seam for repos.** It's created only as `Provider<AppDatabase>(create: (_) => AppDatabase())` in `lib/app.dart:37-40`. Repos are static singletons (`XRepo.ins`) with no access to it.
- **Onboarding completion is mocked.** `OnboardingCubit.complete(data)` → `OnboardingRepo.ins.complete(data.toJson())` → `_OnboardingMocks.complete` (echo + `step:4`) (`lib/repos/onboarding/onboarding_data_provider.dart`, `onboarding_mocks.dart`). `_OnboardingParser` is a no-op.
- **`buildData()` is correct & real.** `_ScreenState.buildData(userId)` (`_state.dart`) assembles `OnboardingData` (subjects via `_SubjectDraft.toSubject()`, exams via `_ExamDraft.toExam()`, `Schedule`, `uploadedMaterials: const []`). `finish()` now uses the real uid (`userCubit.state.user?.uid`).
- **Step 4 is 100% mock.** `file_picker: 10.3.10` + `image_picker: 1.2.1` are in `pubspec.yaml` but **unused** in `lib/`. Source chips call `UIFlash.info('… coming soon')`; "Added so far" renders a hardcoded `files` list in `_state.dart`; `uploadedMaterials` is always empty.
- **Validation thin (G8).** Step 1 `FormBuilder` never `saveAndValidate()`; only Step 2 gates Continue (`subjects.isNotEmpty`). Step 1 & 3 ungated.
- **Loader cosmetic (G7).** `stepwise_loader` advances on a `Timer.periodic` then `Future.delayed → home`; reads no cubit/DB.
- **Model→table field map** (for the writer):
  - `OnboardingData{userId, step, institution}` → `OnboardingDataTable`.
  - `Subject{id, code, name, colorHex, confidence, order}` → `Subjects{…, confidenceLevel}` (note column rename `confidence`→`confidenceLevel`).
  - `Exam{id, subjectId, date, label}` → `Exams`.
  - `Schedule{id, userId, dailyTargetHours, enabledWindowIds}` → `Schedules` (`enabledWindowIds` via `StringListConverter`).
  - `LibraryItem{…}` → `LibraryItems`.

## Desired End State
- Finishing onboarding writes **real rows** to Drift: one `onboarding_data` row, N `subjects`, N `exams`, one `schedule`, and one `library_items` row per picked file — all keyed to the real `uid` — verifiable by re-reading via the DAOs (and by a debug dump).
- Step 4 lets the user pick documents/images; each becomes a `LibraryItem` shown in "Added so far" and persisted; removing one updates the list.
- Step 1 enforces required fields (name + institution) and Step 3 enforces at least the daily target / a window; Continue/Finish is gated.
- The stepwise loader reflects actual persistence completion (advance off real `complete` success, not a blind timer).
- On relaunch a completed user lands on home (already working); their onboarding rows are present locally for downstream features to read.

## What We're NOT Doing
- **No Firestore** write of the onboarding payload (deferred to a later "onboarding cloud sync" plan) and **no** `firestore.rules`/`storage.rules` changes.
- **No Firebase Storage** upload — picked files are referenced locally only (path + metadata); `ProcessingStatus` stays mocked (`indexed`/`processing`).
- **No** per-step `save()` wiring (the dormant cubit `save` stays dormant); we persist once on `complete`.
- **No** real AI indexing of materials.

## Implementation Approach
Introduce a single `AppDatabase` instance reachable by both the widget tree and the repo singletons (make `AppDatabase` a lazy singleton and have the `app.dart` provider hand out that instance, so there's exactly one connection). Keep the existing onboarding repo seam: `complete(Map)` stays the mock→real boundary, but now maps the JSON into Drift `Companion`s and upserts via the DAOs inside one transaction. Repo stays rule-6 (Map in / Map out; models only used internally). UI never touches a DAO. Build bottom-up: DB seam + persistence → file picker feeding the payload → validation + loader polish. Each phase compiles and is verifiable on a debug build.

---

## Phase 1: Local persistence (AppDatabase seam + onboarding writer)

### Overview
Give repos access to the one `AppDatabase`, then replace the mocked `complete` with a transactional Drift write of the assembled `OnboardingData`.

### Changes Required
1. **`AppDatabase` singleton** — `lib/core/db/database.dart`: add `static final AppDatabase ins = AppDatabase();` (or a guarded factory). **`lib/app.dart`**: change the provider to `Provider<AppDatabase>(create: (_) => AppDatabase.ins, dispose: …)` so the tree and repos share one connection.
2. **Onboarding repo → Drift** — `lib/repos/onboarding/onboarding_data_provider.dart`: `complete(Map values)` reconstructs `OnboardingData.fromJson(values)` internally, then in a `AppDatabase.ins.transaction(() async { … })` upserts: `onboardingDao.upsert(...)`, `subjectDao.upsertSubject(...)`/`upsertExam(...)` per item, `scheduleDao.upsertSchedule(...)`, `libraryDao.upsert(...)` per material. Returns the persisted map (`{...values,'step':4}`). Convert `DriftRemoteException`/`Exception`→ typed `Fault` (the catch ladder; likely `UnknownFault`/a new `DbFault` — decide). Keep `_OnboardingMocks` file (per repo-scaffold rule); `save` may stay mocked.
3. **Collection/table imports** — provider imports `package:taleemmate/core/db/database.dart`. Map `confidence`→`confidenceLevel`.
4. **Cubit** — `OnboardingCubit.complete` unchanged in shape (still `toJson()` → repo → `fromJson` → success); now it persists for real.

### Success Criteria
**Automated:** `flutter analyze` clean; `build_runner` clean (no schema change unless a column is added).
**Manual (debug build + Dart MCP):** Complete onboarding with ≥1 subject, ≥1 exam, a schedule, → inspect the Drift DB (debug dump / a temporary read) shows the `onboarding_data`, `subjects`, `exams`, `schedules` rows under the real uid. Relaunch → still on home; rows persist.

> Pause for manual confirmation before Phase 2.

---

## Phase 2: Step 4 file picker (local refs)

### Overview
Replace the mock material step with real picking that feeds `uploadedMaterials`, persisted by Phase 1.

### Changes Required
1. **`_state.dart`** — remove the hardcoded `files` list; hold `List<LibraryItem> uploadedMaterials` (or a `_MaterialDraft`). Add `addFiles()` (via `file_picker` — documents) and `addImages()` (via `image_picker`/camera) that build `LibraryItem`s (`id` uuid, `userId`, `name`, `kind`, `fileSize`, `uploadedAt`, `processingStatus: .indexed` mocked, local path in `metadata`). Add `removeMaterial(id)`. `buildData()` passes the real list.
2. **`pages/_4_material.dart` + `widgets/_file_item.dart`** — wire the drop-zone/Files/Photos/Camera chips to the new methods (replace the `UIFlash.info('coming soon')`); render the live list with remove; iterate with `.map()` (no `for`).
3. **Permissions** — confirm iOS `Info.plist` / Android manifest entries for photo/file access (add if missing).

### Success Criteria
**Automated:** analyze clean.
**Manual:** Pick a document + an image → both appear in "Added so far"; remove works; Finish → the `library_items` rows are persisted (Phase 1) under the uid with the right `kind`/size.

> Pause for manual confirmation before Phase 3.

---

## Phase 3: Validation (G8) + real loader (G7)

### Changes Required
1. **Step 1 validation** — `pages/_1_about_you.dart`: enforce name + institution (FormBuilder `saveAndValidate()` or explicit checks); gate the step-0 Continue.
2. **Step 3 gating** — require a sensible minimum (daily target set / ≥1 window) before Continue.
3. **Continue/Finish gating** — disable/early-return until the current step is valid (mirror Step 2's `subjects.isNotEmpty` pattern).
4. **Loader (G7)** — `stepwise_loader`: drive the final hand-off off real `complete` success rather than a blind timer (keep the animation, but only navigate home once persistence succeeded; surface failure via flash instead of proceeding).

### Success Criteria
**Automated:** analyze clean.
**Manual:** Empty name/institution blocks Step 1; loader only proceeds to home after a successful write; a forced write failure shows an error and does not navigate.

---

## Testing Strategy
- **Unit** (`/write_unit_test`): onboarding repo `complete` maps `OnboardingData.toJson()` → correct DAO upserts (use an in-memory `AppDatabase(NativeDatabase.memory())`); fault path on a DB error. Cubit `complete` success/failure transitions.
- **Widget** (`/write_widget_test`): Step 4 picker adds/removes a `LibraryItem`; Step 1 validation blocks Continue when empty.
- **Manual**: emulators not required (local DB). Drive via Dart MCP; verify rows by a temporary DAO read or debug dump.

## Architecture Checklist
- [ ] UI never calls a DAO — persistence goes cubit → repo → DAO.
- [ ] Repo public methods stay Map/primitive (rule 6); models only used internally.
- [ ] One `AppDatabase` connection (singleton shared with the provider).
- [ ] DB writes wrapped in a transaction; errors → typed `Fault`.
- [ ] `.map()`/`.expand()` for the materials list (no `for`).
- [ ] Spacing/typography tokens; `App.init(context)` in any new `build()`.
- [ ] Mock/parser files retained.
- [ ] Update `docs/feat-checklist/onboarding-flow.md` (flip G3/G5/G7/G8 rows to ✅).

## References
- Research: the two `docs/research/2026-06-03-onboarding-*` docs.
- Completed predecessor: `docs/exec-plans/completed/onboarding-session-lifecycle.md`.
- DB: `lib/core/db/database.dart`, `daos/onboarding_dao.dart`, `subject_dao.dart`, `schedule_dao.dart`, `library_dao.dart`.
- Seam: `lib/repos/onboarding/onboarding_data_provider.dart`; assembly: `lib/ui/screens/onboarding/_state.dart`.
