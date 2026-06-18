# Feature Checklist — Focus Session + Reschedule/Snooze (v1)

> A living test-plan + edge-case list for the two Home affordances turned real:
> the **Reschedule/Snooze bottom sheet** (deterministic single-block edits +
> a narrow AI "Why this plan" rewrite) and the **Focus Session screen** (timer
> ring, activities guidance, static tutor panel, "I'm stuck" deep-link, "Mark
> block done" → `SessionMetric`). Re-run the relevant rows before merging any
> change that touches `lib/blocs/plan/`, `lib/repos/plan/`,
> `lib/ui/screens/focus/`, `lib/ui/screens/home/widgets/_reschedule_sheet.dart`
> / `_today_plan_card.dart` / `_why_this_plan_card.dart`,
> `lib/ui/widgets/design/plan/ai_reasoning_card.dart`,
> `AppDatabase.updateStudyBlock` / `recordSessionMetric`,
> `StudyBlockStatus.effectiveStatus`, the `assets/plan_reason_sys_prompt.md`
> prompt, or `ai_service.dart` / `agent_tools.dart` / `system_prompts.dart`
> reason members.
>
> Status legend: ✅ verified on simulator (Dart MCP driver) · 🔒 guard /
> invariant to keep · 🚧 by-design gap · 🐛 bug found + fixed during driver
> verification · 📝 observation.
>
> Related: [exec-plan](../exec-plans/completed/focus-session-and-reschedule-sheet.md),
> [research](../research/2026-06-16-focus-session-and-reschedule-sheet.md),
> [navigation/routing-stack research](../research/2026-06-18-navigation-routing-stack.md),
> [study-plan-generation checklist](study-plan-generation.md),
> [chat-agent checklist](chat-agent.md), [ADR-013](../architecture/DECISIONS.md).

## How to run

1. Firebase AI Logic / Gemini enabled + billing active (the reasoning rewrite is
   a live `firebase_ai` call — no emulator).
2. `flutter run --flavor stage -t test_driver/app.dart`; `connect_dart_tooling_daemon`
   with the DTD URI.
3. Sign in to an account whose plan has today blocks (≥1 upcoming).

> Verified 2026-06-18 via the Dart MCP driver on the stage flavor: account
> "Muhammad", today's plan with Calculus / Circuit Analysis / Applied Physics
> blocks, Circuit Analysis exam on Jul 5 (≈16d out).

---

## 1. Reschedule/Snooze sheet

| # | Scenario | Expected | Status |
|---|---|---|---|
| 1.1 | Clock button opens the sheet | `showRescheduleSheet` over the now-block, else the earliest upcoming block; `RouteSettings('/modal/reschedule')` | ✅ |
| 1.2 | Header subtitle | `<subject> · <title> · <startTime> · <fmtBlockLength>` (e.g. "Applied Physics · Applied Physics — Vectors and Equilibrium · 21:00 · 45m") | ✅ |
| 1.3 | Snooze subtitle | "Start this block at `<start+30>` instead" (21:00 → 21:30; rolls the hour) | ✅ |
| 1.4 | Move/Shorten/Skip subtitles | "Slot it after Isha · 20:30" · "Keep `<start>`, trim the walkthrough" · "Fold it into tomorrow's plan" | ✅ |
| 1.5 | Footer note | Gold-edge `AppEdgeCard`: "I'll re-plan around your choice and update \"Why this plan\"." | ✅ |
| 1.6 | Snooze action | Block `startTime` += 30, streams to the Today list within a frame (21:00 → 21:30) | ✅ |
| 1.7 | Move to tonight | Block `startTime` = 20:30; re-sorts into the list by start time | ✅ |
| 1.8 | Shorten to 30 | `durationMinutes` 45 → 30 ("Applied Physics · 30m"); ≤30 left untouched | ✅ |
| 1.9 | Skip today | `date` += 1 day; drops off today's list (cubit unit-tested; driver-confirmed via patch) | ✅ |
| 1.10 | Cancel | Dismisses with no write | ✅ |

## 2. AI "Why this plan" refresh

| # | Scenario | Expected | Status |
|---|---|---|---|
| 2.1 | Reasoning rewrite after a move | `Schedule.aiReasoning` is rewritten by `reasonModel` + `plan_reason_sys_prompt.md`; acknowledges the change ("It's perfectly fine to adjust… Despite the change, your plan still prioritizes Circuit Analysis…") | ✅ |
| 2.2 | Loading state | `_RethinkingPill` (spinner + "Rethinking…") shows beside the pill while the call runs; the prior paragraph dims (`AnimatedOpacity`) until the fresh one lands | ✅ |
| 2.3 | Decoupled from the move | The block move never waits on the AI call; the reasoning resolves a beat later | ✅ |
| 2.4 | Failure keeps prior reasoning | On a reasoning `Fault`, the move still stands and the old paragraph remains (unit-tested; by design no error chrome) | ✅ |
| 2.5 | Persisted | New reasoning written to `schedules.aiReasoning`; mirrored into the live `week`/`schedule` so the card updates without a re-watch | ✅ |

## 3. Focus Session screen

| # | Scenario | Expected | Status |
|---|---|---|---|
| 3.1 | "Begin next block" opens Focus | `/focus` (**`SlideUpRoute`** — slides up from the bottom, back down on dismiss) for the now/next-upcoming block, passed via route `arguments`; cream background; no BottomBar | ✅ |
| 3.2 | Top bar | chevron-down close · "FOCUS SESSION" + "Block N of M · Do Not Disturb on" (static DND) · pause/resume toggle | ✅ |
| 3.3 | Timer ring | Determinate `CustomPainter` ring sweeping from top; mono `mm:ss` countdown + "remaining · `<dur>` min"; ticks each second (59:56 → 59:33) | ✅ |
| 3.4 | Block card | subject dot + "SUBJECT · WALKTHROUGH", serif title, `activities` rendered as guidance (no stepper) | ✅ |
| 3.5 | Tutor panel | `AppAiPill('Guided by tutor')` + the block's `aiInsight`; hidden when null/empty; no source chips | ✅ |
| 3.6 | "I'm stuck" deep-link | `ChatCubit.startConversation(subjectId)` + push `/tutor`; lands in a fresh per-subject conversation (verified: "Circuit Analysis" empty chat) | ✅ |
| 3.7 | "Mark block done" | `status: done` persisted + `SessionMetric` recorded; pops to Home; block shows done (filled check + strikethrough), counter "2 of 4" → "3 of 4" | ✅ |
| 3.8 | Pause/resume | Toggles the countdown + pause/play icon (timer is ephemeral `_ScreenState`) | ⏳ (icon not keyed; countdown + state logic unit-shaped) |

## 4. Home "Today's plan" card states

| # | Scenario | Expected | Status |
|---|---|---|---|
| 4.1 | Now/upcoming block exists | "Begin next block" (→ Focus) + reschedule clock (→ sheet), targeting the now-block else earliest upcoming (`_rescheduleTarget`) | ✅ |
| 4.2 | **All blocks done** (`_rescheduleTarget == null`) | The action row is replaced by a single creamy **"See what's next →"** CTA — the inert Begin/clock buttons are gone | ✅ |
| 4.3 | "See what's next" navigation | `AppRoutes.plan.pushReplace(arguments: <next-planned-date ISO>)` where the date is the next day after today with blocks (`_nextPlannedDate`); Plan opens with that day **pre-selected** in the week strip (verified: today done + one block skipped → Plan opens on Fri 19) | ✅ |
| 4.4 | Pre-seed overridable | Tapping any day in the Plan week strip overrides the pre-seed (`_ScreenState.selectedDayIndex` wins over `initialDate`) | ✅ |
| 4.5 | No blocks today at all | Handled upstream by `_HomePlanContent` → `PlanPlaceholder` ("No study blocks scheduled…"), not this card | ✅ |

---

## Bugs found + fixed during driver verification 🐛

- **Partial block UPDATE, not upsert** — `AppDatabase.updateStudyBlock` first
  used `scheduleDao.upsertBlock` (`insertOnConflictUpdate`), whose INSERT branch
  requires every NOT NULL column; a partial companion failed the SQL, threw, and
  was swallowed as a handled `UnknownFault` (block silently didn't move, no
  runtime error). Fixed to a targeted `update(studyBlocks)..where(id).write(...)`,
  mirroring `updateScheduleReasoning`. 🔒 Never reschedule via upsert.
- **`const` card didn't reflect live cubit state** — `_WhyThisPlanCard` read
  `PlanCubit.c(context)` with `listen: false`; as a `const` child its parent
  skipped rebuilding it, so the reasoning **loading** state never surfaced.
  Fixed to `PlanCubit.c(context, true)` so it rebuilds on every `PlanState` emit.
  🔒 Any widget that must show a transient cubit sub-state needs `listen: true`
  (or its own `BlocBuilder`), not reliance on a parent rebuild.
- **`effectiveStatus` ignored a manual completion** — it was purely clock-derived,
  so "Mark block done" wrote `status: done` but a *future* block still rendered
  `upcoming`. Fixed: a stored `done` is now authoritative and sticks regardless
  of the clock. 🔒 Manual completion overrides clock-derivation; clock still
  drives done/now/upcoming for un-completed blocks.
- **`/focus` transition** — switched from `FadeRoute` to a dedicated
  `SlideUpRoute` (slides up from the bottom, back down on dismiss), scoped to
  `/focus` only; the five tab routes keep `FadeRoute`. The bottom bar +
  `Screen` back-handler are **unchanged** (`pushReplace` — tabs are roots,
  swapped one at a time; this is correct and was left alone). See
  [research](../research/2026-06-18-navigation-routing-stack.md). 📝 The one
  remaining stack quirk is the "I'm stuck" deep-link `push`ing `/tutor` (a tab
  route) on top of the pushed `/focus`; tabbing away from that pushed `/tutor`
  can bury `/focus` — see by-design gaps. Normal focus push→pop is clean.

## Invariants / regression guards 🔒

- **Repo stays Map/primitives-only (ADR-013)** — `PlanRepo.updateBlock` /
  `recordSession` / `updateReasoning` take/return `Map`/primitives; the
  `BlockStatus.name → enum` map + `SessionMetric` companion build live in
  `AppDatabase` (`updateStudyBlock`, `recordSessionMetric`), **not** the repo.
  `lib/repos/plan/` must not import `core/models/` (enforced by
  `repo-purity-check.sh`).
- **Reasoning seam mirrors plan generation** — prompt in
  `SystemPrompts.reason()` → `plan_reason_sys_prompt.md`; schema in
  `AgentTools.reasonSchema`; model in `AiService.reasonModel` (built once,
  reused). `firebase_ai` errors → `AiFault`; empty/invalid JSON → `UnknownFault`.
- **Timer is ephemeral + UI-only** — the countdown lives in the Focus
  `_ScreenState` (`Timer.periodic`, cancelled in `dispose`); business actions
  (mark done) delegate to `PlanCubit`. `_state.dart` never touches Firebase.
- **Block passed by route arguments** — Focus reads
  `ModalRoute.settings.arguments as StudyBlock`; `/focus` is **not** in the
  BottomBar allowlist, so the surface is full-screen.
- **Shared time helper** — `String.clockPlusMinutes(int)` (configs `_string.dart`)
  is used by both the cubit (`snoozeBlock`) and the sheet subtitle; don't
  duplicate the HH:mm math.

## By-design gaps 🚧 (not bugs)

- **No full AI re-plan** on reschedule — only the four deterministic edits + a
  single-string reasoning rewrite; `generate()` is untouched.
- **"Move to tonight" uses a fixed 20:30** — no prayer-time data.
- **"Do Not Disturb on" is a static label** — no real OS DND.
- **Tutor deep-link is subject-only** — `startConversation(subjectId)`; no
  topicId threading or auto-asked starter question. "I'm stuck" `push`es `/tutor`
  on top of `/focus` (`[home, focus, tutor]`); the pushed `/tutor` shows its own
  BottomBar. Popping `/tutor` returns to the Focus session; **tabbing away** from
  it instead leaves `/focus` orphaned in the stack until the next tab switch.
  Left as-is per scope (don't touch the bottom-bar / tab-route mechanism). A
  future tweak could pop `/focus` as part of the deep-link.
- **`SessionMetric` unchanged** — recorded with the existing four fields
  (`topicIds` carries the block's `topicId` when present); `durationMinutes` is
  the block's planned length, not actual elapsed.
- **No structured per-block checklist/stepper** — `activities` rendered as-is.
