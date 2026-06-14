# Completed Plans

Plans whose phases are all done, merged, and verified.

| Plan | Completed | Description |
|---|---|---|
| [onboarding-implementation](onboarding-implementation.md) | 2026-06-13 | Create account + 4-step onboarding PageView + stepwise loader (new-user flow foundation) |
| [onboarding-session-lifecycle](onboarding-session-lifecycle.md) | 2026-06-03 | Real Firebase Auth + launch gate (isOnboardingComplete) + back-out sign-out via new AppAlertBase. Emulators-first |
| [onboarding-local-persistence](onboarding-local-persistence.md) | 2026-06-13 | Persist onboarding payload + picked materials to local Drift DB; file picker (local refs); Step 1/3 validation; profile→Firestore split |
| [library-materials-module](library-materials-module.md) | 2026-06-13 | App-wide materials module: LibraryCubit/Repo (Drift, one-shot load + pull-to-refresh), Library screen (grouped-by-subject incl. Unsorted, in-state search + filter chips), session-userId ADR-014, shared widgets, post-onboarding add-material path |
| [library-text-extraction](library-text-extraction.md) | 2026-06-14 | Gemini-based (firebase_ai multimodal) text extraction for library materials: MaterialCubit/Repo, MaterialTexts Drift store (schema v2), shared AiService + AiFault, real processingStatus + live status badges, copy-picked-files-to-stable-storage. Feeds chat grounding |
