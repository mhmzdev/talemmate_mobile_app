---
date: 2026-06-19T17:30:00+05:00
researcher: Claude (claude-opus-4-8)
git_commit: d4f2b66a7b08221eb66bec7edac5361af1890e3c
branch: main
repository: taleemmate
topic: "Current state of the lib/ui/screens/progress/ feature — what exists, what's wired, and what's missing relative to the design"
tags: [research, codebase, progress, stats, quiz-history, streak, mastery, drift, ai-insight]
status: complete
last_updated: 2026-06-19
---

# Research: Progress Feature — Current State vs Design

**Date**: 2026-06-19
**Git Commit**: `d4f2b66a7b08221eb66bec7edac5361af1890e3c`
**Branch**: `main`
**Design**: [TaleemMate Design — Progress screen](https://claude.ai/design/p/019dc88c-9f8b-7336-a9a8-01c96265b986?file=TaleemMate.html) (`screens/progress.jsx`)

## Research Question
Document the current state of the `lib/ui/screens/progress/` feature — what exists, what's wired up, and what's missing relative to the design.

## Summary
The Progress feature is an **empty UI scaffold sitting on top of a fully-built data foundation**. The screen is routed and present as the 5th bottom-tab, but `_Body` renders a `Column` with zero children. Underneath, the entire persistence layer the design needs already exists: dedicated Drift tables (`ProgressMetrics`, `StudyStreaks`, `DailyScores`, `SessionMetrics`), a `ProgressDao` with read+write methods, six freezed models under `lib/core/models/progress/`, and every design component (AI pill, edge card, stat card, meter, eyebrow) is already a reusable widget. What's missing is the **middle**: no `ProgressCubit`, no `ProgressRepo`, no read path from DAO → repo → cubit → screen, almost no **write** path populating the tables (only `SessionMetrics` is actually written today), and no bar-chart widget. The design's five sections (hero readiness card, mastery-by-topic, quiz-history bar chart, streak/time stats, AI insight) all map cleanly to existing models and widgets, but the data that backs three of them is never produced.

## The Design (target)

Source: `screens/progress.jsx` in the Claude Design project. The screen is a scrollable column under an `AppHeader` (serif greeting "Assalam-o-alaikum, Hamza", sub "Last 14 days", right = `more` icon button). Five sections, top to bottom:

1. **Hero readiness card** — eyebrow "Midterm readiness · Networks"; big serif score `68/100`; green "↑ 6 this week" delta; a **gold meter** at 68%; "Predicted score range" → mono `62 – 74`; an **AI-edge** note ("Two more focused sessions… cross 75").
2. **Mastery by topic** — eyebrow + a single card listing `Topic` rows: name, subject sub-label, optional "Weak" rose badge, `pct%` mono, trend arrow (↑/↓/—), and a per-row **meter** (rose fill when weak). 7 rows in the mock.
3. **Quiz history** — eyebrow + "14 quizzes · 112 questions" counter; a **bar chart** card (14 vertical bars of quiz scores, last bar gold-highlighted, opacity scaled by value); axis labels "2 weeks ago" / "today".
4. **Streak / time stats** — a row of 3 **stat cards**: "Study streak 11 days", "This week 14.2 hrs", "Avg session 38 min".
5. **AI insight** — an **AI-edge card** with an `AIPill` "Insight" header, serif headline ("You retain best in the morning."), and a body paragraph.

Design tokens (`styles.css`) map 1:1 to the app's existing theme: cream surfaces, ink (`--ink-900` `#0F2027`), gold (`--gold-500` `#D4A574`), green (`--green` `#4F7A5C`), rose (`--rose` `#A35C5C`), Fraunces serif, Geist sans, Geist Mono.

## Detailed Findings

### 1. Screen files — empty scaffold

- `lib/ui/screens/progress/progress.dart:9` — `ProgressScreen` (StatelessWidget), `App.init(context)` at line 14, `ChangeNotifierProvider<_ScreenState>` at lines 16–18.
- `lib/ui/screens/progress/progress.dart:23-39` — `_Body` renders `Screen(keyboardHandler: true, child: SafeArea(child: Column(crossAxisAlignment: .stretch, children: [])))` — **children list is empty**.
- `lib/ui/screens/progress/_state.dart:3-6` — `_ScreenState extends ChangeNotifier` with only the static `s()` accessor. No fields, no methods.
- No `widgets/` or `listeners/` subdirectory exists under `progress/`.

### 2. Routing & bottom-tab — fully wired

- `lib/router/routes.dart:8` — `AppRoutes.progress = '/progress'`.
- `lib/router/router.dart:9` — `ProgressScreen` imported; `:40-41` — `onGenerateRoutes` returns a `FadeRoute(ProgressScreen())` for `/progress`. (Not in the `appRoutes` map; handled only via `onGenerateRoutes`.)
- `lib/ui/widgets/core/screen/screen.dart:75-81` — `bottomBarRoutes` includes `AppRoutes.progress`; `:84` — `hasBottomBar` true on this route; `:137-144` — `BottomBar()` rendered.
- `lib/ui/widgets/core/bottom_bar/_data.dart:24-28` — Progress tab: label `'Progress'`, path `AppRoutes.progress`, icon `LucideIcons.chart_column` (5th tab, after Home/Library/Tutor/Plan).
- `lib/ui/widgets/core/bottom_bar/bottom_bar.dart:45` — tap calls `tab.path.pushReplace(context)` + Crashlytics `trackUserAction`.

### 3. Cubit / Repo — do not exist

- No `lib/blocs/progress*/` directory — no `ProgressCubit` / `ProgressState`.
- No `lib/repos/progress*/` directory — no `ProgressRepo`.

This is the single biggest gap: the read path (DAO → repo → cubit → screen) is entirely absent.

### 4. Data layer — already built (Drift)

**Tables** — `lib/core/db/tables/progress_table.dart`:
- `ProgressMetrics` (`:6`) — PK `{userId, subjectId}`; cols `readinessScore`, `lastUpdatedAt`, `predictedScoreMin`, `predictedScoreMax`, `weeklyGain`, `aiInsight`. → backs the **hero card**.
- `StudyStreaks` (`:20`) — PK `{userId}`; cols `dayCount`, `lastStudiedDate`, `startDate`. → backs **streak stat**.
- `DailyScores` (`:31`) — autoinc `id`, `userId`, `date`, `score`, `topicId?` (FK Topics). → backs the **quiz-history bar chart**.
- `SessionMetrics` (`:40`) — autoinc `id`, `userId`, `date`, `durationMinutes`, `topicIds` (JSON text). → backs **this-week hrs / avg session**.

**DAO** — `lib/core/db/daos/progress_dao.dart`:
- `watchByUser(userId)` (`:10`) — `Stream<List<ProgressMetricRow>>`.
- `streakForUser(userId)` (`:13`) — `StudyStreakRow?`.
- `scoresForUser(userId, {since})` (`:17`) — `List<DailyScoreRow>` asc by date.
- Writes: `upsertMetric` (`:28`), `upsertStreak` (`:31`), `insertDailyScore` (`:34`), `insertSessionMetric` (`:37`).
- **Gap**: no `sessionMetricsForUser` read method — `SessionMetrics` is only readable via the generated `managers.sessionMetrics`, not a named DAO method.

**Models** — `lib/core/models/progress/` (all freezed + `fromJson`): `ProgressMetric`, `ScoreRange`, `StudyStreak`, `SessionMetric`, `DailyScore`, `QuizHistory` (composes `QuizAttempt` + `DailyScore` lists). None are imported by any cubit/screen today.

### 5. Write paths — mostly absent (the real blocker for real data)

| Table | Write method | Caller exists? |
|---|---|---|
| `SessionMetrics` | `recordSessionMetric` (`database.dart:483`) | **Yes** — `PlanCubit.markBlockDone` → `PlanRepo.recordSession` → `plan_data_provider.dart:46` (only on Focus "Mark block done") |
| `ProgressMetrics` | `upsertMetric` (`progress_dao.dart:28`) | **No caller anywhere** |
| `StudyStreaks` | `upsertStreak` (`progress_dao.dart:31`) | **No caller anywhere** |
| `DailyScores` | `insertDailyScore` (`progress_dao.dart:34`) | **No caller anywhere** |
| `Topics.masteryPercentage/trend/isWeak` | `SubjectDao.upsertTopic` (`subject_dao.dart:37`) | **No caller** — topic rows are never even created (onboarding inserts no topics) |

Consequence: even after a cubit/repo are wired, the hero card (readiness), mastery-by-topic, and the bar chart would render empty/zero until generation logic populates `ProgressMetrics`, `Topics`, and `DailyScores`. Only the session-time stats and (partially) streak have any genuine source — and streak is never written either.

### 6. Quiz data that could feed scores

- `lib/core/db/daos/quiz_dao.dart:18` — `attemptsForUser(userId)` returns all `QuizAttemptRow` newest-first (each row has `isCorrect`, `timestamp`, `quizId`, `questionId`). **Exists but not exposed via any repo.**
- `QuizRepo` (`lib/repos/quiz/quiz_repo.dart`) exposes only `generate`, `recordAnswer`, `quiz(quizId)` — no history/score aggregation.
- `QuizState` (`lib/blocs/quiz/`) has only `BlocState<Quiz> generate` — no history field.
- So raw quiz attempts are persisted (write path live via `recordAnswer`), but nothing aggregates them into `DailyScores` or a quiz-history summary. The bar chart's "112 questions / 14 quizzes" counters have no producer.

### 7. AI insight generation — proven pattern, not applied to progress

- `lib/services/firebase/ai/ai_service.dart` — five lazy `gemini-2.5-flash` accessors (`chatModel`, `planModel`, `reasonModel`, `quizModel`, internal extractor), each with a structured `responseSchema`.
- The closest template is `_PlanProvider.updateReasoning` (`plan_data_provider.dart:66-105`): query Drift for context → assemble user turn → `AiService.ins.reasonModel(...)` with JSON schema → parse → persist. A progress-insight generator would follow the same shape, writing to `ProgressMetric.aiInsight`.
- `ProgressMetric.aiInsight` (`progress_metric.dart:17`) and `StudyBlock.aiInsight` are `String?`. Only `StudyBlock.aiInsight` is currently populated (during plan generation). `ProgressMetric.aiInsight` has no write path.

### 8. Design → existing-widget mapping (all reusable, no new component needed except chart)

| Design element | Existing widget / token | Reference |
|---|---|---|
| AppHeader (serif title + sub + right icon) | `AppCoreHeader` + `AppIconButton` in `trailing` | `lib/ui/widgets/core/header/app_core_header.dart:1`; usage `lib/ui/screens/home/widgets/_header.dart:6` |
| Card (white, rounded, border) | inline `Container` (no `AppCard` wrapper exists) | `lib/ui/screens/home/widgets/_today_plan_card.dart:29-35` |
| Meter (thin bar, gold variant) | `_Meter` (home, private) — swap `c.primary`→`c.accent` for gold | `lib/ui/screens/home/widgets/_today_plan_card.dart:285-307` |
| AI pill ("AI"/"Insight") | `AppAiPill(text:)` | `lib/ui/widgets/design/misc/app_ai_pill.dart:1` |
| AI-edge card (gold left border) | `AppEdgeCard` / `AiReasoningCard` | `lib/ui/widgets/design/misc/app_edge_card.dart:1`; `lib/ui/widgets/design/plan/ai_reasoning_card.dart:13` |
| Stat card (label + serif number + unit) | `_Glance` / `_GlanceCard` (profile, private) | `lib/ui/screens/profile/widgets/_glance.dart:1-97` |
| Eyebrow (mono/bold uppercase caption) | inline `AppText.l1b.cl(c.subText).copyWith(letterSpacing:1.2)` | `lib/ui/screens/home/widgets/_today_plan_card.dart:44`; `_results_view.dart:34` |
| "Weak" badge (rose pill) | no exact widget; build inline like the AI pill with `c.error` | — |
| Colors: ink/gold/green/rose | `AppTheme.c.primary/.accent/.success/.error` | `lib/configs/theme/_theme_model.dart:3-33` |
| Typography: serif/mono | `AppText.h1/h2` + `.fra()`; `.gm()` for mono | `lib/configs/theme/_typography.dart:4-68`; `lib/configs/extension/_typography.dart` |
| Spacing | `Space.*` tokens (`t04`–`t32`, `t60`, `t100`) | `lib/configs/space/_tokens.dart:8-33` |
| **Bar chart (14 quiz-score bars)** | **none — `fl_chart` not in pubspec**; build inline like `_Meter` (Column + `FractionallySizedBox` per bar) | `pubspec.yaml` (no chart dep) |

Note: `_Glance` and `_Meter` are screen-private widgets. Reusing them on Progress means either promoting them to `lib/ui/widgets/` (per the shared-widget convention) or rebuilding equivalents.

## Code References
- `lib/ui/screens/progress/progress.dart:33` — empty `Column(children: [])`.
- `lib/ui/screens/progress/_state.dart:3` — bare `_ScreenState`.
- `lib/router/router.dart:40` — `/progress` → `FadeRoute(ProgressScreen())`.
- `lib/ui/widgets/core/bottom_bar/_data.dart:24` — Progress tab definition.
- `lib/core/db/tables/progress_table.dart:6,20,31,40` — the four progress tables.
- `lib/core/db/daos/progress_dao.dart:10,13,17,28-37` — DAO reads + writes.
- `lib/core/models/progress/` — six freezed models.
- `lib/repos/plan/plan_data_provider.dart:46` — the only live progress write (`SessionMetrics`).
- `lib/core/db/daos/quiz_dao.dart:18` — `attemptsForUser` (unexposed).
- `lib/repos/plan/plan_data_provider.dart:66-105` — AI-insight generation template.

## Architecture Documentation
- **Layer boundary**: building Progress correctly means a new `lib/repos/progress/` (returning `Map`/`List<Map>`/primitives per ADR-013) + `lib/blocs/progress/` cubit (does `Model.fromJson`), generated via `hygen cubit nested progress`. The screen's `_state.dart` holds only ephemeral UI state; data flows through the cubit + `BlocState<T>`.
- **Reactive reads**: `ProgressDao.watchByUser` is a stream — the cubit can subscribe (mirroring how `PlanCubit.week` watches `watchBlocks`).
- **AI**: structured-output via `AiService` + a JSON `responseSchema`, system prompt from a bundled asset (mirroring plan/quiz). A `progress_sys_prompt.md` asset would be new.
- **Shared widgets**: per the shared-widget convention, `_Meter`/`_Glance` should be promoted before reuse rather than duplicated.

## Open Questions
1. **Where do `ProgressMetrics`, `Topics` mastery, and `DailyScores` get written?** No producer exists. Is readiness/mastery meant to be AI-generated (like plan reasoning), derived deterministically from quiz attempts, or both? This determines whether the work is mostly UI or mostly a new generation pipeline.
2. **Daily score derivation** — should completing a quiz write a `DailyScore` row (and `Topics.masteryPercentage`)? `recordAnswer` currently persists raw attempts only.
3. **Streak maintenance** — what triggers `upsertStreak`? (Focus session done? Daily app open?) Nothing calls it today.
4. **Topic rows never created** — mastery-by-topic needs `Topics` rows with `masteryPercentage`/`trend`/`isWeak`; onboarding inserts none. Are topics seeded by plan/quiz generation, or a new step?
5. **Chart** — build a lightweight inline bar chart (consistent with the hand-built `_Meter`/`_ProgressBar` approach) vs. add `fl_chart`. Codebase precedent is hand-built, no chart dependency.

## Related Docs
- [2026-06-18 — AI quiz generation end-to-end state](2026-06-18-quiz-generation.md) — quiz attempts/scores that should feed progress.
- [2026-06-16 — Focus Session + Reschedule sheet](2026-06-16-focus-session-and-reschedule-sheet.md) — the only live progress writer (`SessionMetrics`).
- [2026-06-15 — Study plan generation end-to-end](2026-06-15-study-plan-generation.md) — the AI structured-output template a progress-insight generator would follow.
- [2026-06-18 — Navigation/routing stack](2026-06-18-navigation-routing-stack.md) — bottom-tab `pushReplace` behaviour that hosts Progress.
