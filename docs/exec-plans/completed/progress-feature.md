---
title: "Progress Feature — readiness, mastery, quiz history, streak & AI insight"
status: completed
created: 2026-06-19
completed: 2026-06-19
---

✅ COMPLETED — All five phases shipped; `flutter analyze` clean, 71 unit/widget tests passing, and driver-verified on the emulator (live Progress render, AI readiness pass, quiz-completion → DailyScore + streak bump).

# Progress Feature — Implementation Plan

**Design**: [TaleemMate — Progress screen](https://claude.ai/design/p/019dc88c-9f8b-7336-a9a8-01c96265b986?file=TaleemMate.html) (project `019dc88c-9f8b-7336-a9a8-01c96265b986`, file `screens/progress.jsx`). Fetched via the **`DesignSync` (claude.ai/design) MCP** — `get_file` against the project; do not WebFetch (auth-gated). Re-pull through the design MCP if the design changes.

## Overview
Complete the Progress tab (`lib/ui/screens/progress/`), today an empty scaffold, into the full dashboard from the Claude Design (`screens/progress.jsx`): a **hero readiness card**, a **mastery-by-subject** card, a **quiz-history bar chart**, a **streak/time stat row**, and a **bottom AI insight card**. The data foundation (Drift tables, DAO, freezed models) already exists; this plan wires the missing middle — a `ProgressRepo` + `ProgressCubit`, the deterministic write hooks that populate scores/streak, the AI readiness pass, the chart dependency, and the screen UI — and promotes two screen-private widgets (`_Glance`, `_Meter`) to shared widgets.

## Current State Analysis

**What exists** (see `docs/research/2026-06-19-progress-feature-state.md`):
- Screen scaffold + route + bottom-tab — `lib/ui/screens/progress/progress.dart:33` (empty `Column`), `lib/router/router.dart:40`, `lib/ui/widgets/core/bottom_bar/_data.dart:24`.
- Drift tables — `lib/core/db/tables/progress_table.dart` (`ProgressMetrics`, `StudyStreaks`, `DailyScores`, `SessionMetrics`).
- DAO — `lib/core/db/daos/progress_dao.dart` (`watchByUser`, `streakForUser`, `scoresForUser`, `upsertMetric`, `upsertStreak`, `insertDailyScore`, `insertSessionMetric`). **No `sessionMetricsForUser` read.**
- Models — `lib/core/models/progress/` (`ProgressMetric`, `ScoreRange`, `StudyStreak`, `SessionMetric`, `DailyScore`, `QuizHistory`).
- Quiz attempts persisted via `QuizCubit.recordAnswer` → `QuizRepo.recordAnswer` (`lib/repos/quiz/quiz_data_provider.dart:156`). `QuizDao.attemptsForUser` exists (`quiz_dao.dart:18`) but is unexposed.
- Quiz completes at the taking→results transition — `lib/ui/screens/quiz/_state.dart:98-107` (`next(total)`), with `score(questions)` at `:110`.
- `SessionMetrics` is the **only** live progress write — `PlanCubit.markBlockDone` (`lib/blocs/plan/cubit.dart:169`) → `PlanRepo.recordSession` → `recordSessionMetric` (`database.dart:483`).

**What's missing:** no `ProgressRepo`, no `ProgressCubit`, no read path to the screen, no producer for `ProgressMetrics`/`DailyScores`/`StudyStreaks`, no chart dependency (`fl_chart` absent from `pubspec.yaml`).

**Key patterns to mirror:**
- AI structured pass — `_PlanProvider.updateReasoning` (`lib/repos/plan/plan_data_provider.dart:66-105`): load context → `AiService.ins.reasonModel(await SystemPrompts.reason())` → `generateContent` → `_decode` → persist. Schema in `AgentTools` (`agent_tools.dart`), model accessor in `AiService` (`ai_service.dart`), prompt getter in `SystemPrompts` (`system_prompts.dart`), asset in `pubspec.yaml`.
- Repo purity (ADR-013) — `PlanRepo`/`QuizRepo` public methods take/return `Map`/`List<Map>`/primitives; the `_XProvider` part does the work; AppDatabase wrappers shape Maps so the repo never touches a DAO (`database.dart:483`, `:508`).
- Cubit uid lifecycle (ADR-014) — `initUid` from auth listeners (`splash/listeners/_init.dart:21`, `login/_login.dart`, `create_account/_register.dart`), `resetUid` from logout listeners (`profile/listeners/_logout.dart:23`, `onboarding/listeners/_logout.dart`).
- Test seam — `@visibleForTesting static set ins` on every repo; mocktail only; cubit tested by collecting stream emissions (`docs/TESTING.md`).

## Desired End State
Opening the Progress tab shows live data: a hero readiness card for the nearest-exam subject (score/100, gold meter, predicted range, AI note), a mastery-by-subject list, a 14-bar quiz-score chart (last bar gold), three stat cards (streak / this-week hrs / avg session), and a bottom AI insight card. Completing a quiz writes a `DailyScore` and bumps the streak; finishing a focus block bumps the streak. The AI readiness pass runs on tab open only when data is stale (> 6h since `lastUpdatedAt`). Verified by `flutter analyze` (zero new errors), unit + widget tests passing, and a manual run on the emulator.

## What We're NOT Doing
- **No topic-level mastery** — mastery is by **subject** (Topics rows are never created). `Topic.masteryPercentage`/`trend`/`isWeak` stay unused.
- **No new Drift columns / migration** — the global "you retain best in the morning" insight is held in cubit state (regenerated each refresh), not persisted. All other fields already exist on `ProgressMetrics`.
- **No readiness history table** — `weeklyGain`/`trend` come from the AI pass, not a stored time series.
- **No backfill** — historical quizzes completed before this ships won't retroactively get `DailyScore` rows.
- **No changes to quiz generation or plan generation** beyond the two completion write-hooks.

## Implementation Approach
Five phases, bottom-up so each is independently testable: (1) data plumbing + chart dep, (2) repo + cubit + AI pass, (3) deterministic write hooks, (4) shared widgets, (5) screen UI. Tests ship inside the phase that introduces the logic (cubit/repo in 2–3, widgets/screen in 4–5), per the test-layer convention.

**Cubit shape:** `ProgressCubit` is global (registered in `app.dart` via hygen), so its throttle/cache survives tab switches and it's reachable from the quiz screen. It lazily loads on tab open (post-frame from `_ScreenState`, mirroring `quiz/_state.dart:45` `startIfNeeded`), watches `ProgressMetrics`, and triggers the AI refresh only when stale.

**Derived fields (no new columns):** mastery row `pct` = `readinessScore`; `trend` = sign of `weeklyGain` (`>0` up, `<0` down, else flat); `weak` = `readinessScore < 50`. Hero subject = nearest upcoming exam's subject (fallback: lowest readiness). Each completed quiz writes one `DailyScore` (`score` = `round(correct/total*100)`); the chart plots the last 14 by date.

---

## Phase 1: Data plumbing + chart dependency

### Overview
Add the missing DAO read, the AppDatabase Map-shaped wrappers the repo will call, and `fl_chart`. No model or schema changes.

### Changes Required

#### 1. DAO read method
**File**: `lib/core/db/daos/progress_dao.dart`
**Changes**: Add a session-metrics read (mirrors `scoresForUser`).
```dart
Future<List<SessionMetricRow>> sessionMetricsForUser(
  String userId, {
  DateTime? since,
}) {
  final query = select(sessionMetrics)..where((s) => s.userId.equals(userId));
  if (since != null) query.where((s) => s.date.isBiggerOrEqualValue(since));
  return (query..orderBy([(s) => OrderingTerm.asc(s.date)])).get();
}
```
Also expose quiz attempts for counters (used by the "N quizzes · N questions" line) — `QuizDao.attemptsForUser` already exists; just needs an AppDatabase wrapper (below).

#### 2. AppDatabase wrappers (Map-shaped, ADR-013)
**File**: `lib/core/db/database.dart` (mirror `recordSessionMetric`/`subjectsForUser` style, with `_xToMap` helpers)
**Changes**: Add wrappers + row→map helpers:
```dart
Stream<List<Map<String, dynamic>>> watchProgressMetrics(String userId) =>
    progressDao.watchByUser(userId).map((r) => r.map(_progressMetricToMap).toList());

Future<Map<String, dynamic>?> studyStreakForUser(String userId) async {
  final row = await progressDao.streakForUser(userId);
  return row == null ? null : _studyStreakToMap(row);
}

Future<List<Map<String, dynamic>>> dailyScoresForUser(String userId, {DateTime? since}) async {
  final rows = await progressDao.scoresForUser(userId, since: since);
  return rows.map(_dailyScoreToMap).toList();
}

Future<List<Map<String, dynamic>>> sessionMetricsForUser(String userId, {DateTime? since}) async {
  final rows = await progressDao.sessionMetricsForUser(userId, since: since);
  return rows.map(_sessionMetricToMap).toList();
}

Future<List<Map<String, dynamic>>> quizAttemptsForUser(String userId) async {
  final rows = await quizDao.attemptsForUser(userId);
  return rows.map(_quizAttemptToMap).toList();
}

Future<void> recordDailyScore({required String userId, required DateTime date, required int score, String? topicId}) =>
    progressDao.insertDailyScore(DailyScoresCompanion.insert(
      userId: userId, date: date, score: score, topicId: Value(topicId)));

Future<void> upsertStudyStreak({required String userId, required int dayCount, required DateTime lastStudiedDate, required DateTime startDate}) =>
    progressDao.upsertStreak(StudyStreaksCompanion.insert(
      userId: userId, dayCount: dayCount, lastStudiedDate: lastStudiedDate, startDate: startDate));

Future<void> upsertProgressMetric(Map<String, dynamic> m) =>
    progressDao.upsertMetric(ProgressMetricsCompanion.insert(/* map fields → companion */));
```
Add `_progressMetricToMap`, `_studyStreakToMap`, `_dailyScoreToMap`, `_sessionMetricToMap`, `_quizAttemptToMap` shaped to the matching `*.toJson()` (decode `topicIds` JSON for session metrics; flatten/rebuild `predictedScoreMin/Max` ↔ `ScoreRange`).

#### 3. Add fl_chart
**File**: `pubspec.yaml`
**Changes**: Under `# ui related`, add `fl_chart: ^1.0.0` (pin to the latest 1.x resolved by `flutter pub get`).

### Hygen Commands
_None._

### Success Criteria

#### Automated Verification
- [ ] `flutter pub get` resolves with `fl_chart` added
- [ ] Code gen clean: `flutter pub run build_runner build --delete-conflicting-outputs` (drift picks up the new DAO method)
- [ ] Zero new analysis errors: `flutter analyze`

#### Manual Verification
- [ ] N/A (no UI yet) — wrappers exercised by Phase 2/3 tests.

**Implementation Note**: Pause for confirmation after automated checks pass.

---

## Phase 2: ProgressRepo + ProgressCubit + AI readiness pass

### Overview
Scaffold the repo + cubit via hygen, implement the data-provider (deterministic snapshot assembly + streak logic + AI readiness pass), register the AI schema/model/prompt, and wire the cubit's load-on-open + throttle.

### Changes Required

#### 1. Scaffold
```bash
hygen cubit nested progress   # creates lib/blocs/progress/{cubit,state}.dart + lib/repos/progress/{progress_repo,_mocks,_parser,_data_provider}.dart, registers ProgressCubit in app.dart
```

#### 2. AI plumbing
**File**: `assets/progress_sys_prompt.md` (new) — system instruction: "given per-subject quiz performance, confidence, session time and nearest exams, return a readiness score 0–100, a predicted score range, a weekly gain estimate, a short per-subject insight, and one global study-pattern insight. Write insights in the student's language."
**File**: `pubspec.yaml` — add `- assets/progress_sys_prompt.md` to `assets:`.
**File**: `lib/services/firebase/ai/system_prompts.dart` — add `static Future<String> progress() => _load(Assets.progressSysPrompt);`
**File**: `lib/services/firebase/ai/agent_tools.dart` — add `progressSchema`:
```dart
Schema get progressSchema => Schema.object(properties: {
  'subjects': Schema.array(items: Schema.object(properties: {
    'subjectId': Schema.string(...),
    'readinessScore': Schema.integer(description: '0–100'),
    'predictedScoreMin': Schema.integer(...),
    'predictedScoreMax': Schema.integer(...),
    'weeklyGain': Schema.integer(description: 'signed delta vs last week'),
    'aiInsight': Schema.string(...),
  })),
  'studyInsight': Schema.string(description: 'One global retention/behaviour insight.'),
});
```
**File**: `lib/services/firebase/ai/ai_service.dart` — add a `progressModel(String systemPrompt)` accessor (Flash tier, `responseSchema: AgentTools.ins.progressSchema`), cached like `reasonModel`.

#### 3. Repo (ADR-013, Map in/out)
**File**: `lib/repos/progress/progress_repo.dart` + `_progress_data_provider.dart`
Public methods:
```dart
Stream<List<Map<String, dynamic>>> watchMetrics(String userId);            // ProgressMetrics stream
Future<Map<String, dynamic>> dashboardData(String userId);                  // {streak, dailyScores[], sessionMetrics[], quizCount, questionCount}
Future<void> recordQuizScore({required String userId, required String subjectId, required int score, required int total, required DateTime date});
Future<void> recordStudyActivity({required String userId, DateTime? date}); // streak upsert
Future<void> refreshReadiness(String userId);                               // AI pass → upsert ProgressMetrics; held studyInsight returned via watch or a getter
```
- **Streak logic** (`recordStudyActivity`): read `studyStreakForUser`; let `last = lastStudiedDate` (date-only). If `today == last` → no-op; if `today == last + 1d` → `dayCount+1`; else → `dayCount=1, startDate=today`. Upsert.
- **`recordQuizScore`**: `recordDailyScore(score: round(score/total*100))` then `recordStudyActivity`.
- **`refreshReadiness`**: load subjects + recent daily scores + session metrics + exams → assemble a user turn (mirror `_reasonTurn`) → `AiService.ins.progressModel(await SystemPrompts.progress())` → `_decode` → per-subject `upsertProgressMetric`. The global `studyInsight` is returned (cubit holds it). Catch `FirebaseAIException` → `AiFault`, `FormatException`/other → `UnknownFault`.
- Add the `@visibleForTesting static set ins` seam (hygen includes it; verify).

#### 4. Cubit + state
**File**: `lib/blocs/progress/cubit.dart` + `state.dart`
- State: `BlocState<ProgressDashboard> dashboard` (a small view-model assembled in the cubit: hero metric, subject metrics list, daily scores, stats, studyInsight), plus a `DateTime? _lastRefresh` guard. (Define `ProgressDashboard` as a plain immutable class in the cubit's models, or assemble from existing models — no new freezed needed if kept as a cubit-local value object; prefer composing existing models.)
- `loadForUser(userId)`: start watching `watchMetrics` (map → `ProgressMetric`), fetch `dashboardData`, assemble + emit success; then if stale (`> 6h` since newest `lastUpdatedAt`, or empty) call `refreshReadiness` (the watch re-emits on upsert).
- `recordQuizResult({userId, subjectId, score, total})` → `ProgressRepo.ins.recordQuizScore(...)` (fire-and-forget like `recordAnswer`; failures swallowed).
- `recordStudyActivity(userId)` → `ProgressRepo.ins.recordStudyActivity(...)`.
- `resetUid()` → cancel watch, clear state.
- Derived getters: hero subject (nearest exam / lowest readiness), `trend` from `weeklyGain`, `weak` from `readiness < 50`.

### Hygen Commands
```bash
hygen cubit nested progress
```

### Success Criteria

#### Automated Verification
- [ ] Code gen clean: `flutter pub run build_runner build --delete-conflicting-outputs` (flutter_gen picks up the new asset → `Assets.progressSysPrompt`)
- [ ] `flutter analyze` — zero new errors
- [ ] Unit tests pass: `flutter test test/blocs/progress/progress_cubit_test.dart`
  - streak transitions (same-day no-op / +1 / reset) via mock repo
  - `recordQuizResult` calls repo with `round(correct/total*100)`
  - `loadForUser` emits `[loading, success]` and triggers `refreshReadiness` only when stale
  - readiness `AiFault` path leaves the deterministic dashboard intact

#### Manual Verification
- [ ] With a signed-in user, calling `loadForUser` populates metrics (verify via logs / temporary debug print before UI lands).

**Implementation Note**: Pause for confirmation after automated checks pass.

---

## Phase 3: Deterministic write hooks (quiz completion + focus done)

### Overview
Populate `DailyScores` + `StudyStreaks` at the two real study events, and wire `resetUid` on logout.

### Changes Required

#### 1. Quiz completion → DailyScore + streak
**File**: `lib/ui/screens/quiz/` (the widget that calls `s.next(total)` on the last question — `_state.dart:98`)
**Changes**: When `next` transitions to `QuizPhase.results`, record the result. Since `_ScreenState` has no `BuildContext`, do it at the call site (the widget has context) or pass a callback. Preferred: in the "next/finish" button handler, after `s.next(total)`, if `s.phase == QuizPhase.results` call:
```dart
ProgressCubit.c(context).recordQuizResult(
  userId: s.userId!, subjectId: s.subjectId,
  score: s.score(questions), total: questions.length);
```
(Guard `s.userId != null`.) Keep it best-effort — never block the results screen.

#### 2. Focus block done → streak
**File**: `lib/blocs/plan/cubit.dart:169` (`markBlockDone`)
**Changes**: After `recordSession`, bump the streak:
```dart
await ProgressRepo.ins.recordStudyActivity(userId: userId);
```
(Import `ProgressRepo`; cubit→repo is allowed. `recordSession` already runs here so the `userId` guard is in place.)

#### 3. Logout clears progress
**File**: `lib/ui/screens/profile/listeners/_logout.dart:25` and `lib/ui/screens/onboarding/listeners/_logout.dart:26`
**Changes**: Add `progressCubit.resetUid();` alongside the existing `planCubit.resetUid();` (resolve the cubit the same way the others are). `initUid` is intentionally **not** wired — Progress loads lazily on tab open.

### Hygen Commands
_None._

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` — zero new errors
- [ ] Unit tests pass: `flutter test test/blocs/plan/plan_cubit_test.dart` (markBlockDone now also calls `ProgressRepo.recordStudyActivity` — assert via mock)

#### Manual Verification
- [ ] Complete a quiz → a `DailyScore` row is written and the streak reflects today.
- [ ] Mark a focus block done → streak reflects today (no double-count if a quiz already counted today).
- [ ] Sign out → progress state cleared (no stale data for the next user).

**Implementation Note**: Pause for confirmation after automated checks pass.

---

## Phase 4: Shared widgets (promote + bar chart)

### Overview
Promote the two screen-private widgets the design reuses, and add the bar chart. Per the shared-widget convention, promote rather than duplicate.

### Changes Required

#### 1. Promote `_Glance` → shared stat card
**File**: new `lib/ui/widgets/design/progress/app_stat.dart` (`AppStat` = single stat; `AppStatCard` = bordered row of stats with dividers)
**Changes**: Move the `_Glance`/`_GlanceCard` bodies (`lib/ui/screens/profile/widgets/_glance.dart:51-97`) verbatim into public widgets keyed on `{value, unit, label, highlight}`. Refactor `profile/_glance.dart` to use `AppStatCard`. The Progress stat row (`Streak 11 days` / `This week 14.2 hrs` / `Avg session 38 min`) uses the same widget.

#### 2. Promote `_Meter` → shared meter
**File**: new `lib/ui/widgets/design/progress/app_meter.dart` (`AppMeter({required double fraction, bool gold = false, double height = 6})`)
**Changes**: Move `_Meter` (`lib/ui/screens/home/widgets/_today_plan_card.dart:285-307`) into a public widget; `gold` swaps fill `AppTheme.c.primary` → `AppTheme.c.accent`; `weak` callers pass an explicit color or a `color` override (mastery rows use rose `AppTheme.c.error`). Refactor `_TodayPlanCard` to use `AppMeter(fraction: ...)`.

#### 3. Bar chart
**File**: new `lib/ui/widgets/design/progress/app_score_chart.dart` (`AppScoreChart({required List<int> scores})`)
**Changes**: `fl_chart` `BarChart` — last 14 scores, bars `AppTheme.c.text` at opacity scaled by value, the most-recent bar `AppTheme.c.accent` (gold), no axes/grid (design is minimal), fixed height ~120. Empty list → a calm empty state.

### Hygen Commands
_None_ (shared widgets are hand-authored in `lib/ui/widgets/`, not screen-scaffolded).

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` — zero new errors
- [ ] Existing profile/home tests still pass: `flutter test test/screens/profile/ test/screens/home/`

#### Manual Verification
- [ ] Profile "At a glance" card unchanged visually after refactor.
- [ ] Home "Today's plan" meter unchanged visually after refactor.

**Implementation Note**: Pause for confirmation after automated checks pass.

---

## Phase 5: Progress screen UI

### Overview
Assemble the screen from the cubit + shared widgets, with loading/empty/error states, and kick `loadForUser` on open.

### Changes Required

#### 1. Screen state kicks load
**File**: `lib/ui/screens/progress/_state.dart`
**Changes**: Add a `startIfNeeded(BuildContext)` (mirror `quiz/_state.dart:45`) that, post-frame, resolves the uid from `UserCubit` and calls `ProgressCubit.c(context).loadForUser(uid)`.

#### 2. Screen body + section widgets
**File**: `lib/ui/screens/progress/progress.dart` + `lib/ui/screens/progress/widgets/*`
**Changes**: Wrap the body in a `BlocBuilder<ProgressCubit, ProgressState>` over `state.dashboard`. Scrollable column:
- **Header** — `AppCoreHeader(greeting: 'Assalam-o-alaikum,', name: user?.fullName, subtitle: 'Last 14 days', trailing: AppIconButton(icon: LucideIcons.ellipsis, ...))`.
- **`_HeroCard`** (≥5 children → own widget) — eyebrow `MIDTERM READINESS · <subject>`, big serif `AppText` score `/100`, green `weeklyGain` delta, gold `AppMeter(fraction: readiness/100, gold: true)`, predicted range mono, `AppEdgeCard`/`AppAiPill` note from `aiInsight`.
- **`_MasteryCard`** — `eyebrow` + a card mapping subject metrics → rows (`.map`, no for-loops): name, pct% mono, trend arrow (from `weeklyGain` sign), `Weak` rose badge (readiness<50), `AppMeter(fraction, color: weak ? error : text)`.
- **`_QuizHistory`** — eyebrow + `N quizzes · N questions` counter + `AppScoreChart(scores: dailyScores)` + "2 weeks ago / today" mono labels.
- **Stat row** — `AppStatCard` with streak / this-week hrs / avg session (computed from session metrics).
- **`_InsightCard`** — `AppEdgeCard` + `AppAiPill('Insight')` + serif headline + body from `studyInsight` (hidden when null).
- Loading → shimmer/placeholder; error → calm retry; empty (no data yet) → friendly empty state.
Follow the widget-extraction threshold (≥5 children / ≥30 lines), `.map()` not for-loops, `Space.*` tokens, `App.init(context)` in every `build`.

### Hygen Commands
```bash
hygen screen _widget hero_card        # and similar per section, OR hand-add under widgets/ following the screen-anatomy doc
```
(Use `hygen screen _widget <name>` to add each private section widget to the existing Progress screen rather than hand-creating files.)

### Success Criteria

#### Automated Verification
- [ ] `flutter analyze` — zero new errors
- [ ] Widget tests pass: `flutter test test/screens/progress/progress_test.dart`
  - renders hero/mastery/chart/stats/insight when the cubit (real, mock repo) emits a populated dashboard
  - shows the empty state when there's no data
  - shows the error state + retry on a failed load

#### Manual Verification
- [ ] On a stage emulator, the Progress tab renders all five sections with seeded data, matching the design.
- [ ] Pulling fresh data (tab re-open after staleness) refreshes readiness without a visible stall (deterministic parts show immediately).
- [ ] Dark mode renders correctly (tokens already theme-aware).
- [ ] No overflow on small screens; scroll is smooth.

**Implementation Note**: Final phase — after manual verification, the feature is complete.

---

## Testing Strategy

### Unit Tests
- **`ProgressCubit`** (`test/blocs/progress/progress_cubit_test.dart`): `loadForUser` emit sequence + staleness-gated refresh; `recordQuizResult` percentage math + repo call; streak transition cases; `refreshReadiness` `AiFault` keeps deterministic dashboard; `resetUid` clears state.
- **`PlanCubit`** (extend existing): `markBlockDone` also calls `ProgressRepo.recordStudyActivity`.
- **Streak logic**: pure date math cases (same-day / consecutive / gap) through the mock repo seam.
- Add `MockProgressRepo` to `test/helpers/mocks.dart`, fixtures + `ProgressStateX` builder to `test/helpers/fixtures.dart`, and register the `ins` seam.

### Widget Tests
- **`ProgressScreen`** (`test/screens/progress/progress_test.dart`): populated render, empty state, error+retry. Real `ProgressCubit` + `MockProgressRepo` via `TestApp`; set a tall surface; push as a named route.

### Manual Testing Steps
> Driven via the `dart` MCP against the driver entrypoint (`test_driver/app.dart`, `flutter run --flavor stage -t test_driver/app.dart`). The user fires the build and shares the DTD URI; Claude connects (`connect_dart_tooling_daemon`) and verifies flows with `get_widget_tree` / `flutter_driver` (`tap`, `screenshot`) rather than asking the user to click through. Mind the driver gotchas (no `timeout` arg; finder by visible text; spinners hang `waitFor` — use `get_widget_tree` for transient states).

1. Sign in → open Progress → confirm five sections render (seed a couple of quizzes + a focus block first).
2. Complete a quiz → return to Progress → new bar appears, streak +1, counters increment.
3. Mark a focus block done on the same day → streak unchanged (no double count); next day → +1.
4. Force staleness (or first open) → readiness/insight populate after the AI pass; AI failure → deterministic stats still show.
5. Sign out / sign in as another user → no cross-user bleed (ADR-014).

## Architecture Checklist
- [ ] `App.init(context)` called at top of every `build()` (screen + each section widget)
- [ ] UI layer (`_state.dart`) does not call Firebase/Drift directly — only `ProgressCubit`
- [ ] `ProgressCubit`/repo do not import from `lib/ui/`
- [ ] State accessed via `ProgressCubit.c(context)` / `_ScreenState.s(context)` — never `context.read<X>()`
- [ ] Firebase/AI exceptions converted to typed `Fault` (`AiFault`/`UnknownFault`) before emit
- [ ] Repo public methods return `Map`/`List<Map>`/primitives only (ADR-013); cubit does `fromJson`
- [ ] All boilerplate via `hygen` (`cubit nested progress`, `screen _widget`)
- [ ] `.map()` not for-loops in the widget tree; `Space.*` tokens; widget-extraction threshold respected
- [ ] Shared widgets promoted to `lib/ui/widgets/`, not duplicated
- [ ] `RouteSettings(name: ...)` on any dialog/sheet (e.g. the header "more" menu)
- [ ] `*_mocks.dart`/`*_parser.dart` kept as `part of` (don't prune)

## References
- Research: `docs/research/2026-06-19-progress-feature-state.md`
- Design: [TaleemMate — Progress screen](https://claude.ai/design/p/019dc88c-9f8b-7336-a9a8-01c96265b986?file=TaleemMate.html) — file `screens/progress.jsx`, tokens `styles.css`; fetched via the `DesignSync` claude.ai/design MCP (`get_file`, project `019dc88c-9f8b-7336-a9a8-01c96265b986`)
- AI pass template: `lib/repos/plan/plan_data_provider.dart:66-105`
- Repo/cubit template: `lib/repos/quiz/quiz_repo.dart`, `lib/blocs/quiz/cubit.dart`
- Shared-widget sources: `lib/ui/screens/profile/widgets/_glance.dart:51`, `lib/ui/screens/home/widgets/_today_plan_card.dart:285`
- Testing: `docs/TESTING.md`
- Related plans: `docs/exec-plans/.../2026-06-18-quiz-generation`, `2026-06-16-focus-session-and-reschedule-sheet`
