---
date: 2026-06-15T11:30:00+05:00
researcher: Claude (claude-opus-4-8)
git_commit: 0f321c5adfccc3a5a6c19fa6b5aec1e582e975c8
branch: main
repository: taleemmate
topic: "Study plan generation — what exists end-to-end (onboarding → home) and what's remaining to complete the plan UI, executions, and Gemini generation"
tags: [research, codebase, plan, schedule, study-block, firebase_ai, gemini, onboarding, home, focus, cubit, repo]
status: complete
last_updated: 2026-06-15
---

# Research: Study Plan Generation — End-to-End State

**Date**: 2026-06-15
**Git Commit**: `0f321c5`
**Branch**: `main`

## Research Question
What exists today for the study-plan-generation feature, from onboarding through the in-app home, and what's remaining — so the home UI showing plan blocks, their executions, and how they're generated (via Gemini/firebase_ai) can be completed. (Quiz generation is explicitly out of scope.)

## Summary

The plan feature is **fully scaffolded at the data-model and DB layers, has all its onboarding inputs collected and persisted, and reuses a proven firebase_ai structured-output pattern — but has zero generation logic, zero plan UI, and zero execution flow.** Naming note: the feature is called **"plan"** in the UI/route/tab but **"schedule"** in the models and DB. The schedule models (`Schedule`, `WeekPlan`, `DayPlan`, `StudyBlock`, `StudyWindow`) and Drift tables (`StudyWindows`, `Schedules`, `StudyBlocks`) + `ScheduleDao` exist and mirror the design 1:1. Onboarding collects subjects, exams, study windows, daily-target-hours and materials and persists them. What's **entirely missing**: a `schedule`/`plan` cubit+repo, the `planSchema` + `AiService.planModel()` + `SystemPrompts.plan()` glue, the (empty) `plan_sys_prompt.md`, the actual Gemini call that produces `StudyBlock`s, persistence/wiring of those blocks (none are ever created — `saveOnboardingData` saves the `Schedule` but no blocks), the home "Today's plan" + "Why this plan" cards, the plan-screen week timeline, and the Focus (execution) screen with block status transitions and reschedule. The stepwise loader's "Calibrating today's plan" step is currently a **fake 900 ms timer**.

## Detailed Findings

### 1. Data models — COMPLETE (`lib/core/models/schedule/` + `subject/`)

All freezed + json_serializable, fully generated. These map 1:1 onto the design's plan/home/focus screens.

- `schedule.dart:6` — **`Schedule`** `{id, userId, dailyTargetHours, enabledWindowIds[], weekStartDate?, isAIGenerated=true}`.
- `week_plan.dart:8` — **`WeekPlan`** `{id, scheduleId, startDate, endDate, days[], aiReasoning?}` — `aiReasoning` is the design's "Why this week"/"Why this plan" text.
- `day_plan.dart:9` — **`DayPlan`** `{date, blocks[], exam?, isDone}` + getters `isToday` (`day_plan.dart:22`) and `totalDurationMinutes` (`day_plan.dart:29`).
- `study_block.dart:6` — **`BlockStatus { done, now, upcoming }`** and **`StudyBlock`** `{id, scheduleId, dayOfWeek, date, startTime, durationMinutes, subjectId, title, activities, status, topicId?, aiInsight?, isAIGenerated=false}`. `activities` = the design's "via" line (e.g. "Tutor + Forouzan Ch. 24"); `aiInsight` = the gold per-block AI note.
- `study_window.dart:6` — **`StudyWindow`** `{id, label, startTime, endTime, isEnabled}`.
- `subject/subject.dart:6` — **`Subject`** `{id, code, name, colorHex, confidenceLevel, order}`.
- `subject/exam.dart:6` — **`Exam`** `{id, subjectId, date, label?}` + getter `daysUntil` (`exam.dart:20`) — drives "Midterm in 4d".
- `subject/topic.dart:8` — **`Topic`** `{id, subjectId, name, masteryPercentage, trend(up/down/flat), isWeak}` — the signal for "your last quiz scored 62%, lowest of the week" reasoning.

`WeekPlan` and `DayPlan` are **in-memory aggregations only** — there is no `WeekPlans`/`DayPlans` Drift table. `aiReasoning` has no persistence column anywhere (see §3 gap).

### 2. Onboarding inputs — COLLECTED & PERSISTED

`OnboardingData` (`lib/core/models/onboarding/onboarding_data.dart:37`) carries everything plan generation needs:
`{userId, step, name, educationLevel, year?, goal, subjects[], exams[], institution?, schedule?, uploadedMaterials[]}`.

- Step 3 ("Your rhythm") collects study windows + daily target hours. Windows are **static constants**, not DB rows: `lib/ui/screens/onboarding/static/_data.dart:5` → `('afterFajr','After Fajr','05:30-07:00')`, `morning`, `afternoon`, `evening`, `('afterIsha','After Isha','21:00-23:00')`. The user's picks live in `_state.dart:34` (`enabledWindowIds`) and `dailyTargetHours`, assembled into a `Schedule` at `lib/ui/screens/onboarding/_state.dart:246`.
- The `StudyWindows` Drift table exists but **is never seeded/populated** — `enabledWindowIds` on the saved `Schedule` references the static constant ids above. `ScheduleDao.allWindows()` would return empty today.
- Persistence path: `OnboardingCubit.complete()` (`lib/blocs/onboarding/cubit.dart:31`) → `OnboardingRepo.complete()` (`lib/repos/onboarding/onboarding_repo.dart:21`) → `_OnboardingProvider.complete()` (`lib/repos/onboarding/onboarding_data_provider.dart:17`) → `AppDatabase.ins.saveOnboardingData(values)`.
- `saveOnboardingData` (`lib/core/db/database.dart:~120-200`) upserts **subjects** (`:120`), **exams** (`:135`), the **Schedule** (`database.dart:149-159`, only if non-null), and **library items** (`:163`) — all in one transaction. **It does NOT create any `StudyBlock`s.** No plan is generated here.
- Completion side-effects: `_CompleteListener` (`lib/ui/screens/onboarding/listeners/_complete.dart:14-24`) fires background material extraction (`MaterialCubit.process(item)` per upload) and then `AppRoutes.stepwiseLoader.pushReplace(context)`.

### 3. Persistence layer — TABLES READY, NO BLOCKS WRITTEN

- `lib/core/db/tables/schedule_table.dart` — `StudyWindows` (`:8`), `Schedules` (`:20`), `StudyBlocks` (`:33`). `StudyBlocks` columns match `StudyBlock` exactly, incl. `status` via `EnumConverter<BlockStatus>` (`:44`) and FKs to `Schedules`/`Subjects`/`Topics`.
- `lib/core/db/daos/schedule_dao.dart` — `ScheduleDao` (registered in `database.dart:75`): `allWindows()`, `findByUser(userId)` (`:10`), `watchBlocksForDate(date)` (`:14`), `watchBlocksForSchedule(scheduleId)` ordered by date+startTime (`:17`), `upsertWindow/upsertSchedule/upsertBlock` (`:26-32`), `deleteBlock(id)` (`:35`).
- **Gaps:** (a) no rows are ever written to `StudyBlocks`; (b) there is **no column for `aiReasoning`** ("Why this plan") on `Schedules` or anywhere — persisting it needs a new column or table; (c) `WeekPlan`/`DayPlan` have no tables (they'd be assembled in the cubit from `StudyBlocks` + `Exam`s).

### 4. AI infrastructure — REUSABLE TEMPLATE EXISTS (firebase_ai / Gemini)

There are **two working AI features today** (library extraction + grounded chat), both on `firebase_ai`. The chat path is the exact template for plan generation (single-shot, structured JSON output).

- **Service wrapper** `lib/services/firebase/ai/ai_service.dart`:
  - `AiService.ins` singleton, piggybacks on `Firebase.initializeApp()` (no separate init).
  - Models: `gemini-2.5-flash` for both extraction and chat (`:17,:20`).
  - `extractText(bytes, mime)` (`:38`) — multimodal extraction (used by library/material).
  - **`chatModel(systemPrompt)` (`:53`)** — the structured-output template: builds a `GenerativeModel` with `GenerationConfig(responseMimeType: 'application/json', responseSchema: AgentTools.ins.chatSchema)` and a `Content.system(systemPrompt)` instruction, built once and cached.
- **Schemas** `lib/services/firebase/ai/agent_tools.dart` — `AgentTools.ins.chatSchema` (`:15`) shows the `Schema.object` / `Schema.array` / `Schema.string(nullable:, description:)` / `optionalProperties` API to copy for a `planSchema`.
- **Prompts** `lib/services/firebase/ai/system_prompts.dart` — `SystemPrompts` loads `assets/*.md` once via `rootBundle.loadString` and caches (`:15`). Getters today: `chat()` (`:19`), `library()` (`:22`). **No `plan()` getter.**
- **Canonical AI flow** = `_ChatProvider.send()` (`lib/repos/chat/chat_data_provider.dart:43-118`): (1) gather grounding via `MaterialRepo.ins.textsForSubject(userId, subjectId)` (`:69`), (2) build a grounding block tagged `[itemId | name]` clipped to a char budget (`_groundingBlock`, `:148`), (3) assemble `List<Content>`, (4) `AiService.ins.chatModel(await SystemPrompts.chat()).generateContent(contents)` (`:83-84`), (5) `_parseReply(res.text)` = `jsonDecode` → Map (`:195-209`), (6) persist, (7) convert `FirebaseAIException` → `AiFault.fromAiException` and other errors → `UnknownFault` (`:111-117`).
- **Repo/cubit shape** to copy: `MaterialRepo` (`lib/repos/material/material_repo.dart`) and `MaterialCubit` (`lib/blocs/material/cubit.dart`) — singleton repo with `part` files (`*_mocks.dart`, `*_parser.dart`, `*_data_provider.dart`), `BlocState<T>` with `.toLoading/.toSuccess/.toFailed`, ADR-013 Map in/out, cubit does `Model.fromJson`.

### 5. UI shells — WIRED BUT EMPTY

- **Home** `lib/ui/screens/home/home.dart` — renders only `_Header()` (`home.dart:57`); `initState` pre-loads `QuotesCubit.today()` (`:26-30`). No plan UI. Reads only `QuotesCubit`/`UserCubit`. Design wants a "Today's plan" summary card (`3 of 5`, progress meter, `PlanRow`s, "Begin next block"/Reschedule) + a "Why this plan" AI card + recent uploads + quick-tutor + reminder (see design `home.jsx`).
- **Plan** `lib/ui/screens/plan/plan.dart` — empty `Screen` with `Column(children: [])` (`plan.dart:30-38`); `_state.dart` is the bare accessor (`plan/_state.dart`). Design wants a week strip, exam marker, "Why this week" card, and a vertical timeline of `Block`s (design `plan.jsx`).
- **Stepwise loader** `lib/ui/screens/stepwise_loader/stepwise_loader.dart` — renders 4 steps incl. **"Calibrating today's plan"** (`:32`). Its `_state.dart` `startSequenceIfNeeded` (`stepwise_loader/_state.dart:14-31`) is a **fake `Timer.periodic(900ms)`** that advances UI ticks and then `AppRoutes.home.pushReplace`. **This is the natural hook for real plan generation.**
- **Routing/tabs** — `AppRoutes.plan = '/plan'`, `home = '/home'`, `stepwiseLoader = '/stepwise-loader'` (`lib/router/routes.dart:5,7,11`); loader registered (`lib/router/router.dart:20`). Plan is a bottom-bar tab (`lib/ui/widgets/core/bottom_bar/_data.dart` — label "Plan", `LucideIcons.calendar`). `Screen` auto-injects the bottom bar for the 5 tab routes.
- **Registered cubits** (`lib/app.dart:51-56`): Chat, Material, Quotes, Library, Onboarding, User. **No Schedule/Plan cubit.**

### 6. Focus / execution — DOES NOT EXIST

There is **no `lib/ui/screens/focus/`** (nor any session/timer screen) and no focus route. The design's Focus screen (`focus.jsx`) needs: a countdown timer ring, a per-block goals checklist (done/active/pending), a "Guided by Tutor" card linking to chat with grounded sources, "I'm stuck" → tutor, and "Mark block done". Block status lives in `BlockStatus`/`StudyBlock.status` and `ScheduleDao.upsertBlock` exists, but **no logic computes the "now" block or transitions status**. The design's Reschedule sheet (`dialogs.jsx` `RescheduleSheet` — snooze/move/shorten/skip + AI re-plan note) has no code either.

## What's Remaining (checklist to ship study-plan generation)

1. **Author** `assets/plan_sys_prompt.md` (currently 0 lines / empty) — week-plan generation prompt: inputs = subjects (+confidence), exams (+daysUntil), enabled windows & times, daily target hours, weak topics, grounded material; output rules for blocks/activities/aiInsight/aiReasoning, Urdu/English.
2. **Add** `SystemPrompts.plan()` getter (`system_prompts.dart`) → `Assets.planSysPrompt` (constant already generated).
3. **Add** `AgentTools.planSchema` (`agent_tools.dart`) — `Schema.object` for `{aiReasoning, days:[{date, blocks:[{startTime, durationMinutes, subjectId, topicId?, title, activities, aiInsight?}]}]}` (mirror `WeekPlan`→`DayPlan`→`StudyBlock`).
4. **Add** `AiService.planModel(systemPrompt)` (`ai_service.dart`) — JSON structured model, same shape as `chatModel`.
5. **Generate** the cubit + repo: `hygen cubit nested schedule` (or `plan`) → `lib/blocs/schedule/` + `lib/repos/schedule/` (auto-registers in `app.dart`). Repo `generate()` gathers inputs (subjects/exams/schedule + `MaterialRepo.textsForSubject` grounding + weak topics), calls `planModel`, parses JSON into `StudyBlock` maps, persists via `ScheduleDao.upsertBlock`; expose `watchBlocksForSchedule`/`watchBlocksForDate`, `markDone(blockId)`, `reschedule(...)`. Follow ADR-013 (Map in/out).
6. **Persist `aiReasoning`** — add a column (e.g. to `Schedules`) or a small `WeekPlans` table; current schema drops it (needs a Drift migration + `build_runner`).
7. **Wire real generation into the stepwise loader** — replace the fake timer in `stepwise_loader/_state.dart` with a real `ScheduleCubit.generate()` call driving the "Calibrating today's plan" step, then route to home on success (handle failure → retry/UIFlash).
8. **Home plan UI** — "Today's plan" card (meter, `PlanRow`s for today's `StudyBlock`s, "Begin next block" → Focus, Reschedule) + "Why this plan" AI card (uses `WeekPlan.aiReasoning`, nearest `Exam.daysUntil`, available hours). Reuse `AppAiPill`, `AppIconButton`, `Screen`, `Space`/`AppText` tokens.
9. **Plan screen UI** — week strip (7 days w/ block-count dots + exam markers), "Why this week" card, vertical block timeline (`Block` w/ time column, spine+dot, now/done/upcoming states, `aiInsight` chip). Use `.map()` over days/blocks (rule 11).
10. **Focus (execution) screen + route** — `hygen screen new focus` + `AppRoutes.focus`: timer ring, goals checklist, "Guided by Tutor" (deep-link to chat for the block's subject, grounded), "Mark block done" → `markDone`, "I'm stuck" → tutor.
11. **Reschedule sheet** — bottom sheet (`showModalBottomSheet` with `RouteSettings(name:)` per rule 14) with snooze/move/shorten/skip → repo re-plan + refresh "Why this plan".
12. **Seed `StudyWindows`** (optional) if any screen reads windows from the DB; today they're static constants and the plan only needs `enabledWindowIds` + the constant times.

## Code References
- `lib/core/models/schedule/{schedule,week_plan,day_plan,study_block,study_window}.dart` — plan model set (complete)
- `lib/core/models/subject/{subject,exam,topic}.dart` — subjects/exams/topics
- `lib/core/models/onboarding/onboarding_data.dart:37` — onboarding payload (plan inputs)
- `lib/core/db/tables/schedule_table.dart` — `StudyWindows`/`Schedules`/`StudyBlocks`
- `lib/core/db/daos/schedule_dao.dart` — `ScheduleDao` (CRUD + watch streams)
- `lib/core/db/database.dart:120-200` — `saveOnboardingData` (saves Schedule, NOT blocks)
- `lib/services/firebase/ai/ai_service.dart:53` — `chatModel` (structured-output template)
- `lib/services/firebase/ai/agent_tools.dart:15` — `chatSchema` (Schema API template)
- `lib/services/firebase/ai/system_prompts.dart` — prompt loader/cache (`chat()`, `library()`)
- `lib/repos/chat/chat_data_provider.dart:43-209` — canonical Gemini call + JSON parse + Fault mapping
- `lib/repos/material/material_repo.dart`, `lib/blocs/material/cubit.dart` — repo/cubit scaffold to copy
- `lib/ui/screens/stepwise_loader/_state.dart:14-31` — fake-timer "Calibrating plan" (hook point)
- `lib/ui/screens/onboarding/listeners/_complete.dart:14-24` — completion → extraction + loader
- `lib/ui/screens/home/home.dart`, `lib/ui/screens/plan/plan.dart` — empty UI shells
- `lib/ui/widgets/core/bottom_bar/_data.dart` — Plan tab; `lib/router/routes.dart:5,7,11` — routes
- `assets/plan_sys_prompt.md` — EMPTY (0 lines); `assets/chat_sys_prompt.md` (109 lines), `assets/library_extraction_sys_prompt.md` (real)
- Design source: `/tmp/tm_design/taleemmate/project/screens/{home,plan,focus,loading,dialogs,onboarding-steps}.jsx`

## Architecture Documentation
- **Naming**: feature surface = "plan" (route/tab/screen), data layer = "schedule" (models/DB). A `schedule` cubit/repo aligns with models; a `plan` cubit/repo aligns with the UI. Pick one and stay consistent.
- **Layer boundary**: UI reads via `ScheduleCubit.c(context)` / `_ScreenState.s(context)`; repo wraps `firebase_ai` + `ScheduleDao`; cubit does `Model.fromJson`. Convert `FirebaseAIException` → `AiFault` before emit (rule 5).
- **Repo purity (ADR-013)**: schedule repo public methods take/return `Map`/`List<Map>`/primitives; cubit converts to `StudyBlock`/`WeekPlan`.
- **Structured output**: define a `Schema` in `AgentTools`, set `GenerationConfig(responseMimeType:'application/json', responseSchema:…)`, `jsonDecode(res.text)` into Maps (mirror `_ChatProvider`).
- **Generators**: `hygen cubit nested schedule`, `hygen screen new focus`, `hygen screen _widget` for plan/home cards — never hand-create (rule 4).
- **Design tokens**: every `build()` calls `App.init(context)`; spacing via `Space.x/y/a.t*`; type via `AppText.*`; colors via `AppTheme.c.*`; lists via `.map()` (rule 11).

## Related Docs
- `docs/research/2026-06-14-chat-agent-integration.md` — chat/tutor firebase_ai integration (sibling AI feature; same service/schema/prompt infra)
- `docs/features/CATALOGUE.md` — feature specs (Plan/Tutor scope)
- `docs/architecture/DECISIONS.md` — ADR-008 (firebase_ai), ADR-013 (repo purity)
- `docs/architecture/FIREBASE.md` — firebase_ai usage rules

## Open Questions
1. **Generation scope**: generate the whole `WeekPlan` (7 days) at onboarding, or just "today" first then roll forward daily? Design shows both a week (plan screen) and today (home).
2. **`aiReasoning` persistence**: add a column to `Schedules`, a new `WeekPlans` table, or keep it transient and regenerate? Affects the Drift migration.
3. **Grounding**: should plan generation be grounded in extracted material texts (like chat) and weak `Topic`s, or scheduled purely from subjects/exams/windows in v1? Material extraction runs in the background during the loader — may not be finished when the plan is generated.
4. **Regeneration triggers**: when does the plan re-generate — daily, on reschedule, after a quiz score, on new material? Reschedule sheet implies on-demand re-plan.
5. **Topic source**: `Topic.masteryPercentage`/`isWeak` power the reasoning, but onboarding doesn't collect topics — where do they come from before any quiz exists (out of scope here but blocks "Why this plan" specifics)?
6. **Block "now" computation**: derive `BlockStatus.now` live from device time vs. persist it — persisted status needs a refresh strategy.
7. **Naming decision**: `schedule` vs `plan` for the new cubit/repo/blocs directory.
