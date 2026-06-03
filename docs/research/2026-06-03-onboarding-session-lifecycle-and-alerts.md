---
date: 2026-06-03T00:00:00+05:00
researcher: Claude (claude-opus-4-8)
git_commit: 5a97a1dbc08bdfad9ff4140a0ae73195929abb26
branch: main
repository: taleemmate
topic: "Onboarding session lifecycle, auth state, and alert/dialog patterns — to support incomplete-onboarding resume, back-button sign-out confirmation, and a reusable centered alert base"
tags: [research, codebase, onboarding, auth, user-cubit, routing, navigation, modals, alerts]
status: complete
last_updated: 2026-06-03
---

# Research: Onboarding Session Lifecycle, Auth State & Alert Patterns

**Date**: 2026-06-03
**Git Commit**: `5a97a1d`
**Branch**: `main`

## Research Question
How onboarding session lifecycle, auth state, and alert/dialog patterns work today — to support: (a) detecting an incomplete onboarding on app restart and routing back into it, (b) a back-button "sign out" confirmation during onboarding, and (c) a reusable centered alert base widget. Covering UserCubit/UserState (`userData`/`user` fields), FirebaseAuth usage + the `app_flight` reference pattern, splash routing & `isOnboardingComplete` gating, onboarding entry/exit & back-button/PopScope, dialog/alert presentation & AppModalBase, and the logout flow.

## Summary
The new `UserData? userData` and `User? user` fields exist on `UserState` (`lib/blocs/user/state.dart:16-17`) but are **never populated** — all real data still lives in the action `BlocState`s (`state.register.data`, `state.login.data`). There is **no real FirebaseAuth anywhere** in TaleemMate; register/login are mocked. The sibling project **`app_flight` already implements the exact target pattern** (`authStateChanges` listener on `init()`, `createUserWithEmailAndPassword` + Firestore `users/{uid}` write, `fetchProfile`, `signOut`), and TaleemMate's `userData`/`user` fields plus its `FirebaseAuthFault`/`FirebaseFault` converters are clearly shaped to receive it. Splash unconditionally routes to login with **no auth/onboarding gate**. The app has **no centered dialog/alert primitive** — only `AppModalBase` (bottom sheet) and three inline `showModalBottomSheet` call sites. `PopScope` is used in exactly three places (`Screen`, `AppModalBase`, and the onboarding sub-modals via AppModalBase); the onboarding screen does **not** intercept Android system back today.

## Detailed Findings

### 1. UserCubit / UserState — `userData` & `user` are inert
- `UserState` has 8 `BlocState<UserData>` action fields + `UserData? userData` + `User? user` (firebase_auth `User`, imported at `lib/blocs/user/cubit.dart:3`) (`lib/blocs/user/state.dart:6-17`).
- `UserState.def()` sets `userData = null`, `user = null` (`state.dart:42-43`). **No `copyWith` in the cubit ever passes a non-null `userData`/`user`** — every method only drives one action `BlocState`. So both are always null at runtime.
- A commented-out intent exists: `// UserData? get userData => UserCubit.c(this, true).state.userData;` (`lib/configs/extension/_context.dart:35`).
- Onboarding currently reads the uid from `state.init.data?.uid` (`lib/ui/screens/onboarding/_state.dart:162`) — but `init()` is mocked to return `{}` and is **never called at startup**, so the uid is effectively `''`.
- `UserData` model: `uid`, `fullName`, `email`, `institution?`, `@Default(false) isOnboardingComplete` (`lib/core/models/user/user.dart:7-22`).

### 2. No real FirebaseAuth in TaleemMate; `app_flight` is the reference
- `FirebaseAuth` appears in TaleemMate only as the `User` type import (`cubit.dart:3`) and the emulator setup (`main.dart:35`). The repo/provider layer is 100% `_UserMocks` (`lib/repos/user/user_data_provider.dart`). Register mock returns `{uid:'mock-user-002', isOnboardingComplete:false}` (`user_mocks.dart:6-16`); login mock only accepts `test@taleemmate.com / test1234` and returns `isOnboardingComplete:true` (`user_mocks.dart:22-38`).
- **`app_flight` pattern** (`/Users/hamza/Development/Work/app_flight/lib/cubits/user/`) — the model to mirror:
  - `init()` subscribes once to `_auth.authStateChanges()`, then `_initUser(user)` → `_repo.fetchProfile(uid)` (Firestore `users/{uid}`) → `_initSuccess(user, profile)` which sets **both** `state.user` (Firebase `User`) and `state.userData` (Firestore profile) (`cubit.dart:131-177`).
  - `register`: `_auth.createUserWithEmailAndPassword` → strip password → `_firestore.collection(users).doc(uid).set(userData)` → return `User` (`data_provider.dart:59-90`).
  - `login`: `_auth.signInWithEmailAndPassword` → `fetchProfile` (`data_provider.dart:119-133`, `cubit.dart:217-228`).
  - `fetchProfile`: `_firestore.collection(users).doc(uid).get()` → `UserData.fromJson(raw.data() ?? {})` (`data_provider.dart:92-105`).
  - `logOut`: best-effort field clear → `_auth.signOut()` (`cubit.dart:179-191`).
  - Fault conversion: `on FirebaseAuthException → AuthFault.fromFirebaseAuth`, `on FirebaseException → FirebaseFault.fromFirebase` (every provider method). TaleemMate already has the equivalents: `FirebaseAuthFault.fromFirebaseAuthException` (`lib/services/fault/faults.dart:103`) and `FirebaseFault.fromFirebase` (`faults.dart:160`).
  - `init()` holds a `StreamSubscription<User?>? listener` cancelled in `close()` (`cubit.dart:143-149`).

### 3. Splash → routing; no `isOnboardingComplete` gate
- `SplashScreen._BodyState.initState`: `Future.delayed(1.5s)` → `AppRoutes.login.pushReplace(context)` unconditionally — no auth check, no onboarding-status check (`lib/ui/screens/splash/splash.dart:35-42`).
- `AppRoutes` constants (`lib/router/routes.dart`): `splash`, `login`, `createAccount`, `onboarding`, `stepwiseLoader`, `home`, `library`, `tutor`, `plan`, `progress`.
- Router (`lib/router/router.dart`): `appRoutes` map (MaterialPageRoute) covers splash/login/createAccount/onboarding/stepwiseLoader; `onGenerateRoutes` returns `FadeRoute` for the 5 bottom-bar routes. Global `navigator = GlobalKey<NavigatorState>()` (`router.dart:15`), wired at `app.dart:55`. `initialRoute: AppRoutes.splash` (`app.dart:63`).
- Nav helpers are String extensions (`lib/configs/extension/_string.dart`): `.push`, `.pushReplace`, `.pop`, `.popUntil`, `.slowHeroPushReplacement`.

### 4. Onboarding entry/exit & back-button; PopScope inventory
- **Entry**: `_RegisterListener` on `register.isSuccess` → `AppRoutes.onboarding.pushReplace(context)` (`lib/ui/screens/create_account/listeners/_register.dart:14-16`). `pushReplace` removes create-account from the stack.
- **Exit**: `_CompleteListener` on `complete.isSuccess` → `AppRoutes.stepwiseLoader.pushReplace` (`lib/ui/screens/onboarding/listeners/_complete.dart:14-16`) → stepwise loader timer (~4.2s) → `AppRoutes.home.pushReplace` (`lib/ui/screens/stepwise_loader/_state.dart:27`). The loader is cosmetic — no Firestore, no cubit.
- **Onboarding back button** (`_StepHeader`, `onboarding.dart:129-163`): `AppBackButton.onTap` → if `step == 0` calls `AppRoutes.createAccount.pushReplace(context)`; else `state.prevPage()` (animates PageView). `AppBackButton` default does `''.pop(context)` (`app_back_button.dart:25`).
- **PopScope usages** (only three, no `WillPopScope` anywhere):
  1. `Screen` (`lib/ui/widgets/core/screen/screen.dart:106-116`) — wraps body in `PopScope` only when `onWillPop != null` or `canPop == false`. On the 5 bottom-bar routes it auto-sets `onWillPop` to redirect to home and `canPop = false` (`screen.dart:98-104`). For onboarding (not a bottom-bar route, `canPop` not passed) **no PopScope is installed** → Android back pops the route normally.
  2. `AppModalBase` (`app_modal_base.dart:72`) — `PopScope(canPop: canPop)`.
  3. The two onboarding sub-modals pass `canPop: true` through AppModalBase.
- `Screen` key params relevant here: `canPop` (bool?), `onBackPressed` (`void Function()?`) — passing `canPop: false` + `onBackPressed:` installs the same intercept used by bottom-bar routes.

### 5. Dialog / alert patterns — no centered primitive exists
- **No `showDialog`, `AlertDialog`, `Dialog(`, `CupertinoAlertDialog`, or `showAppModal` helper anywhere in `lib/`.** Only `showModalBottomSheet`, called inline at 3 sites: `_2_subjects.dart:68`, `_3_schedule.dart:112`, and `full_screen_loader.dart:27` (all `isScrollControlled: true`, `backgroundColor: Colors.transparent`).
- Only `FullScreenLoader.modal(...)` provides a static `showModalBottomSheet` wrapper (`full_screen_loader.dart:22-39`) — scoped, not generic.
- **`AppModalBase`** (`lib/ui/widgets/design/modals/app_modal_base.dart`) is the design template to mirror for `AppAlertBase`:
  - Params: `icon`, `title`, `subtitle`, `child`, `expanded`, `actions` (rendered as a **column**, `t08` apart, `_Actions` `app_modal_base.dart:207-224`), `padding`, `bottomSafe`, `dragger`, `canPop`, `backgroundColor`.
  - `_Header` (`app_modal_base.dart:140-192`): icon in a 40×40 `AppTheme.c.subBackground` container with `AppProps.radiusMd.radius()`, icon `AppTheme.c.subText` size 18; title `AppText.h3` (Fraunces serif 16); subtitle `AppText.b2 + AppTheme.c.subText`. Note: this header is **left-aligned in a Row** — the target alert (Image #1) is **center-aligned** with a circular icon badge and a **horizontal two-button footer with a top divider**, so `AppAlertBase` differs in layout (centered column + side-by-side actions), not in tokens.
  - Outer container `22.top()` radius, `AppTheme.c.background` fill.

### 6. Design primitives for the alert
- **AppButton** (`lib/ui/widgets/core/button/button.dart`, enums `_enums.dart:4-16`): `style` ∈ {`primary`, `creamy`, `error`, `success`}; `size` ∈ {`small`, `medium`, `large`}; `borderRadius` ∈ {`normal`, `rounded`, `capsule`}; `state` ∈ {`def`, `pressed`, `disabled`}; `mainAxisSize` (`.max` = full width); `label`, `icon`, `onTap`, `textColor`, `margin`, `padding`. No `expanded` bool — use `Expanded` or `mainAxisSize: .max`.
- **Space**: `Space.sym(h, v)` → `EdgeInsets.symmetric` (`_space.dart:72-75`); `Space.y.t*` / `Space.x.t*` spacing boxes; `Space.a/h/v/t/b.t*` edge insets; tokens `t04..t100` (`_tokens.dart`).
- **Typography** (`_typography.dart`): `h1`=Fraunces 26, `h2`=Fraunces 20, `h3`=Fraunces 16 (serif headings); `b1`=Geist 14, `b2`=Geist 12; extensions `.cl(color)`, `.w(int)`, `.fra()`.
- **Colors** `AppTheme.c.*` (`_theme_model.dart` / `_colors.dart`): `primary`, `accent`, `onPrimary`, `text`, `subText`, `background`, `subBackground`, `specBackground`, `border`, `error`, `success`, `warning`.
- **Radius helpers** (`_int.dart`): `int.radius()` (`BorderRadius.circular`), `int.top()`, `int.bottom()`. `AppProps.radius{Sm:4, Md:8, Lg:12, Xl:16, Pill:48}` (`_props.dart`).

### 7. Logout flow
- TaleemMate `UserCubit.logout()` only drives `state.logout` BlocState; it does **not** clear other state (`lib/blocs/user/cubit.dart:154-174`). `reset()` emits `UserState.def()` (clears everything incl. `userData`/`user`) (`cubit.dart:198`). The repo `logout` is mocked. There is no listener that navigates after logout today — no screen reacts to `state.logout.isSuccess`.

## Code References
- `lib/blocs/user/state.dart:16-17` — `userData` / `user` fields (inert)
- `lib/blocs/user/cubit.dart:3` — firebase_auth `User` import
- `lib/repos/user/user_data_provider.dart` — fully mocked auth
- `lib/repos/user/user_mocks.dart:6-38` — register/login mock shapes incl. `isOnboardingComplete`
- `lib/core/models/user/user.dart:7-22` — `UserData` + `isOnboardingComplete`
- `lib/ui/screens/splash/splash.dart:35-42` — unconditional → login
- `lib/router/routes.dart`, `lib/router/router.dart`, `lib/configs/extension/_string.dart` — routes + nav helpers
- `lib/ui/screens/onboarding/onboarding.dart:129-163` — `_StepHeader` back button
- `lib/ui/screens/onboarding/_state.dart:161-164` — `finish()`, uid from `init.data`
- `lib/ui/widgets/core/screen/screen.dart:98-116` — PopScope / back-intercept mechanism
- `lib/ui/widgets/design/modals/app_modal_base.dart` — bottom-sheet base (template for AppAlertBase)
- `lib/ui/widgets/core/button/button.dart`, `_enums.dart:4-16` — AppButton API
- `lib/services/fault/faults.dart:103,160` — `FirebaseAuthFault` / `FirebaseFault` converters
- `app_flight: lib/cubits/user/cubit.dart:131-228`, `lib/cubits/user/data_provider.dart:59-133` — reference Firebase auth wiring

## Architecture Documentation
- **State accessor pattern**: `XCubit.c(context)` / `_ScreenState.s(context)` (never `context.read`). Cubits use `BlocState<T>` with `.toLoading/.toSuccess/.toFailed`.
- **Repo purity**: providers wrap calls in try/catch converting to typed `Fault` subtypes; `app_flight` confirms the intended `FirebaseAuthException → AuthFault` / `FirebaseException → FirebaseFault` mapping that TaleemMate's faults are already built for.
- **Back-intercept**: the single mechanism is `Screen(canPop: false, onBackPressed: …)` → `PopScope`. Onboarding does not use it yet.
- **Modals**: presented via raw `showModalBottomSheet(isScrollControlled, transparent bg)`; `AppModalBase` is the shared visual base. No centered-dialog equivalent exists.

## Related Docs
- `docs/research/2026-06-03-onboarding-feature-state-and-gaps.md` — companion: onboarding UI complete, backend fully mocked, gap list (G1–G9).

## Open Questions
- Firestore schema for onboarding persistence (flat `users/{uid}` merge vs. subcollections) — not yet decided.
- Whether `init()`'s `authStateChanges` listener should be one-shot (app_flight cancels after first event) or continuous for TaleemMate.
- Where logout should land (login screen) and whether a global `logout.isSuccess` listener or imperative navigation is preferred.
