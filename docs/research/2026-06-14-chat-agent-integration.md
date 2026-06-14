---
date: 2026-06-14T12:00:00+05:00
researcher: Claude (claude-opus-4-8)
git_commit: aaaeff7c7ce916daceea11ba666197e41e50ba28
branch: main
repository: taleemmate
topic: "How the chat agent feature would integrate end-to-end using firebase_ai"
tags: [research, codebase, chat, tutor, firebase_ai, gemini, cubit, repo, navigation]
status: complete
last_updated: 2026-06-14
---

# Research: Chat Agent (Tutor) End-to-End Integration with firebase_ai

**Date**: 2026-06-14
**Git Commit**: `aaaeff7`
**Branch**: `main`

## Research Question
How the chat agent feature would integrate end-to-end using firebase_ai. Research: (1) existing firebase_ai / Gemini usage and AI service wiring, (2) the cubit + repo layer patterns and how a new "chat" cubit/repo would be scaffolded, (3) any existing chat UI/screens or conversation models, (4) how system prompts / assets are loaded, (5) the home screen wiring and navigation to reach a chat screen.

## Summary

The chat ("Tutor") feature is **scaffolded at the data-model and routing layers but has zero runtime behaviour**. What exists: a complete set of freezed models (`TutorMessage`, `TutorConversation`, `TutorSettings`, `Citation`, `FollowUpPoint`), a Drift table + DAO for local persistence, an empty `/tutor` screen already wired into the bottom bar, and three system-prompt asset slots registered via flutter_gen. What is **entirely missing**: any `firebase_ai` runtime usage (no `GenerativeModel`, no service wrapper), a tutor cubit + repo, the chat UI itself, asset-loading code (`rootBundle.loadString`), markdown rendering, and a correct system prompt (the current `chat_sys_prompt.md` is a leftover from a different app, "Dreamstale"). The naming convention in this codebase is **"tutor"**, not "chat" — models, route, DB table, and bottom-bar tab all use `tutor`.

## Detailed Findings

### 1. firebase_ai / Gemini — declared but never used

- `firebase_ai: 3.6.0` is declared at `pubspec.yaml:40`. **No file under `lib/` imports it.**
- No `GenerativeModel`, `FirebaseAI`, `generateContent`, `startChat`, `GenerationConfig`, `Schema`, or `HarmCategory` anywhere in source.
- No AI service wrapper exists. `lib/services/firebase/` contains only Crashlytics (`crash/crashlytics.dart`, `crash/_exts.dart`) and Firestore collection constants (`collections.dart`).
- `lib/main.dart:20` calls `Firebase.initializeApp()` — firebase_ai would piggyback on this `FirebaseApp` instance, no separate init needed. `main.dart:16` sets `useFirebaseEmulators = true`; the emulator block (lines 31–39) wires Auth/Firestore/Storage but **not** any AI emulator.
- ADR-008 (`docs/architecture/DECISIONS.md:72-77`) records the decision to use firebase_ai over OpenAI/custom proxy. `docs/architecture/FIREBASE.md:74-77` says firebase_ai must be used inside cubits, never in `_state.dart`/widgets. Feature spec at `docs/features/CATALOGUE.md:154-179` describes the intended Tutor: chat grounded in the user's uploaded library, citations, suggested follow-ups, typing indicator, Urdu support; `:372` — "The tutor never answers from general knowledge."

**Remaining:** instantiate a Gemini model with system instruction + (optional) JSON response schema, build a service/repo wrapper, decide streaming vs single-shot.

### 2. Cubit + Repo pattern (the scaffold blueprint)

The **quotes** feature is the cleanest recent template (singleton repo + `BlocState<T>` cubit).

Cubit — `lib/blocs/quotes/cubit.dart`:
```dart
class QuotesCubit extends Cubit<QuotesState> {
  static QuotesCubit c(BuildContext context, [bool listen = false]) =>
      BlocProvider.of<QuotesCubit>(context, listen: listen);
  QuotesCubit() : super(QuotesState.def());

  Future<void> today() async {
    emit(state.copyWith(today: state.today.toLoading()));
    try {
      final data = await QuotesRepo.ins.today();
      emit(state.copyWith(today: state.today.toSuccess(data: data)));
    } on Fault catch (e) {
      emit(state.copyWith(today: state.today.toFailed(fault: e)));
    }
  }
  void reset() => emit(QuotesState.def());
}
```
- State is a `BlocState<T>` field (`today`) with `.toLoading()/.toSuccess(data:)/.toFailed(fault:)` transitions, defined in `lib/configs/bloc/`.
- Error model: catch `on Fault catch (e)` — `Fault` subtypes include `HttpFault`, `UnknownFault` (`lib/services/fault/faults.dart`). Firebase/AI exceptions must be converted to a `Fault` subtype before emitting (CLAUDE.md rule 5).

Repo — `lib/repos/quotes/quotes_repo.dart` (singleton + `part` files):
```dart
class QuotesRepo {
  static final QuotesRepo _instance = QuotesRepo._();
  QuotesRepo._();
  static QuotesRepo get ins => _instance;
  Future<Quote> today() => _QuotesProvider.today();
}
```
- Parts: `quotes_mocks.dart`, `quotes_parser.dart`, `quotes_data_provider.dart` — all kept even if unused (CLAUDE.md rule 12, `// ignore_for_file: unused_element`).
- The data provider (`_QuotesProvider`) does the actual I/O and `Model.fromJson`. Note: quotes repo returns a `Quote` model rather than a raw `Map` — ADR-013 says repos should return `Map`/primitives and cubits do `fromJson`; the tutor repo should follow ADR-013 (return `Map`/`List<Map>`), with the cubit converting to `TutorMessage`/`TutorConversation`.

Other existing cubits: `user`, `onboarding`, `library`, `quotes` (`lib/blocs/<name>/cubit.dart` + `state.dart`). Registered in `lib/app.dart` under the `// bloc-initiate-start` marker.

**Scaffold command:** `hygen cubit nested tutor` generates `lib/blocs/tutor/` + `lib/repos/tutor/` and auto-registers in `app.dart`.

**Remaining:** generate tutor cubit + repo; repo wraps the firebase_ai call; cubit owns the conversation/message state machine.

### 3. Chat UI / conversation models — models exist, UI does not

Models already present under `lib/core/models/tutor/` (all freezed + json_serializable, fully generated):
- `tutor_message.dart` — `TutorMessage { id, conversationId, sender (MessageSender.user|ai), text, timestamp, followUpPoints[], citations[], kickerQuestion? }`, getter `isAI`.
- `tutor_conversation.dart` — `TutorConversation { id, userId, subjectId, groundedSourceCount, createdAt, lastMessageAt, topicId?, title?, messages[] }`.
- `tutor_settings.dart`, `citation.dart`, `follow_up_point.dart`.

Local persistence already scaffolded:
- `lib/core/db/tables/tutor_table.dart`, `lib/core/db/daos/tutor_dao.dart`, registered in `lib/core/db/database.dart` (Drift).

Screen — **empty shell**:
- `lib/ui/screens/tutor/tutor.dart` (`TutorScreen` root) + `lib/ui/screens/tutor/_state.dart` (empty `_ScreenState`, accessor only). `_Body` renders a `Screen` with an empty `Column` — no widgets/, listeners/, or message list.

**Screen scaffold anatomy** (reference: login/onboarding) — a full screen folder contains: root `<name>.dart` (`App.init` + `ChangeNotifierProvider<_ScreenState>`), `_state.dart`, `widgets/`, `listeners/` (BlocConsumer/BlocListener), `static/` (form keys/data), optionally `pages/`, `models/`, `utils.dart`.

**Remaining:** build the chat UI (message list, input composer, typing indicator, AI/user bubbles, citations, follow-up chips), a `listeners/` BlocListener for send/receive side-effects, and wire `_ScreenState` for ephemeral input state.

### 4. System prompts / asset loading

- `pubspec.yaml:162-167` declares assets: `assets/`, `assets/app/`, and explicitly `assets/chat_sys_prompt.md`, `assets/plan_sys_prompt.md`, `assets/quiz_sys_prompt.md` (the explicit lines are redundant with the `assets/` glob but harmless).
- flutter_gen generated constants at `lib/gen/assets/assets.gen.dart:39-41`: `Assets.chatSysPrompt`, `Assets.planSysPrompt`, `Assets.quizSysPrompt` — bare `static const String` paths (not `AssetGenImage`, since they're not images).
- **No runtime loader exists** — zero `rootBundle.loadString(...)` calls in `lib/`. The constants are referenced nowhere outside the generated file.
- **No markdown rendering** — `flutter_markdown`/`MarkdownBody` absent from pubspec and code.
- Content status: `chat_sys_prompt.md` is a **138-line prompt for the wrong app ("Dreamstale")** — dream-to-image-prompt refinement, returns `{title, refinedPrompt, theme, tags, lucidDream}`. `plan_sys_prompt.md` and `quiz_sys_prompt.md` are **empty**.

**Remaining:** rewrite `chat_sys_prompt.md` for the TaleemMate tutor; add a loader (`rootBundle.loadString(Assets.chatSysPrompt)`, likely cached once) feeding the model's system instruction; add markdown rendering if AI replies use markdown.

### 5. Home wiring & navigation to the chat screen

- The `/tutor` route already exists and is reachable: `AppRoutes.tutor` (`lib/router/routes.dart`), registered in `onGenerateRoutes` with a `FadeRoute` (`lib/router/router.dart:27-42`).
- It is one of the **five bottom-bar tabs** (`lib/ui/widgets/core/bottom_bar/_data.dart`): Home, Library, **Tutor (`LucideIcons.message_square`)**, Plan, Progress. `Screen` auto-injects `BottomBar` for these five routes (`lib/ui/widgets/core/screen/screen.dart:75-84`). Tapping the Tutor tab calls `tab.path.pushReplace(context)`.
- Navigation helpers are `String` extensions (`lib/configs/extension/_string.dart`): `.push`, `.pushReplace`, `.pushAndClear`, `.pop`, `.popUntil`, `.sameRoute`. Example: `AppRoutes.tutor.pushReplace(context)`.
- Home screen (`lib/ui/screens/home/home.dart`) currently renders only `_Header()` (greeting + date + avatar→profile). No chat entry card on home — but the bottom-bar Tutor tab is the primary entry point and is already live.
- Splash → home flow (`lib/ui/screens/splash/listeners/_init.dart`): on auth success with `isOnboardingComplete`, routes to `AppRoutes.home`; `QuotesCubit.today()` is pre-loaded here — a parallel place a tutor warm-up could hook in if needed.

**Remaining:** no new route or tab wiring needed — the Tutor tab already lands on the (empty) tutor screen. Optionally add a home-screen "Ask your tutor" affordance.

## Code References
- `pubspec.yaml:40` — `firebase_ai: 3.6.0` (only reference)
- `lib/main.dart:20` — `Firebase.initializeApp()`
- `lib/gen/assets/assets.gen.dart:39-41` — `Assets.chatSysPrompt` / `planSysPrompt` / `quizSysPrompt`
- `assets/chat_sys_prompt.md` — Dreamstale prompt (needs full rewrite)
- `lib/core/models/tutor/tutor_message.dart` — `TutorMessage` + `MessageSender`
- `lib/core/models/tutor/tutor_conversation.dart` — `TutorConversation`
- `lib/core/db/daos/tutor_dao.dart`, `lib/core/db/tables/tutor_table.dart` — local persistence
- `lib/ui/screens/tutor/tutor.dart` + `_state.dart` — empty screen shell
- `lib/blocs/quotes/cubit.dart`, `lib/repos/quotes/quotes_repo.dart` — cubit/repo template
- `lib/router/routes.dart`, `lib/router/router.dart:27-58` — `/tutor` route + `FadeRoute`
- `lib/ui/widgets/core/bottom_bar/_data.dart` — Tutor tab definition
- `lib/configs/extension/_string.dart` — navigation helpers
- `lib/services/fault/faults.dart` — `Fault` hierarchy

## Architecture Documentation
- **Layer boundary**: UI never calls Firebase/HTTP; cubits never import `lib/ui/`. The tutor repo must wrap firebase_ai; the cubit orchestrates; the UI only reads state via `TutorCubit.c(context)` and `_ScreenState.s(context)`.
- **Repo purity (ADR-013)**: tutor repo public methods should return `Map`/`List<Map>`/primitives; cubit does `TutorMessage.fromJson`.
- **Error model**: convert firebase_ai exceptions to a `Fault` subtype before emit.
- **State**: `BlocState<T>` with `.toLoading/.toSuccess/.toFailed`. Ephemeral chat input state lives in `_ScreenState` (ChangeNotifier).
- **Generators**: `hygen cubit nested tutor`, `hygen screen consumer/listener tutor`, `hygen screen _widget` — never hand-create.
- **Naming**: existing convention is **"tutor"** (route, models, DB, tab). The asset is named `chat_sys_prompt.md` but the feature surface is "tutor".

## Related Docs
- `docs/features/CATALOGUE.md:154-179` — AI Tutor feature spec (grounding, citations, follow-ups, Urdu)
- `docs/architecture/DECISIONS.md:72-77` — ADR-008 (firebase_ai) and ADR-013 (repo purity)
- `docs/architecture/FIREBASE.md:74-77` — firebase_ai usage rules

## Open Questions
1. **Grounding source**: spec says the tutor answers only from the user's uploaded library — does v1 wire library/RAG grounding, or ship ungrounded chat first? (firebase_ai grounding vs. prompt-injected context vs. none.)
2. **Streaming vs single-shot**: `generateContentStream` (typing effect) vs `generateContent`. Affects cubit state shape (incremental token appends).
3. **Structured vs free-text output**: feature wants citations + follow-up points (structured), but chat reads as free markdown — JSON response schema vs. plain text + parsing.
4. **Persistence scope for v1**: is the existing Drift tutor DAO wired now, or is conversation kept in-memory first?
5. **System prompt rewrite**: `chat_sys_prompt.md` must be authored fresh for TaleemMate (subject tutoring, Urdu/English, grounding rules) — replacing the Dreamstale content.
6. **Multi-conversation vs single thread**: `TutorConversation` supports many (per subject/topic); does v1 expose conversation history/switching or a single running thread?
