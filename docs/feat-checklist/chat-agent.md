# Feature Checklist — Chat Agent (Grounded Tutor)

> A living test-plan + edge-case list for the conversational tutor (`ChatCubit` +
> `ChatRepo`, single-shot structured-JSON Gemini via `AiService.chatModel` +
> `AgentTools.chatSchema`, per-subject Drift history on the existing `Tutor*`
> models/tables). Re-run the relevant rows before merging any change that touches
> `lib/blocs/chat/`, `lib/repos/chat/`, `lib/ui/screens/tutor/`,
> `lib/services/firebase/ai/` (`ai_service.dart`, `agent_tools.dart`,
> `system_prompts.dart`), `AppDatabase` tutor helpers / `TutorDao` /
> `MaterialTextsDao.forSubject`, the `assets/chat_sys_prompt.md` prompt, or the
> auth-transition listeners that call `ChatCubit.initUid/resetUid`.
>
> Status legend: ✅ verified on simulator (Dart MCP) · 🔒 guard / invariant to
> keep · 🚧 by-design gap (not implemented yet) · ⏳ not driver-tested (inferred
> from a shared code path) · 📝 observation to revisit.
>
> Related: [exec-plan](../exec-plans/completed/chat-agent.md),
> [library-text-extraction checklist](library-text-extraction.md),
> [ADR-013](../architecture/DECISIONS.md),
> [tutor system prompt](../../assets/chat_sys_prompt.md).

## How to run

1. Ensure the Firebase project has **Firebase AI Logic / Gemini** enabled and
   billing active (chat is a live `firebase_ai` call — no emulator).
2. `flutter run --flavor stage -t test_driver/app.dart`; `connect_dart_tooling_daemon`
   with the DTD URI.
3. Sign in, open the **Tutor** tab. For grounded-citation rows, first add +
   index materials for the chosen subject via the Library tab.

---

## 1. Model + schema + system prompt (Phase 1)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 1.1 | `chatModel(...).generateContent(...)` | Returns JSON parseable into `TutorMessage` (`text`, `citations[]`, `followUpPoints[]`, `kickerQuestion?`) | ✅ |
| 1.2 | `AgentTools.chatSchema` shape | Tutor output shape (not the old `responseMessage`/`error` placeholder); `kickerQuestion`/`libraryItemId`/`pageReference` optional | ✅ |
| 1.3 | `SystemPrompts.chat()` | Loads + caches `assets/chat_sys_prompt.md` (TaleemMate tutor copy, not "Dreamstale") | ✅ |
| 1.4 | No materials for subject | Answers from general knowledge, **empty `citations`** — no fabricated citation | ✅ |
| 1.5 | Language follows the question | English question → English answer (`text` + `followUpPoints` + `kickerQuestion`); switches only when the student switches | ✅ |
| 1.6 | Cross-language grounding | Urdu source + English question → **English** answer (materials translated); language never inherited from the source | ✅ |
| 1.7 | No tag echo | The `[id \| name]` grounding markers never leak into `text`; they only fill `citations` | ✅ |

## 2. Cubit / repo + persistence (Phase 2)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 2.1 | Send a question | User turn persists immediately; AI turn persists after reply; both appear via Drift stream | ✅ |
| 2.2 | Conversation row | First turn derives a `title`; `lastMessageAt` + `groundedSourceCount` updated | ✅ |
| 2.3 | Multi-turn context | Prior turns sent as `Content.text`/`Content.model` history | ✅ (follow-up answered in context) |
| 2.4 | Survives relaunch | After `hot_restart`, conversations reload from Drift (per-user, newest first) | ✅ |
| 2.5 | Reopen thread | `openConversation` re-subscribes `watchMessages`; full history restored | ✅ |
| 2.6 | Grounded citation | With indexed materials, reply cites a real `libraryItemId`/name | ✅ (cited `concept - ai agents.md`) |
| 2.7 | `get_runtime_errors` | Zero unhandled errors; failures are typed `Fault`s (`AiFault`/`UnknownFault`) | ✅ |

## 3. Chat UI (Phase 3)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 3.1 | Tutor tab, no active chat | Empty state (graduation-cap, "Choose a subject"; "Past conversations" when history exists) | ✅ |
| 3.2 | Subject picker | Sheet lists real subjects; tap starts + opens a conversation | ✅ |
| 3.3 | Composer | Multi-line field; send button disabled while empty/sending; clears + unfocuses on send | ✅ |
| 3.4 | User bubble | Right-aligned, primary fill | ✅ |
| 3.5 | AI bubble | Left-aligned; **markdown** rendered (bold, bullet lists) via `gpt_markdown` | ✅ |
| 3.6 | Typing indicator | Pulsing-dots bubble while `send.isLoading` | ✅ |
| 3.7 | Kicker question | Italic accent line under the answer when present | ✅ |
| 3.8 | Follow-up chips | Rendered with sparkle icon; tap **sends the `body`** (not the label) | ✅ |
| 3.9 | Citation chip tap | Non-crashing peek (`showAppAlert`, routeName `citation`) | ✅ (peek shows source + "From your materials.") |
| 3.10 | Composer clears bottom bar | Composer + list sit above the floating `BottomBar` (measured height) | ✅ |

## 4. History + subject picker + settings (Phase 4)

| # | Scenario | Expected | Status |
|---|---|---|---|
| 4.1 | History sheet | Lists conversations newest-first with subject + relative time; tap reopens | ✅ |
| 4.2 | New conversation | History "New conversation" + bar pencil open the subject picker | ✅ |
| 4.3 | Settings sheet | `scope` / `reasoningDepth` chips + `showCitationsOnEveryReply` toggle; each change saves | ✅ |
| 4.4 | Settings feed prompt | `reasoningDepth`/`scope` injected into the user turn (`PREFERENCES:` line) | ✅ (wired; effect not isolated on device) |
| 4.5 | `showCitationsOnEveryReply = false` | `_AiBubble` suppresses citation chips | ⏳ (no citations to suppress without materials) |
| 4.6 | Settings persist | Reload restores saved scope/depth/toggle | ⏳ (saved via Drift; not re-asserted on device) |

---

## Invariants / regression guards 🔒

- **Repo stays Map/primitives-only (ADR-013)** — `ChatRepo` takes/returns
  `Map`/`List<Map>`/primitives; `ChatCubit` does `Tutor*.fromJson`/`toJson`. The
  row↔model conversion lives in `AppDatabase` (`watchTutorConversations`,
  `watchTutorMessages`, `saveTutorConversation`, `saveTutorMessage`,
  `tutorSettings`, `saveTutorSettings`), **not** the repo. `lib/repos/chat/` must
  not import `core/models/`.
- **No fabricated citations** — `citations` is empty when the answer is general
  knowledge; the model is told never to invent an id/name/page. Citations get a
  generated `id` in the repo (the model omits it).
- **`firebase_ai` errors → `AiFault`** — `send` catches `FirebaseAIException` →
  `AiFault.fromAiException`; other errors → `UnknownFault`. Never uncaught.
- **System prompts live in `SystemPrompts`** — `system_prompts.dart` is the single
  home + cache for all bundled prompts (`chat()` → `chat_sys_prompt.md`,
  `library()` → `library_extraction_sys_prompt.md`); a shared `_cache` map loads
  each asset once. `AiService` sources both prompts from here — don't `rootBundle`
  them inline. Schema lives in `AgentTools.chatSchema`. Add a getter per new agent.
- **Language follows the question, never the source** — reply language is decided
  only from the student's message; the system prompt + the per-turn `LANGUAGE:`
  line (appended after the question in `_userTurn`) enforce this and tell the
  model to *translate* differently-languaged materials. Keep both — the turn-level
  line is what overrides a strongly-Urdu grounding block.
- **Grounding tags stay internal** — the `[id | name]` markers must never appear in
  `text`; the prompt forbids echoing them. They only fill `citations`.
- **uid lifecycle (ADR-014)** — `ChatCubit.initUid` is called alongside
  `LibraryCubit.initUid` in splash + login listeners; `resetUid` in both logout
  listeners. Cancels conversation/message stream subs on reset + `close()`.
- **Active snapshot kept fresh** — the conversation stream listener re-maps the
  active conversation from its persisted row so `title`/`lastMessageAt` don't go
  stale (prevents the first-turn title being overwritten on later turns).
- **Reuses existing `Tutor*` terminology** — no rename of the `tutor/` screen,
  `/tutor` route, "Tutor" tab, `Tutor*` models, or `tutor_*` tables; no Drift
  migration in this feature.
- **`chat_mocks.dart` / `chat_parser.dart` kept** — scaffold parts with
  `// ignore_for_file: unused_element` (rule 12). Don't prune.
- **Dialogs/sheets pass `routeName`** — `/modal/tutor-subject`,
  `/modal/tutor-history`, `/modal/tutor-settings`, `/alert/citation`.
- **Driver hooks** — `ValueKey`s `tutor_send` / `tutor_history` / `tutor_new` /
  `tutor_settings` exist only so `flutter_driver` can target them; keep them.
- **Screen metrics via `AppMedia`, not `MediaQuery`** — bubbles size off
  `AppMedia.width` (set up by `App.init`); don't reintroduce `MediaQuery.of/sizeOf`.
- **Typing indicator reuses `AppProgressDots`** — the three-dot pulse is the shared
  `lib/ui/widgets/design/misc/progress_dots.dart` (also used by `FullScreenLoader`);
  `_Typing` is just the bubble around it. Don't re-hand-roll the animation.

## By-design gaps 🚧 (not implemented — don't treat as bugs)

- **No streaming** — single-shot `generateContent` only; the whole reply appears
  at once after the typing indicator.
- **Per-subject only** — `topicId` is always null; no topic-level threading UI.
- **Grounding = "all subject text", truncated** — `~12k` char budget,
  oldest-first, each chunk tagged `[itemId | name]`. No vector DB / embeddings.
- **`scope` is informational** — there's no separate "lectures" corpus in v1, so
  `libraryOnly` vs `libraryAndLectures` only nudges the prompt.
- **No voice / TTS / image attachments** in chat.
- **Bottom tab bar shows above the keyboard** — a consequence of `Screen`'s
  overlay `BottomBar`; the composer still sits above it.
- **Citation chip is a peek, not navigation** — tapping shows source/page in an
  alert; it does not open the library item.
