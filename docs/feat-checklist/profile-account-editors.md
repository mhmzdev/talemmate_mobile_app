# Feature Checklist — Profile → Account Editors (v1)

> A living test-plan + edge-case list for the three editor-backed rows in
> **Profile → Account**: **Institution** edit (Firestore + local Drift), the
> standalone **Subjects & confidence** editor, and the **Schedule & exams**
> editor — plus the shared **offer-to-regenerate** flow that fires after a
> plan-affecting save. Re-run the relevant rows before merging any change that
> touches `lib/ui/screens/subjects_editor/`, `lib/ui/screens/schedule_editor/`,
> `lib/ui/screens/profile/widgets/_settings.dart` /
> `_institution_sheet.dart`, `lib/ui/widgets/design/plan/regenerate.dart`,
> `lib/blocs/library/` (`commitSubjects`), `lib/blocs/plan/` (`commitSchedule`),
> `lib/blocs/user/` (`updateProfile`), the `AppDatabase` editor wrappers
> (`upsertSubject` / `deleteSubjectCascade` / `upsertExam` / `deleteExam` /
> `updateSchedule` / `updateInstitution`), or the `UserRepo.update` provider.
>
> Status legend: ✅ verified on simulator (Dart MCP) · 🔒 guard / invariant to
> keep · 🚧 by-design gap (not implemented yet) · ⏳ not driver-tested (inferred
> from a shared code path / unit + widget coverage) · 📝 observation.
>
> Related: [exec-plan](../exec-plans/active/profile-account-editors.md),
> [study-plan-generation checklist](study-plan-generation.md),
> [onboarding-flow checklist](onboarding-flow.md),
> [ADR-013 / ADR-014](../architecture/DECISIONS.md).

## How to run

1. `flutter run --flavor stage -t test_driver/app.dart`; `connect_dart_tooling_daemon`
   with the DTD URI. Sign in to an onboarded account (≥1 subject, a schedule).
2. Open **Profile** (avatar, top-right) → **Account** section.

> Driver-verified 2026-06-20 on the stage flavor (account `hamza.verify6@cui.edu.pk`,
> 4 subjects: Calculus *Shaky* / Applied Physics *Getting there* / Circuit
> Analysis & Intro to Programming *Confident*; windows After Fajr + After Isha,
> 3.5 h/day; exams Circuit Analysis 5 Jul, Applied Physics 18 Jul).

## Institution edit

- [x] ✅ Tapping **Institution** opens a bottom sheet seeded with the current value (`/modal/edit-institution`).
- [x] ✅ Save shows a disabled **Saving…** button while the write is in flight (no double-submit).
- [x] 🔒 The sheet **owns** its success/failure `BlocConsumer` (not a Profile-level listener) — a slow / offline-queued write that only succeeds **after** the sheet is dismissed must NOT pop an unrelated route. (Regression found + fixed during verification: a Profile-hosted listener bounced Profile→Home when a delayed Firestore write ack'd.)
- [x] ✅ On success the **sheet** closes (not an unrelated route) + flashes "Institution updated"; the Account row reflects the value. Verified the post-fix flow: Save → sheet closed → Profile stayed put (no Profile→Home bounce).
- [ ] ⏳ Firestore failure → error flash, sheet stays open (covered by `UserCubit.updateProfile` Fault unit test; not driver-forced).
- [x] 🔒 Value mirrors into local Drift `onboarding_data.institution` via a **targeted UPDATE** (`OnboardingDao.updateInstitution`), never an upsert (avoids inserting a row with a null `step`).
- [x] ✅ Persists to `users/{uid}` (`set(merge:true)` then `fetchProfile`) — the write ack'd (success → sheet close) even under a slow connection. 📝 No client-side timeout on the write: a genuinely offline write stays **Saving…** until it acks; the sheet-owned listener means dismissing meanwhile is safe.

## Subjects & confidence editor

- [x] ✅ Opens a standalone screen pre-filled from `LibraryCubit.state.subjects` (name + code fields, confidence slider + live label, colour picker, remove).
- [x] ✅ **Add a subject** sheet (`/modal/add-subject`) renders (code/name, tag colour, starting confidence) and appends a row locally.
- [x] ✅ Confidence label thresholds mirror onboarding: Shaky `<0.35` · Getting there `<0.7` · Confident `≥0.7`.
- [x] ⏳ On **Rebuild**, the diff is committed via a single `LibraryCubit.commitSubjects(upserts, removeIds)` — removes (cascade) then upserts (uid-scoped), one reload (widget + cubit tests; live cascade not run to avoid destroying real data).
- [x] 🔒 **Subject removal cascades** (`AppDatabase.deleteSubjectCascade`): deletes the subject + its study blocks, topics, exams, quizzes (+questions/attempts/feedback), tutor conversations (+messages) and progress metrics in one FK-safe transaction; **uploaded materials survive** (their `subjectId` is nulled). In-memory DB test asserts this.
- [x] 🔒 Edits never touch Firebase/Drift from `_state.dart` — the editor holds drafts locally and only commits via the cubit on Rebuild (the alert action), never imperatively in `_state.dart`.
- [x] ✅ `App.init(context)` at the top of every `build()`; state via `XCubit.c` / `_ScreenState.s`; no `context.read`.

## Schedule & exams editor

- [x] ✅ Opens pre-filled from `PlanCubit.state.schedule` (windows + daily target) and `PlanCubit.exams`; exam rows resolve their subject name/colour from `LibraryCubit` subjects.
- [x] ✅ Study-window multi-select from `kStudyWindowCatalog`; daily-target slider (0.5–6, 11 divisions); exam list with add (`/modal/add-exam`: subject picker + type + date) and remove.
- [x] ✅ **At least one window stays required** — saving with zero windows is blocked with a flash (mirrors onboarding Step-3 gate). Widget test asserts no `updateSchedule` call.
- [x] ✅ On **Rebuild** the commit is a single `PlanCubit.commitSchedule(target, windows, upsertExams, removeExamIds)`; cached `schedule`/`_exams` refresh in-memory (Account "hrs/day" + `nextExam` update without a full reset).
- [x] 🔒 Exam `subjectId` references an existing subject (picker only offers loaded subjects → FK invariant held).

## Apply-on-rebuild flow (shared)

> The editors hold edits **locally** and only persist them when the user commits
> to a rebuild — there is no "save without rebuild" half-state. The plan inputs
> (windows/target/exams/subjects) and the generated week therefore never drift
> apart.

- [x] ✅ **Save changes** always shows the `showAppAlert` (`/alert/regenerate-plan`) — no `changedPlanInputs` gate; validation (≥1 window / non-empty names) runs first, blocking the alert with a flash on failure.
- [x] ✅ **Later** → editor pops **quietly**, edits **discarded** (no DB write, no Gemini call, plan + windows unchanged). Driver-verified: toggle a window → Save → Later → reopen → the window is back to its persisted value.
- [x] ✅ **Rebuild** → persists the edits (`commitSubjects` / `commitSchedule`), then `PlanCubit.generate(uid)` runs behind `PlanRebuildLoader`; on success the editor pops + "Your week has been rebuilt" flash. Widget tests assert the write happens **only** on Rebuild and `generate(uid)` is called; the live Gemini rebuild itself isn't run (avoids resetting the real plan + a billed call).
- [x] 🔒 A commit failure (Drift fault) flashes the error and skips `generate` — the editor stays open to retry.
- [x] 🔒 The only success flash is "Your week has been rebuilt" (after an actual rebuild). Closing the editor — Later or a cosmetic-only edit — never flashes "saved".
- [x] 🔒 The old plan only changes on a successful Gemini parse (`replaceStudyBlocks` runs after parse) — a generation failure leaves the existing week intact + error flash.

## Architecture / invariants

- [x] 🔒 Repo methods take/return `Map`/primitives (ADR-013); Map→Companion lives in `AppDatabase` (`upsertSubject`/`upsertExam`/`updateSchedule` read the `userId` key the uid-less models don't carry).
- [x] 🔒 Per-user scoping (ADR-014) on every subject/exam/schedule write (uid threaded from the owning cubit).
- [x] 🔒 All screen scaffolding generated via `hygen screen new` / `_widget`; cubits/repos hand-extended (the `cubit update` generator's 6-file injection doesn't fit the existing hand-written repos).
- [x] 🔒 Dialogs/sheets carry `RouteSettings(name:)` (rule 14); `.map()` not `for` in widget trees (rule 11); `Space.*` tokens (rule 8/13).
- [x] 🔒 `*_mocks.dart` / `*_parser.dart` and existing method surfaces kept (rule 12).

## Automated coverage

- `test/blocs/user/user_cubit_test.dart` — `updateProfile` success/refresh, Fault, no-uid no-op.
- `test/blocs/library/library_cubit_test.dart` — `commitSubjects` batch (remove→upsert→reload), Fault, no-uid no-op.
- `test/blocs/plan/plan_cubit_test.dart` — `commitSchedule` persists windows/target/exam edits + refreshes caches; Fault keeps prior schedule.
- `test/core/db/profile_editors_db_test.dart` — `upsertSubject` (insert→update), exam upsert/delete, `updateSchedule` partial write, `deleteSubjectCascade` (subject+exam+block gone, material survives un-assigned) on a real in-memory SQLite (FK on).
- `test/screens/subjects_editor/subjects_editor_test.dart` — renders, add sheet, remove+save→prompt, Rebuild→generate(uid), Later→no rebuild.
- `test/screens/schedule_editor/schedule_editor_test.dart` — renders windows/target/exam, window toggle+save→prompt, window-required gate.
