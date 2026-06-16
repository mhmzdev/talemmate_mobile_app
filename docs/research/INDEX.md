# Research Index

| Document | Description | Date |
|---|---|---|
| [2026-05-25 — Form Keys + Form Data convention](2026-05-25-form-keys-pattern.md) | How `static/_form_keys.dart` and `static/_form_data.dart` are organised in create_account and login | 2026-05-25 |
| [2026-06-03 — Onboarding feature state & gaps](2026-06-03-onboarding-feature-state-and-gaps.md) | Onboarding UI is complete but backend (repo, auth, file upload, launch gate) is fully mocked — gap list to finish on emulators | 2026-06-03 |
| [2026-06-03 — Onboarding session lifecycle & alerts](2026-06-03-onboarding-session-lifecycle-and-alerts.md) | Auth state (`userData`/`user`), app_flight Firebase reference, splash gating, back-button/PopScope, and dialog patterns — for resume-on-restart, sign-out confirmation, and a centered AppAlertBase | 2026-06-03 |
| [2026-06-13 — Library feature: materials module](2026-06-13-library-feature-materials-module.md) | What exists to build the Library as a separate cubit/repo materials module: Drift tables/DAOs/streams ready, subjectId FK, repo→AppDatabase template, screen scaffold, reusable (but private) widgets, no search/group/read-path yet | 2026-06-13 |
| [2026-06-14 — Chat Agent (Tutor) firebase_ai integration](2026-06-14-chat-agent-integration.md) | What exists vs remaining to build the chat/tutor agent: tutor models + Drift DAO + empty /tutor screen + bottom-bar tab ready; firebase_ai unused, no cubit/repo/UI/asset-loader, system prompt is wrong-app leftover | 2026-06-14 |
| [2026-06-15 — Study plan generation end-to-end](2026-06-15-study-plan-generation.md) | Plan (=schedule) models + Drift tables/DAO complete, onboarding inputs collected/persisted, firebase_ai structured-output template proven — but no plan cubit/repo, no Gemini generation (no blocks ever created), empty home/plan UI, no Focus/execution screen; loader "Calibrating plan" is a fake timer | 2026-06-15 |
