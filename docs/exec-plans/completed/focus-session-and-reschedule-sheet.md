---
title: "Focus Session screen + Reschedule/Snooze bottom sheet"
status: completed
created: 2026-06-18
completed: 2026-06-18
---

✅ COMPLETED — All phases implemented + driver-verified. See
[feat-checklist/focus-session-and-reschedule.md](../../feat-checklist/focus-session-and-reschedule.md)
(incl. 3 bugs found + fixed during verification).

# Focus Session + Reschedule/Snooze — Implementation Plan

## Overview
Turn the two currently-stubbed Home affordances into real features:

1. **Reschedule/Snooze bottom sheet** — opened from the inert clock button on "Today's plan" (`_today_plan_card.dart:68`). Four actions (Snooze 30 min, Move to tonight, Shorten to 30 min, Skip today) that **deterministically edit the block's time/duration/date locally**, followed by a **narrow AI rewrite of `Schedule.aiReasoning`** ("Why this plan").
2. **Focus Session screen** — a new full-screen surface reached from the "Begin next block" button (`_today_plan_card.dart:64`). A determinate timer ring, the block's `activities` as guidance, a static `aiInsight` "Guided by tutor" panel, an "I'm stuck" deep-link into the existing `/tutor` screen, and a "Mark block done" action that writes `StudyBlock.status` and records a `SessionMetric`.

The block move is instant (it streams back to Home via the existing `watchBlocks` Drift stream); the reasoning refresh resolves a beat later and, on failure, silently keeps the prior reasoning (the move still stands).

## Current State Analysis
Full inventory in `docs/research/2026-06-16-focus-session-and-reschedule-sheet.md`. Key facts:

- **Both Home affordances are stubs.** "Begin next block" → `AppRoutes.plan.pushReplace(context)` (`lib/ui/screens/home/widgets/_today_plan_card.dart:64`); reschedule clock → `onTap: () {}` ("Reschedule is a later (Focus) plan — placeholder no-op", `:68-72`).
- **No single-block mutation path exists.** `PlanRepo` only has `generate / watchBlocks / currentSchedule / exams` (`lib/repos/plan/plan_repo.dart:30-44`). `StudyBlock.status` is stored but always written `'upcoming'` (`lib/repos/plan/plan_data_provider.dart:89`); UIs read clock-derived `effectiveStatus()` (`lib/core/models/schedule/study_block.dart:32-52`).
- **DB write seam**: `ScheduleDao.upsertBlock(StudyBlocksCompanion)` uses `insertOnConflictUpdate` keyed on `id` (`lib/core/db/daos/schedule_dao.dart:32`) — a partial companion updates one block. There is **no** `AppDatabase`-level single-block update wrapper and **no** `blockById` fetch. `AppDatabase.updateScheduleReasoning(scheduleId, reasoning)` already exists (`lib/core/db/database.dart:400`). Row→Map shape is `_studyBlockToMap` (`database.dart:471-485`), with `status` re-emitted as `.name` and `date` as ISO-8601.
- **AI seam**: `AiService.planModel(systemPrompt)` is a synchronous cached getter wired to `planSchema` (full days+blocks) (`lib/services/firebase/ai/ai_service.dart:72-80`). `SystemPrompts.plan()` loads `assets/plan_sys_prompt.md` with a static `_cache` map (`system_prompts.dart`). `AgentTools.planSchema` is a `Schema.object` getter (`agent_tools.dart:74-119`). Error handling pattern in `generate()`: `on Fault rethrow / on FirebaseAIException → AiFault.fromAiException(e,st) / on FormatException → UnknownFault(...) / catch → UnknownFault(...)` (`plan_data_provider.dart:120-128`).
- **Session metric**: `SessionMetric` has only `userId, date, durationMinutes, topicIds` — no blockId/subjectId (`lib/core/models/progress/session_metric.dart:10-15`). `ProgressDao.insertSessionMetric(SessionMetricsCompanion)` exists (`lib/core/db/daos/progress_dao.dart:37`); the companion's `topicIds` is a `required String` (JSON-encoded list). **No caller exists anywhere.**
- **Tutor deep-link**: `ChatCubit.startConversation(String subjectId)` (subject-only; `lib/blocs/chat/cubit.dart:65`) is fire-and-forget async that calls `_activate(...)` → sets `state.active` → tutor screen shows the chat (`tutor.dart:85-101`). `ChatCubit` is app-global (`app.dart:53`). No topic/starter-question param exists.
- **Design building blocks**: `AppModalBase` sheet base (`lib/ui/widgets/design/modals/app_modal_base.dart`); the `showModalBottomSheet` + transparent bg + `RouteSettings(name:)` + typed-enum-return pattern (`lib/ui/screens/library/widgets/_material_actions_sheet.dart:7-31`); `_SheetAction` row (`:147-198`) + `_SettingRow` chevron (`profile/widgets/_settings.dart:75-122`); `AppEdgeCard` for the footer note; `AppButton` / `AppIconButton`. **No determinate progress ring exists** — must build (only indeterminate spinners, `full_screen_loader.dart:78-99`).
- **Screen wrapper**: BottomBar is rendered only for a hardcoded route allowlist (`screen.dart:75-84`), so a new `/focus` route gets none with no opt-out flag needed. `scaffoldBackgroundColor` param exposed (`:127`); `Screen` applies no `SafeArea` itself (each screen wraps its own). Custom top/bottom bars go in-body (the tutor/create_account pattern), not via `appBar`.
- **Routing**: `AppRoutes` string constants (`lib/router/routes.dart`); full-screen surfaces use a `FadeRoute` case in `onGenerateRoutes` (`router.dart:27-58`); navigation via `'/route'.push(context)` (`lib/configs/extension/_string.dart:9`).

## Desired End State
- Tapping the clock button on Home's "Today's plan" opens a reschedule sheet; choosing an action visibly moves/edits the block in the Today list within a frame (Drift stream), and the "Why this plan" card refreshes its reasoning shortly after (or quietly keeps the old reasoning if the AI call fails).
- Tapping "Begin next block" opens the Focus Session screen for the current/next block with a live countdown ring; "Mark block done" returns to Home with the block shown as done and a `SessionMetric` persisted; "I'm stuck" lands the user in a fresh tutor conversation for the block's subject.
- `flutter analyze` clean, `build_runner` clean, new unit + widget tests pass.

## What We're NOT Doing
- **No full AI re-plan** on reschedule — only the four deterministic edits + a single-string reasoning rewrite. `generate()` is untouched.
- **No structured checklist/stepper** ("This block 1 of 3") — `StudyBlock.activities` is rendered as-is; no new step model, no plan-schema change for steps.
- **No "Your 62% quiz" source chip** and **no tutor source/citation chips** on Focus — citation data only exists after a tutor reply, which Focus has none of.
- **No real OS Do-Not-Disturb** — "Do Not Disturb on" is a static label only.
- **No tutor-seam changes** — deep-link uses `startConversation(subjectId)` only; no topicId threading, no auto-asked starter question.
- **No prayer-time data** — "Move to tonight" uses a fixed `20:30` after-Isha slot.
- **No `SessionMetric` schema change** — recorded with the existing four fields (`topicIds` carries the block's `topicId` when present).

## Implementation Approach
- **Layering**: all DB writes go through a new `AppDatabase.updateStudyBlock(...)` and the existing `updateScheduleReasoning` / `insertSessionMetric`. `PlanRepo` exposes Map/primitive methods (ADR-013). `PlanCubit` holds the typed `StudyBlock`, **computes** the new field values for each reschedule action, calls the repo, then triggers the reasoning refresh.
- **Reasoning refresh is decoupled from the move**: the cubit awaits the block write (fast, local), then fires the AI reasoning call tracked by a dedicated `reasoning` BlocState. The block move never depends on the AI call succeeding.
- **Focus timer is ephemeral**: the countdown/paused state lives in the Focus screen's `_ScreenState` (`ChangeNotifier`) with a `Timer.periodic`. Business actions (mark done) go through `PlanCubit`. `_ScreenState` never touches Firebase.
- **Block passed by route arguments**: "Begin next block" pushes `/focus` with the chosen `StudyBlock` as the argument; the Focus screen reads it from `ModalRoute.settings.arguments`.

---

## Phase 1: Plan layer — block mutation + AI reasoning refresh

### Overview
Add the write/AI plumbing and the `PlanCubit` actions that Phases 2 and 3 call. No UI yet.

### Changes Required

#### 1. DB single-block update
**File**: `lib/core/db/database.dart`
**Changes**: Add an `AppDatabase`-level method that builds a partial `StudyBlocksCompanion` (only the changed fields) and calls `scheduleDao.upsertBlock`. Takes the block `id` plus optional fields. Mirrors the existing `updateScheduleReasoning` style (targeted write inside `AppDatabase`).

```dart
Future<void> updateStudyBlock(
  String id, {
  String? startTime,
  int? durationMinutes,
  DateTime? date,
  BlockStatus? status,
}) async {
  await scheduleDao.upsertBlock(StudyBlocksCompanion(
    id: Value(id),
    startTime: startTime == null ? const Value.absent() : Value(startTime),
    durationMinutes:
        durationMinutes == null ? const Value.absent() : Value(durationMinutes),
    date: date == null ? const Value.absent() : Value(date),
    status: status == null ? const Value.absent() : Value(status),
  ));
}
```

> `upsertBlock` is `insertOnConflictUpdate` keyed on `id`; absent values are excluded from the update clause, so unspecified columns are left untouched.

#### 2. New narrow AI surface for reasoning rewrite
**Files**: `lib/services/firebase/ai/agent_tools.dart`, `lib/services/firebase/ai/ai_service.dart`, `lib/services/firebase/ai/system_prompts.dart`, `assets/plan_reason_sys_prompt.md`, `pubspec.yaml`, `lib/gen/assets/assets.gen.dart` (regenerated)

**`agent_tools.dart`** — add a tiny schema (single required string), mirroring `planSchema`'s getter style:
```dart
Schema get reasonSchema => Schema.object(
      properties: {
        'aiReasoning': Schema.string(
          description: "One short paragraph: why the plan still works after the change, "
              "in the student's language.",
        ),
      },
    );
```

**`ai_service.dart`** — add a cached `_reasoner` model field + getter (same shape as `planModel`):
```dart
GenerativeModel? _reasoner;

GenerativeModel reasonModel(String systemPrompt) =>
    _reasoner ??= FirebaseAI.googleAI().generativeModel(
      model: _planModel, // reuse gemini-2.5-flash
      systemInstruction: Content.system(systemPrompt),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: AgentTools.ins.reasonSchema,
      ),
    );
```

**`system_prompts.dart`** — add `reason()` + the asset constant:
```dart
static Future<String> reason() => _load(Assets.planReasonSysPrompt);
```

**`assets/plan_reason_sys_prompt.md`** — new prompt: given the current week's blocks summary, the nearest exam, and the change just made, produce one short reasoning paragraph in the student's language. Register it in `pubspec.yaml` under the existing per-file asset list, then regenerate `assets.gen.dart` (flutter_gen runs via build_runner).

#### 3. PlanRepo methods
**File**: `lib/repos/plan/plan_repo.dart` (+ `plan_data_provider.dart`)
**Changes**: Add Map/primitive methods delegating to `_PlanProvider`.

```dart
// plan_repo.dart
Future<void> updateBlock(Map<String, dynamic> patch) =>
    _PlanProvider.updateBlock(patch);          // patch: {id, startTime?, durationMinutes?, date?, status?}

Future<void> recordSession(Map<String, dynamic> metric) =>
    _PlanProvider.recordSession(metric);        // {userId, date, durationMinutes, topicIds}

Future<String> updateReasoning(String userId) =>
    _PlanProvider.updateReasoning(userId);      // returns the new reasoning string
```

**`_PlanProvider.updateBlock`** — parse the patch, call `AppDatabase.ins.updateStudyBlock(...)`. `status` arrives as a `.name` string → map to `BlockStatus.values.byName(...)`. `date` arrives as ISO-8601 → `DateTime.parse`.

**`_PlanProvider.recordSession`** — build a `SessionMetricsCompanion.insert(userId:, date:, durationMinutes:, topicIds: jsonEncode(list))` and call `AppDatabase.ins.progressDao.insertSessionMetric(...)` (add a thin `AppDatabase.recordSessionMetric(Map)` wrapper if direct DAO access from the repo is undesirable; prefer an `AppDatabase`-level method for symmetry with `replaceStudyBlocks`).

**`_PlanProvider.updateReasoning`** — load schedule + blocks + exams from `AppDatabase`, assemble a compact user turn (current blocks + nearest exam + "the student just rescheduled a block"), call `AiService.ins.reasonModel(await SystemPrompts.reason())`, `generateContent([Content.text(turn)])`, `_decode` the JSON, read `aiReasoning`, persist via `AppDatabase.ins.updateScheduleReasoning(scheduleId, reasoning)`, return the string. Use the **same error-handling block** as `generate()` (`on Fault rethrow / FirebaseAIException → AiFault / FormatException → UnknownFault / catch → UnknownFault`).

#### 4. PlanCubit actions + reasoning state
**Files**: `lib/blocs/plan/cubit.dart`, `lib/blocs/plan/state.dart`
**Changes**: Add a `reasoning: BlocState<String>` field to `PlanState` (threaded through constructor / `def` / `copyWith` / `props`), then add the action methods. The cubit holds the `StudyBlock`, computes new values, calls the repo, and refreshes reasoning.

```dart
Future<void> snoozeBlock(StudyBlock b) =>
    _reschedule(b, startTime: _addMinutes(b.startTime, 30));

Future<void> moveToTonight(StudyBlock b) =>
    _reschedule(b, startTime: '20:30');                    // fixed after-Isha slot

Future<void> shortenBlock(StudyBlock b) =>
    _reschedule(b, durationMinutes: b.durationMinutes <= 30 ? b.durationMinutes : 30);

Future<void> skipBlock(StudyBlock b) =>
    _reschedule(b, date: b.date.add(const Duration(days: 1)));

Future<void> _reschedule(StudyBlock b, {String? startTime, int? durationMinutes, DateTime? date}) async {
  try {
    await PlanRepo.ins.updateBlock({
      'id': b.id,
      if (startTime != null) 'startTime': startTime,
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      if (date != null) 'date': date.toIso8601String(),
    });
    // Block move is committed (streams to Home). Now refresh reasoning.
    await _refreshReasoning();
  } on Fault catch (e) {
    emit(state.copyWith(reasoning: state.reasoning.toFailed(fault: e)));
  }
}

Future<void> _refreshReasoning() async {
  final userId = _watchingUserId;
  if (userId == null) return;
  emit(state.copyWith(reasoning: state.reasoning.toLoading()));
  try {
    final text = await PlanRepo.ins.updateReasoning(userId);
    emit(state.copyWith(reasoning: state.reasoning.toSuccess(data: text)));
    // aiReasoning is persisted; watchBlocks stream + schedule re-read surface it on Home.
  } on Fault catch (e) {
    // Keep prior reasoning — the move still stands.
    emit(state.copyWith(reasoning: state.reasoning.toFailed(fault: e)));
  }
}

Future<void> markBlockDone(StudyBlock b) async {
  await PlanRepo.ins.updateBlock({'id': b.id, 'status': BlockStatus.done.name});
  final userId = _watchingUserId;
  if (userId != null) {
    await PlanRepo.ins.recordSession({
      'userId': userId,
      'date': DateTime.now().toIso8601String(),
      'durationMinutes': b.durationMinutes,
      'topicIds': [if (b.topicId != null) b.topicId],
    });
  }
}
```

> `_addMinutes` is a small helper parsing `"HH:mm"`, adding minutes with hour rollover, re-formatting. Lives in the cubit (logic) or an existing time util if one exists.

> **`Why this plan` re-read**: `_WhyThisPlanCard` reads `PlanCubit.c(context).week?.aiReasoning`. Since the reasoning is persisted to the `schedules` row (not the blocks stream), confirm the card reflects it — if `week.aiReasoning` is sourced from the assembled `WeekPlan` rather than a live schedule read, have `_refreshReasoning` also update the in-memory `schedule`/`week` reasoning (emit an updated `WeekPlan` with the new `aiReasoning`) so the card updates without a full re-watch. Verify during implementation against `_assembleWeek` (`cubit.dart:90-122`).

### Hygen Commands
```bash
# Thread the reasoning BlocState through PlanState boilerplate, then hand-edit:
# (the generated generic action/repo stubs for this module are removed/replaced by the custom
#  methods above — use the generator only for the state-field threading it does reliably)
hygen cubit update plan --args "reasoning:String"
```
> If the generated `reasoning()` action + `PlanRepo.reasoning()` stub conflict with the custom methods, delete those generated stubs and keep only the state-field threading. Hand-writing the state field is acceptable if the generator's repo injection is more trouble than the threading it saves — decide at implementation time.

### Success Criteria

#### Automated Verification
- [x] `flutter pub run build_runner build --delete-conflicting-outputs` clean (freezed state regen + assets.gen)
- [x] `flutter analyze` — zero new errors
- [x] `flutter test test/blocs/plan/` passes (new action tests, see Testing Strategy)

#### Manual Verification
- [ ] (Deferred to Phase 2/3 where these actions are wired to UI.)

**Implementation Note**: After this phase and all automated verification passes, pause for manual confirmation before proceeding.

---

## Phase 2: Reschedule/Snooze bottom sheet

### Overview
Build the sheet and wire it to the Home clock button. Each action calls a Phase-1 `PlanCubit` method.

### Changes Required

#### 1. The sheet
**File**: `lib/ui/screens/home/widgets/_reschedule_sheet.dart` (new `part of '../home.dart';`)
**Changes**: A `showRescheduleSheet(BuildContext, StudyBlock, {String? subjectName})` helper + the sheet widget + a `_RescheduleAction` row. Follows the library `_material_actions_sheet` pattern exactly.

```dart
Future<void> showRescheduleSheet(BuildContext context, StudyBlock block) async {
  final cubit = PlanCubit.c(context);
  final action = await showModalBottomSheet<_RescheduleChoice>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    routeSettings: const RouteSettings(name: '/modal/reschedule'),
    builder: (_) => _RescheduleSheet(block: block),
  );
  if (!context.mounted || action == null) return;
  switch (action) {
    case _RescheduleChoice.snooze:       cubit.snoozeBlock(block);
    case _RescheduleChoice.tonight:      cubit.moveToTonight(block);
    case _RescheduleChoice.shorten:      cubit.shortenBlock(block);
    case _RescheduleChoice.skip:         cubit.skipBlock(block);
  }
}
```

- Header: `AppModalBase` with the clock icon tile + "Reschedule this block" + subtitle `"<subject> · <title> · <startTime> · <fmtBlockLength(duration)>"`.
- Four `_RescheduleAction` rows (icon tile + title + computed subtitle + trailing `LucideIcons.chevron_right`), each `Navigator.pop(context, _RescheduleChoice.x)`:
  - Snooze 30 min — `"Start this block at <startTime+30> instead"`
  - Move to tonight — `"Slot it after Isha · 20:30"`
  - Shorten to 30 min — `"Keep <startTime>, trim the walkthrough"`
  - Skip today — `"Fold it into tomorrow's plan"`
- Footer: `AppEdgeCard` (accent edge) with **static** copy: *"I'll re-plan around your choice and update 'Why this plan'."* (No live exam-days interpolation needed; keep static per scope. Optional: append nearest-exam text from `PlanCubit.c(context).nextExam` if trivially available.)
- Cancel: `AppButton` (creamy) → `Navigator.pop(context)`.

`_RescheduleAction` is a new private widget = `_SheetAction` shape + trailing chevron (combine the two existing patterns).

#### 2. Wire the clock button
**File**: `lib/ui/screens/home/widgets/_today_plan_card.dart`
**Changes**: Replace the no-op at `:68-72`. The block to reschedule is the current "now" block, else the next "upcoming" block.

```dart
AppIconButton(
  icon: LucideIcons.clock,
  onTap: () {
    final target = _rescheduleTarget(today.blocks); // now block, else next upcoming
    if (target != null) showRescheduleSheet(context, target);
  },
),
```

### Hygen Commands
_None — sheet widgets are added by hand as `part` files (consistent with `_material_actions_sheet.dart`)._

### Success Criteria

#### Automated Verification
- [x] `flutter analyze` — zero new errors
- [x] `flutter test test/screens/home/` passes (sheet widget test, see Testing Strategy)

#### Manual Verification
- [ ] Clock button opens the sheet with correct header + computed subtitles (snooze time = start+30, etc.)
- [ ] Choosing Snooze/Move/Shorten/Skip visibly updates the block in the Today list within a frame
- [ ] "Why this plan" reasoning refreshes shortly after (and a forced AI failure leaves the prior reasoning intact while the move stays)
- [ ] Cancel dismisses with no change
- [ ] No `unknown` route in navigation logs (RouteSettings name set)

**Implementation Note**: Pause for manual confirmation before proceeding.

---

## Phase 3: Focus Session screen

### Overview
New full-screen Focus surface reached from "Begin next block", with a live timer ring, block guidance, a static tutor panel, and the done/stuck actions.

### Changes Required

#### 1. Scaffold the screen
**Hygen**:
```bash
hygen screen new focus --formData false --widgets "top_bar,timer_ring,block_card,tutor_panel,actions"
```
Then convert the route to a `FadeRoute` (move the generated `appRoutes`-map entry into an `onGenerateRoutes` case in `lib/router/router.dart`, matching plan/home):
```dart
case AppRoutes.focus:
  return FadeRoute(child: const FocusScreen(), settings: settings);
```

#### 2. Ephemeral timer state
**File**: `lib/ui/screens/focus/_state.dart`
**Changes**: `_ScreenState` owns the countdown. A `Timer.periodic(const Duration(seconds: 1), ...)` decrements `remaining`; `paused` toggles it; expose `elapsedMinutes` for the done action. Initialize `remaining` from the block's `durationMinutes`. Cancel the timer in `dispose`. No Firebase here.

```dart
class _ScreenState extends ChangeNotifier {
  _ScreenState(this.block) { _total = Duration(minutes: block.durationMinutes); _remaining = _total; _start(); }
  final StudyBlock block;
  late Duration _total, _remaining;
  Timer? _timer; bool paused = false;
  Duration get remaining => _remaining;
  double get fraction => 1 - (_remaining.inSeconds / _total.inSeconds).clamp(0.0, 1.0);
  int get elapsedMinutes => (_total - _remaining).inMinutes;
  void togglePause() { paused = !paused; paused ? _timer?.cancel() : _start(); notifyListeners(); }
  void _start() { _timer?.cancel(); _timer = Timer.periodic(const Duration(seconds: 1), (_) { if (_remaining.inSeconds > 0) { _remaining -= const Duration(seconds: 1); notifyListeners(); } }); }
  @override void dispose() { _timer?.cancel(); super.dispose(); }
  static _ScreenState s(BuildContext c, [bool listen = false]) => Provider.of<_ScreenState>(c, listen: listen);
}
```
> The block is read from route args in `FocusScreen.build` and passed to `ChangeNotifierProvider(create: (_) => _ScreenState(block))`.

#### 3. Determinate timer ring (new widget)
**File**: `lib/ui/screens/focus/widgets/_timer_ring.dart`
**Changes**: A `CustomPainter` drawing a background track circle + a foreground arc sweeping `fraction * 2π` from top, with the remaining time (`AppText` mono, e.g. `54:12`) and "remaining · 60 min" centered. Colors: track `AppTheme.c.border`, arc `AppTheme.c.accent`. Reads `_ScreenState.s(context, true).fraction` + `remaining`.

#### 4. Top bar, block card, tutor panel, actions
**Files**: `lib/ui/screens/focus/widgets/_top_bar.dart`, `_block_card.dart`, `_tutor_panel.dart`, `_actions.dart`
- **`_top_bar.dart`**: in-body row — `AppIconButton(chevron_down)` → `AppRoutes.x.pop(context)`; centered "FOCUS SESSION" + "Block N of M · Do Not Disturb on" (static DND label; N/M from `PlanCubit.today` index); `AppIconButton(pause/play)` → `_ScreenState.togglePause()`.
- **`_block_card.dart`**: subject dot + "SUBJECT · WALKTHROUGH" label, the block `title` (serif), and a card rendering `block.activities` as the guidance text. **No stepper.**
- **`_tutor_panel.dart`**: `AppAiPill('Guided by tutor')` + the block's `aiInsight` rendered statically (hidden if null/empty). **No source chips.**
- **`_actions.dart`**: bottom row — "I'm stuck" (`AppButton` creamy) and "Mark block done" (`AppButton` primary, check icon).
  - "I'm stuck": `ChatCubit.c(context).startConversation(block.subjectId); AppRoutes.tutor.push(context);`
  - "Mark block done": `PlanCubit.c(context).markBlockDone(block); AppRoutes.x.pop(context);` (record uses `block.durationMinutes` per Phase 1; if recording actual elapsed is preferred, pass `_ScreenState.s(context).elapsedMinutes`).
- **`Screen`** with `scaffoldBackgroundColor: <cream>` (the spec'd Focus background), `keyboardHandler: false`, child wrapped in `SafeArea`.

#### 5. Wire "Begin next block"
**File**: `lib/ui/screens/home/widgets/_today_plan_card.dart`
**Changes**: Replace `:64`'s `AppRoutes.plan.pushReplace(context)`:
```dart
onTap: () {
  final target = _focusTarget(today.blocks); // now block, else next upcoming
  if (target != null) AppRoutes.focus.push(context, arguments: target);
},
```
`FocusScreen` reads `ModalRoute.of(context)!.settings.arguments as StudyBlock`.

### Hygen Commands
```bash
hygen screen new focus --formData false --widgets "top_bar,timer_ring,block_card,tutor_panel,actions"
```

### Success Criteria

#### Automated Verification
- [x] `flutter analyze` — zero new errors
- [x] `flutter test test/screens/focus/` passes (generated + extended widget test)

#### Manual Verification
- [ ] "Begin next block" opens Focus for the correct block; ring counts down; pause/resume works
- [ ] `activities` shows as guidance; `aiInsight` panel shows (or is hidden when empty); no source chips
- [ ] "Mark block done" returns to Home, block shows done, a `SessionMetric` row is written (verify via DB/log)
- [ ] "I'm stuck" opens `/tutor` in a fresh conversation for the block's subject
- [ ] chevron-down dismisses; no BottomBar on the Focus route; cream background renders
- [ ] No `unknown` route in navigation logs

**Implementation Note**: Pause for manual confirmation before proceeding.

---

## Phase 4: Tests

### Overview
Cover the new business logic and the two UI surfaces. Mocktail-only per `docs/TESTING.md` (no bloc_test); repo `.ins` seam mocked.

### Changes Required
- **`test/blocs/plan/plan_cubit_test.dart`** (extend): `snoozeBlock` computes `startTime+30` (incl. hour rollover), `moveToTonight` sets `20:30`, `shortenBlock` clamps to 30 (and leaves ≤30 untouched), `skipBlock` advances `date` by one day, each calling `PlanRepo.updateBlock` with the right patch; `_refreshReasoning` emits loading→success and, on repo throw, emits failed while leaving prior `week.aiReasoning` intact; `markBlockDone` writes `status:done` + records a session with `topicIds:[block.topicId]`.
- **`test/screens/home/reschedule_sheet_test.dart`** (new): sheet renders header + four rows with correct computed subtitles; tapping each row pops the matching `_RescheduleChoice`; Cancel pops null.
- **`test/screens/focus/focus_screen_test.dart`** (extend generated): renders the block title/activities; "Mark block done" calls `PlanCubit.markBlockDone`; "I'm stuck" calls `ChatCubit.startConversation` + navigates; ring renders.

### Success Criteria
#### Automated Verification
- [x] `flutter test` — full suite passes
- [x] `flutter analyze` — zero new errors

---

## Testing Strategy

### Unit Tests
- `PlanCubit`: the five actions' field computations + repo-call patches; `reasoning` BlocState transitions (loading/success/failure-keeps-prior); `markBlockDone` session recording. Mock `PlanRepo.ins` via the existing `.ins` seam.
- Time helper `_addMinutes` edge cases (rollover past midnight, `:00`/`:30` inputs).

### Widget Tests
- Reschedule sheet: render + per-row pop value + Cancel.
- Focus screen: render block guidance, mark-done → cubit, I'm-stuck → cubit + nav. Use a fake `PlanCubit`/`ChatCubit` per the test helpers in `docs/TESTING.md`.

### Manual Testing Steps
1. Home → clock → Snooze → confirm Today list shifts the block to start+30 and "Why this plan" reasoning refreshes.
2. Repeat for Move to tonight (20:30), Shorten (30 min), Skip (gone from today / appears tomorrow).
3. Force the reasoning AI call to fail (airplane mode after the local write) → block move stands, old reasoning remains.
4. Home → Begin next block → ring counts down, pause/resume, Mark done → Home shows done.
5. Focus → I'm stuck → lands in `/tutor` fresh conversation for the subject.

## Architecture Checklist
- [ ] `App.init(context)` called at top of every `build()` (Focus screen + all part widgets + sheet)
- [ ] UI layer (`_state.dart`) does not call Firebase or HTTP (timer only; mark-done delegates to `PlanCubit`)
- [ ] Cubits do not import from `lib/ui/`
- [ ] State accessed via `XCubit.c(context)` / `_ScreenState.s(context)` — not `context.read<X>()`
- [ ] Firebase/AI exceptions converted to typed `Fault` in `_PlanProvider.updateReasoning` (same block as `generate()`)
- [ ] Screen/widget boilerplate via `hygen` (`screen new focus`); sheet `part` widgets by hand per existing sheet convention
- [ ] Spacing via `Space.*` tokens; `.map()` (no for-loops) for the sheet rows
- [ ] `RouteSettings(name:)` on the reschedule sheet and `/focus` route
- [ ] Widget-extraction threshold respected (ring, rows, panels each clear ≥5 children / ≥30 lines)

## References
- Research: `docs/research/2026-06-16-focus-session-and-reschedule-sheet.md`
- Related research: `docs/research/2026-06-15-study-plan-generation.md`, `docs/research/2026-06-14-chat-agent-integration.md`
- Repo-layer rule: `docs/architecture/DECISIONS.md` (ADR-013)
- Sheet pattern: `lib/ui/screens/library/widgets/_material_actions_sheet.dart:7-31,147-198`
- AI call pattern: `lib/repos/plan/plan_data_provider.dart:26-128`
- DB write seams: `lib/core/db/database.dart:400-439`, `lib/core/db/daos/schedule_dao.dart:32-39`
- Tutor deep-link: `lib/blocs/chat/cubit.dart:65,83`
- Testing conventions: `docs/TESTING.md`
