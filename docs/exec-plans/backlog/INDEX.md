# Exec Plans — Backlog

| Plan | Description |
|---|---|
| [`library-text-extraction.md`](library-text-extraction.md) | Prerequisite: Gemini-based (firebase_ai multimodal) text extraction for library materials — new `MaterialCubit`/`MaterialRepo`, `MaterialTexts` Drift store, real `processingStatus`. Feeds chat grounding. |
| [`chat-agent.md`](chat-agent.md) | Grounded tutor chat: new `ChatCubit`/`ChatRepo`, single-shot structured-JSON Gemini responses → existing `Tutor*` models, per-subject multi-conversation Drift history. Keeps `tutor` UI/route/tab. Depends on library-text-extraction. |
