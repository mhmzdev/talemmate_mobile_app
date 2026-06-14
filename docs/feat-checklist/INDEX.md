# Feature Checklists

Living test-plans + edge-case lists, one per feature/flow. Re-run the relevant
checklist before merging any change that touches a listed feature, so existing
flows don't regress. Each row carries a status: ✅ verified · 🔒 invariant to
keep · 🚧 by-design gap.

| Checklist | Covers |
|---|---|
| [onboarding-flow](onboarding-flow.md) | Register → onboarding → home; launch gate; login routing; sign-out back-out; completion |
| [library-materials-module](library-materials-module.md) | Library screen (grouped-by-subject + Unsorted, in-state search + filter chips, pull-to-refresh); "…" actions sheet + delete; post-onboarding add-material; session userId (ADR-014); shared widgets + picker service |
| [library-text-extraction](library-text-extraction.md) | Gemini text-extraction pipeline (MaterialCubit/Repo, MaterialTexts schema v2); supported/unsupported kinds; live status badges + retry; copy-picked-files-to-stable-storage; grounding retrieval |
| [chat-agent](chat-agent.md) | Grounded tutor (ChatCubit/Repo, structured-JSON Gemini → Tutor* models); send round-trip + markdown/citation/follow-up/kicker UI; per-subject Drift history + reopen; subject picker + settings; uid lifecycle |
