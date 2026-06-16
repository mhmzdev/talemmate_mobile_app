# Completed Plans

Plans whose phases are all done, merged, and verified.

| Plan | Completed | Description |
|---|---|---|
| [onboarding-implementation](onboarding-implementation.md) | 2026-06-13 | Create account + 4-step onboarding PageView + stepwise loader (new-user flow foundation) |
| [onboarding-session-lifecycle](onboarding-session-lifecycle.md) | 2026-06-03 | Real Firebase Auth + launch gate (isOnboardingComplete) + back-out sign-out via new AppAlertBase. Emulators-first |
| [onboarding-local-persistence](onboarding-local-persistence.md) | 2026-06-13 | Persist onboarding payload + picked materials to local Drift DB; file picker (local refs); Step 1/3 validation; profile→Firestore split |
| [library-materials-module](library-materials-module.md) | 2026-06-13 | App-wide materials module: LibraryCubit/Repo (Drift, one-shot load + pull-to-refresh), Library screen (grouped-by-subject incl. Unsorted, in-state search + filter chips), session-userId ADR-014, shared widgets, post-onboarding add-material path |
| [library-text-extraction](library-text-extraction.md) | 2026-06-14 | Gemini-based (firebase_ai multimodal) text extraction for library materials: MaterialCubit/Repo, MaterialTexts Drift store (schema v2), shared AiService + AiFault, real processingStatus + live status badges, copy-picked-files-to-stable-storage. Feeds chat grounding |
| [chat-agent](chat-agent.md) | 2026-06-14 | Grounded tutor chat: ChatCubit/ChatRepo, single-shot structured-JSON Gemini (AiService.chatModel + AgentTools.chatSchema) → existing Tutor* models, per-subject multi-conversation Drift history, chat UI (markdown/citations/follow-ups/kicker), subject picker + settings. Keeps tutor UI/route/tab |
| [study-plan-generation](study-plan-generation.md) | 2026-06-16 | v1 study-plan generation: Gemini structured-output pipeline (prompt/schema/model), `plan` cubit+repo generating a 7-day WeekPlan from subjects/exams/windows, Drift persistence (+aiReasoning migration), generation wired into the stepwise loader, home/plan read UIs, PlanCubit auth-uid lifecycle (ADR-014). Excludes Focus/reschedule |
