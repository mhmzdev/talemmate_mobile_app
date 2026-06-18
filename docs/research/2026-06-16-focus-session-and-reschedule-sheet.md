---
date: 2026-06-16T12:00:00+05:00
researcher: Claude (claude-opus-4-8)
git_commit: b0f971cf45271e362d196e2035a447a3a6cd1769
branch: main
repository: taleemmate
topic: "Home → Focus Session screen + Reschedule/Snooze bottom sheet: what exists today"
tags: [research, codebase, home, plan, schedule, tutor, chat, design-system, modals, routing]
status: complete
last_updated: 2026-06-16
---

# Research: Home → Focus Session + Reschedule/Snooze — what exists today

**Date**: 2026-06-16
**Git Commit**: `b0f971cf45271e362d196e2035a447a3a6cd1769`
**Branch**: `main`

## Research Question
Home → Focus Session screen + Reschedule/Snooze bottom sheet: document how the home plan area (`lib/ui/screens/home/`), the plan cubit/repo + schedule models, the tutor/chat stack, the design/sheet/widget system, and routing/screen-scaffolding currently work — establishing what exists today that a Focus Session screen and a Reschedule bottom sheet would build on.

## Summary
The home plan area renders a live-streamed `DayPlan` into a "Today's plan" card and a "Why this plan" card. Both forward-looking affordances are present but inert: the **"Begin next block"** button does `AppRoutes.plan.pushReplace(context)` and the **reschedule clock button** is an empty `onTap: () {}` annotated "Reschedule is a later (Focus) plan — placeholder no-op" (`_today_plan_card.dart:64,70`). The `PlanCubit`/`PlanRepo` layer can generate and live-watch blocks but has **no mutation path** for a single block (no snooze/shorten/skip/mark-done); `StudyBlock.status` is stored but always written `'upcoming'`, and block display status is derived from the device clock via `effectiveStatus()`. There is **no Focus/session screen, no timer/ticker, no determinate progress ring, and no structured block-checklist** — `StudyBlock.activities` is a single unstructured String, and `SessionMetric` exists in the DB layer but is never written by any cubit. The tutor/chat stack (`ChatCubit.send()`, Gemini grounding, `Citation` model, screen-private `_CitationChip`) is fully built but lives entirely inside the standalone `/tutor` screen. The design system provides strong reusable parts for a bottom sheet (`AppModalBase`, the `showModalBottomSheet` + `routeSettings` + typed-enum pattern in library, `_SheetAction` rows, `AppEdgeCard` footer note) and the standard screen scaffold/route wiring (hygen `screen new`, `FadeRoute`, `plan/` as reference).

## Detailed Findings

### 1. Home plan area (`lib/ui/screens/home/`)

**Files:** `home.dart`, `_state.dart`, `widgets/_header.dart`, `_today_plan_card.dart`, `_why_this_plan_card.dart`, `_recently_added.dart`, `_tutor_card.dart`, `_daily_reminder.dart`.

- `HomeScreen` is a `StatefulWidget` (`home.dart:37`). `initState` (`home.dart:46`) kicks off three loads: `QuotesCubit.today()`, `LibraryCubit.load()` (for subject swatches/names), and `PlanCubit.c(context).watchForUser(userId)` resolving the user id from `UserCubit` (`home.dart:49-60`).
- `build` calls `App.init(context)` then provides a screen-local `_ScreenState` (`ChangeNotifier`) via `ChangeNotifierProvider` over `_Body` (`home.dart:64-71`). `_ScreenState` is currently empty apart from the `s(context)` accessor (`_state.dart:3-7`).
- `_Body` (`home.dart:74-110`) returns the shared `Screen(keyboardHandler: true, ...)` wrapper containing a `SingleChildScrollView` → `Column` of: `_Header`, a `BlocBuilder<PlanCubit, PlanState>` → `_HomePlanContent`, `_RecentlyAdded`, `_TutorCard`, `_DailyReminder`.
- `_HomePlanContent` (`home.dart:114-153`) branches on `state.week`: loading placeholder, failed placeholder (with retry → `watchForUser`), empty placeholder when `today == null || today.blocks.isEmpty`, else `_TodayPlanCard(today:)` + `_WhyThisPlanCard()`.

**`_TodayPlanCard`** (`_today_plan_card.dart:6-79`):
- Computes `done`/`remaining`/`total` from `today.blocks` using `b.effectiveStatus() == BlockStatus.done` (`:17-23`).
- Renders header ("TODAY'S PLAN" + "`done` of `total`"), a summary line, a `_Meter` progress bar, then `...blocks.map((b) => _TodayBlockRow(block: b))` (`:55`).
- **The two forward-looking affordances are stubs:**
  - "Begin next block" `AppButton` → `onTap: () => AppRoutes.plan.pushReplace(context)` (`:64`).
  - Reschedule `AppIconButton(icon: LucideIcons.clock, onTap: () {})` with comment "Reschedule is a later (Focus) plan — placeholder no-op." (`:68-72`).
- `_TodayBlockRow` (`:82-180`) renders one block: a `_StatusDot` driven by `effectiveStatus()`, the title (line-through when done), subject swatch + name (`LibraryCubit.c(context).subjectById(block.subjectId)`), duration via `fmtBlockLength`, and `block.startTime`. A 2px left edge is gold when the block has a non-empty `aiInsight` and is not "now".
- `_StatusDot` (`:184-221`): filled check (done), thick ring (now), open ring (upcoming). `_Meter` (`:224-246`): thin `FractionallySizedBox` fill.

**`_WhyThisPlanCard`** (`_why_this_plan_card.dart:5-48`): hidden unless `PlanCubit.c(context).week?.aiReasoning` is non-empty. Renders `AiReasoningCard(pillText: 'Why this plan', reasoning:, footer:)` where the footer is `_InfoChip`s for the next exam (`cubit.nextExam`) and available hours (`cubit.state.schedule?.dailyTargetHours`).

### 2. Plan state/data layer

**`PlanCubit`** (`lib/blocs/plan/cubit.dart`) + **`PlanState`** (`lib/blocs/plan/state.dart`).

State fields (`state.dart:4-43`): `generate: BlocState<WeekPlan>`, `week: BlocState<WeekPlan>`, `schedule: Schedule?`. `def()` zeroes all three.

Public methods:
- `static c(context, [listen])` (`cubit.dart:20`).
- `initUid(uid)` / `resetUid()` (`cubit.dart:31,34`) — auth hooks delegating to `watchForUser` / `reset`.
- `generate(userId)` (`cubit.dart:37-49`) — `generate.toLoading()` → `PlanRepo.ins.generate(userId)` → `WeekPlan.fromJson` → `toSuccess`; `Fault` → `toFailed`.
- `watchForUser(userId)` (`cubit.dart:54-74`) — idempotent guard; loads `currentSchedule`, parses `Schedule` + `exams`, caches `_exams`, emits `schedule`, then `_watchSchedule` subscribes to the blocks stream and assembles a `WeekPlan`.
- `reset()` (`cubit.dart:154-160`) — cancels the subscription, clears state.

Computed getters: `week` → `state.week.data` (`:129`); `today` → first `DayPlan` where `isToday` (`:132-139`); `nextExam` → soonest `Exam` with `daysUntil >= 0` (`:142-146`).

Internals: `_blocksSub` (Drift stream), `_watchingUserId` (guard), `_exams` (cache). `_assembleWeek` (`:90-122`) groups the flat block list by calendar day into 7 `DayPlan`s.

**`PlanRepo`** (`lib/repos/plan/plan_repo.dart`, singleton `PlanRepo.ins`) — returns Map/List/primitives only (ADR-013):
- `generate(userId) → Map` (`:30`) — single-shot Gemini structured call, replaces all blocks, returns a `WeekPlan`-shaped map. In `_PlanProvider.generate` blocks are written with `'status': 'upcoming'` hard-coded (`plan_data_provider.dart:89`) and `DayPlan.isDone` is written `false` (`:101`).
- `watchBlocks(scheduleId) → Stream<List<Map>>` (`:35`) — live Drift stream of blocks ordered by date/time.
- `currentSchedule(userId) → Map?` (`:39`).
- `exams(userId) → List<Map>` (`:43`).

**No block-mutation surface exists.** `PlanRepo` has no `markBlockDone`/`snoozeBlock`/`rescheduleBlock`/`deleteBlock`. At the DAO level `ScheduleDao.upsertBlock` and `ScheduleDao.deleteBlock(id)` exist (`schedule_dao.dart:32-36`) but `upsertBlock` is only called by `replaceStudyBlocks` (bulk regen) and `deleteBlock` is never called. `AppDatabase.ins.replaceStudyBlocks` (`database.dart:412-439`) is the only block write path and is invoked only during generation.

### 3. Schedule + subject models

`lib/core/models/schedule/`:
- **`StudyBlock`** (`study_block.dart:9-30`, freezed sealed): `id, scheduleId, dayOfWeek, date, startTime` (`"HH:MM"`), `durationMinutes, subjectId, title, activities` (unstructured String), `status` (BlockStatus), `topicId?, aiInsight?, isAIGenerated`. `BlockStatus` enum = `done|now|upcoming` (`:6`).
  - Extension `StudyBlockStatus` (`:32-52`): `effectiveStatus([now])` derives status from device clock vs the block window; the doc comment states the stored `status` is "reserved for the future Focus/execution plan; UIs should read this" (`:35`). `startDateTime` parses `date`+`startTime`.
- **`Schedule`** (`schedule.dart:7-22`): `id, userId, dailyTargetHours, enabledWindowIds, weekStartDate?, aiReasoning?, isAIGenerated`.
- **`DayPlan`** (`day_plan.dart:9-31`): `date, blocks, exam?, isDone`. Getters `isToday` (`:22-27`), `totalDurationMinutes` (`:29-30`).
- **`WeekPlan`** (`week_plan.dart:8-22`): `id, scheduleId, startDate, endDate, days, aiReasoning?`.
- **`StudyWindow`** (`study_window.dart:7-20`): `id, label, startTime, endTime, isEnabled` — named time window from `kStudyWindowCatalog`.

`lib/core/models/subject/`:
- **`Subject`** (`subject.dart:7-21`): `id, code, name, colorHex, confidenceLevel, order`.
- **`Exam`** (`exam.dart:7-21`): `id, subjectId, date, label?`; getter `daysUntil` (`:20`).
- **`Topic`** (`topic.dart:9-23`): `id, subjectId, name, masteryPercentage, trend (TrendType up|down|flat), isWeak`.

**No "step/checklist/subtask" model** for a block exists anywhere; `activities` is the only per-block activity data (a single String).

**Session/timer data:** `SessionMetric` (`session_metric.dart:7-19`: `userId, date, durationMinutes, topicIds`) and the `SessionMetrics` Drift table (`progress_table.dart:40-47`) + `ProgressDao.insertSessionMetric` (`progress_dao.dart:37-38`) exist, but **no cubit in `lib/blocs/` reads or writes `SessionMetric`**. No active-session / countdown / elapsed state exists anywhere.

### 4. Tutor / chat stack

**Screen** (`lib/ui/screens/tutor/`): `TutorScreen` (`tutor.dart:41`) is a full-screen chat. `_BodyState.build` (`:74-107`) is a `BlocBuilder<ChatCubit, ChatState>`: when `state.active == null` shows `_Empty`, else `_ChatBar` + reverse `_MessageList` + `_Composer`. Messages render as `_AiBubble` / `_UserBubble`; the AI bubble renders markdown via `GptMarkdown`, a citations `Wrap`, an optional kicker question, and follow-up chips (`_ai_bubble.dart:5-75`).

**`ChatCubit`** (`lib/blocs/chat/cubit.dart`) + state (`state.dart`): state holds `send: BlocState<TutorMessage>`, `settings: BlocState<TutorSettings>`, `userId?`, `conversations`, `active?`, `messages`. Conversations and messages are **live Drift streams**. Methods: `initUid` (`:33`), `resetUid` (`:57`), `startConversation(subjectId)` (`:65`), `openConversation(id)` (`:77`), `send(text)` (`:93`), `deleteConversation(id)` (`:117`), `loadSettings`/`saveSettings`, `reset`. `send()` is single-shot `model.generateContent` (no token streaming); the reactive feel comes from the Drift stream.

**`ChatRepo`/`_ChatProvider`** (`lib/repos/chat/`): `send()` (`chat_data_provider.dart:43-118`) persists the user turn, pulls grounding via `MaterialRepo.ins.textsForSubject(userId, subjectId)`, assembles history `Content`, calls `AiService.ins.chatModel(...)` with `responseMimeType: application/json` + `AgentTools.ins.chatSchema`, parses `text`/`citations`/`followUpPoints`/`kickerQuestion`, assigns each citation a UUID, persists the AI message, and updates the conversation row (title, `groundedSourceCount`, `lastMessageAt`).

**Tutor models** (`lib/core/models/tutor/`): `Citation` (`id, source, pageReference?, colorHex?, libraryItemId?` — `colorHex` is on the model but never populated by the parser; the AI schema has no `colorHex`), `TutorMessage` (`id, conversationId, sender, text, timestamp, followUpPoints, citations, kickerQuestion?`; getter `isAI`), `TutorConversation` (`id, userId, subjectId, groundedSourceCount, createdAt, lastMessageAt, topicId?, title?`; `topicId` always written null at creation), `FollowUpPoint` (`label, body`), `TutorSettings` (`showCitationsOnEveryReply, scope, reasoningDepth`).

**Citation chip:** `_CitationChip` (`tutor/widgets/_citation_chip.dart:5-59`) is **screen-private** (`part of '../tutor.dart'`). Pill with hard-coded `LucideIcons.book_open` in `accent`, shows `source` or `source · pageReference`; tap opens `showAppAlert`. There is no shared/public citation chip in `lib/ui/widgets/`.

**Quiz scoring:** `QuizAttempt.isCorrect` and `QuizHistory` exist, but **no cubit or repo method returns a per-subject/per-topic score percentage** (e.g. a "62% quiz" value). `Quiz.sourceLabel` is a nullable string never linked to a citation.

### 5. Design system — sheets, rows, cards, ring

**Bottom sheet pattern** (canonical example: `library/widgets/_material_actions_sheet.dart:7-31`):
```dart
final action = await showModalBottomSheet<_MaterialAction>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  routeSettings: const RouteSettings(name: '/modal/material-actions'),
  builder: (_) => _MaterialActionsSheet(...),
);
if (!context.mounted) return;
switch (action) { ... }
```
`isScrollControlled: true` + `backgroundColor: Colors.transparent` + `routeSettings(name:)` (CLAUDE.md rule 14) + typed-enum return via `Navigator.pop(context, value)`.

**`AppModalBase`** (`lib/ui/widgets/design/modals/app_modal_base.dart:19-121`): reusable sheet base — `dragger` pill, optional header (40×40 rounded-square icon tile in `subBackground` + serif `title` + `subtitle`), `child`, `actions` column (8dp apart), `bottomSafe`, `expanded`, `padding`. The header icon slot (`:152-172`) is the rounded-square-icon-tile pattern.

**Action-row patterns (closest matches; both screen-private, none is a shared widget):**
- `_SheetAction` (`_material_actions_sheet.dart:147-198`) — `[icon][title + subtitle]` in a bordered `subBackground` row; **no trailing chevron**.
- `_SettingRow` (`profile/widgets/_settings.dart:75-122`) — `[icon slot][label][value?][chevron_right]`; **no subtitle**. Rows grouped in a bordered `_Section` card with hairline dividers.
- No existing widget combines `[rounded icon tile][title+subtitle][chevron]`.

**Other reusable widgets:** `AppButton` (`core/button/button.dart`, styles `.primary/.creamy/.error/.success`, `mainAxisSize: .max`), `AppIconButton` (round, `subBackground`), `AppEdgeCard` (`design/misc/app_edge_card.dart` — bordered card with colored left edge, good fit for a footer note callout), `AiReasoningCard` (`AppEdgeCard` + `AppAiPill` header + reasoning + footer), `AppAiPill`, `LibraryItemTile`, `AppCoreHeader`/`StackCenter` headers, `Screen` wrapper, `AppTouch` (tap wrapper), `showAppAlert` (`design/alerts/app_alert_base.dart` — centered dialog, auto-prefixes `/alert/<routeName>`).

**Circular progress ring:** **no determinate radial timer ring exists.** All `CircularProgressIndicator` usages are indeterminate spinners (`FullScreenLoader._RingSpinner` 64×64 `Stack` with centered child at `full_screen_loader.dart:78-99`; plus stepwise_loader/plan_placeholder/material_status). A determinate ring (arc + centered time label) must be built (`CircularProgressIndicator(value:)` or a `CustomPainter`). `CustomPainter`s that exist (`ripple_effect.dart` `CirclePainter`, `app_icon_painters.dart`) are unrelated to progress.

**Tokens:** `Space.x/y.t*` (gaps), `Space.a/h/v/t/b/l/r.t*` (padding), `Space.sym(h,v)`, `Space.top/bottom` (safe area), `Space.xf/yf(n)` (free-form). Named `SpaceToken`s defined: `t04,t08,t12,t16,t20,t24,t28,t32,t60,t100` (`configs/space/_tokens.dart:8-33`) — note `t48`/`t64` are listed in CLAUDE.md but **not defined in code**; use `Space.xf/yf` for those sizes. Typography `AppText.h1/h2/h3(+b), b1/b2(+b), l1/l1b` with extensions `.cl(color) .w(n) .fra() .gm() .urdu()`. Colors `AppTheme.c.{primary, accent, text, subText, background, subBackground, specBackground, border, error, success, warning}`.

### 6. Routing + screen scaffolding

- **Routes** (`lib/router/routes.dart`): `AppRoutes` = `static const` String paths — `profile, createAccount, onboarding, stepwiseLoader, progress, plan, tutor, library, splash, home, login`. **No `focus`/`session` route.**
- **Wiring** (`lib/router/router.dart`): plain routes in the `appRoutes` map (`:18-25`); `home, library, tutor, plan, progress` get a `FadeRoute` via the `onGenerateRoutes` switch (`:27-42`). `FadeRoute` (`:44-58`) is a `PageRouteBuilder` with a `FadeTransition`.
- **Navigation** (string extension `lib/configs/extension/_string.dart`): `'/route'.push(context)`, `.pushReplace(context)`, `.pushAndClear(context)`, `.pop(context)`, etc. Convention: tab destinations use `.pushReplace`; forward/detail pushes use `.push`.
- **Hygen `screen new <name>`** (`_templates/screen/new/`): generates `lib/ui/screens/<name>/<name>.dart` (StatelessWidget root → `ChangeNotifierProvider<_ScreenState>` → `_Body` → `Screen`), `_state.dart`, optional `static/_form_*.dart` (only `--formData true`), per-`--widgets` `widgets/_*.dart` part files, and a widget test. Injects `AppRoutes.<name>` into `routes.dart`, the import + an `appRoutes`-map entry into `router.dart` (map entry = no fade; a `FadeRoute` case is hand-added if desired). Also `screen consumer` (`BlocConsumer` + `FullScreenLoader` listener) and `screen listener` (`BlocListener`, no UI) generators.
- **Reference screen `lib/ui/screens/plan/`**: upgraded to `StatefulWidget` for `initState` cubit loads (`plan.dart:36-46`); `build` → `App.init` → `ChangeNotifierProvider<_ScreenState>` → `_Body` (`Screen` + `SafeArea` + header + `Expanded(BlocBuilder)`); reads cubits via `XCubit.c(context[, true])`, ephemeral UI via `_ScreenState.s(context[, true])`.
- **App-level wiring** (`lib/app.dart`): cubits are global, registered between `// bloc-initiate-start`/`-end` (`:51-60`) — `PlanCubit, ChatCubit, MaterialCubit, QuotesCubit, LibraryCubit, OnboardingCubit, UserCubit`; `hygen cubit nested` auto-injects here. App providers between `// provider-initiate-start`/`-end`. Screens read the already-registered cubit; only `_ScreenState` is provided per-screen.

## Code References
- `lib/ui/screens/home/_today_plan_card.dart:64` — "Begin next block" → `AppRoutes.plan.pushReplace(context)` (stub).
- `lib/ui/screens/home/_today_plan_card.dart:68-72` — reschedule `AppIconButton` with `onTap: () {}` ("placeholder no-op").
- `lib/core/models/schedule/study_block.dart:32-52` — `effectiveStatus()` (clock-derived) + `startDateTime`; `status` field reserved for Focus.
- `lib/repos/plan/plan_repo.dart:30-44` — `generate / watchBlocks / currentSchedule / exams` (no mutation methods).
- `lib/repos/plan/plan_data_provider.dart:89,101` — blocks written `status:'upcoming'`, `isDone:false`.
- `lib/core/db/daos/schedule_dao.dart:32-36` — `upsertBlock`, `deleteBlock` (latter uncalled).
- `lib/core/models/progress/session_metric.dart:7-19` + `lib/core/db/daos/progress_dao.dart:37-38` — `SessionMetric` model + `insertSessionMetric` (no cubit writes it).
- `lib/blocs/chat/cubit.dart:93` — `send(text)` single-shot Gemini.
- `lib/ui/screens/tutor/widgets/_citation_chip.dart:5-59` — screen-private citation pill.
- `lib/ui/widgets/design/modals/app_modal_base.dart:19-121` — reusable sheet base.
- `lib/ui/screens/library/widgets/_material_actions_sheet.dart:7-31,147-198` — sheet launch pattern + `_SheetAction` row.
- `lib/ui/screens/profile/widgets/_settings.dart:75-122` — `_SettingRow` chevron pattern.
- `lib/ui/widgets/design/full_screen_loader/full_screen_loader.dart:78-99` — `_RingSpinner` (indeterminate; structural reference for a ring+center-label).
- `lib/router/routes.dart`, `lib/router/router.dart:18-58` — route list, `appRoutes` map, `onGenerateRoutes`, `FadeRoute`.
- `lib/app.dart:51-60` — global cubit registration markers.

## Architecture Documentation
- **Layer boundary holds across the stack**: UI reads cubits via `XCubit.c(context)` and ephemeral state via `_ScreenState.s(context)`; cubits call repos returning Map/List/primitives (ADR-013) and do `Model.fromJson`. Plan UI is purely render-from-state; the only data write path for blocks today is bulk regeneration.
- **Status is derived, not stored**: home reads `StudyBlock.effectiveStatus()` (device clock) rather than the persisted `status` enum, which is reserved for an execution/Focus plan.
- **Reactivity via Drift streams**: both plan blocks (`watchBlocks`) and tutor conversations/messages are live streams, so any underlying row mutation propagates to the UI without explicit cubit emits.
- **Sheets/dialogs**: `showModalBottomSheet` + transparent background + `RouteSettings(name:)` + typed-enum return; `AppModalBase` is the shared sheet chrome; `showAppAlert` is the centered-dialog equivalent.
- **Screens**: scaffolded by hygen; `App.init(context)` first in every `build`; global cubits in `app.dart`, per-screen `_ScreenState` only.

## Related Docs
- `docs/research/2026-06-15-study-plan-generation.md` — plan/schedule models, Drift tables/DAO, Gemini generation (notes the absence of a Focus/execution screen).
- `docs/research/2026-06-14-chat-agent-integration.md` — tutor/chat agent integration.
- `docs/research/2026-06-13-library-feature-materials-module.md` — materials module + the `_material_actions_sheet` pattern.
- `docs/architecture/DECISIONS.md` — ADR-013 (repo layer returns Map/primitives).

## Open Questions
- **Prayer-time data** for a "Move to tonight · after Maghrib 19:30" affordance: the home greeting references "before Maghrib", but whether prayer times are available as data (vs. static copy) was not confirmed in this pass.
- **"Why this plan" re-write on reschedule**: `Schedule.aiReasoning` is written only by `generate`; whether a targeted reschedule would re-run generation or edit reasoning in place is undefined today (no mutation path exists).
