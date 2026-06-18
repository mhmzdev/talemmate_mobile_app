---
date: 2026-06-18T17:30:00+05:00
researcher: Claude (claude-opus-4-8)
git_commit: 75e1ee0eaf2e7eb976cedd83c3fb089c09beb142
branch: main
repository: taleemmate
topic: "Routing/navigation architecture + why the route stack accumulates duplicate /home and buries pushed full-screen routes like /focus"
tags: [research, codebase, routing, navigation, bottom-bar, focus]
status: complete
last_updated: 2026-06-18
---

# Research: Navigation/Routing Stack — duplicate `/home` + buried `/focus`

**Date**: 2026-06-18
**Git Commit**: `75e1ee0eaf2e7eb976cedd83c3fb089c09beb142`
**Branch**: `main`

## Research Question
How does routing/navigation work, and why can the route stack accumulate duplicate `/home` routes (with a pushed `/focus` buried underneath) when navigating via the bottom bar? Also: how to give `/focus` a bottom-to-top slide transition scoped to that screen.

## Summary
Two route tables back `MaterialApp`: a `routes` map (`appRoutes`, default `MaterialPageRoute`) for the auth/onboarding screens, and `onGenerateRoute` (`onGenerateRoutes`) which wraps the five tab routes **plus `/focus`** in a `FadeRoute`. The bottom bar switches tabs with **`pushReplace`** (`Navigator.pushReplacementNamed`), which replaces **only the top route**. This keeps the stack shallow in the normal tab-to-tab flow, but breaks when a full-screen route (`/focus`) is pushed and then a **tab route** (`/tutor`, via Focus's "I'm stuck") is pushed on top of it: a subsequent bottom-bar tap (or the `Screen` back handler) replaces only `/tutor`, leaving `/focus` sandwiched between the original `/home` and a new `/home`. The result is the observed `[home, focus, home]` stack.

## Detailed Findings

### Route tables + MaterialApp wiring
- `MaterialApp` (`lib/app.dart:73-92`): `routes: appRoutes`, `onGenerateRoute: onGenerateRoutes`, `navigatorObservers: [RouteLogger()]`, `navigatorKey: navigator`, `initialRoute: AppRoutes.splash`.
- `appRoutes` map (`lib/router/router.dart:19-26`): `/profile`, `/stepwise-loader`, `/onboarding`, `/create-account`, `/login`, `/splash` → plain `MaterialPageRoute`.
- `onGenerateRoutes` (`lib/router/router.dart:28-45`): `/home`, `/library`, `/tutor`, `/plan`, `/progress`, **`/focus`** → each wrapped in `FadeRoute` (a `PageRouteBuilder` with a `FadeTransition`, `lib/router/router.dart:47-58`). Returns `null` otherwise.
- `AppRoutes` constants: `lib/router/routes.dart` (incl. `focus = '/focus'`).

### Navigation helpers (`lib/configs/extension/_string.dart`)
- `.push` → `Navigator.pushNamed` (`:9`).
- `.pushReplace` → `Navigator.pushReplacementNamed` (`:12`) — **replaces the top route only**.
- `.pushAndClear` → `Navigator.pushNamedAndRemoveUntil(this, (route) => false)` (`:18-24`) — clears the **entire** stack, leaving the new route as the sole entry. Used today only on logout (`onboarding/listeners/_logout.dart:22`, `profile/listeners/_logout.dart:21`).
- `.pop` → `Navigator.pop` (`:41-44`).
- `.clockPlusMinutes` (`:56-66`) — unrelated (time helper, added by the Focus feature).

### Bottom bar tab navigation
- `BottomBar` (`lib/ui/widgets/core/bottom_bar/bottom_bar.dart:35-49`): for each tab, `if (isActive) return; tab.path.pushReplace(context);`. Tabs (`_data.dart`): `/home`, `/library`, `/tutor`, `/plan`, `/progress`.
- The bar is rendered by `Screen` **only** for those five routes (`screen.dart:75-84`, `hasBottomBar`). `/focus` is **not** in the allowlist, so Focus has no bottom bar.
- `Screen` back handling (`screen.dart:98-104`): on a bottom-bar route with no custom `onBackPressed`, installs `onWillPop = () => AppRoutes.home.pushReplace(context)` with `canPop: false`. This too **only replaces the top**.

### Full-screen route interaction (the bug path)
- "Begin next block" pushes `/focus`: `AppRoutes.focus.push(context, arguments: target)` (`_today_plan_card.dart:67`) → stack `[home, focus]`.
- Focus "I'm stuck": `ChatCubit.c(context).startConversation(...); AppRoutes.tutor.push(context)` (`focus/widgets/_actions.dart:24-25`) → stack `[home, focus, tutor]`. `/tutor` is a **tab route** and renders its own bottom bar.
- On `/tutor`, tapping a bottom-bar tab (e.g. Home) → `pushReplace` replaces **only `/tutor`** → stack `[home, focus, home]` — duplicate `/home`, `/focus` buried. The same happens via the `Screen` PopScope back handler (`home.pushReplace`).
- Focus dismissal/return: `AppRoutes.focus.pop(context)` from the top bar (`focus/widgets/_top_bar.dart:21`) and "Mark block done" (`focus/widgets/_actions.dart:37`).

### Route observers / logging
- `RouteLogger` (`lib/services/logging/route_logger.dart`) is the registered observer; it keeps a `static _routeStack` and prints "🚀 PUSHED / ⬅️ POPPED / 📚 CURRENT STACK" (`_printCurrentStack` iterates index 0→top, `:104-111`). This is the source of the logs the user pasted.
- `NavigationHistoryObserver` (package `navigation_history_observer`) is imported (`configs.dart:11`) and called in `String.sameRoute()` (`_string.dart:49-51`) but is **never** registered in `navigatorObservers`, so its history is always empty and `sameRoute()` always returns `false`.
- `context.currentPath` (`lib/configs/extension/_context.dart:4`) = `ModalRoute.of(this)!.settings.name` — reads the route name directly, independent of either observer.

## Root cause
`pushReplace` (top-only replacement) is correct for **tab ↔ tab** switching (keeps the stack at depth 1), but it cannot clean up when a non-tab full-screen route (`/focus`) sits in the stack below a pushed tab route (`/tutor`). Switching tabs (or backing out) then swaps only the top entry, orphaning `/focus` and duplicating `/home`. The accumulation is unbounded across repeated dives.

## Decision (what was actually changed)
The bottom-bar / `Screen` tab mechanism is **left untouched** — `pushReplace` is correct: only one tab route is ever on the stack and it's swapped one-for-one on switch (the user's logs confirm normal flows stay shallow/clean). The only change made was scoped to the new route:

- **`/focus` gets a dedicated bottom-to-top slide route** — a `SlideUpRoute` (`PageRouteBuilder` with a `SlideTransition` from `Offset(0, 1)`, slides back down on dismiss), used for the `AppRoutes.focus` case in `onGenerateRoutes`; the other five routes keep `FadeRoute`. `/focus` is a plain `push` on top of the current route (never replaces it) and pops back to it.

> An earlier exploratory change (tab nav → `pushAndClear`) was **reverted** — it altered working architecture unnecessarily.

### Residual edge (not fixed — out of scope)
The original `[home, focus, home]` stack came specifically from the **"I'm stuck"** deep-link `push`ing `/tutor` (a tab route, which renders a BottomBar) on top of the pushed `/focus`, then a bottom-bar tab tap swapping only `/tutor`. Normal focus push→pop is clean. If this matters later, the fix belongs in the **new** "I'm stuck" action (e.g. pop `/focus` as part of the deep-link), not in the tab mechanism.

## Code References
- `lib/app.dart:73-92` — MaterialApp (routes + onGenerateRoute + observers).
- `lib/router/router.dart:19-26,28-45,47-58` — `appRoutes`, `onGenerateRoutes`, `FadeRoute`.
- `lib/configs/extension/_string.dart:9-24` — push/pushReplace/pushAndClear/pop.
- `lib/ui/widgets/core/bottom_bar/bottom_bar.dart:43-49` — tab tap → `pushReplace`.
- `lib/ui/widgets/core/screen/screen.dart:75-104,137-144` — bottomBarRoutes allowlist, PopScope back handler, BottomBar render.
- `lib/ui/screens/focus/widgets/_actions.dart:24-25,37` — "I'm stuck" push tutor; "Mark block done" pop focus.
- `lib/ui/screens/focus/widgets/_top_bar.dart:21` — chevron-down pop focus.
- `lib/services/logging/route_logger.dart:104-111` — stack logging.

## Related Docs
- [Focus + Reschedule exec-plan](../exec-plans/completed/focus-session-and-reschedule-sheet.md)
- [Focus + Reschedule feat-checklist](../feat-checklist/focus-session-and-reschedule.md)

## Open Questions
- Whether tab cards elsewhere (`_tutor_card.dart:37`, `_recently_added.dart:30`) that use `pushReplace` to jump to a tab should also adopt `pushAndClear` for consistency — they don't currently trigger the bug (they run from `/home`, a shallow stack), so out of scope for the immediate fix.
