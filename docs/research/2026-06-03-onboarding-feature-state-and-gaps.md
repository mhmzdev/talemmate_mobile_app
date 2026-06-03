# Onboarding Feature — Current State & Gaps to Completion

> **Date:** 2026-06-03
> **Scope:** `lib/ui/screens/onboarding/`, `lib/blocs/onboarding/`, `lib/repos/onboarding/`, `lib/core/models/onboarding/` and the surrounding entry/exit flow.
> **Goal of this doc:** Establish exactly what is built vs. mocked vs. missing so the feature can be completed against the **local Firebase emulators** first (`useFirebaseEmulators = true` in `lib/main.dart:15`), then verified live.

---

## 1. TL;DR

The onboarding **UI is essentially complete** — all 4 steps render, collect input into a single `_ScreenState`, and assemble a fully-typed `OnboardingData` model. The **entire backend is mocked**: the onboarding repo never touches Firestore, the post-onboarding loader is purely cosmetic, and — critically — **even account creation / auth is mocked**, so there is no real authenticated `uid` to write under. There is also **no auth gate** on app launch (splash always routes to login).

To finish on emulators, the missing work is concentrated in three places: (a) real **Firebase Auth** register/login so a real `uid` exists, (b) a real **Firestore** write in the onboarding data provider, (c) **real file upload** (Step 4) to Firebase Storage — or an explicit decision to keep it mocked for v1.

---

## 2. Architecture Map

| Layer | Location | Status |
|---|---|---|
| Screen root + PageView shell | `lib/ui/screens/onboarding/onboarding.dart` | ✅ Done |
| Ephemeral state | `lib/ui/screens/onboarding/_state.dart` (`_ScreenState`) | ✅ Done (Step 4 files hardcoded) |
| 4 step pages | `lib/ui/screens/onboarding/pages/_1..4_*.dart` | ✅ UI done; ⚠️ validation gaps |
| 20 private widgets | `lib/ui/screens/onboarding/widgets/` | ✅ Done |
| Drafts | `models/_subject_draft.dart`, `models/_exam_draft.dart` | ✅ Done |
| Static data | `static/_data.dart`, `_form_data.dart`, `_form_keys.dart` | ✅ Done (hardcoded lists) |
| Completion listener | `listeners/_complete.dart` | ✅ Done |
| Cubit + State | `lib/blocs/onboarding/cubit.dart`, `state.dart` | ✅ Done (`save`, `complete`) |
| Repo | `lib/repos/onboarding/*` | ❌ **Fully mocked** |
| Domain model | `lib/core/models/onboarding/onboarding_data.dart` | ✅ Done |
| Sub-models | `subject.dart`, `exam.dart`, `schedule.dart`, `library_item.dart` | ✅ Done (freezed + json) |
| Cubit registration | `lib/app.dart:30` | ✅ Registered |

The screen uses the part-file pattern: `onboarding.dart` is the library; `_state.dart`, pages, widgets, drafts, static data and the listener are all `part of 'onboarding.dart'`.

---

## 3. What the UI Collects (per step)

Single `PageView` with `NeverScrollableScrollPhysics` (`onboarding.dart:110-119`); all state lives in `_ScreenState`.

### Step 1 — About You (`pages/_1_about_you.dart`)
- **Name** → `nameCtrl`; **Institution** → `institutionCtrl` (form keys `name`, `institution`).
- **Institution chips** (6 hardcoded: NUST/FAST/LUMS/COMSATS/UET/PIEAS) → `selectedInstitutionChip`.
- **Education level** (`EducationLevel` enum, default `.undergraduate`) → `educationLevel`.
- **Year** chips `Y1..Y4` (shown only when `educationLevel.hasYear`), default `'Y3'` → `year`.
- **Goal** (`OnboardingGoal` enum, default `.passExams`) → `goal`.
- Debug-only prefill `{name: 'Muhammad Hamza', institution: 'NUST'}` via `_FormData.initialValues()`.

### Step 2 — Subjects (`pages/_2_subjects.dart`)
- Subjects added via `_AddSubjectModal` → `List<_SubjectDraft> subjects`.
- Each draft: code, name, color hex (7 swatches), confidence slider (0–1).
- Suggestions hardcoded; only `NUST + Y3` returns a tailored set, else a generic fallback.

### Step 3 — Schedule (`pages/_3_schedule.dart`)
- **Study windows** — 5 hardcoded windows toggled into `Set<String> enabledWindowIds`.
- **Daily target hours** slider (0.5–6.0) → `dailyTargetHours` (default 3.5).
- **Exams** via `_AddExamModal` → `List<_ExamDraft> exams` (subject + type + date).

### Step 4 — Material (`pages/_4_material.dart`) — ⚠️ 100% mock
- The drop-zone and all source chips (Files / Photos / Camera) call `UIFlash.info('File upload coming soon')`.
- **No `file_picker` / `image_picker` imported** here (both ARE in `pubspec.yaml:92,94` but unused).
- The "Added so far" list renders a **hardcoded `files` list** in `_state.dart:28-53` — never mutated.
- `buildData()` passes `uploadedMaterials: const []` (`_state.dart:158`) — the mock files are never serialized.

---

## 4. Data Assembly & Models

`_ScreenState.buildData(userId)` (`_state.dart:142-159`) produces a complete `OnboardingData`:
- `step: 4`, name/institution trimmed, level/year/goal.
- `subjects`: `_SubjectDraft.toSubject()` — new uuid, code, name, colorHex, confidence, `order: 0`.
- `exams`: `_ExamDraft.toExam()` — new uuid, subjectId, date, `label: type.name.titleCase`.
- `schedule`: new `Schedule` with fresh uuid, userId, dailyTargetHours, enabledWindowIds.
- `uploadedMaterials: const []`.

`userId` comes from `UserCubit.c(context).state.init.data?.uid ?? ''` (`_state.dart:162`).
**⚠️ `UserCubit.init()` is mocked and returns `{}` → `uid` is empty.** After register the uid lives in `state.register.data`, not `state.init.data` — so `buildData` currently gets `''`. (See Gap G4.)

All models are freezed with `fromJson`/`toJson`: `OnboardingData`, `Subject`, `Exam`, `Schedule`, `LibraryItem` (the last has `ItemKind` + `ProcessingStatus` enums, ready for real uploads).

---

## 5. Cubit & State (`lib/blocs/onboarding/`)

`OnboardingState` holds two `BlocState<OnboardingData>`: `save` and `complete`. Cubit exposes:
- `save(data)` → `OnboardingRepo.ins.save(data.toJson())` (step-wise persistence — **not currently called from the UI**).
- `complete(data)` → `OnboardingRepo.ins.complete(data.toJson())` — called by `finish()`.
- `reset()`.

`_CompleteListener` (`listeners/_complete.dart`): on `complete.isSuccess` → `AppRoutes.stepwiseLoader.pushReplace`; on failure → `UIFlash.error`; shows `FullScreenLoader` while loading. Registered in `app.dart:30`.

> Note: `save` is fully wired through cubit→repo→mock but no page calls it. Per-step persistence is plumbed but dormant.

---

## 6. Repo Layer — fully mocked

`lib/repos/onboarding/` follows the 4-part repo pattern (`repo` / `data_provider` / `mocks` / `parser`):
- `onboarding_data_provider.dart` `save`/`complete` both delegate to `_OnboardingMocks` inside the standard try/catch (`Fault` rethrow, `DioException`→`HttpFault`, else `UnknownFault`).
- `_OnboardingMocks.save` waits 0.3s and echoes input; `.complete` waits 0.6s and returns `{...values, 'step': 4}`.
- `_OnboardingParser` is a no-op passthrough.
- **No `FirebaseFirestore`, no `collection()`, no Storage anywhere in the repo.**

This is the primary backend gap. The provider is the single seam to swap mock→Firestore.

---

## 7. Surrounding Flow

**Entry:** `create_account` register success → `AppRoutes.onboarding.pushReplace` (`create_account/listeners/_register.dart:15`).

**Exit:** onboarding `complete` success → `stepwiseLoader`. That screen (`lib/ui/screens/stepwise_loader/`) is **purely cosmetic** — a `Timer.periodic` animates 4 hardcoded labels, then `Future.delayed` → `AppRoutes.home.pushReplace`. It reads **no** Firestore and calls **no** cubit.

**App launch / gating:** `app.dart` `initialRoute: splash`. `SplashScreen` waits 1.5s then **unconditionally** `AppRoutes.login.pushReplace` — **no FirebaseAuth state check, no `isOnboardingComplete` check, no auth wrapper anywhere** (`splash.dart:38`).

---

## 8. Firebase Reality Check

- **No real Firestore/Storage/Auth calls exist anywhere in `lib/`** (grep for `FirebaseFirestore.instance` / `.collection(` / `FirebaseStorage` / `FirebaseAuth` in repos/blocs returns nothing but fault-mapping helpers).
- `UserRepo` is **also fully mocked** — `register` returns a fake `uid: 'mock-user-002'`; `login` only accepts `test@taleemmate.com / test1234`. No `createUserWithEmailAndPassword`.
- `lib/services/firebase/collections.dart` defines only `users`. No `onboarding` / `subjects` / `schedules` / `materials` collection constants.
- Emulator wiring **is** done (`main.dart:30-38`: Auth 9099, Firestore 8080, Storage 9199) and `firebase.json` matches.
- **Fault converters ready to use:** `FirebaseFault.fromFirebase(FirebaseException, st)` (`faults.dart:160`) and `FirebaseAuthFault.fromFirebaseAuthException(...)` (`faults.dart:103`).

---

## 9. Gaps — What's Missing to Complete on Emulators

Ordered roughly by dependency.

| # | Gap | Where | Notes |
|---|---|---|---|
| **G1** | **Real Firebase Auth register/login** | `lib/repos/user/user_data_provider.dart` | Swap `_UserMocks` for `FirebaseAuth.instance.createUserWithEmailAndPassword` / `signInWithEmailAndPassword`. Without a real `uid`, nothing can be written under the user. Convert errors via `FirebaseAuthFault.fromFirebaseAuthException`. |
| **G2** | **Persist + read the User doc in Firestore** | `user_data_provider`, `collections.dart` | Write `users/{uid}` with `isOnboardingComplete:false` on register; this flag is the natural gate signal. |
| **G3** | **Real Firestore write in onboarding provider** | `lib/repos/onboarding/onboarding_data_provider.dart` | Replace `_OnboardingMocks.complete/save` with a Firestore write of `OnboardingData.toJson()`. Decide schema: single `users/{uid}` merge vs. subcollections (`subjects`, `exams`, `schedule`, `materials`). Add collection constants. Flip `isOnboardingComplete:true` on complete. |
| **G4** | **`buildData` reads empty uid** | `_state.dart:162` | Pulls `state.init.data?.uid`, but the uid is in `state.register.data` after signup (and `init` is mocked to `{}`). Need a reliable current-uid source (e.g. `FirebaseAuth.instance.currentUser!.uid` once G1 lands, or fix which `BlocState` is read). |
| **G5** | **Step 4 file upload** | `pages/_4_material.dart`, `_state.dart` | Currently 100% mock. Either wire `file_picker`/`image_picker` → Firebase Storage → `LibraryItem` list → `uploadedMaterials`, **or** consciously defer for v1 and remove the hardcoded `files` list so it doesn't ship as fake data. **Decision needed.** |
| **G6** | **Auth + onboarding gate on launch** | `splash.dart` / new auth wrapper | Splash always → login. Need: if `FirebaseAuth.currentUser != null` → read `isOnboardingComplete` → route to `home` or `onboarding`; else `login`. |
| **G7** | **`stepwiseLoader` is cosmetic** | `lib/ui/screens/stepwise_loader/` | Decide if it should reflect real save/index progress or remain a timed animation for v1. Currently it advances on a fixed timer regardless of backend. |
| **G8** | **Validation gates are thin** | Step 1 & Step 3 | `FormBuilder` in Step 1 never calls `saveAndValidate()`; only Step 2 gates "Continue" (on `subjects.isNotEmpty`). Step 1 (name/institution) and Step 3 have no gating. Confirm desired required-fields before live. |
| **G9** | **Firestore security rules** | `firestore.rules`, `storage.rules` | Verify rules allow `users/{uid}` writes for the owner under the emulator before live test. |

---

## 10. Suggested Sequence (emulators-first)

1. **G1+G2** — real Auth + `users/{uid}` doc (unblocks a real uid).
2. **G4** — fix uid source in `buildData`.
3. **G3** — real Firestore write in onboarding provider (the core deliverable); test via emulator UI at `localhost:4000`.
4. **G6** — launch gate using `isOnboardingComplete`.
5. **G5 / G7** — decide scope for file upload and the loader (mock-acceptable for v1?).
6. **G8 / G9** — tighten validation + rules before live Firebase test.

---

## Key File Reference

- `lib/ui/screens/onboarding/onboarding.dart` — shell + PageView + header/progress
- `lib/ui/screens/onboarding/_state.dart` — all state, `buildData()`, `finish()`, hardcoded `files`
- `lib/ui/screens/onboarding/pages/_4_material.dart` — mock upload step
- `lib/blocs/onboarding/cubit.dart` — `save` / `complete`
- `lib/repos/onboarding/onboarding_data_provider.dart` — **the mock→Firestore seam**
- `lib/repos/user/user_data_provider.dart` — mocked auth (G1)
- `lib/services/firebase/collections.dart` — only `users` defined
- `lib/services/fault/faults.dart:103,160` — `FirebaseAuthFault` / `FirebaseFault` converters
- `lib/ui/screens/splash/splash.dart:38` — unconditional → login (no gate)
- `lib/ui/screens/stepwise_loader/` — cosmetic post-onboarding loader
- `lib/main.dart:15,30-38` — emulator flag + wiring
