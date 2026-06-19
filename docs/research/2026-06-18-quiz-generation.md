---
date: 2026-06-18T16:00:00+05:00
researcher: Claude (claude-opus-4-8)
git_commit: bbf2614df4c02b1f1738651af6352bf391f5e697
branch: main
repository: taleemmate
topic: "AI quiz generation — what exists end-to-end (models, DB, AI glue, entry points) and what's missing to build generation + a quiz-taking + results flow"
tags: [research, codebase, quiz, firebase_ai, gemini, focus, library, material-grounding, cubit, repo, drift]
status: complete
last_updated: 2026-06-18
---

# Research: AI Quiz Generation — End-to-End State

**Date**: 2026-06-18
**Git Commit**: `bbf2614`
**Branch**: `main`

## Research Question

What exists today for an AI quiz-generation feature — the data models, Drift tables/DAO, `firebase_ai` glue, material-grounding source, and the screens a quiz would launch from — and what's missing to ship generation + a quiz-taking screen + a results screen. (Mirrors the now-completed study-plan-generation pipeline, which was the blocker.)

## Summary

The quiz feature is **fully scaffolded at the data-model and DB layers** (mirroring how study-plan looked before that feature was built), with a **proven sibling AI pipeline to copy 1:1** (study-plan), and a **material-grounding source already solved** by the chat agent — but it has **zero generation logic, zero AI glue, zero UI, no route, and no entry-point CTA anywhere.**

- **Models** (`lib/core/models/quiz/`): `Quiz`, `QuizQuestion`, `QuizAttempt`, `QuizFeedback` + `QuizHistory` aggregate — all freezed + json_serializable, generated.
- **DB** (`lib/core/db/tables/quiz_table.dart`, `daos/quiz_dao.dart`): four tables (`Quizzes`, `QuizQuestions`, `QuizAttempts`, `QuizFeedbackItems`) registered in `database.dart` (schemaVersion **4**); `QuizDao` has read/write methods. **No `AppDatabase` Map-wrapper methods exist for quiz yet** (the ADR-013 boundary layer the repo would call).
- **AI**: `assets/quiz_sys_prompt.md` exists, is registered in `pubspec.yaml`, and `Assets.quizSysPrompt` resolves — but the file is **empty (0 bytes)**. There is **no** `AiService.quizModel()`, **no** `AgentTools.quizSchema`, **no** `SystemPrompts.quiz()`.
- **Grounding**: the chat agent already extracts and serves material text via `MaterialTextsDao.forSubject(userId, subjectId)` with a 12 k-char budget and `[itemId | name]` chunk tagging — directly reusable for quiz grounding + citations.
- **Entry points**: the Focus screen (`lib/ui/screens/focus/`) receives a `StudyBlock` and has a bottom action row; the Library screen (`lib/ui/screens/library/`) has a per-material action sheet. **Neither has a quiz CTA**, and there is **no `AppRoutes.quiz`**.
- **Known constraints**: a Row↔model field-name mismatch (`QuizQuestions.content` vs `QuizQuestion.text`); no per-question `explanation`/`citation` columns (the design shows both); no quiz-level score/completedAt column; and a documented navigation back-stack bug for routes pushed over `/focus` (see [navigation research](2026-06-18-navigation-routing-stack.md)).

## Detailed Findings

### 1. Data models — COMPLETE (`lib/core/models/quiz/` + `progress/`)

- `quiz.dart:11` — **`Quiz`** `{id, subjectId, currentQuestionIndex, questions[]=[], topicId?, sourceLabel?, isAIGenerated=true}` + getter `questionCount` (`quiz.dart:24`). `sourceLabel` maps to the design's "Generated from Lec 12" eyebrow.
- `quiz_question.dart:6` — **`QuestionType { singleAnswer, multipleAnswer, shortAnswer }`** and **`QuizQuestion`** `{id, quizId, index, text, type, markValue, options[]=[], correctAnswerIndex?, timeLimit?}`. **No `explanation` or `citation`/source field** — the design shows both inline.
- `quiz_attempt.dart:10` — **`QuizAttempt`** `{id, quizId, userId, questionId, timestamp, selectedAnswerIndex?, isCorrect?}`.
- `quiz_feedback.dart:10` — **`QuizFeedback`** `{id, attemptId, questionId, isCorrect, feedbackText, explanation?}` — a per-attempt feedback record. For deterministic single-answer MCQ this is `(isCorrect, question.explanation)`, i.e. derivable without a separate record.
- `progress/quiz_history.dart:12` — **`QuizHistory`** `{userId, totalQuizzesAttempted, totalQuestionsAnswered, attempts[], scoreHistory[]}` — aggregate for the Progress screen. References `DailyScore` (`progress/daily_score.dart`).

### 2. Drift tables + DAO — COMPLETE, but no AppDatabase wrappers (`lib/core/db/`)

- `tables/quiz_table.dart` — four `Table`s with `@DataClassName` rows:
  - `Quizzes` (`:8`): `id` (PK), `subjectId` → `Subjects`, `topicId?` → `Topics`, `currentQuestionIndex`, `sourceLabel?`, `isAIGenerated` (default true).
  - `QuizQuestions` (`:21`): `id` (PK), `quizId` → `Quizzes`, `index`, **`content`** (text), `type` (`EnumConverter<QuestionType>`), `markValue`, `options` (`StringListConverter`), `correctAnswerIndex?`, `timeLimit?`. **Column is `content`; the model field is `text`** — a mismatch the persistence wrapper must reconcile.
  - `QuizAttempts` (`:38`): `id` (PK), `quizId`, `userId`, `questionId` → `QuizQuestions`, `timestamp`, `selectedAnswerIndex?`, `isCorrect?`.
  - `QuizFeedbackItems` (`:52`): `id` (PK), `attemptId` → `QuizAttempts`, `questionId`, `isCorrect`, `feedbackText`, `explanation?`.
- `daos/quiz_dao.dart` — `QuizDao` (registered `@DriftAccessor`): `findById`, `questionsForQuiz(quizId)` (ordered by index), `attemptsForUser(userId)` (desc by timestamp), `feedbackForAttempt(attemptId)`, `upsertQuiz`, `upsertQuestion`, `insertAttempt`, `insertFeedback`.
- `db/database.dart`: all four quiz tables are in `@DriftDatabase.tables`; `QuizDao` is in `daos`; `schemaVersion => 4`. **There are no `_quizToMap`/`_quizQuestionToMap` converters and no `quizById`/`replaceQuizQuestions`/`insertQuizAttempt` Map-wrapper methods** — the layer the study-plan repo uses (`scheduleForUser`, `replaceStudyBlocks`, etc., in the `// --- Study-plan persistence ---` block) has no quiz equivalent.
- Migration shape (`database.dart:100-114`): `onUpgrade` uses `if (from < N)` blocks; the quiz tables were created as part of the v4 schema. Any model/table change (e.g. new columns) requires a `schemaVersion` bump + a new `if (from < 5)` block.

### 3. AI layer — glue absent, asset empty (`lib/services/firebase/ai/`)

- `ai_service.dart` — `AiService.ins` lazily builds cached `GenerativeModel`s. `chatModel`, `planModel`, `reasonModel` exist, each `FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash', systemInstruction: Content.system(prompt), generationConfig: GenerationConfig(responseMimeType: 'application/json', responseSchema: <schema>))`. **No `quizModel`.**
- `agent_tools.dart` — `AgentTools.ins` holds `chatSchema`, `planSchema` (`:74-119`), `reasonSchema` (Schema API). **No `quizSchema`.**
- `system_prompts.dart` — cached `rootBundle` loader; `chat()`, `library()`, `plan()`, `reason()`. **No `quiz()`.**
- `assets/quiz_sys_prompt.md` — **empty (0 bytes)**, but **registered** in `pubspec.yaml:175`, and `Assets.quizSysPrompt` → `'assets/quiz_sys_prompt.md'` resolves in `lib/gen/assets/assets.gen.dart`. (Identical starting state to `plan_sys_prompt.md` before study-plan was built.)

### 4. Material grounding — SOLVED by chat, reusable (`lib/core/db/daos/material_texts_dao.dart`, `lib/repos/chat/`)

- `tables/material_texts_table.dart` — `MaterialTexts` `{itemId (PK) → LibraryItems, content, pageCount, charCount, extractedAt}`: "Extracted plain text for a single material — the grounding source consumed by the Chat agent. One row per indexed item."
- `MaterialTextsDao.forSubject(userId, subjectId)` returns `List<(MaterialTextRow, String name)>` — joins `LibraryItems` so each chunk can be tagged `[itemId | name]` and cited by name. `forItem(itemId)` returns a single material's text.
- `repos/chat/chat_data_provider.dart`: `_groundingCharBudget = 12000` (`:6`); `_groundingBlock(texts)` (`:148`) concatenates chunks until the budget is hit; `_userTurn(grounding, userText, settings)` injects it. The chat's structured `_parseReply` (`:195-209`) returns a `citations[]` array with generated ids — the same shape a quiz's per-question citation would follow.

### 5. Library item / subject / topic — grounding inputs (`lib/core/models/`)

- `library/library_item.dart:11` — `LibraryItem` `{id, userId, name, kind(ItemKind), fileSize, uploadedAt, processingStatus(ProcessingStatus{pending,processing,indexed,failed}), subjectId?, metadata?, colorHex?, indexedPageCount?}`. **`processingStatus == indexed`** is the gate for "has extracted text" — i.e. whether a material can be quizzed with citations.
- `subject/subject.dart:7` — `Subject` `{id, code, name, colorHex, confidenceLevel, order}` — `confidenceLevel` calibrates difficulty.
- `subject/topic.dart:9` — `Topic` `{id, subjectId, name, masteryPercentage, trend, isWeak}` — `isWeak`/`masteryPercentage` could target weak topics.

### 6. Entry points — present screens, no quiz CTA anywhere

- **Routes** (`lib/router/routes.dart`): `focus, profile, createAccount, onboarding, stepwiseLoader, progress, plan, tutor, library, splash, home, login`. **No `quiz`.** Routing is named routes + `FadeRoute` (and a `SlideUpRoute` proposed for `/focus` in the nav research).
- **Focus** (`lib/ui/screens/focus/focus.dart:35`): receives a `StudyBlock` via `ModalRoute.settings.arguments` (has `subjectId`, `topicId?`, `title`, `durationMinutes`). `_state.dart` is a 1-second countdown timer (ephemeral). `widgets/_actions.dart` is the bottom action row: **"I'm stuck"** (`ChatCubit.startConversation(block.subjectId)` → `/tutor`) and **"Mark block done"** (`PlanCubit.markBlockDone(block)` → pop). No quiz action.
- **Library** (`lib/ui/screens/library/`): `widgets/_material_actions_sheet.dart` is the per-material action sheet (the natural home for a "Generate quiz" tile), `_subject_section.dart` groups items by subject. `_add_material_sheet.dart` handles uploads. No quiz action.
- **Progress** (`lib/ui/screens/progress/`): `_state.dart` + `progress.dart` only — would consume `QuizHistory`/`DailyScore` if quiz scores were wired (not yet).

### 7. The sibling pipeline to mirror 1:1 — study-plan (BUILT)

The completed study-plan feature is the exact template (see [study-plan research](2026-06-15-study-plan-generation.md) and `docs/exec-plans/completed/study-plan-generation.md`):

- **Repo** (`lib/repos/plan/`): four `part` files — `plan_repo.dart` (singleton `.ins` facade, `@visibleForTesting set ins`, all public methods `Map`/`List<Map>`/primitive per ADR-013), `plan_data_provider.dart` (private `_PlanProvider`: gather DB inputs → assemble text user-turn → `AiService.ins.planModel(await SystemPrompts.plan()).generateContent([Content.text(turn)])` → `_decode`/`jsonDecode` → build Map payloads → persist → return a `WeekPlan.toJson()`-shaped Map; error cascade `on Fault rethrow` / `on FirebaseAIException → AiFault.fromAiException` / `on FormatException → UnknownFault` / `catch → UnknownFault`), plus kept-stub `plan_mocks.dart` + `plan_parser.dart` (rule 12).
- **Cubit** (`lib/blocs/plan/`): `PlanCubit.c(context)`, `PlanState.def()` with `BlocState<T>` fields, `generate(userId)` emits `toLoading()` → `toSuccess(data: WeekPlan.fromJson(raw))` / `on Fault → toFailed(fault:)`. **`Model.fromJson` happens in the cubit, never the repo.**
- **DB wrappers** (`database.dart` `// --- Study-plan persistence ---`): `scheduleForUser`, `replaceStudyBlocks` (txn: delete-then-insert, calls `StudyBlock.fromJson` *inside* the wrapper), `updateScheduleReasoning`, `watchStudyBlocks`, `subjectsForUser`, `examsForUser`, `_scheduleToMap`/`_studyBlockToMap`/`_subjectToMap`/`_examToMap` (explicit per-key maps; enum↔string handled here).
- **AI glue**: `AgentTools.planSchema` (`Schema.object`), `AiService.planModel`, `SystemPrompts.plan()` (`_load(Assets.planSysPrompt)`).
- **Loader wiring** (`lib/ui/screens/stepwise_loader/`): `_state.dart` calls `PlanCubit.generate(userId)`; `listeners/_generate.dart` is a `BlocListener` (`listenWhen: a.generate != b.generate`) that on `isSuccess` navigates and on `isFailed` calls `UIFlash.error`.
- **Faults** (`lib/services/fault/faults.dart`): sealed `Fault<T>`; `AiFault.fromAiException` (`:198`), `UnknownFault` (`:241`); `FaultExtension.message` (`:262`) gives every subtype a `.message`.
- **BlocState** (`lib/configs/bloc/`): `toLoading/toSuccess/toFailed/toDefault`, `isLoading/isSuccess/isFailed`, `data`/`getData`, `errorMessage`, `when/maybeWhen`; `meta` (dynamic) carries a correlation id through a transition.
- **Listener conventions**: `BlocListener` → `child: SizedBox.shrink()`; `BlocConsumer` adds a `FullScreenLoader` builder; navigation/`UIFlash` always in the listener, never `_state.dart` (state-driven-navigation rule).

## Open Gaps (what building the feature must add)

1. **AI glue**: author `quiz_sys_prompt.md`; add `SystemPrompts.quiz()`, `AgentTools.quizSchema`, `AiService.quizModel()`.
2. **Model/table reconciliation**: decide `content` vs `text` handling (wrapper-map vs rename); add per-question `explanation` + `citation` (model + table + schemaVersion 4→5 migration) if inline feedback + source are in scope.
3. **AppDatabase wrappers**: `quizById`, `replaceQuizQuestions` (txn, `QuizQuestion.fromJson` inside), `insertQuizAttempt`, `_quizToMap`/`_quizQuestionToMap`.
4. **Repo + cubit**: `hygen cubit nested quiz` → `QuizRepo.generate({subjectId, topicId?, sourceItemId?})` (grounded via `MaterialTexts`) + `recordAnswer`; `QuizCubit` with `BlocState<Quiz> generate`.
5. **UI**: `hygen screen new quiz` + `AppRoutes.quiz`; question view (progress bar, options w/ correct-wrong states, inline feedback) + results view; loader/retry on the `generate` `BlocState`.
6. **Entry points**: Focus action ("Test yourself" on the block) + Library per-material action ("Generate quiz", `indexed`-only), each routing to the quiz screen with generation params.
7. **Navigation**: a quiz route pushed over `/focus` must respect the back-stack fix documented in [navigation research](2026-06-18-navigation-routing-stack.md) (tab nav uses top-only `pushReplace`).

## Out of Scope of This Research

This document records current state only. The implementation strategy, phase breakdown, locked v1 scope decisions (single-answer MCQ only, 8 questions, bundled feedback, no `QuizFeedback`/`DailyScore`/Progress wiring), and success criteria live in the exec-plan: `docs/exec-plans/backlog/quiz-generation.md`.

## References

- Sibling pipeline (built): `docs/research/2026-06-15-study-plan-generation.md`, `docs/exec-plans/completed/study-plan-generation.md`
- Chat grounding pattern: `docs/research/2026-06-14-chat-agent-integration.md`, `lib/repos/chat/chat_data_provider.dart:148`
- Navigation back-stack constraint: `docs/research/2026-06-18-navigation-routing-stack.md`
- Design source: `/tmp/tm_design/taleemmate/project/screens/quiz.jsx`
- ADRs: `docs/architecture/DECISIONS.md` (ADR-008 firebase_ai, ADR-013 repo purity)
