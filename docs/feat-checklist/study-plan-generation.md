# Feature Checklist — Study Plan Generation (v1)

> A living test-plan + edge-case list for the AI study-plan **generation pipeline**
> (`PlanCubit` + `PlanRepo`, single-shot structured-JSON Gemini via
> `AiService.planModel` + `AgentTools.planSchema`, persisted on the `schedule`
> models/`ScheduleDao` + new `aiReasoning` column). Covers generation at
> onboarding, the read UIs (home cards + plan-screen week timeline), and
> persistence. Re-run the relevant rows before merging any change that touches
> `lib/blocs/plan/`, `lib/repos/plan/`, `lib/ui/screens/home/`,
> `lib/ui/screens/plan/`, `lib/ui/screens/stepwise_loader/`,
> `lib/ui/widgets/design/plan/`, `lib/core/constants/study_windows.dart`,
> `lib/core/models/schedule/`, `AppDatabase` schedule helpers / `ScheduleDao`,
> the `assets/plan_sys_prompt.md` prompt, `ai_service.dart` / `agent_tools.dart`
> / `system_prompts.dart` plan members, or the auth-transition listeners that
> call `PlanCubit.initUid/resetUid`.
>
> Status legend: ✅ verified on simulator (Dart MCP) · 🔒 guard / invariant to
> keep · 🚧 by-design gap (not implemented yet) · ⏳ not driver-tested (inferred
> from a shared code path / non-deterministic model output) · 📝 observation.
>
> Related: [exec-plan](../exec-plans/completed/study-plan-generation.md),
> [research](../research/2026-06-15-study-plan-generation.md),
> [onboarding-flow checklist](onboarding-flow.md),
> [chat-agent checklist](chat-agent.md), [ADR-013](../architecture/DECISIONS.md),
> [plan system prompt](../../assets/plan_sys_prompt.md).

## How to run

1. Ensure the Firebase project has **Firebase AI Logic / Gemini** enabled and
   billing active (generation is a live `firebase_ai` call — no emulator).
2. `flutter run --flavor stage -t test_driver/app.dart`; `connect_dart_tooling_daemon`
   with the DTD URI.
3. For a fresh generation, register a new account (or wipe local data) and
   complete onboarding with ≥3 subjects (varied confidence), ≥1 exam within the
   7-day window, 2–3 study windows enabled, a daily target (~3.5h).

> Verified 2026-06-15 via the Dart MCP driver on the stage flavor: fresh account
> `hamza.plan1@cui.edu.pk`, 3 subjects (Discrete Math = *Shaky*, Linear Algebra
> & Database Systems = *Getting there*), exam Discrete Math · 19 Jun (in 3d),
> windows Morning/Afternoon/Evening, target 3.5h.

---

## 1. AI plumbing — prompt, schema, model (Phase 1)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 1.1 | `planModel(...).generateContent(...)` | Returns JSON parseable into `WeekPlan` (`aiReasoning`, `days[]` → `blocks[]`) | ✅ |
| 1.2 | `AgentTools.planSchema` shape | `aiReasoning` + `days[{date, blocks[{startTime, durationMinutes, subjectId, title, activities, aiInsight?}]}]`; `aiInsight` optional; app-filled fields omitted | ✅ |
| 1.3 | `SystemPrompts.plan()` | Loads + caches `assets/plan_sys_prompt.md` (week-planner copy) | ✅ |
| 1.4 | Blocks inside enabled windows | Every `startTime` falls inside an enabled window (09:00/10:00 Morning, 14:00 Afternoon, 16:30/17:30 Evening) | ✅ |
| 1.5 | Durations realistic | `durationMinutes` 20–90 (observed 45–50m) | ✅ |
| 1.6 | Valid subject ids only | Every block `subjectId` is one of the provided ids; unknown ids dropped in the repo | ✅ |
| 1.7 | Reasoning language follows input | English subjects/context → English `aiReasoning` | ✅ |
| 1.8 | `aiInsight` gold note | Optional, "at most the highest-impact" block — model placed one on the day-before-exam block (Thu 18, "Solve Full Past Paper Section") | ✅ |

## 2. Generation engine — cubit / repo + persistence (Phases 2–3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 2.1 | `generate(userId)` round-trip | Gathers schedule + subjects + exams → Gemini → parses → persists blocks + reasoning → returns `WeekPlan` map | ✅ |
| 2.2 | Front-loading (weak + near exam) | Discrete Math (Shaky, exam in 3d) got 4/5 of today's blocks; lighter pre-exam revision on exam day, shift to others after | ✅ |
| 2.3 | `aiReasoning` persisted | Stored on the `schedules.aiReasoning` column (schema v3); hydrated into `WeekPlan.aiReasoning` | ✅ |
| 2.4 | Blocks persisted | `replaceStudyBlocks` writes the week to `StudyBlocks`; `watchStudyBlocks` streams them back | ✅ |
| 2.5 | Window catalog resolves | `enabledWindowIds` resolves against `kStudyWindowCatalog` to real `HH:mm` ranges | ✅ |
| 2.6 | `effectiveStatus` (device time) | Past blocks → done (filled/strikethrough), future → upcoming (open ring); recomputed each render, stored status untouched | ✅ |
| 2.7 | `WeekPlan` assembly | `watchForUser` groups blocks by day into a 7-day `WeekPlan` (today + 6), attaches the exam that falls on each day | ✅ |
| 2.8 | `get_runtime_errors` | Zero unhandled errors; failures are typed `Fault`s (`AiFault`/`UnknownFault`) | ✅ |

## 3. Loader wiring (Phase 4)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 3.1 | Real generation in loader | Steps 1–2 walk quickly, hold on "Calibrating today's plan" while the live Gemini call runs | ✅ |
| 3.2 | Gated nav on success | `_GenerateListener` marks all steps done + `AppRoutes.home.pushReplace` after a brief dwell | ✅ |
| 3.3 | Failure → retry | On `generate.isFailed`, `UIFlash.error` + a "Try again" button re-invokes generation (listener-driven, never imperative in `_state.dart`) | ⏳ |
| 3.4 | Min dwell | 4-step animation isn't jarring even if generation is fast | ✅ |

## 4. Read UIs — home + plan (Phase 5)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 4.1 | Home "Today's plan" card | Eyebrow + "done of total" (2 of 5), "N blocks left to go today.", progress meter (done/total), today's block rows | ✅ |
| 4.2 | Block row | Status dot (check / thick ring / open ring), title (strikethrough when done), subject swatch + activities + duration, start time | ✅ |
| 4.3 | "Begin next block" CTA + reschedule clock | Now wired — "Begin next block" → Focus Session for the now/next block; clock → Reschedule sheet. See [focus-session-and-reschedule](focus-session-and-reschedule.md) | ✅ |
| 4.4 | Home "Why this plan" card | Gold left edge, `AppAiPill('Why this plan')`, reasoning paragraph, footer chips (nearest exam "Exam in 3d" + "3.5h available") | ✅ |
| 4.5 | Plan week strip | 7 days (today + 6) with weekday + date + block-count dots; tap selects the day | ✅ |
| 4.6 | Exam marker | Red dot on the day with an exam (Fri 19); persists on the selected cell | ✅ |
| 4.7 | Plan "Why this week" card | Gold-edge `AiReasoningCard('Why this week')` with the same reasoning (no footer) | ✅ |
| 4.8 | Plan timeline | Header "WEEKDAY · N BLOCKS · H HRS" (totalDurationMinutes); vertical spine + dots; now/done/upcoming styling | ✅ |
| 4.9 | Day switching | Tapping a day re-renders the timeline + header for that day (`_ScreenState.selectedDayIndex`); selection defaults to today | ✅ |
| 4.10 | `aiInsight` chip | Gold sparkle chip on a block when present — verified on Thu 18's "Solve Full Past Paper Section" (accent bg + border, sparkle icon) | ✅ |
| 4.11 | Bottom-bar tabs intact | Home / Library / Tutor / Plan / Progress all present; no `unknown` routes in logs | ✅ |

## 5. Persistence + session lifecycle

| # | Scenario | Expected | Status |
|---|---|---|---|
| 5.1 | Relaunch (hot restart) | Resumes session → lands on home with the **same persisted plan**, **no loader, no regeneration** | ✅ |
| 5.2 | Plan tab after relaunch | Week strip + reasoning + timeline restored identically from Drift | ✅ |
| 5.3 | uid lifecycle (ADR-014) | `PlanCubit.initUid` called in splash + login + **register** listeners; `resetUid` in both logout listeners | ✅ (resume + sign-out → new account verified — see 5.5) |
| 5.4 | Idempotent watch | `watchForUser` no-ops if already watching the same uid with a live subscription; re-resolves after a fresh generation when no sub is active | ✅ |
| 5.5 | Per-account subjects/exams (ADR-014) | Generation reads `subjectsForUser(uid)` / `examsForUser(uid)` (userId column, schema v4); a different account's subjects/exams never enter the plan or library chips | ✅ (signed out, onboarded a fresh account with one subject "Communication Skills" → plan contained only that subject, "your only subject"; no leak from the prior account) |

---

## Invariants / regression guards 🔒

- **Repo stays Map/primitives-only (ADR-013)** — `PlanRepo` takes/returns
  `Map`/`List<Map>`/primitives; `PlanCubit` does `WeekPlan.fromJson` /
  `StudyBlock.fromJson`. Row↔Map + the `StudyBlock.fromJson` write-conversion
  live in `AppDatabase` (`scheduleForUser`, `updateScheduleReasoning`,
  `replaceStudyBlocks`, `watchStudyBlocks`, `subjectsForUser`, `examsForUser`),
  **not** the repo. `lib/repos/plan/` must not import `core/models/` (except the
  `StudyWindow` const-catalog type used for prompt assembly).
- **`firebase_ai` errors → `AiFault`** — `generate` catches
  `FirebaseAIException` → `AiFault.fromAiException`; empty/invalid JSON →
  `FormatException` → `UnknownFault`; else `UnknownFault`. Never uncaught.
- **Pure inputs (decision c)** — generation is grounded only in subjects
  (+confidence), exams (+daysUntil), enabled windows, and daily target. **No**
  material/topic/quiz grounding in v1. Don't wire `MaterialRepo` into `PlanRepo`.
- **Window single source of truth** — `kStudyWindowCatalog`
  (`lib/core/constants/study_windows.dart`) is shared by the onboarding picker
  (`_studyWindows` derives from it) and `PlanRepo`. Keep ids identical so
  `enabledWindowIds` resolves; don't reintroduce a divergent literal list, and
  don't seed/read the empty `StudyWindows` DB table.
- **System prompt lives in `SystemPrompts`** — `plan()` → `plan_sys_prompt.md`,
  cached in the shared `_cache`. Schema lives in `AgentTools.planSchema`. Model
  in `AiService.planModel` (built once, reused). Don't `rootBundle` inline.
- **`effectiveStatus` drives display** — a **manual** completion (stored
  `status == done`, written by the Focus session's "Mark block done") is now
  authoritative and sticks regardless of the clock; otherwise status is derived
  from device time vs `date`+`startTime`+`durationMinutes` (`StudyBlockStatus`
  extension). Generation still stamps blocks `upcoming`. UIs read
  `effectiveStatus`, never the raw stored value. (Updated by the Focus feature —
  see [focus-session-and-reschedule](focus-session-and-reschedule.md).)
- **Blocks generated as `upcoming`, `isAIGenerated: true`, `topicId: null`** —
  the repo stamps `id` (uuid), `scheduleId`, `dayOfWeek` (`date.weekday`), parsed
  `date`. Unknown `subjectId`s are dropped (never persisted).
- **uid lifecycle (ADR-014)** — `PlanCubit.initUid` runs alongside
  `LibraryCubit`/`ChatCubit` in splash + login + register listeners; `resetUid`
  in both logout listeners. Cancels the block-stream sub on reset + `close()`.
- **Subjects/exams are per-account (ADR-014)** — both tables carry a `userId`
  (schema v4); generation reads `subjectsForUser(uid)` / `examsForUser(uid)` and
  onboarding stamps `userId` on every saved subject/exam. Never read the
  un-scoped `subjectDao.getAll()` / raw `exams` table for plan inputs — that
  leaks one account's subjects into another's plan.
- **Listener-driven nav** — the stepwise loader navigates home only from
  `_GenerateListener` on `generate.isSuccess`; `_state.dart` kicks generation +
  drives the visual steps but never navigates. Kickoff is deferred past the build
  frame (`addPostFrameCallback`) so `notifyListeners`/cubit-emit don't fire
  during build.
- **`plan_mocks.dart` / `plan_parser.dart` kept** — scaffold parts with
  `// ignore_for_file: unused_element` (rule 12). Don't prune.
- **Shared plan widgets** — `SubjectSwatch` + `fmtBlockLength`
  (`plan_visuals.dart`), `AiReasoningCard`, `PlanPlaceholder` live in
  `lib/ui/widgets/design/plan/` and are used by both home and plan; don't
  duplicate them screen-private. Subject lookup goes through
  `LibraryCubit.subjectById`.
- **Spacing/edge-inset tokens** — `Space.b.t100` (bottom-bar clearance) etc.;
  the edge-inset model exposes `t04/t08/t12/t16/t20/t24/t28/t32/t60/t100` only
  (not every 4-multiple). Widget lists use `.map()` (no `for` in the tree).

## By-design gaps 🚧 (not implemented — don't treat as bugs)

- ~~**No Focus / execution screen**~~ — **shipped**: Focus Session screen with a
  timer ring + "Mark block done" (writes `status: done` + a `SessionMetric`).
  `effectiveStatus` now honours a manual `done`. See
  [focus-session-and-reschedule](focus-session-and-reschedule.md).
- ~~**No reschedule / snooze**~~ — **shipped**: Reschedule/Snooze sheet with four
  deterministic edits + a narrow AI reasoning rewrite. Still no full AI re-plan.
- **No per-block goals checklist** (no model backing in v1).
- **One generation at onboarding** — no regeneration triggers (daily
  roll-forward, post-quiz). Manual re-generate exists in the repo but isn't wired
  to any UI.
- **`StudyWindows` DB table unused** — windows come from the const catalog; the
  empty table is left for a future plan.
- **`aiInsight` is best-effort** — the model adds at most one or two gold notes
  and may add none (as in the verification run).
- **7-day window only** — `WeekPlan` is always today + 6 days; days the model
  omits render as empty (calm empty-timeline state).
