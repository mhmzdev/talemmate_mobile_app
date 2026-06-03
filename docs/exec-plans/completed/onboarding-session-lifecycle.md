---
title: "Onboarding Session Lifecycle (real auth + gate + sign-out)"
status: completed
created: 2026-06-03
completed: 2026-06-03
---

✅ COMPLETED — all 3 phases implemented, committed to `main`, and verified on the Firebase emulators via Dart MCP. See [docs/feat-checklist/onboarding-flow.md](../../feat-checklist/onboarding-flow.md).

# Onboarding Session Lifecycle — Implementation Plan

## Overview
Make the new-user session real end-to-end against the **local Firebase emulators**: real Firebase Auth (register/login/session-restore/logout), a launch gate driven by the user's `isOnboardingComplete` flag, and a back-out flow that signs the user out via a new reusable centered alert. This turns the currently-mocked auth + ungated splash into a coherent session model where **a registered-but-not-onboarded user is authenticated with `isOnboardingComplete == false`**, and that single flag decides routing on every cold start.

## Current State Analysis
Both companion research docs are the basis for this plan:
- `docs/research/2026-06-03-onboarding-feature-state-and-gaps.md`
- `docs/research/2026-06-03-onboarding-session-lifecycle-and-alerts.md`

Key facts:
- **Auth is fully mocked.** `lib/repos/user/user_data_provider.dart` delegates to `_UserMocks`; register returns `{uid:'mock-user-002', isOnboardingComplete:false}` (`user_mocks.dart:6-16`), login only accepts `test@taleemmate.com/test1234` (`user_mocks.dart:22-38`). No `FirebaseAuth` calls anywhere.
- **`UserState.userData` / `UserState.user` exist but are never populated** (`lib/blocs/user/state.dart:16-17`); all data lives in action `BlocState`s. The cubit only drives one `BlocState` per method (`lib/blocs/user/cubit.dart`).
- **`UserData`** = `uid, fullName, email, institution?, @Default(false) isOnboardingComplete` (`lib/core/models/user/user.dart:7-22`).
- **Splash never gates** — `Future.delayed(1.5s)` → `AppRoutes.login.pushReplace` unconditionally (`lib/ui/screens/splash/splash.dart:35-42`).
- **Login listener always → home** (`lib/ui/screens/login/listeners/_login.dart:14-16`); register listener → onboarding (`lib/ui/screens/create_account/listeners/_register.dart:14-16`).
- **Onboarding does not intercept back.** Header step-0 back → `AppRoutes.createAccount.pushReplace` (`onboarding.dart:142-143`); Android system back pops the route (no `PopScope`, since onboarding isn't a bottom-bar route — `lib/ui/widgets/core/screen/screen.dart:98-104`).
- **`finish()` reads an empty uid** from `state.init.data?.uid` (`lib/ui/screens/onboarding/_state.dart:162`); both "Skip for now" (step 3) and Finish call `state.finish(context)` (`onboarding.dart:155`, `_4_material.dart`).
- **No centered dialog primitive exists** — only `AppModalBase` (bottom sheet) and inline `showModalBottomSheet`. `showDialog` is unused anywhere.
- **Reference pattern**: `app_flight` already does exactly this — `init()` listens to `authStateChanges()`, then `fetchProfile` → populates `user` + `userData` (`/Users/hamza/Development/Work/app_flight/lib/cubits/user/cubit.dart:131-228`, `data_provider.dart:59-133`).
- **Available tools**: `FirebaseAuthFault.fromFirebaseAuthException` (`lib/services/fault/faults.dart:103`), `FirebaseFault.fromFirebase` (`faults.dart:160`); `FireCollections.users` (`lib/services/firebase/collections.dart:2`); emulators wired + `useFirebaseEmulators = true` (`lib/main.dart:15,30-38`); `Screen(canPop:, onBackPressed:)` installs a `PopScope` (`screen.dart:106-116`).

Key files to change:
- `lib/repos/user/user_repo.dart` / `user_data_provider.dart` — mock → real Firebase
- `lib/blocs/user/cubit.dart` — populate `user`/`userData`, add session methods
- `lib/ui/screens/splash/splash.dart` — gate
- `lib/ui/screens/login/listeners/_login.dart` — route by flag
- `lib/ui/screens/onboarding/onboarding.dart` / `utils.dart` / `_state.dart` — back-out + completion
- `lib/ui/widgets/design/alerts/app_alert_base.dart` — NEW widget

## Desired End State
- **Register** → real auth account + `users/{uid}` doc (`isOnboardingComplete:false`) → onboarding.
- **Cold start** routes by session: signed-out → login; signed-in + complete → home; signed-in + incomplete → onboarding.
- **Login** routes by `isOnboardingComplete` (un-onboarded returning user resumes onboarding).
- **Back during onboarding**: step > 0 → previous page; step 0 (header arrow OR Android system back) → centered **sign-out confirmation**; confirming signs out (`signOut` + cubit `reset`) → login.
- **Finish or "Skip for now"** marks `isOnboardingComplete:true` on `users/{uid}` and proceeds to the stepwise loader → home; on next cold start the user lands on home.
- Verifiable in the Firestore emulator UI (`localhost:4000`) and by driving the app via Dart MCP.

## What We're NOT Doing
- **NOT** persisting the onboarding payload (subjects / exams / schedule) to Firestore (gap G3). `OnboardingCubit.complete` stays mocked; only the user's `isOnboardingComplete` flag (+ optional `institution`) is written.
- **NOT** implementing real file upload (gap G5). Step 4 material stays the hardcoded mock list.
- **NOT** changing the stepwise loader — it remains a cosmetic timed animation.
- **NOT** adding password reset / account deletion / profile update flows (the unused `forgot`/`update`/`fetch`/`deleteAccount` cubit+repo methods are removed since nothing calls them).

## Implementation Approach
Mirror the proven `app_flight` user-cubit pattern, adapted to TaleemMate's `BlocState<T>` + `UserState.userData/user` shape and its existing `Fault` converters. Keep the repo returning `Map`/SDK-`User` (rule 6) and let the cubit do `UserData.fromJson`. Build bottom-up: real auth foundation → splash/login routing that reads it → onboarding back-out + completion wiring (which also introduces the small `AppAlertBase` widget it consumes). Each phase compiles and is independently verifiable on the emulators.

---

## Phase 1: Real Firebase Auth (repo + cubit)

### Overview
Replace the mocked user repo with real `FirebaseAuth` + Firestore, and rewrite `UserCubit` to populate `user` (Firebase `User`) and `userData` (`UserData`) on register/login/session-restore.

### Changes Required

#### 1. User repo — public surface
**File**: `lib/repos/user/user_repo.dart`
**Changes**: Swap imports to `cloud_firestore` + `firebase_auth` + `FireCollections`; drop `dio` + `UserData` import; drop the `user_mocks`/`user_parser` parts. New method surface:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taleemmate/services/fault/faults.dart';
import 'package:taleemmate/services/firebase/collections.dart';

part 'user_data_provider.dart';

class UserRepo {
  static final UserRepo _instance = UserRepo._();
  UserRepo._();
  static UserRepo get ins => _instance;

  Stream<User?> authChanges() => _UserProvider.authChanges();
  Future<User> register(Map<String, dynamic> values) => _UserProvider.register(values);
  Future<User> login(Map<String, dynamic> values) => _UserProvider.login(values);
  Future<Map<String, dynamic>> fetchProfile(String uid) => _UserProvider.fetchProfile(uid);
  Future<void> completeOnboarding(String uid, [Map<String, dynamic>? extra]) =>
      _UserProvider.completeOnboarding(uid, extra);
  Future<void> logout() => _UserProvider.logout();
}
```

> Rule-6 note: returning the SDK `User` (not the `UserData` model) is allowed — the prohibition is on returning app model classes. The cubit does `UserData.fromJson(map)`.

#### 2. User data provider — real Firebase
**File**: `lib/repos/user/user_data_provider.dart`
**Changes**: Replace the whole `_UserProvider` with real implementations. Pattern per method: `on FirebaseAuthException → FirebaseAuthFault.fromFirebaseAuthException`, `on FirebaseException → FirebaseFault.fromFirebase`, else rethrow `Fault` / `UnknownFault`.

```dart
part of 'user_repo.dart';

class _UserProvider {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<User?> authChanges() => _auth.authStateChanges();

  static Future<User> register(Map<String, dynamic> values) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: values['email'] as String,
        password: values['password'] as String,
      );
      final user = cred.user!;
      await _firestore.collection(FireCollections.users).doc(user.uid).set({
        'uid': user.uid,
        'fullName': (values['fullName'] as String?)?.trim() ?? '',
        'email': values['email'] as String,
        'isOnboardingComplete': false,
      });
      return user;
    } on FirebaseAuthException catch (e, s) {
      throw FirebaseAuthFault.fromFirebaseAuthException(e, s);
    } on FirebaseException catch (e, s) {
      throw FirebaseFault.fromFirebase(e, s);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<User> login(Map<String, dynamic> values) async { /* signInWithEmailAndPassword → cred.user!, same catch ladder */ }

  static Future<Map<String, dynamic>> fetchProfile(String uid) async {
    try {
      final doc = await _firestore.collection(FireCollections.users).doc(uid).get();
      return doc.data() ?? <String, dynamic>{};
    } on FirebaseException catch (e, s) {
      throw FirebaseFault.fromFirebase(e, s);
    } catch (e, st) {
      if (e is Fault) rethrow;
      throw UnknownFault('Something went wrong!', st);
    }
  }

  static Future<void> completeOnboarding(String uid, Map<String, dynamic>? extra) async {
    // _firestore...doc(uid).set({'isOnboardingComplete': true, ...?extra}, SetOptions(merge: true));
    // FirebaseException → FirebaseFault; else UnknownFault
  }

  static Future<void> logout() async { /* await _auth.signOut(); FirebaseAuthException → FirebaseAuthFault */ }
}
```

#### 3. Delete unused mock/parser parts
**Files**: `lib/repos/user/user_mocks.dart`, `lib/repos/user/user_parser.dart` — `rm` (no longer referenced).

#### 4. UserCubit — populate session, add methods
**File**: `lib/blocs/user/cubit.dart`
**Changes**: Add `import 'package:firebase_auth/firebase_auth.dart';` and `dart:async`. Hold a `StreamSubscription<User?>? _authSub` (cancel in `close()`). Rewrite `register`/`login` to also set `user` + `userData`. Replace mock `init()` with an `authStateChanges` one-shot. Add `completeOnboarding`. Rewrite `logout`. Remove the unused `update`/`fetch`/`forgot`/`deleteAccount` methods. Keep `reset()`.

```dart
Future<void> init() async {
  emit(state.copyWith(init: state.init.toLoading()));
  _authSub?.cancel();
  _authSub = UserRepo.ins.authChanges().listen((user) {
    _resolveSession(user);
    _authSub?.cancel();
  });
}

Future<void> _resolveSession(User? user) async {
  if (isClosed) return;
  if (user == null) { emit(state.copyWith(init: state.init.toSuccess())); return; }
  try {
    final raw = await UserRepo.ins.fetchProfile(user.uid);
    if (isClosed) return;
    if (raw.isEmpty) { // authed but no profile doc → treat as logged out
      await UserRepo.ins.logout();
      if (isClosed) return;
      emit(state.copyWith(init: state.init.toSuccess()));
      return;
    }
    final data = UserData.fromJson(raw);
    emit(state.copyWith(user: user, userData: data, init: state.init.toSuccess(data: data)));
  } on Fault catch (e) {
    if (isClosed) return;
    emit(state.copyWith(init: state.init.toFailed(fault: e)));
  }
}

Future<void> register(Map<String, dynamic> values) async {
  emit(state.copyWith(register: state.register.toLoading()));
  try {
    final user = await UserRepo.ins.register(values);
    final data = UserData.fromJson(await UserRepo.ins.fetchProfile(user.uid));
    emit(state.copyWith(user: user, userData: data, register: state.register.toSuccess(data: data)));
  } on Fault catch (e) {
    emit(state.copyWith(register: state.register.toFailed(fault: e)));
  }
}
// login(): same shape, drives state.login.

Future<void> completeOnboarding([Map<String, dynamic>? extra]) async {
  final uid = state.user?.uid ?? state.userData?.uid;
  if (uid == null) return;
  try {
    await UserRepo.ins.completeOnboarding(uid, extra);
    final raw = await UserRepo.ins.fetchProfile(uid);
    if (isClosed || raw.isEmpty) return;
    emit(state.copyWith(userData: UserData.fromJson(raw)));
  } catch (e, st) {
    'completeOnboarding failed: $e\n$st'.appLog(level: AppLogLevel.error);
  }
}

Future<void> logout() async {
  emit(state.copyWith(logout: state.logout.toLoading()));
  try {
    await UserRepo.ins.logout();
    await _authSub?.cancel();
    emit(state.copyWith(logout: state.logout.toSuccess()));
  } on Fault catch (e) {
    emit(state.copyWith(logout: state.logout.toFailed(fault: e)));
  }
}
```

> `BlocState.copyWith`/`UserState.copyWith` use `x ?? this.x`, so a non-null `user`/`userData` sets the field; clearing is done only via `reset()` (Phase 3 sign-out). `init.toSuccess()` with null data keeps `userData` null for the signed-out branch.

### Hygen Commands
None — editing existing repo/cubit files (originally scaffolded by `hygen cubit nested`).

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` — zero new errors (watch for now-unused imports / removed methods).
- [ ] `flutter pub run build_runner build --delete-conflicting-outputs` — clean (no model changes expected, but confirm).
- [ ] No references remain to `_UserMocks` / `_UserParser`: `grep -rn "_UserMocks\|_UserParser" lib` returns nothing.

#### Manual Verification
- [ ] With emulators running, registering a new account creates an Auth user (9099) and a `users/{uid}` doc with `isOnboardingComplete:false` (visible at `localhost:4000`).
- [ ] Logging in with those credentials succeeds and the doc is read back.
- [ ] A bad password surfaces a typed `FirebaseAuthFault` message via the existing `UIFlash.error` in the register/login listeners.

**Implementation Note**: After this phase + automated verification, pause for manual confirmation before Phase 2.

---

## Phase 2: Launch gate + login routing

### Overview
Make cold-start routing read the resolved session, and make login route by onboarding status.

### Changes Required

#### 1. Splash gate
**File**: `lib/ui/screens/splash/splash.dart`
**Changes**: Replace the unconditional `Future.delayed → login`. In `initState`, post-frame call `UserCubit.c(context).init()`. Wrap the body in `BlocListener<UserCubit, UserState>` (listenWhen on `init`) that routes once:

```dart
void _onInit(UserState state) {
  if (_routed || !mounted) return;
  if (state.init.isFailed) { _routed = true; AppRoutes.login.pushReplace(context); return; }
  if (state.init.isSuccess) {
    _routed = true;
    final data = state.userData;
    final next = data == null
        ? AppRoutes.login
        : data.isOnboardingComplete ? AppRoutes.home : AppRoutes.onboarding;
    next.pushReplace(context);
  }
}
```
Add imports: `flutter_bloc`, `blocs/user/cubit.dart`. Keep the existing `Screen` + logo body. (`_routed` guard prevents double-push.)

#### 2. Login listener routes by flag
**File**: `lib/ui/screens/login/listeners/_login.dart`
**Changes**:
```dart
if (state.login.isSuccess) {
  final done = state.userData?.isOnboardingComplete ?? false;
  (done ? AppRoutes.home : AppRoutes.onboarding).pushReplace(context);
}
```

> Register listener (`create_account/listeners/_register.dart:14-16`) already pushes onboarding on success — no change; a freshly registered user is `isOnboardingComplete:false` by construction.

### Hygen Commands
None.

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` — zero new errors.

#### Manual Verification (emulators)
- [ ] Fresh install / signed-out cold start → **login**.
- [ ] Register → onboarding; kill & relaunch → **onboarding** (gate sees `isOnboardingComplete:false`).
- [ ] Manually flip the user doc's `isOnboardingComplete` to `true` at `localhost:4000`, relaunch → **home**.
- [ ] Login as a complete user → home; login as an incomplete user → onboarding.

**Implementation Note**: Pause for manual confirmation before Phase 3.

---

## Phase 3: Onboarding back-out + completion (incl. `AppAlertBase`)

### Overview
Add the reusable centered alert widget, intercept back during onboarding to offer sign-out, and mark onboarding complete on finish/skip using the real uid.

### Changes Required

#### 1. `AppAlertBase` widget (the alert — just a widget)
**File**: `lib/ui/widgets/design/alerts/app_alert_base.dart` (NEW)
**Changes**: Centered `Dialog` counterpart to `AppModalBase`, same tokens (`AppTheme.c.*`, `Space`, `AppText`, `22.radius()`). API mirrors AppModalBase: `icon` / `title` / `subtitle` / `actions`, plus a `showAppAlert()` helper (uses `showDialog`). Layout per design: centered circular icon badge (64, `BoxShape.circle`, `subBackground`, icon `subText` 24) → serif `AppText.h2` title (centered) → `AppText.b1` subtitle in `subText` (centered) → 1px `border` divider → `IntrinsicHeight` `Row` of actions split by 1px vertical dividers; each action flat-text, destructive → `AppTheme.c.error`.

```dart
class AppAlertAction {
  const AppAlertAction({required this.label, required this.onTap, this.isDestructive = false});
  final String label; final VoidCallback onTap; final bool isDestructive;
}

Future<T?> showAppAlert<T>(BuildContext context, {Widget? icon, String? title, String? subtitle,
    List<AppAlertAction> actions = const [], bool barrierDismissible = true}) {
  return showDialog<T>(context: context, barrierDismissible: barrierDismissible,
    builder: (_) => AppAlertBase(icon: icon, title: title, subtitle: subtitle, actions: actions));
}
```
`build()` calls `App.init(context)`. Helper classes `_IconBadge`, `_ActionRow`, `_ActionButton` each clear the rule-7 extraction threshold.

#### 2. Onboarding back interception
**File**: `lib/ui/screens/onboarding/onboarding.dart`
**Changes**: Add `import '.../design/alerts/app_alert_base.dart';`. On the `_Body` `Screen`, add `canPop: false` + `onBackPressed` (handles Android system back):
```dart
onBackPressed: () {
  if (state.currentStep > 0) { state.prevPage(); }
  else { _confirmSignOut(context); }
},
```
In `_StepHeader`, change the step-0 branch from `AppRoutes.createAccount.pushReplace(context)` to `_confirmSignOut(context)`.

#### 3. Sign-out helpers
**File**: `lib/ui/screens/onboarding/utils.dart` (part of onboarding)
**Changes**: Add:
```dart
void _confirmSignOut(BuildContext context) {
  showAppAlert(context,
    icon: const Icon(LucideIcons.logOut),
    title: 'Sign out of TaleemMate?',
    subtitle: 'Your study material and progress stay saved on this device. You can sign back in anytime.',
    actions: [
      AppAlertAction(label: 'Cancel', onTap: () => Navigator.pop(context)),
      AppAlertAction(label: 'Sign out', isDestructive: true, onTap: () => _signOutFromOnboarding(context)),
    ]);
}

Future<void> _signOutFromOnboarding(BuildContext context) async {
  final userCubit = UserCubit.c(context);
  Navigator.pop(context);          // dismiss the alert
  await userCubit.logout();
  userCubit.reset();               // clears user/userData
  if (!context.mounted) return;
  AppRoutes.login.pushReplace(context);
}
```

#### 4. `finish()` — real uid + mark complete (Skip = complete)
**File**: `lib/ui/screens/onboarding/_state.dart`
**Changes**: Both Finish and "Skip for now" route through `finish()` (`onboarding.dart:155`), so marking complete here satisfies the Skip-=-complete decision.
```dart
void finish(BuildContext context) {
  final userCubit = UserCubit.c(context);
  final userId = userCubit.state.user?.uid ?? userCubit.state.userData?.uid ?? '';
  final inst = institutionCtrl.text.trim();
  userCubit.completeOnboarding({if (inst.isNotEmpty) 'institution': inst});
  OnboardingCubit.c(context).complete(buildData(userId));
}
```
`OnboardingCubit.complete` stays mocked; `_CompleteListener` still navigates to `stepwiseLoader` on success. The user-flag write runs concurrently (best-effort) so the next cold start gates to home.

### Hygen Commands
None (`AppAlertBase` is a shared design widget, not a screen/cubit/provider — hand-authored like `AppModalBase`).

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` — zero new errors.
- [ ] Widget test renders `AppAlertBase` with two actions and taps `Cancel`/`Sign out` (see Testing Strategy).

#### Manual Verification (emulators + Dart MCP driver)
- [ ] Onboarding step 2/3, press back → animates to previous page (no alert).
- [ ] Onboarding step 0, header arrow → centered sign-out alert matching the design (badge, serif title, divided Cancel | Sign out).
- [ ] Android system back at step 0 → same alert (not a route pop).
- [ ] Cancel → alert dismisses, stay on onboarding.
- [ ] Sign out → returns to login; relaunch → login (auth cleared at 9099).
- [ ] Restart mid-onboarding → resumes onboarding; press back → alert appears again (consistent).
- [ ] "Skip for now" on step 4 → loader → home; relaunch → **home** (doc shows `isOnboardingComplete:true`).
- [ ] Finish normally → same.

**Implementation Note**: Pause for manual confirmation; this is the last phase.

---

## Testing Strategy

### Unit Tests (`/write_unit_test`)
- `UserCubit`: register success populates `user` + `userData` + `register.toSuccess`; login success likewise; `init` with null user → `init` success + null `userData`; `init` with user but empty profile → `logout` called + success/null; `completeOnboarding` no-op when uid null; fault paths emit `toFailed`. Mock `UserRepo` (inject or via a test seam) — note current `UserRepo.ins` is a singleton; cover what's reachable.
- Verify `FirebaseAuthFault`/`FirebaseFault` conversion happens in the provider catch ladders.

### Widget Tests (`/write_widget_test`)
- `AppAlertBase`: renders icon/title/subtitle, two actions; tapping an action fires its callback; destructive action uses `AppTheme.c.error`.
- Onboarding: at step 0 the back arrow shows the alert (pump + `showAppAlert`); at step > 0 it calls `prevPage`.
- Splash: stub `UserState.init` success with/without `userData` → asserts the routed destination.

### Manual Testing Steps
1. `firebase emulators:start`; `flutter run --flavor stage` (or the Driver MCP entrypoint).
2. Register → confirm Auth user + `users/{uid}` doc at `localhost:4000`.
3. Kill app → relaunch → resumes onboarding.
4. Step 0 back (arrow + system back) → sign-out alert → Sign out → login.
5. Re-login → onboarding (incomplete) → "Skip for now" → home.
6. Relaunch → home. Flip flag false in emulator UI → relaunch → onboarding.

## Architecture Checklist
- [ ] `App.init(context)` at top of every `build()` (`AppAlertBase`, splash).
- [ ] UI (`_state.dart`) does not call Firebase/HTTP directly — sign-out goes through `UserCubit`.
- [ ] Cubits do not import from `lib/ui/`.
- [ ] State via `UserCubit.c(context)` / `_ScreenState.s(context)` — no `context.read`.
- [ ] Firebase exceptions → typed `Fault` before emitting (provider catch ladders).
- [ ] Repo returns `Map`/primitives/SDK `User`; cubit does `UserData.fromJson` (rule 6).
- [ ] Spacing via `Space.*` tokens; radius via `int.radius()`; no `Spacer()`.
- [ ] Private widgets only when ≥5 children or ≥30 lines (alert sub-widgets qualify).

## References
- Research: `docs/research/2026-06-03-onboarding-feature-state-and-gaps.md`, `docs/research/2026-06-03-onboarding-session-lifecycle-and-alerts.md`
- Reference impl: `app_flight` `lib/cubits/user/cubit.dart:131-228`, `data_provider.dart:59-133`
- Design template: `lib/ui/widgets/design/modals/app_modal_base.dart`
- Back-intercept seam: `lib/ui/widgets/core/screen/screen.dart:106-116`
- Fault converters: `lib/services/fault/faults.dart:103,160`
