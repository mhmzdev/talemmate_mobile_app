# Feature Checklist — Onboarding Session Lifecycle

> A living test-plan + edge-case list for the new-user session flow (register →
> onboarding → home, plus gate, login routing, and sign-out). Re-run the
> relevant rows before merging any change that touches `splash`, `login`,
> `create_account`, `onboarding`, `UserCubit`, the user repo, or routing — so we
> don't regress an existing path.
>
> Status legend: ✅ verified on emulator (Dart MCP) · 🔒 guard / invariant to
> keep · 🚧 by-design gap (not implemented yet).
>
> Related: [exec-plan](../exec-plans/active/onboarding-session-lifecycle.md),
> [FLOWS](../screens/FLOWS.md).

## How to run

1. `firebase emulators:start` (Auth :9099, Firestore :8080, UI :4000).
2. `flutter run --flavor stage` (driver: `test_driver/app.dart`). Ensure
   `useFirebaseEmulators = true` in `lib/main.dart` for local emulator runs.
3. Inspect writes at `localhost:4000`, or via the emulator REST APIs.

---

## 1. Registration & auth (Phase 1)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 1.1 | Register a fresh email | Auth user created (9099) + `users/{uid}` doc with `{uid, fullName, email, isOnboardingComplete:false}` (4000); routes to onboarding | ✅ |
| 1.2 | Login with wrong password | Typed `FirebaseAuthFault` → `UIFlash.error` "Incorrect email or password."; stays on login | ✅ |
| 1.3 | Register an email already in use | `email-already-in-use` fault surfaced via flash; no navigation | 🔒 (fault ladder) |
| 1.4 | Register/login success | `UserState.user` (SDK `User`) **and** `userData` (`UserData`) both populated | ✅ |

## 2. Launch gate (Phase 2 — cold start / relaunch)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 2.1 | Signed-out cold start | → `/login` | ✅ |
| 2.2 | Signed-in + `isOnboardingComplete:true` | → `/home` | ✅ |
| 2.3 | Signed-in + `isOnboardingComplete:false` | → `/onboarding` (resume) | ✅ |
| 2.4 | Authed but no `users/{uid}` doc | cubit signs out → `/login` | ✅ |
| 2.5 | Relaunch with a warm session | resumes the correct route (no false logout) | ✅ |
| 2.6 | `init()` first auth event is a transient `null` before restore | resolved via `authChanges().first ?? currentUser`; does not wrongly route to login | 🔒 |
| 2.7 | `init` failure (profile fetch fault) | → `/login` (fail-safe) | 🔒 |

## 3. Login routing (Phase 2)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 3.1 | Login as complete user | → `/home` | 🔒 (same decision as 2.2) |
| 3.2 | Login as incomplete user | → `/onboarding` | 🔒 (same decision as 2.3) |

## 4. Onboarding back-out (Phase 3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 4.1 | Step > 0, header back arrow | animates to previous page, **no** alert | ✅ |
| 4.2 | Step > 0, Android system back | previous page, no alert | 🔒 |
| 4.3 | Step 0, header back arrow | centered sign-out alert (badge, serif title, Cancel \| Sign out) | ✅ |
| 4.4 | Step 0, Android system back | same sign-out alert (not a route pop) | 🔒 (PopScope `canPop:false`) |
| 4.5 | Alert → Cancel | dismisses, stays on onboarding | ✅ |
| 4.6 | Alert → Sign out | `logout()` + `reset()` → `/login` | ✅ |
| 4.7 | Sign out from a deep stack (register → onboarding) | stack wiped to a **single** `/login` (no duplicate) | ✅ (`pushAndClear`) |

## 5. Completion (Phase 3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 5.1 | "Finish setup" (step 4) | `completeOnboarding` writes `isOnboardingComplete:true` (+ `institution` if set) → loader → `/home` | ✅ |
| 5.2 | "Skip for now" (step 4) | same as Finish (both route through `finish()`) | ✅ |
| 5.3 | Relaunch after completion | → `/home` | ✅ |
| 5.4 | `finish()` throws mid-completion | caught + logged; user is not stranded | 🔒 (try/catch) |

## 6. Local persistence — Drift DB (onboarding-local-persistence plan)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 6.1 | Finish onboarding | `onboarding_data` row written under the real uid (`step`, `institution`) | ✅ |
| 6.2 | Finish with subjects | one `subjects` row per subject (`code`/`name`/`colorHex`/`confidenceLevel`/`order`) | ✅ |
| 6.3 | Finish with a schedule | one `schedules` row (uid, `dailyTargetHours`, `enabledWindowIds`) | ✅ |
| 6.4 | Finish with exams | one `exams` row per exam (`subjectId`/`date`/`label`); `exams.subjectId` **must equal** the persisted `subjects.id` (FK) | ✅ (e2e: Midterm row, subject_id matches CS-200; this case caught the FK bug below) |
| 6.5 | Finish with materials | one `library_items` row per picked file (`kind`/`fileSize`/local path in `metadata`) | ✅ (2 PDFs persisted) |
| 6.6 | Write is transactional | a DAO error surfaces a `Fault` → error flash, no navigation to home (reaching home ⇒ commit) | ✅ |
| 6.7 | Single DB connection | repos use `AppDatabase.ins`; the `app.dart` provider hands out the same instance | ✅ |

## 7. Step 4 file picker — local refs (G5)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 7.1 | "Files" / drop-zone | opens the native document picker; selected files appear in "Added so far" as `LibraryItem`s | ✅ |
| 7.2 | File badge + size | `kind` derived from extension (PDF/IMG/…); human size (KB/MB) shown | ✅ |
| 7.3 | Remove a file (×) | drops it from the list | 🔒 |
| 7.4 | "Photos" / "Camera" | `image_picker` gallery / camera → `LibraryItem`s | 🔒 (needs a native rebuild for the new Info.plist usage strings; camera n/a on sim) |
| 7.5 | Empty state | "Nothing yet…" shown when no materials (no hardcoded fake files) | ✅ |

## 8. Validation gates (G8)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 8.1 | Step 1 with name + institution | Continue enabled | ✅ |
| 8.2 | Step 1 with name cleared | Continue disabled | ✅ |
| 8.3 | Step 2 with no subjects | Continue disabled (pre-existing) | ✅ |
| 8.4 | Step 3 with no window selected | Continue disabled | ✅ |
| 8.5 | Step 3 after selecting a window | Continue enabled | ✅ |
| 8.6 | Debug prefill | seeded name/institution make Step 1 valid from first frame (controllers seeded in `_ScreenState` ctor) | ✅ |

---

## Invariants / regression guards 🔒

- **Sign-out clears the stack** — session-boundary navigation uses
  `AppRoutes.x.pushAndClear`, never `pushReplace` (else a stale `/login` lingers
  beneath and you get two).
- **`OnboardingData` round-trips** — `build.yaml` `explicit_to_json: true` must
  stay; without it `complete()`'s `toJson()`/`fromJson()` crashes on nested
  `schedule`/`subjects`/`exams` and the loader hangs.
- **Dialogs pass `routeName`** — `showAppAlert` sets `RouteSettings` so the
  sign-out dialog shows as `/alert/...` (not `unknown`) in nav logs.
- **`finish()` is wrapped in try/catch** — completion is fire-and-forget for the
  user-flag write; a throw must not leave the user stuck on step 4.
- **Repo purity** — user repo returns `Map`/SDK-`User`; the cubit does
  `UserData.fromJson`. Mock/parser files and the `forgot/update/fetch/
  deleteAccount` method surface are kept (mocked) — do not delete.

## Invariants — local persistence 🔒

- **Repo stays model-free (ADR-013)** — `OnboardingRepo.complete(Map)` passes the
  raw Map to `AppDatabase.saveOnboardingData(Map)`. The model↔table mapping
  (`OnboardingData.fromJson` + Drift `Companion`s) lives in the **DB layer**
  (`lib/core/db/database.dart`), which may import models; `lib/repos/` must not.
  Enforced by `.claude/hooks/repo-purity-check.sh`.
- **UI never touches a DAO** — persistence is cubit → repo → `AppDatabase`/DAO.
- **`explicit_to_json` still required** — `complete()` round-trips
  `OnboardingData` JSON; nested `schedule`/`subjects`/`exams`/`uploadedMaterials`
  must serialize as maps (see the `build.yaml` invariant above).
- **One DB connection** — `AppDatabase.ins` is the single shared instance for
  both the repo and the `app.dart` provider.
- **Subject id is stable across references (FK)** — `_SubjectDraft.toSubject()`
  must persist with the draft's own `id`, because `_ExamDraft.subjectId` is set
  to that same `subject.id` and `Exams.subjectId` is a foreign key to
  `Subjects.id` (with `PRAGMA foreign_keys = ON`). Minting a fresh id in
  `toSubject()` makes the exam reference a non-existent subject → the whole save
  transaction aborts and the user sees "Failed to save your setup" (regression
  found e2e on 2026-06-13; only manifests when an exam is added).

## By-design gaps 🚧 (not implemented — don't treat as bugs)

- Onboarding payload persists to the **local Drift DB only** — Firestore sync of
  the payload is deferred (the `users/{uid}.isOnboardingComplete` flag is the
  only cloud write).
- Step 4 file upload stores **local references only** (no Firebase Storage);
  `ProcessingStatus` is mocked.
- `forgot` / `update` / `fetch` / `deleteAccount` are mocked placeholders with
  no UI yet.
