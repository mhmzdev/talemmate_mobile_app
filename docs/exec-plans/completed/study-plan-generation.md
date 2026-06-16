---
title: "Study Plan Generation (v1) — AI pipeline, data & read UIs"
status: completed
created: 2026-06-15
completed: 2026-06-16
---

✅ COMPLETED — All phases implemented, merged to main, and driver-verified (new-account + existing-account flows).

# Study Plan Generation (v1) — Implementation Plan

## Overview

Build the study-plan **generation pipeline** end-to-end: take the inputs onboarding already collects (subjects + confidence, exams, study windows, daily target hours), call Gemini once to produce a structured **7-day `WeekPlan`** of `StudyBlock`s plus a "Why this week" reasoning string, persist them locally, and render them on the home and plan screens. Generation is wired into the existing post-onboarding stepwise loader (replacing its fake timer).

This plan deliberately stops at **generation + read UIs**. Execution (Focus screen), reschedule/snooze, and per-block goal checklists are separate plans.

## Current State Analysis

The data + AI layers are fully scaffolded; generation logic and UI are absent. (Full detail: `docs/research/2026-06-15-study-plan-generation.md`.)

**Naming**: feature surface = "plan" (route/tab/screen); data layer = "schedule" (models/tables/DAO). Per the decision below, the new cubit/repo are named **`plan`** (matching the UI surface, mirroring the existing `chat` bloc ↔ `tutor` models split); they operate on the `schedule` models/DAO.

Key files:
- `lib/core/models/schedule/{schedule,week_plan,day_plan,study_block,study_window}.dart` — model set complete. `StudyBlock{startTime, durationMinutes, subjectId, title, activities, status(BlockStatus), topicId?, aiInsight?, isAIGenerated}`; `WeekPlan.aiReasoning?`; `DayPlan.isToday`/`totalDurationMinutes`.
- `lib/core/models/subject/{subject,exam}.dart` — `Subject.confidenceLevel`, `Exam.daysUntil`.
- `lib/core/db/tables/schedule_table.dart` — `StudyWindows`/`Schedules`/`StudyBlocks`. **No `aiReasoning` column.**
- `lib/core/db/daos/schedule_dao.dart` — `ScheduleDao`: `findByUser`, `watchBlocksForSchedule`, `upsertSchedule`, `upsertBlock`, `deleteBlock`, `allWindows` (currently unused — windows are never seeded).
- `lib/core/db/database.dart:93` — `schemaVersion = 2`, `MigrationStrategy` with `onUpgrade` `if (from < N)` blocks; `saveOnboardingData` (`:110`) saves the `Schedule` but **no blocks** and **no windows**.
- `lib/services/firebase/ai/ai_service.dart:53` — `chatModel(systemPrompt)` = the structured-JSON template (`GenerationConfig(responseMimeType:'application/json', responseSchema:…)`).
- `lib/services/firebase/ai/agent_tools.dart:15` — `chatSchema` (Schema API to copy).
- `lib/services/firebase/ai/system_prompts.dart` — cached `rootBundle` loader; `chat()`/`library()` only.
- `lib/repos/chat/chat_data_provider.dart:43-209` — canonical Gemini call + `jsonDecode` parse + `AiFault` mapping; ADR-013 Map in/out.
- `lib/blocs/material/cubit.dart`, `lib/repos/material/material_repo.dart` — cubit/repo scaffold to mirror.
- `lib/ui/screens/stepwise_loader/_state.dart:14-31` — **fake `Timer.periodic(900ms)`** → `AppRoutes.home.pushReplace`. Generation hook.
- `lib/ui/screens/onboarding/listeners/_complete.dart:14-24` — onboarding success → fire material extraction → push loader.
- `lib/ui/screens/{home/home.dart,plan/plan.dart}` — empty shells. `home.dart` renders `_Header()` only.
- `lib/ui/screens/onboarding/static/_data.dart:5` — canonical study-window ids/labels/times as records (`afterFajr`, `morning`, `afternoon`, `evening`, `afterIsha`).
- `assets/plan_sys_prompt.md` — **EMPTY (0 lines)**. `Assets.planSysPrompt` constant already generated.
- Reusable widgets: `lib/ui/widgets/design/misc/app_ai_pill.dart` (`AppAiPill({text='AI'})`), `lib/ui/widgets/core/buttons/app_icon_button.dart` (`AppIconButton`), `lib/ui/widgets/core/screen/screen.dart` (`Screen` auto-injects bottom bar + tab routes), `lib/ui/widgets/core/button/button.dart`.

## Desired End State

After onboarding completes, the stepwise loader runs a **real** Gemini call that writes a 7-day set of `StudyBlock`s + a `WeekPlan.aiReasoning` to Drift, then lands on home. Home shows a "Today's plan" card (progress + today's blocks) and a "Why this plan" AI card; the Plan tab shows a week strip + "Why this week" + a vertical timeline of the selected day's blocks. Re-launching the app reads the persisted plan (no re-generation). Verifiable via the Dart MCP driver and a fresh onboarding run on the stage flavor.

## What We're NOT Doing

- **Focus / execution screen**, the in-block timer, "Mark block done", and live status transitions (separate plan). Block `status` is computed for display only here.
- **Reschedule / snooze** sheet and any AI re-plan pass.
- **Per-block goals checklist** (no model backing; dropped for v1).
- **Material/weak-topic grounding** of generation (decision below) and quiz/topic data sources.
- **Regeneration triggers** (daily roll-forward, post-quiz). One generation at onboarding; manual re-generate is a thin extra but not wired to UI here.
- **Seeding/using the `StudyWindows` DB table** as the source of truth — windows come from a shared const catalog (the empty table is left for a future plan).

## Implementation Approach

**Decisions (confirmed with user):**
- **(a) Generate the full week (7 days)** in one call → one `WeekPlan` with `days[]`.
- **(b) Name the cubit/repo `plan`** (`lib/blocs/plan/`, `lib/repos/plan/`), operating on `schedule` models + `ScheduleDao`.
- **(c) Pure inputs**: subjects (+`confidenceLevel`), exams (`daysUntil`), enabled study windows + times, daily target hours. No material/topic grounding in v1.

**Layering** (ADR-013): `PlanRepo` public methods take/return `Map`/`List<Map>`/primitives; `PlanCubit` does `WeekPlan.fromJson`. Gemini + Drift access live behind `PlanRepo` (via `AiService` + `AppDatabase` Map-wrappers). `FirebaseAIException` → `AiFault`; other failures → `UnknownFault`.

**Window source**: extract the canonical windows into a shared const catalog in `lib/core/` (single source of truth), referenced by both the onboarding UI and `PlanRepo`, so `enabledWindowIds` always resolves to real times without a UI→repo import.

**Status for display**: blocks are generated as `upcoming`; a pure helper derives effective `BlockStatus` (done/now/upcoming) from device time vs `date`+`startTime`+`durationMinutes` at render. Stored status is reserved for the future Focus plan.

---

## Phase 1: AI plumbing — prompt, schema, model, loader

### Overview
Stand up the Gemini surface for plan generation with no UI. Independently testable via a scratch call / unit-ish check.

### Changes Required

#### 1. System prompt
**File**: `assets/plan_sys_prompt.md` (currently empty)
**Changes**: Author a week-plan generator prompt. Spec: role = study planner for a Pakistani student; **inputs** (provided in the user turn) = student profile (level/goal), subjects with `id`+`name`+`confidenceLevel` (lower confidence ⇒ more/earlier time), upcoming exams with `subjectId`+date+`daysUntil` (front-load subjects with near exams; heavier load in the days before, lighter recall after), enabled study windows (`id`,`label`,`HH:mm-HH:mm`) and daily target hours (only schedule inside windows; respect the daily total ±, don't exceed window capacity), today's date + 7-day range. **Output rules**: return ONLY JSON matching the schema; `startTime` 24h `HH:mm` inside a window; `durationMinutes` realistic (20–90); every `subjectId` must be one of the provided ids; `activities` = short method line (e.g. "Read + summarize", "Recall + 5 questions", "Walkthrough"); optional `aiInsight` gold note for at most the highest-impact block/day; one-paragraph `aiReasoning` ("Why this week") in the student's language; no blocks on days with nothing to do is fine. No prose outside JSON.

#### 2. Prompt loader
**File**: `lib/services/firebase/ai/system_prompts.dart`
**Changes**: add getter mirroring `chat()`:
```dart
/// Weekly study-plan generation prompt (`assets/plan_sys_prompt.md`).
static Future<String> plan() => _load(Assets.planSysPrompt);
```

#### 3. Response schema
**File**: `lib/services/firebase/ai/agent_tools.dart`
**Changes**: add `planSchema` (mirrors `WeekPlan`→`DayPlan`→`StudyBlock`, omitting fields the app fills: id/scheduleId/dayOfWeek/status/isAIGenerated):
```dart
Schema get planSchema => Schema.object(
  properties: {
    'aiReasoning': Schema.string(
      description: "One short paragraph explaining the week's strategy, "
          'in the student\'s language (Urdu / English / Roman Urdu).',
    ),
    'days': Schema.array(
      description: 'Up to 7 day entries covering the week range. Days with '
          'no study are allowed to be omitted.',
      items: Schema.object(
        properties: {
          'date': Schema.string(description: 'ISO-8601 date (yyyy-MM-dd).'),
          'blocks': Schema.array(
            items: Schema.object(
              properties: {
                'startTime': Schema.string(description: '24h HH:mm, inside an enabled window.'),
                'durationMinutes': Schema.integer(description: 'Block length, 20–90.'),
                'subjectId': Schema.string(description: 'One of the provided subject ids.'),
                'title': Schema.string(description: 'Concise topic/goal for the block.'),
                'activities': Schema.string(description: 'Short method line, e.g. "Read + summarize".'),
                'aiInsight': Schema.string(nullable: true, description: 'Optional gold note for a high-impact block.'),
              },
              optionalProperties: ['aiInsight'],
            ),
          ),
        },
      ),
    ),
  },
);
```

#### 4. Generative model
**File**: `lib/services/firebase/ai/ai_service.dart`
**Changes**: add a `_planner` field + `planModel`, mirroring `chatModel`:
```dart
static const _planModel = 'gemini-2.5-flash';
GenerativeModel? _planner;

/// Structured weekly-plan generator: JSON-only output ([AgentTools.planSchema]).
GenerativeModel planModel(String systemPrompt) =>
    _planner ??= FirebaseAI.googleAI().generativeModel(
      model: _planModel,
      systemInstruction: Content.system(systemPrompt),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: AgentTools.ins.planSchema,
      ),
    );
```

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` — zero new errors.
- [ ] `assets/plan_sys_prompt.md` is non-empty and listed under `flutter_gen` (`Assets.planSysPrompt` resolves — already generated).

#### Manual Verification
- [ ] `SystemPrompts.plan()` returns the prompt text (temporary debug print or unit harness).

**Implementation Note**: Pause for manual confirmation before Phase 2.

---

## Phase 2: Persistence — `aiReasoning` column, window catalog, DB wrappers

### Overview
Add storage for the reasoning string, a single source of truth for study windows, and the Map-based `AppDatabase` methods the repo needs.

### Changes Required

#### 1. `aiReasoning` on the schedule
**Files**: `lib/core/models/schedule/schedule.dart`, `lib/core/db/tables/schedule_table.dart`
**Changes**: add `String? aiReasoning` to the `Schedule` freezed model; add `TextColumn get aiReasoning => text().nullable()();` to the `Schedules` table. (Reasoning lives on the per-user `Schedule` row; `WeekPlan.aiReasoning` is hydrated from it.)

#### 2. Drift migration
**File**: `lib/core/db/database.dart`
**Changes**: bump `schemaVersion` to **3**; extend `onUpgrade`:
```dart
if (from < 3) await m.addColumn(schedules, schedules.aiReasoning);
```

#### 3. Study-window catalog (shared const)
**File**: `lib/core/constants/study_windows.dart` (new)
**Changes**: define the canonical list as `StudyWindow`s:
```dart
const kStudyWindowCatalog = <StudyWindow>[
  StudyWindow(id: 'afterFajr',  label: 'After Fajr', startTime: '05:30', endTime: '07:00'),
  StudyWindow(id: 'morning',    label: 'Morning',    startTime: '09:00', endTime: '12:00'),
  StudyWindow(id: 'afternoon',  label: 'Afternoon',  startTime: '14:00', endTime: '16:00'),
  StudyWindow(id: 'evening',    label: 'Evening',    startTime: '16:30', endTime: '19:00'),
  StudyWindow(id: 'afterIsha',  label: 'After Isha', startTime: '21:00', endTime: '23:00'),
];
```
Refactor `lib/ui/screens/onboarding/static/_data.dart` to derive its window UI list from `kStudyWindowCatalog` (keeps the ids identical so `enabledWindowIds` resolves in the repo).

#### 4. `AppDatabase` Map-wrappers
**File**: `lib/core/db/database.dart`
**Changes**: add (keeping the repo model-free, like `saveTutorMessage` etc.):
```dart
Future<Map<String, dynamic>?> scheduleForUser(String userId);          // ScheduleDao.findByUser → Schedule.toJson
Future<void> updateScheduleReasoning(String scheduleId, String reasoning);
Future<void> replaceStudyBlocks(String scheduleId, List<Map<String, dynamic>> blocks); // txn: delete schedule's blocks, insert new
Stream<List<Map<String, dynamic>>> watchStudyBlocks(String scheduleId); // ScheduleDao.watchBlocksForSchedule → List<StudyBlock.toJson>
```
Add `ScheduleDao.deleteBlocksForSchedule(scheduleId)` to support the txn replace.

### Hygen Commands
_None — model/table/db edits + build_runner._

### Success Criteria
#### Automated Verification
- [ ] `flutter pub run build_runner build --delete-conflicting-outputs` clean (freezed + drift regenerate).
- [ ] `flutter analyze` — zero new errors.

#### Manual Verification
- [ ] Fresh install creates the v3 schema; an upgrade from v2 adds the column without data loss (open app twice).
- [ ] Onboarding window picker still shows the 5 windows with the same ids/times.

**Implementation Note**: Pause for manual confirmation before Phase 3.

---

## Phase 3: `plan` cubit + repo (generation)

### Overview
The generation engine: gather inputs → call Gemini → parse → persist → expose a watchable week.

### Changes Required

#### 1. Generate the scaffold
**Hygen**: `hygen cubit nested plan` → creates `lib/blocs/plan/{cubit,state}.dart` + `lib/repos/plan/{plan_repo,plan_mocks,plan_parser,plan_data_provider}.dart`, auto-registered in `lib/app.dart`.

#### 2. Repo — generation + read
**Files**: `lib/repos/plan/plan_repo.dart` (+ `plan_data_provider.dart`)
**Changes**: public methods (ADR-013, Map in/out):
- `Future<Map<String, dynamic>> generate(String userId)` — `_PlanProvider.generate`:
  1. Read `scheduleForUser(userId)` (+ subjects/exams via `SubjectDao` Map-wrappers — add `subjectsForUser`/`examsForUser` wrappers if absent).
  2. Resolve enabled windows from `kStudyWindowCatalog` by `schedule.enabledWindowIds`.
  3. Build the user turn (profile + subjects+confidence + exams+daysUntil + windows + dailyTargetHours + today/range).
  4. `AiService.ins.planModel(await SystemPrompts.plan()).generateContent([Content.text(userTurn)])`.
  5. `jsonDecode(res.text)` → for each day/block, build a `StudyBlock.toJson()` map: generate `id` (uuid), set `scheduleId`, `date` (parsed), `dayOfWeek` (`date.weekday`), `status: 'upcoming'`, `topicId: null`, `isAIGenerated: true`.
  6. `replaceStudyBlocks(scheduleId, blocks)` + `updateScheduleReasoning(scheduleId, aiReasoning)`.
  7. Return a `WeekPlan.toJson()`-shaped map `{id, scheduleId, startDate, endDate, days, aiReasoning}`.
  - Errors: `on FirebaseAIException → AiFault.fromAiException`; empty/invalid JSON → `FormatException`→`UnknownFault`; else `UnknownFault('Couldn\'t build your plan. Please try again.')`.
- `Stream<List<Map<String, dynamic>>> watchBlocks(String scheduleId)` → `watchStudyBlocks`.
- `Future<Map<String, dynamic>?> currentSchedule(String userId)` → `scheduleForUser`.

#### 3. Cubit — state machine
**Files**: `lib/blocs/plan/{cubit,state}.dart`
**Changes**:
- State (`BlocState<T>`): `generate: BlocState<WeekPlan>` and `week: BlocState<WeekPlan>` (assembled from watched blocks + schedule), or a single `BlocState<WeekPlan>` plus a blocks stream subscription. Mirror `QuotesCubit`/`MaterialCubit`.
- `Future<void> generate(String userId)` — `toLoading` → `PlanRepo.ins.generate(userId)` → `WeekPlan.fromJson` → `toSuccess`; `on Fault → toFailed`.
- `void watch(String scheduleId)` — subscribe to `watchBlocks`, group into `DayPlan`s (+ attach `Exam` per day) → emit `WeekPlan` into `week`.
- `WeekPlan?` convenience getters (today's `DayPlan`, next block) for the UI.
- Helper `BlockStatus effectiveStatus(StudyBlock)` (pure, device-time based) — placed in cubit or a `lib/blocs/plan/_status.dart` util.

#### 4. Status helper
**File**: `lib/core/models/schedule/study_block.dart` (extension) or `lib/blocs/plan/` util
**Changes**: `BlockStatus` from `date`+`startTime`+`durationMinutes` vs `DateTime.now()`.

### Hygen Commands
```bash
hygen cubit nested plan      # lib/blocs/plan/ + lib/repos/plan/, registers in app.dart
```

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` — zero new errors.

#### Manual Verification (Dart MCP driver)
- [ ] Temporary trigger (debug button or test_driver) runs `generate` against the emulator and writes blocks (inspect via a `watchBlocks` log or DB).
- [ ] Eyeball one generated payload: every `subjectId` is valid, `startTime`s fall inside enabled windows, `aiReasoning` is present and in the student's language.

**Implementation Note**: Pause for manual confirmation before Phase 4.

---

## Phase 4: Wire real generation into the stepwise loader

### Overview
Replace the loader's fake timer with the real `PlanCubit.generate`, keeping the 4-step visual but gating the final nav on actual completion.

### Changes Required

#### 1. Loader sequence
**File**: `lib/ui/screens/stepwise_loader/_state.dart`
**Changes**: drop the pure 900ms auto-advance. Steps map to real progress: mark steps 1–2 done quickly (subjects/material already saved by onboarding), set step 3 ("Calibrating today's plan") active and kick `PlanCubit.generate(userId)`; on success mark steps done and route `AppRoutes.home.pushReplace`; on failure surface a retry. Keep a minimum dwell so the animation isn't jarring. `userId` from `UserCubit`.

#### 2. Generation listener
**Hygen / File**: `hygen screen listener stepwise_loader` → `lib/ui/screens/stepwise_loader/listeners/_generate.dart` (BlocListener on `PlanCubit` `generate` state).
**Changes**: on `isSuccess` advance + navigate home; on `isFailed` `UIFlash.error` + show a "Try again" affordance (re-invoke `generate`). Listener-driven nav (never imperative in `_state.dart`), per state-driven-navigation convention.

#### 3. Wire `PlanCubit` availability
**File**: `lib/app.dart` (already gets `BlocProvider(create: (_) => PlanCubit())` from hygen in Phase 3) — confirm it's above the loader route in the tree.

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` — zero new errors.

#### Manual Verification (Dart MCP driver, stage flavor)
- [ ] Complete a fresh onboarding → loader runs → real blocks exist in the DB → lands on home.
- [ ] Force a generation failure (e.g. offline) → error + retry path works, no dead-end.

**Implementation Note**: Pause for manual confirmation before Phase 5.

---

## Phase 5: Read UIs — home cards + plan-screen week timeline

### Overview
Render the persisted plan, proving the pipeline end-to-end. Reuse `Screen`, `AppAiPill`, `AppIconButton`, `Space`/`AppText`/`AppTheme` tokens. (The "Begin next block" CTA is present but **stubbed** — it routes to the Plan tab for now; Focus is a later plan.)

### Changes Required

#### 1. Plan data into the screens
**Files**: `lib/ui/screens/home/home.dart`, `lib/ui/screens/plan/plan.dart`
**Changes**: on init, resolve the user's schedule (`PlanCubit.currentSchedule`/state) and `watch(scheduleId)` so both screens read the same `WeekPlan` from `PlanCubit`. Home reads today's `DayPlan`; Plan reads the selected day.

#### 2. Home — "Today's plan" + "Why this plan"
**Hygen**: `hygen screen _widget home` for `_TodayPlanCard` and `_WhyThisPlanCard`.
**Changes** (design ref: `home.jsx`):
- `_TodayPlanCard`: eyebrow "Today's plan", `done/total` count, one-line summary, progress meter (`done/total`), today's blocks as rows (`.map()`): check/dot by `effectiveStatus`, title, subject swatch (`Subject.colorHex`) + `activities` + duration, `startTime`. "Begin next block" button (stub → Plan tab) + a reschedule icon button (disabled/no-op placeholder).
- `_WhyThisPlanCard`: `AppAiPill('Why this plan')` + `WeekPlan.aiReasoning`; footer chips: nearest `Exam` (`daysUntil`) and available hours (`schedule.dailyTargetHours`). Hidden when `aiReasoning == null`.
- Insert both into `_Body`'s column above the existing content.

#### 3. Plan screen — week strip + reasoning + timeline
**Hygen**: `hygen screen _widget plan` for `_WeekStrip`, `_WhyThisWeekCard`, `_BlockTimeline`/`_BlockTile`.
**Changes** (design ref: `plan.jsx`): `_state.dart` holds `selectedDayIndex`.
- `_WeekStrip`: 7 days (`.map()` over the week range) with weekday + date + block-count dots + an exam marker dot when `DayPlan.exam != null`; tap selects the day.
- `_WhyThisWeekCard`: `AppAiPill('Why this week')` + `aiReasoning`.
- `_BlockTimeline`: header "DAY · N blocks · H hrs" (`totalDurationMinutes`); vertical list (`.map()`) of `_BlockTile` (time column, spine+dot, card with subject swatch + title + `activities`, now/done/upcoming styling from `effectiveStatus`, gold `aiInsight` chip when present).
- Empty state when the selected day has no blocks.

#### 4. Empty/loading/failed states
**Changes**: both screens show a calm empty state if no schedule/plan exists yet, a loader while `week` is loading, and a retry on failure (consistent with `BlocState` flags).

### Hygen Commands
```bash
hygen screen _widget home      # _TodayPlanCard, _WhyThisPlanCard
hygen screen _widget plan      # _WeekStrip, _WhyThisWeekCard, _BlockTimeline/_BlockTile
```

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` — zero new errors.

#### Manual Verification (Dart MCP driver, stage flavor)
- [ ] Fresh onboarding → home shows today's blocks + reasoning; Plan tab shows the full week + timeline; switching days works.
- [ ] Kill & relaunch → plan persists (no regeneration), bottom-bar tabs intact, no `unknown` routes in logs.
- [ ] Urdu reasoning renders correctly when the student's inputs are Urdu.

---

## Testing Strategy

> **No automated unit/widget tests in this plan** — the data/UI layers are still settling, so verification is **manual via the Dart MCP driver** on a running stage build (`flutter analyze` + `build_runner` remain the only automated gates). Add unit tests for `PlanCubit.generate`, the JSON→`StudyBlock` parse, `effectiveStatus`, and `WeekPlan` assembly in a follow-up once the surface is stable.

### Manual Testing Steps (Dart MCP driver)
1. Fresh onboarding on stage flavor with ≥3 subjects (varied confidence), ≥1 exam within the week, 2–3 windows enabled, target ~3.5h.
2. Watch the loader calibrate, land on home; verify today's blocks + reasoning are sensible (inside windows, near-exam subject front-loaded).
3. Open Plan tab; verify the week, exam day marker, day switching, timeline states.
4. Relaunch app; confirm persistence (no regen).
5. Offline during loader; confirm error + retry.

## Architecture Checklist
- [ ] `App.init(context)` at top of every `build()` (loader/home/plan + new widgets).
- [ ] UI (`_state.dart`) never calls Firebase/Drift directly — only `PlanCubit`.
- [ ] `PlanCubit`/`PlanRepo` never import `lib/ui/`.
- [ ] State via `PlanCubit.c(context)` / `_ScreenState.s(context)` — never `context.read/watch`.
- [ ] `FirebaseAIException`/Drift errors → typed `Fault` before emit.
- [ ] Repo public methods return `Map`/`List<Map>`/primitives (ADR-013); cubit does `fromJson`.
- [ ] All scaffolds via hygen (`cubit nested plan`, `screen _widget`, `screen listener`).
- [ ] Widget lists via `.map()` (no `for` in the tree); spacing via `Space.*` tokens (no `Spacer()` in cards — use the loader's existing `Spacer` only where already present).
- [ ] Any sheet/dialog (none in this plan) would pass `RouteSettings(name:)`.

## References
- Research: `docs/research/2026-06-15-study-plan-generation.md`
- Sibling AI feature: `docs/research/2026-06-14-chat-agent-integration.md`
- Canonical Gemini flow: `lib/repos/chat/chat_data_provider.dart:43-209`
- Structured-output template: `lib/services/firebase/ai/ai_service.dart:53`, `agent_tools.dart:15`
- Cubit/repo scaffold: `lib/blocs/material/cubit.dart`, `lib/repos/material/material_repo.dart`
- Design source: `/tmp/tm_design/taleemmate/project/screens/{home,plan,loading}.jsx`
- ADRs: `docs/architecture/DECISIONS.md` (ADR-008 firebase_ai, ADR-013 repo purity)
