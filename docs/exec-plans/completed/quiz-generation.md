---
title: "Quiz Generation (v1) — AI pipeline, persistence, quiz-taking + results UI"
status: completed
created: 2026-06-18
completed: 2026-06-19
---

✅ COMPLETED — All phases built, driver-verified (Library entry), tests green.

# Quiz Generation (v1) — Implementation Plan

## Overview

Build the AI quiz feature end-to-end: from a study **Focus session** or a **Library material**, generate a structured **single-answer MCQ quiz** (8 questions) with Gemini — grounded on the subject's extracted material text when available, falling back to subject/topic knowledge — persist it, render a quiz-taking screen with inline per-question feedback, and finish on a results screen with score + per-question review.

This mirrors the now-completed **study-plan-generation** pipeline 1:1 (repo → AI glue → AppDatabase Map-wrappers → cubit → screen + listener). The data models, Drift tables, and `QuizDao` already exist; the material-grounding source is already solved by the chat agent. Full current-state detail: `docs/research/2026-06-18-quiz-generation.md`.

## Completion Notes (2026-06-19)

All five phases shipped and driver-verified (Library → Generate quiz → take → results → Done). Two enhancements landed on top of the original v1 scope:

- **Quiz scope — single / subset / whole subject.** The generation param is `sourceItemIds: List<String>?` (migrated from a single `sourceItemId`) threaded through `QuizArgs → _ScreenState → QuizCubit → QuizRepo → _QuizProvider`. One id = single-material (per-material "⋯ → Generate quiz"); several = a chosen subset; null/empty = every indexed material in the subject (Focus "Test yourself"). New Library UX: each subject-section header has a gold **"Quiz"** pill (shown only when the subject has ≥1 indexed material) → a **scope sheet** (`_quiz_scope_sheet.dart`) listing the subject's indexed materials, all pre-checked, with Select all / Clear all and a count-aware "Generate quiz · N materials" button. No new DB surface — reuses `materialTextForItem` (looped) + `materialTextsForSubject`.
- **Question count by scope.** Single material → **8** questions (`_materialQuestions`); a subset or the whole subject → **15** (`_subjectQuestions`). The UI is count-agnostic (progress bar + "Question N of M" derive from `quiz.questions.length`).
- **Exit confirmation.** Leaving mid-quiz (header back arrow or system back during the taking phase) shows an `showAppAlert` confirmation ("Leave the quiz? — progress won't be saved", Keep going / destructive Leave) via `Screen(canPop:/onBackPressed:)`. Loading, failure, and the results phase pop freely.

Tests: `test/blocs/quiz/quiz_cubit_test.dart` (generate success/failure, **subset forwarding**, recordAnswer) + `test/screens/quiz/quiz_test.dart` (render, pick→feedback, Skip, Next→results, **exit-confirmation**). 53 tests green; `flutter analyze` clean. Two driver-only `ValueKey`s were added (`material_more_<id>` on the Library ⋯, `quiz_back` on the quiz header) to aid driving/testing.

## Current State Analysis

The quiz **data + DB layers are fully scaffolded**; AI glue, persistence wrappers, repo/cubit, and all UI are absent. (Full detail: `docs/research/2026-06-18-quiz-generation.md`.)

Key files:
- `lib/core/models/quiz/{quiz,quiz_question,quiz_attempt,quiz_feedback}.dart` — model set complete. `QuizQuestion{text, type(QuestionType), markValue, options, correctAnswerIndex?, timeLimit?}` has **no `explanation`/`citation`** field. `Quiz{subjectId, currentQuestionIndex, questions[], topicId?, sourceLabel?, isAIGenerated}`.
- `lib/core/db/tables/quiz_table.dart` — `Quizzes`/`QuizQuestions`/`QuizAttempts`/`QuizFeedbackItems`. **`QuizQuestions` column is `content`, model field is `text`** (mismatch). No `explanation`/`citation` columns.
- `lib/core/db/daos/quiz_dao.dart` — `QuizDao`: `findById`, `questionsForQuiz`, `attemptsForUser`, `feedbackForAttempt`, `upsertQuiz`, `upsertQuestion`, `insertAttempt`, `insertFeedback`.
- `lib/core/db/database.dart:95` — `schemaVersion = 4`; `MigrationStrategy.onUpgrade` `if (from < N)` blocks. **No quiz `AppDatabase` Map-wrappers.**
- `lib/services/firebase/ai/ai_service.dart` — `planModel`/`chatModel`/`reasonModel` template; **no `quizModel`**.
- `lib/services/firebase/ai/agent_tools.dart:74` — `planSchema` (Schema API to copy); **no `quizSchema`**.
- `lib/services/firebase/ai/system_prompts.dart` — `plan()`/`chat()`/`reason()` loaders; **no `quiz()`**.
- `assets/quiz_sys_prompt.md` — **EMPTY (0 bytes)**; registered in `pubspec.yaml:175`; `Assets.quizSysPrompt` resolves.
- `lib/core/db/daos/material_texts_dao.dart` — `forSubject(userId, subjectId)` / `forItem(itemId)` — the grounding source. `repos/chat/chat_data_provider.dart:148` `_groundingBlock` + `_groundingCharBudget=12000` to mirror.
- `lib/repos/plan/` + `lib/blocs/plan/` — the repo/cubit scaffold to mirror exactly.
- `lib/ui/screens/focus/widgets/_actions.dart` — Focus block-end action row (entry point #1).
- `lib/ui/screens/library/widgets/_material_actions_sheet.dart` — per-material action sheet (entry point #2).
- `lib/router/routes.dart` — `AppRoutes`; **no `quiz`**.

## Desired End State

From the Focus screen ("Test yourself" on the active block) or a Library material's action sheet ("Generate quiz", enabled only for `indexed` materials), the app calls Gemini once to produce 8 single-answer MCQs (each with 4 options, a correct index, an `explanation`, and a `citation` when grounded), persists the quiz + questions, and opens the quiz screen. The user answers each question with **immediate inline feedback** (correct/wrong option styling + explanation + source citation), can Skip, and on finishing sees a **results screen** (score, correct/total, per-question review). Each answer is persisted as a `QuizAttempt`. Re-running generation makes a fresh quiz. Verifiable via the Dart MCP driver on the stage flavor.

## What We're NOT Doing

- **Multiple-answer and short-answer question types** — `QuestionType` enum keeps all three, but v1 generates and renders **single-answer MCQ only** (deterministic grading, no second AI grading call).
- **`QuizFeedback` table writes** — feedback is deterministic (`isCorrect` + the question's pre-generated `explanation`), so no per-attempt `QuizFeedbackItems` rows. Table/model kept as scaffold (rule 12).
- **`QuizHistory` / `DailyScore` / Progress-screen wiring** — quiz scores are not surfaced in Progress yet; the results screen reads in-memory state. (Attempts are persisted, so this is a thin follow-up.)
- **Question flag** (design header flag icon) and **"See in source" deep-link** (no page anchors into material) — dropped for v1.
- **Timer enforcement** — `timeLimit` unused; the per-question stopwatch is **display-only**.
- **Quiz history / list / re-take UI** — a quiz is generated and taken in one session.
- **Onboarding/auto generation** — quizzes are only generated on explicit user action from the two entry points.

## Implementation Approach

**Decisions (confirmed with user):**
- **Entry points (a):** Focus session end ("Test yourself" on the block) **and** Library per-material ("Generate quiz"). Both converge on one repo method.
- **Grounding (b):** material text when available, else subject/topic. Reuse chat's `MaterialTextsDao` + 12k-char budget verbatim.
- **Question types (c):** single-answer MCQ only.
- **Scope (d):** quiz-taking flow **+ results screen**.

**Locked design decisions (derived):**
- **One generation call; feedback bundled.** Each MCQ carries its `explanation` + optional `citation` from generation → **adds 2 columns** to `QuizQuestions` (schema 4→5).
- **`content`↔`text` reconciled in the Map-wrapper** (map explicitly, like `_studyBlockToMap`), **not** a column rename — no destructive migration.
- **Persist** `Quiz` + `QuizQuestions` + per-answer `QuizAttempts` (DB layer already scaffolded). Results read in-memory.
- **Fixed 8 questions** per quiz.
- **One `quiz` route**; the screen renders `_QuestionView` → `_ResultsView` via an internal `_ScreenState.phase` (no completed-quiz arg-passing). The route accepts only the generation params.

**Layering (ADR-013):** `QuizRepo` public methods take/return `Map`/`List<Map>`/primitives; `QuizCubit` does `Quiz.fromJson`. Gemini + Drift live behind `QuizRepo` (via `AiService` + `AppDatabase` Map-wrappers). `FirebaseAIException → AiFault`; `FormatException`/other → `UnknownFault`.

**All boilerplate via hygen (rule 4):** every screen, cubit, repo, listener, and private widget in this plan is scaffolded with a generator — never hand-created. The exact commands per phase are listed under each "Hygen Commands" heading; **`docs/tooling/HYGEN.md` is the authoritative reference** for every generator (flags, generated file layout, injection markers, and the full-workflow example). Consult it before running any `hygen …` command below, and use `build_runner` (per HYGEN.md) after every `@freezed`/Drift change.

**Generation params:** a small Map/record `{subjectId, topicId?, sourceItemId?}` passed as the quiz route argument. Grounding resolves: `sourceItemId != null` → `MaterialTexts.forItem(itemId)`; else → `MaterialTexts.forSubject(userId, subjectId)`; empty → subject/topic-only prompt. `sourceLabel` ("Generated from <material name>" or the subject name) is computed in the provider.

**Navigation:** the quiz route is pushed over Focus/Library (not a tab). Respect the documented back-stack constraint in `docs/research/2026-06-18-navigation-routing-stack.md` — use a plain push (not tab `pushReplace`); on results "Done", pop back to the originating screen (Focus pops to itself/home; Library pops to library).

---

## Phase 1: AI plumbing — prompt, schema, model

### Overview
Stand up the Gemini surface for quiz generation with no UI. Mirrors study-plan Phase 1.

### Changes Required

#### 1. System prompt
**File**: `assets/quiz_sys_prompt.md` (currently empty)
**Changes**: Author a single-answer MCQ generator prompt. Spec: role = quiz author for a Pakistani student; **inputs** (in the user turn) = subject `name` + `confidenceLevel` (lower confidence ⇒ easier/foundational), optional `topic` name, optional **grounding material** (chunks tagged `[itemId | name]`, mirroring chat), requested question count (8), and the student's language. **Output rules:** return ONLY JSON matching the schema; exactly **4 options** per question, **one** correct (`correctAnswerIndex` 0–3); a one–two sentence `explanation` (why the answer is correct, briefly noting why the others are wrong) in the **student's language**; a `citation` string referencing the grounding chunk's name + locator **only when grounded** (omit/null otherwise — never fabricate a source); calibrate difficulty to confidence; vary which option index is correct; no prose outside JSON. Provide a top-level `sourceLabel` describing the basis ("Generated from <name>" when grounded).

#### 2. Prompt loader
**File**: `lib/services/firebase/ai/system_prompts.dart`
**Changes**: add, mirroring `plan()`:
```dart
/// Quiz generation prompt (`assets/quiz_sys_prompt.md`).
static Future<String> quiz() => _load(Assets.quizSysPrompt);
```

#### 3. Response schema
**File**: `lib/services/firebase/ai/agent_tools.dart`
**Changes**: add `quizSchema` (single-answer MCQ; the app fills id/quizId/index/type/markValue):
```dart
Schema get quizSchema => Schema.object(
  properties: {
    'sourceLabel': Schema.string(
      nullable: true,
      description: 'Short basis label, e.g. "Generated from Lec 12" when '
          'grounded on a material, else the subject name.',
    ),
    'questions': Schema.array(
      description: 'Exactly the requested number of single-answer MCQs.',
      items: Schema.object(
        properties: {
          'text': Schema.string(description: 'The question stem.'),
          'options': Schema.array(
            description: 'Exactly 4 answer options.',
            items: Schema.string(),
          ),
          'correctAnswerIndex': Schema.integer(
            description: 'Index (0–3) of the single correct option.',
          ),
          'explanation': Schema.string(
            description: 'Why the correct option is right (and others wrong), '
                "in the student's language.",
          ),
          'citation': Schema.string(
            nullable: true,
            description: 'Source ref (material name + locator) when grounded; '
                'omit when not grounded.',
          ),
        },
        optionalProperties: ['citation'],
      ),
    ),
  },
);
```

#### 4. Generative model
**File**: `lib/services/firebase/ai/ai_service.dart`
**Changes**: add `_quiz` field + `quizModel`, mirroring `planModel`:
```dart
static const _quizModel = 'gemini-2.5-flash';
GenerativeModel? _quiz;

/// Structured single-answer MCQ generator: JSON-only output ([AgentTools.quizSchema]).
GenerativeModel quizModel(String systemPrompt) =>
    _quiz ??= FirebaseAI.googleAI().generativeModel(
      model: _quizModel,
      systemInstruction: Content.system(systemPrompt),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: AgentTools.ins.quizSchema,
      ),
    );
```

### Hygen Commands
_None — hand-edit the three AI files + the asset (no scaffold)._

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` — zero new errors.
- [ ] `assets/quiz_sys_prompt.md` is non-empty (already registered in pubspec; `Assets.quizSysPrompt` resolves).

#### Manual Verification
- [ ] `SystemPrompts.quiz()` returns the prompt text (temporary debug print / harness).

**Implementation Note**: Pause for manual confirmation before Phase 2.

---

## Phase 2: Persistence — question columns, migration, DB Map-wrappers

### Overview
Add storage for per-question `explanation`/`citation`, and the Map-based `AppDatabase` methods the repo needs. Reconcile the `content`↔`text` mismatch in the wrapper (no rename).

### Changes Required

#### 1. `explanation` + `citation` on the question
**Files**: `lib/core/models/quiz/quiz_question.dart`, `lib/core/db/tables/quiz_table.dart`
**Changes**: add `String? explanation` and `String? citation` to the `QuizQuestion` freezed model; add `TextColumn get explanation => text().nullable()();` and `TextColumn get citation => text().nullable()();` to `QuizQuestions`. (Leave the `content` column name as-is.)

#### 2. Drift migration
**File**: `lib/core/db/database.dart`
**Changes**: bump `schemaVersion` to **5**; extend `onUpgrade`:
```dart
if (from < 5) {
  await m.addColumn(quizQuestions, quizQuestions.explanation);
  await m.addColumn(quizQuestions, quizQuestions.citation);
}
```

#### 3. `AppDatabase` Map-wrappers
**File**: `lib/core/db/database.dart` (new `// --- Quiz persistence ---` block, mirroring the study-plan block)
**Changes**: add (model-free repo surface; conversion happens here):
```dart
Future<Map<String, dynamic>?> quizById(String quizId);            // QuizDao.findById + questionsForQuiz → _quizToMap (with nested questions)
Future<void> replaceQuizQuestions(                                // txn: upsert Quiz + its questions
    Map<String, dynamic> quiz, List<Map<String, dynamic>> questions); // calls Quiz.fromJson / QuizQuestion.fromJson INSIDE the wrapper
Future<void> insertQuizAttempt(Map<String, dynamic> attempt);     // QuizAttempt.fromJson inside → QuizDao.insertAttempt
```
Plus private converters:
- `_quizToMap(QuizRow r, List<QuizQuestionRow> qs)` — keys `id, subjectId, topicId, currentQuestionIndex, sourceLabel, isAIGenerated, questions: [...]`.
- `_quizQuestionToMap(QuizQuestionRow r)` — **maps `content` column → `text` key**, plus `id, quizId, index, type(.name), markValue, options, correctAnswerIndex, timeLimit, explanation, citation`.

(`QuizDao` already has `findById`/`questionsForQuiz`/`upsertQuiz`/`upsertQuestion`/`insertAttempt` — no DAO changes needed. Add `deleteQuestionsForQuiz` to `QuizDao` only if `replaceQuizQuestions` needs a clean re-insert; for a freshly-created quiz id this is not required.)

### Hygen Commands
_None — model/table/db edits + build_runner._

### Success Criteria
#### Automated Verification
- [ ] `flutter pub run build_runner build --delete-conflicting-outputs` clean (freezed + drift regenerate).
- [ ] `flutter analyze` — zero new errors.

#### Manual Verification
- [ ] Fresh install creates the v5 schema; an upgrade from v4 adds the two columns without data loss (open app twice).

**Implementation Note**: Pause for manual confirmation before Phase 3.

---

## Phase 3: `quiz` cubit + repo (generation)

### Overview
The generation engine: resolve inputs + grounding → call Gemini → parse → persist → return a `Quiz` map. Plus answer recording.

### Changes Required

#### 1. Generate the scaffold
**Hygen**: `hygen cubit nested quiz` → `lib/blocs/quiz/{cubit,state}.dart` + `lib/repos/quiz/{quiz_repo,quiz_mocks,quiz_parser,quiz_data_provider}.dart`, auto-registered in `lib/app.dart`.

#### 2. Repo — generation + answer recording
**Files**: `lib/repos/quiz/quiz_repo.dart` (+ `quiz_data_provider.dart`)
**Changes**: public methods (ADR-013, Map in/out):
- `Future<Map<String, dynamic>> generate({required String userId, required String subjectId, String? topicId, String? sourceItemId})` — `_QuizProvider.generate`:
  1. Load subject (+ topic if `topicId`) via `AppDatabase` wrappers (reuse `subjectsForUser` / add `subjectById` + `topicById` Map-wrappers if absent).
  2. Resolve grounding: `sourceItemId != null` → `MaterialTexts.forItem` (add a Map-wrapper `materialTextForItem(itemId)`); else `materialTextsForSubject(userId, subjectId)` (add wrapper around `MaterialTextsDao.forSubject`). Build the grounding block with the **same 12k-char budget + `[itemId | name]` tagging** as `chat_data_provider._groundingBlock`.
  3. Build the user turn (subject name + confidence, topic, grounding block or "no material", count=8, language).
  4. `AiService.ins.quizModel(await SystemPrompts.quiz()).generateContent([Content.text(userTurn)])`.
  5. `_decode(res.text)` (`jsonDecode`; `FormatException` on empty). Generate a quiz `id` (uuid); for each question build a `QuizQuestion.toJson()`-shaped map with fresh `id`, `quizId`, `index`, `type: 'singleAnswer'`, `markValue: 1`, `text`, `options`, `correctAnswerIndex`, `explanation`, `citation`. Build the `Quiz` map `{id, subjectId, topicId, currentQuestionIndex: 0, sourceLabel, isAIGenerated: true}`.
  6. `replaceQuizQuestions(quizMap, questionMaps)`.
  7. Return a `Quiz.toJson()`-shaped map with nested `questions` (what the cubit hydrates).
  - Errors: `on Fault → rethrow`; `on FirebaseAIException → AiFault.fromAiException`; `on FormatException → UnknownFault('Couldn\'t read the quiz. Please try again.')`; else `UnknownFault('Couldn\'t build your quiz. Please try again.')`.
- `Future<void> recordAnswer(Map<String, dynamic> attempt)` → `insertQuizAttempt`. (Cubit builds the attempt map with uuid + timestamp + `isCorrect`.)
- `Future<Map<String, dynamic>?> quiz(String quizId)` → `quizById` (for reload, kept thin).

#### 3. Cubit — state machine
**Files**: `lib/blocs/quiz/{cubit,state}.dart`
**Changes**:
- State (`PlanState`-style): `BlocState<Quiz> generate`. (Answers/score are ephemeral UI state — see Phase 4.)
- `Future<void> generate({...})` — `toLoading()` → `QuizRepo.ins.generate(...)` → `Quiz.fromJson(raw)` → `toSuccess(data:)`; `on Fault → toFailed(fault:)`. **`Quiz.fromJson` in the cubit.**
- `Future<void> recordAnswer({required String quizId, required String userId, required QuizQuestion question, int? selectedIndex})` — builds the attempt map (`id` uuid, `timestamp` now, `isCorrect = selectedIndex == question.correctAnswerIndex`) and calls `QuizRepo.ins.recordAnswer`. Fire-and-forget; failure logged, not surfaced (answering must not block).
- Accessor `QuizCubit.c(context)`; `reset()` clears `generate`.

### Hygen Commands
```bash
hygen cubit nested quiz      # lib/blocs/quiz/ + lib/repos/quiz/, registers in app.dart
```

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` — zero new errors.
- [ ] `flutter test test/blocs/quiz/quiz_cubit_test.dart` passes (generate success/failure + `recordAnswer`; via `MockQuizRepo` + the `ins` seam). See Testing Strategy.

#### Manual Verification (Dart MCP driver)
- [ ] Temporary trigger runs `generate` against the emulator and writes a quiz + 8 questions (inspect via `quizById` log or DB).
- [ ] Eyeball one payload: 8 questions, each 4 options, valid `correctAnswerIndex`, `explanation` present in the student's language; `citation` present iff material was grounded.

**Implementation Note**: Pause for manual confirmation before Phase 4.

---

## Phase 4: Quiz screen — question flow + results

### Overview
Render generation + the quiz-taking flow + results. Reuse `Screen`, `AppAiPill`, `AppButton`, `AppIconButton`, `Space`/`AppText`/`AppTheme` tokens. (Design ref: `quiz.jsx`; results view is new UI built from the design system.)

### Changes Required

#### 1. Scaffold + route
**Hygen**: `hygen screen new quiz` → `lib/ui/screens/quiz/{quiz.dart,_state.dart,widgets/…}` + registers the route.
**File**: `lib/router/routes.dart` (+ router): add `static const quiz = '/quiz';` and wire it in `lib/router/router.dart`. The route argument is the generation params Map `{subjectId, topicId?, sourceItemId?}`.

#### 2. Screen state (ephemeral)
**File**: `lib/ui/screens/quiz/_state.dart`
**Changes**: `_ScreenState` holds `phase (taking|results)`, `cursor` (current question index), `Map<int,int?> answers` (questionIndex → selectedOption, null = skipped), per-question `revealed` flag, and a display-only stopwatch. On init (post-frame) calls `QuizCubit.c(context).generate(params)`. Methods: `pick(index)` (reveals feedback + records via cubit), `skip()`, `next()` (advances cursor; on last → `phase = results`). Score computed from `answers` vs the quiz's `correctAnswerIndex`s. **No Firebase/Drift here** — only `QuizCubit`.

#### 3. Generation loading / failure
**Hygen**: `hygen screen consumer quiz` → `lib/ui/screens/quiz/listeners/_generate.dart` (`BlocConsumer` on `QuizCubit` `generate`).
**Changes**: `builder` shows a `FullScreenLoader` while `generate.isLoading` ("Building your quiz…"); `listener` on `isFailed` → `UIFlash.error` + a retry affordance (re-invoke `generate`) or pop. On `isSuccess` the body renders `_QuestionView`. Navigation/flash in the listener only.

#### 4. Question view (`_QuestionView` + `_QuizOption`)
**Hygen**: `hygen screen _widget quiz`.
**Changes** (design ref `quiz.jsx`):
- Header: back button, eyebrow "`<subject>` · Quiz", "Question N of 8", (flag button **dropped**).
- Segmented progress bar (`.map()` over question count: done/current/upcoming).
- `AppAiPill(quiz.sourceLabel ?? 'AI quiz')` + display-only elapsed stopwatch.
- Question text (serif), "Single answer · 1 mark".
- Options (`.map()`): `_QuizOption` with A/B/C/D letter, correct/wrong/picked styling once revealed (green correct, rose wrong-picked, ink picked) per the design.
- Inline feedback card (shown once revealed): `AppAiPill('Feedback')` + Correct/Not quite + `question.explanation` + `question.citation` row (book icon + text; **no "See in source" link**). Hidden when no `explanation`.
- Footer: **Skip** (ghost) + **Next question** (disabled until a pick or skip).

#### 5. Results view (`_ResultsView`)
**Hygen**: `hygen screen _widget quiz`.
**Changes** (new UI, design-system tokens): score header (correct/total + percentage), a short summary line, and a per-question review list (`.map()`): question text, the user's answer (or "Skipped"), the correct answer, and the explanation. A **"Done"** button pops back to the originating screen (per the nav constraint). Empty/degenerate handling if the quiz somehow has 0 questions.

### Hygen Commands
```bash
hygen screen new quiz          # root + state + route
hygen screen consumer quiz     # _GenerateListener (loader + retry)
hygen screen _widget quiz      # _QuestionView, _QuizOption, _ResultsView
```

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` — zero new errors.
- [ ] `flutter test test/screens/quiz/quiz_test.dart` passes (renders questions, pick reveals feedback, Skip/Next, finish→results). See Testing Strategy.

#### Manual Verification (Dart MCP driver, stage flavor)
- [ ] Trigger generation → loader → quiz screen with 8 questions; picking an option reveals correct/wrong styling + feedback + citation; Skip + Next work; finishing shows the results screen with the right score + review; "Done" returns cleanly (no `unknown` routes, no broken back stack).
- [ ] Urdu/Roman-Urdu question + explanation render correctly when inputs are Urdu.

**Implementation Note**: Pause for manual confirmation before Phase 5.

---

## Phase 5: Entry points — Focus + Library

### Overview
Wire the two launch points. Both navigate to `/quiz` with generation params.

### Changes Required

#### 1. Focus session — "Test yourself"
**File**: `lib/ui/screens/focus/widgets/_actions.dart`
**Changes**: add a "Test yourself" CTA (the primary post-study action — e.g. a full-width `AppButton` above the existing "I'm stuck" / "Mark block done" row, to avoid crowding a 3-button row). On tap, navigate to `AppRoutes.quiz` with `{subjectId: block.subjectId, topicId: block.topicId}` as arguments. Use a plain push (not tab `pushReplace`) per `docs/research/2026-06-18-navigation-routing-stack.md`.

#### 2. Library — "Generate quiz" (per material)
**File**: `lib/ui/screens/library/widgets/_material_actions_sheet.dart`
**Changes**: add a "Generate quiz" tile, **enabled only when `item.processingStatus == ProcessingStatus.indexed`** (has extracted text). On tap, close the sheet and navigate to `AppRoutes.quiz` with `{subjectId: item.subjectId, sourceItemId: item.id}`. Pass `RouteSettings(name:)` on the sheet (rule 14) if not already.

#### 3. Route argument plumbing
**File**: `lib/ui/screens/quiz/quiz.dart`
**Changes**: read the params Map from `ModalRoute.settings.arguments` (mirror `FocusScreen`), pass `userId` from `UserCubit` into `QuizCubit.generate`.

### Hygen Commands
_None — hand-edit two existing widgets + the screen root._

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` — zero new errors.

#### Manual Verification (Dart MCP driver, stage flavor)
- [ ] From a Focus block → "Test yourself" → quiz generates from that block's subject/topic, take it, see results, "Done" returns without a broken back stack.
- [ ] From Library → an `indexed` material → "Generate quiz" → quiz is grounded on that material (citations cite its name); a `pending`/`failed` material does not offer the action.

---

## Testing Strategy

The test layer is established and active, so this feature **ships with tests** (mocktail-only; `flutter_test`; no `bloc_test`). Reference: `docs/TESTING.md`; generate boilerplate with `/write-unit-test` and `/write-widget-test`.

**Prerequisite seam:** add a `@visibleForTesting static set ins(QuizRepo)` to `QuizRepo` (hygen does not emit it) and a `MockQuizRepo` in `test/helpers/mocks.dart`, plus a quiz fixture (raw JSON for a generated quiz + questions) and a `QuizStateX` builder in `test/helpers/fixtures.dart`.

### Unit Tests (`/write-unit-test`)
- `test/blocs/quiz/quiz_cubit_test.dart` — `QuizCubit.generate` emits `[loading, success]` and hydrates `Quiz.fromJson` (mock `QuizRepo.ins.generate`); emits `[loading, failed]` with the right `Fault` on repo throw (build faults with the raw subtype / `testFault()`); `recordAnswer` sends a correctly-shaped attempt map (`registerFallbackValue(<String,dynamic>{})` for `any()` map matching). Collect stream emissions + flush with `await Future.delayed(Duration.zero)`.
- Pure logic: a `score`/`isCorrect` helper test (selected vs `correctAnswerIndex`), mirroring `test/core/models/schedule/study_block_test.dart`.

### Widget Tests (`/write-widget-test`)
- `test/screens/quiz/quiz_test.dart` (scaffolded by `hygen screen new quiz`) — real `QuizCubit` driven through `MockQuizRepo`; bystander cubits stay `Fake*`. Cover: renders the question view after a successful generate; picking an option reveals correct/wrong styling + the feedback card; Skip + Next advance; finishing routes to the results view with the right score. Set a tall surface size; push the screen as a named route with `stubRoutes`.

### Automated gates
- `flutter test` green; `flutter analyze` zero new errors; `build_runner` clean.

### Manual Testing Steps (Dart MCP driver)
1. From Focus on a block with a subject that has an `indexed` material: "Test yourself" → verify 8 grounded MCQs with citations.
2. Answer a mix (correct, wrong, skipped) → verify inline feedback styling + explanation each time.
3. Finish → verify results score + per-question review; "Done" returns cleanly.
4. From Library, generate on an `indexed` material (citations) and confirm a `pending` material hides the action.
5. Generate for a subject with **no** material → verify questions still produced (no citations) from subject/topic.
6. Offline during generation → error + retry path works, no dead-end.

## Architecture Checklist
- [ ] `App.init(context)` at top of every `build()` (quiz screen + widgets).
- [ ] UI (`_state.dart`) never calls Firebase/Drift — only `QuizCubit`.
- [ ] `QuizCubit`/`QuizRepo` never import `lib/ui/`.
- [ ] State via `QuizCubit.c(context)` / `_ScreenState.s(context)` — never `context.read/watch`.
- [ ] `FirebaseAIException`/Drift errors → typed `Fault` before emit.
- [ ] Repo public methods return `Map`/`List<Map>`/primitives (ADR-013); cubit does `fromJson`; `_quizQuestionToMap` maps `content`→`text` in the DB layer.
- [ ] All scaffolds via hygen (`cubit nested quiz`, `screen new/consumer/_widget quiz`).
- [ ] Widget lists via `.map()` (no `for` in the tree); spacing via `Space.*` tokens (no `Spacer()`).
- [ ] `_material_actions_sheet` / any sheet passes `RouteSettings(name:)` (rule 14).
- [ ] Kept-stub `quiz_mocks.dart` / `quiz_parser.dart` left as `part of` with `ignore_for_file: unused_element` (rule 12); `QuizFeedback` model/table untouched.
- [ ] `QuizRepo` has the `@visibleForTesting static set ins`; `MockQuizRepo` + quiz fixtures/`QuizStateX` added to `test/helpers/`; cubit + screen tests written and green (`docs/TESTING.md`).

## References
- Research: `docs/research/2026-06-18-quiz-generation.md`
- Sibling pipeline (built): `docs/exec-plans/completed/study-plan-generation.md`, `docs/research/2026-06-15-study-plan-generation.md`
- Chat grounding: `lib/repos/chat/chat_data_provider.dart:148`, `lib/core/db/daos/material_texts_dao.dart`
- Canonical Gemini flow: `lib/repos/plan/plan_data_provider.dart`
- Structured-output template: `lib/services/firebase/ai/ai_service.dart`, `agent_tools.dart:74`
- Cubit/repo scaffold: `lib/blocs/plan/`, `lib/repos/plan/`
- **Code generation (all boilerplate): `docs/tooling/HYGEN.md`** — every `screen`/`cubit`/`provider` generator + `build_runner`
- Navigation constraint: `docs/research/2026-06-18-navigation-routing-stack.md`
- Design source: `/tmp/tm_design/taleemmate/project/screens/quiz.jsx`
- ADRs: `docs/architecture/DECISIONS.md` (ADR-008 firebase_ai, ADR-013 repo purity)
