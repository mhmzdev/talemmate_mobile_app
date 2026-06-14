---
title: "Chat Agent (firebase_ai) — Grounded Tutor"
status: backlog
created: 2026-06-14
---

📋 BACKLOG — Not yet started

# Chat Agent (firebase_ai) — Grounded Tutor — Implementation Plan

## Overview
Build the end-to-end conversational tutor. A dedicated **`ChatCubit` + `ChatRepo`** own all business logic; the **existing `tutor/` screen, `/tutor` route, "Tutor" tab, `Tutor*` models, and Drift `tutor_*` tables are kept as-is** (UI/data terminology stays "tutor"; new business logic is "chat"). Responses are **single-shot, structured JSON** via `responseSchema` (`{text, citations[], followUpPoints[], kickerQuestion?}`) mapped onto the existing models. Answers are **grounded in the student's extracted library text** (produced by `library-text-extraction.md`) and **persisted as multi-conversation, per-subject history** in Drift.

**Depends on:** `library-text-extraction.md` (Phases provide `MaterialRepo.textsForSubject` + the shared `AiService`).

## Current State Analysis

**Data + routing scaffolded; zero behaviour.**

Key files:
- `lib/ui/screens/tutor/tutor.dart:30-38` — `TutorScreen` renders a `Screen` with an **empty `Column`**. `_state.dart` is an empty `_ScreenState`.
- `lib/router/routes.dart` / `lib/router/router.dart:27-42` — `AppRoutes.tutor` (`/tutor`) registered with `FadeRoute`.
- `lib/ui/widgets/core/bottom_bar/_data.dart` — "Tutor" tab (`LucideIcons.message_square`) → `/tutor` (already the entry point).
- `lib/core/models/tutor/` — `TutorMessage{sender, text, followUpPoints[], citations[], kickerQuestion?}`, `TutorConversation{subjectId, topicId?, title?, groundedSourceCount, messages[]}`, `TutorSettings{scope, reasoningDepth, showCitationsOnEveryReply}`, `Citation{source, pageReference?, colorHex?, libraryItemId?}`, `FollowUpPoint{label, body}`.
- `lib/core/db/tables/tutor_table.dart` + `lib/core/db/daos/tutor_dao.dart` — `TutorConversations` / `TutorMessages` / `TutorSettingsTable` with converters; `TutorDao` already has `watchByUser`, `watchMessages`, `settingsForUser`, `upsertConversation`, `insertMessage`, `upsertSettings`.
- `assets/chat_sys_prompt.md` — **wrong-app ("Dreamstale") content; must be rewritten.** Registered as `Assets.chatSysPrompt` (`lib/gen/assets/assets.gen.dart:39`). No loader exists.
- `lib/services/firebase/ai/agent_tools.dart` — `AgentTools.chatSchema`, the structured-output `Schema` home for agents (lives next to `AiService`). **The schema body is placeholder copy from an older project** (dream/image refinement — fields `responseMessage`/`error`, doc text about "generate an image based on the refined prompt"). **Location + pattern are correct; only the schema shape needs rewriting** to the `Tutor*` output (`text`, `citations[]`, `followUpPoints[]`, `kickerQuestion?`). Everything else here is fine as a scaffold.
- Pattern templates: `lib/blocs/quotes/cubit.dart`, `lib/repos/quotes/quotes_repo.dart`; `BlocState<T>` at `lib/configs/bloc/_state.dart`.

**firebase_ai 3.6.0 structured-output API verified:**
- `GenerationConfig(responseMimeType: 'application/json', responseSchema: Schema.object({...}))` (`lib/src/api.dart:1108-1135`).
- `Schema.object/array/string/enumString/boolean` builders (`lib/src/schema.dart`).
- `generativeModel(model:, systemInstruction:, generationConfig:)` → `generateContent([...])` single-shot.

> **Design note:** the visual mockup (`…/TaleemMate.html`) could not be fetched (private/auth-gated URL → 404). Build the chat UI against the `Tutor*` model fields (bubbles, citation chips, follow-up chips, kicker question) and the `/design` token system, and reconcile with the design file when accessible.

## Desired End State
Tapping the Tutor tab opens a chat. The student picks a subject, asks a question, and gets a single grounded reply (markdown text + citation chips referencing their materials + follow-up chips). Conversations persist per subject and are listable/switchable across launches. Verify: ask a Biology question with indexed Biology materials → reply cites a real item by name; reopen the app → the conversation is still there.

## What We're NOT Doing
- **No renaming** of the `tutor/` screen, `/tutor` route, "Tutor" tab, `Tutor*` models, or `tutor_*` Drift tables — and therefore **no Drift migration** in this plan.
- **No streaming** — single-shot `generateContent` only.
- **No text-extraction work** — consumed from `library-text-extraction.md`.
- **No topic-level (`topicId`) threading UI** — conversations are per-subject for v1 (`topicId` left null).
- **No voice input / TTS / image attachments in chat.**

## Implementation Approach
- `ChatRepo` (ADR-013: `Map`/primitives) wraps the shared `AiService` with a **chat-configured model** (system instruction from `chat_sys_prompt.md`, JSON `responseSchema`) and the `TutorDao` for persistence. It returns raw `Map`s; `ChatCubit` does `TutorMessage.fromJson` etc.
- The prompt is assembled in the repo from: system instruction + a **grounding block** (the subject's extracted texts from `MaterialRepo.textsForSubject`, truncated to a char/token budget, each tagged with its `libraryItemId` + name so the model can cite by id) + the prior message history + the new user turn.
- `ChatCubit` owns: conversations stream, active conversation, send flow, settings.

---

## Phase 1: Gemini chat model + system prompt + asset loader

### Overview
Add the chat-configured model to the shared `AiService`, rewrite the system prompt, and load it at runtime.

### Changes Required

#### 1. Rewrite the system prompt
**File**: `assets/chat_sys_prompt.md`
**Changes**: replace Dreamstale content with a TaleemMate tutor prompt: role (patient subject tutor for the student's grade/board), **Urdu + English** support, **grounding rules** ("prefer the student's provided materials; cite them by id; if materials don't cover it, answer from general knowledge and say so; never fabricate citations"), tone/`reasoningDepth` guidance, and an explicit description of the required **JSON output** (`text`, `citations[]` with `libraryItemId`/`source`/`pageReference`, `followUpPoints[]` with `label`/`body`, optional `kickerQuestion`).

#### 2. Asset loader (cached)
**File**: `lib/services/firebase/ai/system_prompts.dart`
```dart
import 'package:flutter/services.dart' show rootBundle;
import 'package:taleemmate/gen/assets/assets.gen.dart';

class SystemPrompts {
  static String? _chat;
  static Future<String> chat() async =>
      _chat ??= await rootBundle.loadString(Assets.chatSysPrompt);
}
```

#### 3. Chat model + response schema on AiService
**File**: `lib/services/firebase/ai/ai_service.dart` (extends the Plan-A service)
Source the `responseSchema` from `AgentTools.ins.chatSchema` (the schema home — see Current State) rather than inlining it here. **First rewrite that schema** from the older-project placeholder (`responseMessage`/`error`) to the `Tutor*` shape shown below.
```dart
GenerativeModel chatModel(String systemPrompt) =>
    FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash', // confirm id
      systemInstruction: Content.system(systemPrompt),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: AgentTools.ins.chatSchema, // updated to the shape below
      ),
    );
```
`AgentTools.chatSchema` (rewritten to match `TutorMessage`):
```dart
Schema get chatSchema => Schema.object(properties: {
      'text': Schema.string(),
      'kickerQuestion': Schema.string(nullable: true),
      'citations': Schema.array(items: Schema.object(properties: {
        'libraryItemId': Schema.string(nullable: true),
        'source': Schema.string(),
        'pageReference': Schema.string(nullable: true),
      })),
      'followUpPoints': Schema.array(items: Schema.object(properties: {
        'label': Schema.string(),
        'body': Schema.string(),
      })),
    });
```

### Hygen Commands
_None._

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` clean.
#### Manual Verification
- [ ] `AgentTools.chatSchema` rewritten from the older-project placeholder (`responseMessage`/`error`, image-refinement doc text) to the `Tutor*` shape (`text`, `citations[]`, `followUpPoints[]`, `kickerQuestion?`); doc comment updated to describe tutor output.
- [ ] `SystemPrompts.chat()` returns the rewritten prompt.
- [ ] A throwaway `chatModel(...).generateContent([Content.text('hi')])` returns parseable JSON matching the schema.

**Implementation Note**: Pause for manual confirmation.

---

## Phase 2: ChatCubit + ChatRepo (send flow + persistence)

### Overview
Scaffold the cubit/repo and implement the grounded single-shot send + Drift persistence.

### Changes Required

#### 1. Scaffold
Run hygen (below), then customize (the generic one-shot template is replaced with the chat logic).

#### 2. Repo
**File**: `lib/repos/chat/chat_repo.dart` (+ parts)
Public surface (ADR-013):
```dart
class ChatRepo {
  static ChatRepo get ins => _instance;

  Stream<List<Map<String, dynamic>>> watchConversations(String userId);
  Stream<List<Map<String, dynamic>>> watchMessages(String conversationId);
  Future<Map<String, dynamic>> createConversation(String userId, String subjectId);

  /// Builds the grounded prompt, calls Gemini single-shot, persists the user
  /// turn + AI turn, returns the AI message map. Throws Fault on failure.
  Future<Map<String, dynamic>> send({
    required Map<String, dynamic> conversation,
    required List<Map<String, dynamic>> history,
    required String userText,
  });

  Future<Map<String, dynamic>?> settings(String userId);
  Future<void> saveSettings(Map<String, dynamic> values);
}
```
`_ChatProvider.send`:
1. Persist the user `TutorMessage` row (`TutorDao.insertMessage`).
2. Fetch grounding: `MaterialRepo.ins.textsForSubject(userId, conversation.subjectId)`; build a grounding block truncated to a budget (e.g. ~12k chars), each chunk labeled `[itemId | name]`.
3. Assemble `Content` list: history (mapped to `Content.text`/`Content.model`) + a final user `Content` containing the grounding block + question.
4. `AiService.ins.chatModel(await SystemPrompts.chat()).generateContent(contents)`; parse `res.text` JSON.
5. Persist the AI `TutorMessage` (text, citations, followUpPoints, kickerQuestion); `upsertConversation` with new `lastMessageAt`, `groundedSourceCount` (= injected item count), and a `title` if first turn (derive from the question).
6. `try/catch` → `AiFault`/`UnknownFault`.

#### 3. Cubit
**File**: `lib/blocs/chat/cubit.dart`
- `initUid(uid)` (mirrors `LibraryCubit.initUid`) → subscribe `watchConversations`.
- `openConversation(id)` → subscribe `watchMessages`; convert rows to `TutorMessage`/`TutorConversation`.
- `startConversation(subjectId)` → `createConversation`, set active.
- `send(text)` → emit `sending` `BlocState`, call `ChatRepo.send`, emit success/failed (Drift streams push the new messages into the list).

### Hygen Commands
```bash
hygen cubit nested chat   # ChatCubit + lib/repos/chat/, auto-registers in app.dart
```

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` clean; `build_runner` clean.
#### Manual Verification (via `dart` MCP driver — see Verification Strategy)
- [ ] Sending a question persists user + AI messages and a conversation row with a title.
- [ ] With indexed materials for the subject, the reply's citations reference a real `libraryItemId`/name.

**Implementation Note**: Pause for manual confirmation.

---

## Phase 3: Chat conversation UI (the tutor screen)

### Overview
Build the actual chat surface inside the existing `tutor/` screen, driven by `ChatCubit`.

### Changes Required

#### 1. Screen body + state
**Files**: `lib/ui/screens/tutor/tutor.dart`, `_state.dart`, `widgets/`, `listeners/`
- `_ScreenState` holds ephemeral composer state (controller/input text, sending flag).
- Body: message list (reverse `ListView` over `ChatCubit` messages via `.map()`), composer (text field + send button), subject-start state when no active conversation.
- Message widgets (extract per rule 7 — these clear the ≥5-child/≥30-line bar):
  - `_AiBubble` — markdown text + citation chips (`Citation.source`, color `colorHex`) + follow-up chips (`FollowUpPoint.label`, tap inserts/sends `body`) + optional `kickerQuestion`.
  - `_UserBubble` — right-aligned text bubble.
  - `_Composer` — input + send; disabled while sending; shows a typing indicator row while awaiting the reply.
- Add **markdown rendering**: add `flutter_markdown` (or a lightweight renderer) to `pubspec.yaml` for `_AiBubble`.

#### 2. Send wiring via listener
**File**: `lib/ui/screens/tutor/listeners/_send.dart` (hygen listener) — handle failed sends (show `showAppAlert` with `RouteSettings(name: ...)` per rule 14); scroll-to-bottom on new message.

### Hygen Commands
```bash
hygen screen listener tutor send     # BlocListener for send side-effects
hygen screen _widget tutor _ai_bubble
hygen screen _widget tutor _user_bubble
hygen screen _widget tutor _composer
```

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` clean.
#### Manual Verification (via `dart` MCP driver — see Verification Strategy)
- [ ] Full round-trip on device: ask → typing indicator → grounded reply with chips.
- [ ] Tapping a follow-up chip sends its body; tapping a citation chip is non-crashing (navigates/peeks the item — or no-op for v1).
- [ ] `App.init(context)` present; no `Spacer`; spacing via `Space.*` tokens.

**Implementation Note**: Pause for manual confirmation.

---

## Phase 4: Multi-conversation history + subject picker + settings

### Overview
Per-subject conversation list (switch/new) and the settings that shape grounding/tone.

### Changes Required

#### 1. Conversation history
**Files**: `lib/ui/screens/tutor/widgets/` (a history panel/sheet) + `listeners/`
- List conversations from `ChatCubit` (`watchConversations`), grouped/labeled by subject, newest first; tap opens; "new conversation" launches the subject picker.
- Subject picker: choose a `Subject` (from the library/subjects source) to seed `createConversation(subjectId)`.

#### 2. Settings
**Files**: a settings entry (sheet) bound to `TutorSettings` via `ChatRepo.settings`/`saveSettings`.
- `scope` (libraryOnly / libraryAndLectures), `reasoningDepth` (brief/balanced/detailed), `showCitationsOnEveryReply` → fed into prompt assembly in `ChatRepo.send`.

### Hygen Commands
```bash
hygen screen _widget tutor _history
hygen screen _widget tutor _subject_picker
```

### Success Criteria
#### Automated Verification
- [ ] `flutter analyze` clean.
#### Manual Verification
- [ ] Start two conversations in different subjects; both list and reopen with correct history after relaunch.
- [ ] Changing `reasoningDepth`/`scope` visibly changes reply behaviour.
- [ ] `showCitationsOnEveryReply = false` suppresses citation chips.

**Implementation Note**: Pause for manual confirmation.

---

## Verification Strategy

**No automated tests for now** (deferred). Each phase is verified by driving the running app in **driver mode** via the `dart` MCP (see CLAUDE.md → "Driving the App"). Static checks (`flutter analyze`, `build_runner`) still gate every phase.

### Driver-mode flow checks
1. Launch the **`Driver (MCP) — <device>`** entrypoint; `connect_dart_tooling_daemon` with the DTD URI.
2. Tap the **Tutor** tab → pick a subject → `enter_text` a Biology question (use `ByText` finders; tap the field before typing).
3. Confirm via `get_widget_tree` / `screenshot`: user bubble → typing indicator → grounded AI reply with **citation chips referencing a real item** + follow-up chips.
4. Ask something outside the materials → reply answers from general knowledge with an honest "not in your materials" note and **no fabricated citation**.
5. Tap a follow-up chip → its body is sent; tap a citation chip → non-crashing.
6. `hot_restart` (or relaunch) → conversations persist; reopen a thread and continue.
7. Open settings; change `reasoningDepth`/`scope`; toggle `showCitationsOnEveryReply` → confirm reply/chip behaviour changes.
8. `get_runtime_errors` throughout — failures surface as handled `Fault` alerts, no unhandled exceptions.

## Architecture Checklist
- [ ] `App.init(context)` at top of every `build()`
- [ ] UI (`_state.dart`) never calls `firebase_ai`/Drift — only `ChatCubit`
- [ ] `ChatCubit`/`ChatRepo` do not import from `lib/ui/`
- [ ] State via `ChatCubit.c(context)` / `_ScreenState.s(context)` — never `context.read`
- [ ] `firebase_ai` exceptions → typed `Fault` (`AiFault`) before emit
- [ ] `ChatRepo` returns `Map`/`List<Map>`/primitives only (ADR-013); cubit does `fromJson`
- [ ] Cubit/repo via `hygen cubit nested chat`; widgets/listeners via `hygen`
- [ ] No `for` loops in widget tree (`.map()`); no `Spacer` (`Space.*` tokens); widget extraction only at ≥5 children / ≥30 lines
- [ ] Dialogs/sheets pass `RouteSettings(name: ...)`

## References
- Research: `docs/research/2026-06-14-chat-agent-integration.md`
- Prerequisite: `docs/exec-plans/backlog/library-text-extraction.md`
- Cubit/repo pattern: `lib/blocs/quotes/cubit.dart`, `lib/repos/quotes/quotes_repo.dart`
- Persistence DAO (reused): `lib/core/db/daos/tutor_dao.dart`
- firebase_ai structured output: `~/.pub-cache/hosted/pub.dev/firebase_ai-3.6.0/lib/src/api.dart:1108-1170`
- Design (currently inaccessible): `…/TaleemMate.html`
