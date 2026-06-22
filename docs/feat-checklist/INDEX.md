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
| [study-plan-generation](study-plan-generation.md) | AI study-plan generation (PlanCubit/Repo, structured-JSON Gemini → WeekPlan; schedule models + aiReasoning schema v3); onboarding-loader generation; front-loading weak/near-exam subjects; window catalog; home Today's-plan + Why-this-plan cards; plan-screen week strip + exam markers + timeline; effectiveStatus display; persistence (no regen); uid lifecycle |
| [focus-session-and-reschedule](focus-session-and-reschedule.md) | Reschedule/Snooze sheet (deterministic block move/snooze/shorten/skip + narrow AI "Why this plan" rewrite with loading state); Focus Session screen (determinate timer ring, activities guidance, static tutor panel, "I'm stuck" subject deep-link, "Mark block done" → status + SessionMetric); `effectiveStatus` honours manual completion |
| [profile-account-editors](profile-account-editors.md) | Profile → Account editors: Institution edit (Firestore + Drift mirror, sheet-owned listener); standalone Subjects & confidence editor (`commitSubjects`, cascade-delete keeping materials); Schedule & exams editor (`commitSchedule`, window-required gate); shared offer-to-regenerate flow (plan-affecting gate, rebuild-behind-loader, Later/Rebuild) |
