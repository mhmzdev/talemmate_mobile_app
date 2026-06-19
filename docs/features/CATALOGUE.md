# Feature Catalogue — TaleemMate

> Source of truth for what each feature does, its v1 scope, and its key data.
> If you are building a screen or cubit, read the relevant section here first.
>
> **This catalogue describes the code as it is actually implemented.** Where a piece
> of UI is present but its action is not yet wired, it is marked _(not yet wired)_.
> Treat those as intent, not behaviour.

TaleemMate is an AI-powered study companion for Pakistani university students. The AI tutor answers only from the student's own uploaded material — it is grounded, not general. All study data is stored locally (Drift/SQLite). Firebase handles auth only; cloud sync is not in v1.

---

## Feature Map

| Feature | Main Screen(s) | Backing bloc | AI? | Status |
|---|---|---|---|---|
| Auth | `login`, `create_account` | `user` | No | v1 |
| Onboarding | 4-step flow (post sign-up) | `onboarding` | No | v1 |
| Home dashboard | `home` | `plan`, `material`, `quotes` | Yes | v1 |
| Library | `library` | `library`, `material` | Yes (indexing) | v1 |
| AI Tutor | `tutor` | `chat` | Yes (core) | v1 |
| Quiz | `quiz` (push from Focus/Tutor) | `quiz` | Yes | v1 |
| Study Plan | `plan` | `plan` | Yes | v1 |
| Focus session | `focus` | `plan`, `chat` | Yes (insight) | v1 |
| Progress | `progress` | `progress` | Yes (insights) | v1 |
| Profile & Settings | `profile` | `user` | No | v1 |
| Splash | `splash` | `user` | No | v1 |

> The Tutor screen is backed by the **`chat`** bloc. The daily card on Home is backed by the **`quotes`** bloc (see §3 — it is a quote card, not a du'a card).

---

## Implementation Status

Where each feature actually stands in code. Status legend:

- ✅ **Shipped & verified** — built, wired to real data/AI, and driver-verified against a `docs/feat-checklist/` plan.
- 🟢 **Wired, unverified** — fully built and wired to real data/AI, but has no formal checklist yet.
- 🟡 **UI only** — screen + widgets built, but bound to **static/placeholder** data; actions not wired.
- 🚧 **Deferred / stub** — intentionally out of v1, or present-but-not-wired (no-op `onTap`).

| Feature | Status | What's real | Not wired yet |
|---|---|---|---|
| Auth (login / register / sign-out) | ✅ | Firebase Auth, launch gate, onboarding routing, stack-clearing sign-out | Forgot-password (empty `onTap`); `forgot`/`update`/`fetch`/`deleteAccount` mocked |
| Onboarding (4 steps + loader) | ✅ | Full flow → local Drift persistence (subjects/schedule/exams/materials), validation gates, resume | Firestore payload sync deferred; file picker stores **local refs only** |
| Library (materials module) | ✅ | Grouped list, in-memory search/filter, add/delete, pull-to-refresh, per-user uid | "Open document" & "Ask the tutor about this" → "coming soon" flash; no cloud storage; no rename/move/re-index |
| Library text extraction (OCR/index) | ✅ | Live Gemini OCR pipeline → `MaterialTexts`, status badges, retry, real page counts | No backfill of pre-existing items; no vector DB/embeddings; slides/video/voice/`.docx` → `failed` |
| AI Tutor (chat) | ✅ | Live Gemini, grounded on indexed materials, per-subject Drift history, citations/follow-ups/kicker | No streaming (single-shot); citation chip is a **peek**, not navigation; no voice/image; `scope` is informational only |
| Study Plan generation | ✅ | Live Gemini → `WeekPlan`, front-loads weak/near-exam subjects, persisted (no regen on relaunch) | One generation at onboarding only — no daily roll-forward / post-quiz regen triggers wired |
| Focus session + Reschedule/Snooze | ✅ | Timer ring, "Mark block done" → `SessionMetric`, 4 deterministic reschedule edits + narrow AI reasoning rewrite | "DND on" is a static label; pause/resume icon not keyed; "Move to tonight" fixed 20:30 (no prayer data) |
| Quiz | 🟢 | Live Gemini (`quizModel`), grounded on materials, 8/15 questions, persists attempts (feeds Progress) | No `docs/feat-checklist/` (not driver-verified); no flag/report-question; feedback citation has no "See in source" link |
| Progress | 🟢 | Reads **real** Drift data (streak, daily scores, session metrics, quiz attempts) + live `progressModel` AI insights | No `docs/feat-checklist/` (not driver-verified) |
| Profile & Settings | 🟡 | Screen renders; theme + Daily-quote-card toggle persist; version-copy-to-clipboard works | Header/account stats are **hardcoded** (`5 subjects`, `86 hrs`, `68/100`, `42 items`); most toggles local-only (not persisted); Delete account / Help / Rate are no-ops |
| Splash | ✅ | Animated gate → `UserCubit.init()` → routes by session/onboarding state | — |

### Cross-cutting — partial / deferred

| Concern | Status | Note |
|---|---|---|
| Hijri date in headers | 🚧 | Toggle exists in Profile; **not rendered** anywhere, and local-only (not persisted) |
| Cloud sync / backup | 🚧 | Toggle visible, off by default; no Firebase Storage or Firestore payload sync in v1 |
| Notifications (reminders / check-in / exam countdown) | 🟡 | Toggle rows render; no real OS notification scheduling wired |
| App language switch (Urdu) | 🚧 | Interface is English-only; `AppLanguage` enum exists but is **not** wired to a control or to AI response language. Only a Nastaliq **font** toggle exists |
| Daily card as Arabic du'a | 🚧 | Ships as a generic **English quote + author** (`quotes` bloc); no Arabic verse / Nastaliq / translation pair |
| Prayer-aware scheduling | 🟢 | "After Fajr" / "After Isha" are real selectable **fixed-time** windows — no computed prayer times |
| Subject colour map | 🟢 | Per-subject `colorHex` (user data, default `#6B6B85`), not a predefined `sw-*` palette |

---

## 1. Auth

### Login (`login`)
- Email + password fields, show/hide password toggle (eye / eye-off Lucide icons)
- "Forgot password?" link — _present but not yet wired (`onTap: () {}`)_
- "Create account" link → `AppRoutes.createAccount`
- Full-screen loader while Firebase Auth completes — title **"Signing In..."**, subtitle "This should only take a moment."
- Footer tagline: **علم نور ہے** (Urdu, rendered without diacritics) — "Knowledge is light."

### Sign-up (`create_account`)
- Single screen, shown as **step `01 / 03`** of account creation; onboarding continues the count
- Fields: full name, email, password, confirm password, Terms agreement checkbox
- Password strength bar — 4 segments, labels: **Weak / Fair / Strong / Very Strong**
- On success → Onboarding (when `isOnboardingComplete == false`)

### Sign-out
- Triggered from Profile → "Sign out"
- **One** confirmation variant: a centered `showAppAlert` dialog (icon + title + subtitle + Cancel / Sign out). _No bottom-sheet variant exists in code._
- Data stays on device after sign-out; signing back in needs a network connection

---

## 2. Onboarding (4 steps — post sign-up)

Runs once immediately after account creation via the `onboarding` bloc. Collects everything needed to generate the first study plan. Step indicator format: **`01 / 04` … `04 / 04`**. Ends with a stepwise loader.

> The "So far" recap card referenced in earlier specs is **not implemented**.

### Step 1 — About you
- Fields: **YOUR NAME**, **INSTITUTION** (text, e.g. "NUST · SEECS")

### Step 2 — Subjects & confidence
- Add subjects via a modal: course code (CS-301) + name (Algorithms)
- Confidence slider per subject. Thresholds (from `utils.dart`): **Shaky** `< 0.35` / **Getting there** `0.35 – 0.7` / **Confident** `≥ 0.7`
- "Add another subject" tile

### Step 3 — Study rhythm
- Time windows (multi-select toggles) — fixed-time named windows from `core/constants/study_windows.dart`:
  - After Fajr (05:30–07:00), Morning (09:00–12:00), Afternoon (14:00–16:00), Evening (16:30–19:00), After Isha (21:00–23:00)
- Daily target hours slider: **0.5 – 6 hrs, 11 divisions (step 0.5)**, shown as "N.N hrs"
- "UPCOMING EXAMS" section: subject + date, add via modal

### Step 4 — Material upload
- Upload zone accepting: **"PDF, images, notes, slides"**
- Source chips: **Files · Photos · Camera** _(no Drive; no dedicated voice-memo source)_
- "ADDED SO FAR" list of picked materials
- Privacy note: *"Files are encrypted and only used to generate your study content. We never share them."*
- Header **"Skip for now"** button + main CTA **"Finish setup"** — both call `state.finish(context)`

### Post-onboarding loader (`stepwise_loader`)
Title: **"STEP 4 OF 4 · PERSONALISING"**. Steps shown:
1. Saving your subjects
2. Indexing uploaded material
3. Calibrating today's plan
4. Almost there — readying your home screen

Footer: *"Patience — صَبْر — you'll be set up in a few seconds."*

---

## 3. Home

Dashboard. Shows today's plan, AI reasoning, recent uploads, quick tutor entry, and the daily quote.

### Today's plan card
- Progress: **"$done of $total"** blocks (dynamic)
- Summary line — **rule-based, not AI-generated**: "All blocks done — great work today." / "$remaining block(s) left to go today."
- Meter bar (`AppMeter`, fraction = done / total)
- List of study block rows: time, duration, subject swatch, topic, status dot (done = filled check, now = thick ring, upcoming = open ring)
- **"Begin next block"** CTA → opens the **Focus session** (`AppRoutes.focus`) for the next block (see §6.5)
- Reschedule icon button (clock, Lucide)

### "Why this plan" AI card
- Amber/gold left edge (`AppEdgeCard`, 3px accent border), "AI" pill (label "Why this plan")
- AI reasoning text from `cubit.week?.aiReasoning`
- Footer pills: upcoming exam countdown + available hours today
- _No timestamp is rendered._

### Recently added
- Horizontal scroll of up to 4 upload tiles (colour thumbnail, name, size + page-count metadata)
- "See all →" → Library

### Quick tutor card
- Amber-edged card, copy: **"Ask anything from your uploaded notes."**
- Tappable input row with placeholder **"Explain TCP slow start with an example"** and a **sparkles** icon _(not a mic)_
- Tap → opens Tutor (`pushReplace`). _No locale-dependent Urdu placeholder._

### Daily quote card (backed by `quotes` bloc)
- Gold/accent left bar
- Renders an **English** quote in italic serif + author as "— {author}". _No Arabic verse / Nastaliq / translation pair._
- Data fetched from the quotes API `/today` endpoint (fields: `q`, `a`, `i`, `date`)
- Toggle lives in Profile → Appearance, labelled **"Daily quote card"**, persisted to SharedPreferences via `AppProvider.dailyQuoteCard` (`Cache.dailyQuoteCard`)

---

## 4. Library

Manages all uploaded study material, grouped by subject. Source of truth for what the AI tutor can reference.

### Header
- Title "Library" + count + storage used (e.g. "42 documents · 1.2 GB")
- Avatar affordance in the header; search is the field below (not a header icon)

### Search & filter
- Search bar placeholder: **"Search notes, slides, photos…"**
- Filter chips: **All** + one per subject

### Subject groups
- Each subject renders a header (colour-dot swatch + name + course code + item count) with its items **always expanded below** — _the sections are not collapsible._

### File item states (`ProcessingStatus` enum: `pending`, `processing`, `indexed`, `failed`)
- **AI INDEXED** — gold pill (+ page count); available to tutor
- **Processing** — gold spinner with "Reading…" label
- **Failed** — error state
- _There is no separate "reading in progress" state._

### File types and colours (`library_item_tile.dart`)
| Type | Colour | Description |
|---|---|---|
| PDF | `#E05252` (red) | Papers, textbooks, lecture notes |
| IMG | `#4A90D9` (blue) | Photos of whiteboards / lecture boards |
| SLIDE | `#E09A2B` (orange) | Slide decks |
| NOTE | `#4CAF50` (green) | Markdown / plain text notes |
| VIDEO | `#9B59B6` (purple) | Video material |
| VOICE | `#1ABC9C` (teal) | Voice memos |

### Upload affordance
- "Add new material" card with a **solid** border _(not dashed)_
- Accepts: **"PDF · Photo of notes · Slide deck · Voice memo"**
- Privacy note: *"New uploads are processed privately on your device for OCR & embeddings."*

---

## 5. AI Tutor (`tutor`, backed by `chat` bloc)

Chat interface. The AI answers only from the student's uploaded, indexed library.

### Header
- "Tutor" title + "AI" pill + subject context: **"$subject · grounded in $n source(s)"** (dynamic)

### Message types
- **User bubble**: right-aligned, primary background
- **AI reply**: left-aligned, surface background, standard border (`AppTheme.c.border` — _not a gold-specific border_). Contains:
  - Main response text (markdown)
  - Tappable **citations** (source + page → modal)
  - **Kicker**: follow-up offer rendered as italic subtext
  - **Follow-up chips**: tapping one sends its body as the next message
- **Typing indicator**: 3 animated dots only (`AppProgressDots`) — _no "Reading N sources…" label._

### Composer
- Text input (1–5 lines) + send button (arrow-up). _No attach icon, no mic button._
- Placeholder: **"Ask your tutor…"**

### Scope
- Tutor answers only from indexed library files (grounded via `ChatRepo` / chat data provider)

---

## 6. Quiz (`quiz`)

AI-generated single-answer MCQ. Reached from the **Focus session** ("Test yourself") and the Tutor.

### Structure
- **Question count is variable** (`quiz_data_provider.dart`): **8** for a single-material quiz, **15** for a subject-wide / multi-material quiz
- Progress: **"Question N of $total"** + segmented progress bar
- Timer displayed, format `m:ss` (from `elapsedLabel`)

### Question anatomy
- AI pill: `quiz.sourceLabel ?? 'AI QUIZ'` ("Generated from [source]")
- Question text in serif (`AppText.h2`)
- Answer options: A/B/C/D letter badge + text

### Answer states
- Unselected (neutral) / selected / after reveal: correct = green border + check badge, wrong = red border + X badge, correct option always revealed green

### Feedback card (after answering)
- "FEEDBACK" AI pill + **"Correct" / "Not quite"** (colour-coded)
- Explanation text
- Citation as book icon + source text — _no "See in source" link/button._

### Navigation
- **Skip** (ghost) + **Next** (disabled until answered). _No flag/report-question icon._

---

## 6.5 Focus session (`focus`)

> **Not previously documented.** A full-screen study-session timer launched from Home's **"Begin next block"** CTA, which pushes `AppRoutes.focus` with the next `StudyBlock` as argument. _Plan-screen blocks are read-only and do not open Focus._

### Top bar
- Close (chevron-down) → pops the route
- Centered **"FOCUS SESSION"** label + position "Block N of M · Do Not Disturb on"
- Pause / resume toggle (cancels / restarts the countdown)

### Timer ring
- Determinate countdown (240×240 custom-painted ring): background track + arc sweeping as time elapses
- Centre: remaining time (`m:ss`, large serif) + total duration below
- 1-second tick; pause/resume supported; **progress is not persisted** — leaving the screen loses remaining time

### Block guidance
- Subject swatch + "SUBJECT · WALKTHROUGH" label
- Serif block title (`block.title`)
- Activities guidance text (`block.activities`) in a bordered card

### Tutor insight (optional)
- Renders only when `block.aiInsight` is non-empty: "Guided by tutor" pill + plain text (no citations/markdown)

### Actions
- **"Test yourself"** → Quiz (`subjectId` + optional `topicId`)
- **"I'm stuck"** → starts a `chat` conversation for the block's subject, then opens Tutor
- **"Mark block done"** → `PlanCubit.markBlockDone(block)` then pops

---

## 7. Study Plan (`plan`)

Weekly view of the AI-generated schedule.

### Week strip
- 7-day horizontal selector: weekday abbreviation + date number + block-count dots (clamped 0–5)
- Red exam dot (top-right) on days with an exam (`day.exam != null`)
- Today / selected day highlighted (primary background)
- _No exam countdown banner._

### "Why this week" AI card
- Gold left edge (`AppEdgeCard`), AI pill, weighting-logic reasoning text
- _No "Adjust →" button._

### Daily timeline
Vertical spine with a time column (left) and block cards (right).

**Block card states:**
| State | Visual |
|---|---|
| Done | 55% opacity, title struck through (`lineThrough`) |
| Now | `specBackground` surface + "Now" badge |
| Upcoming | Transparent (no card background) |

**Block card fields:** start time, duration, subject swatch + name, and the **activities** line (`block.activities`) — this is the freeform method text. _There is no separate "method" model field or topic line._

**AI insight bubble** (`_AiInsight`): gold border + sparkles icon, text from `block.aiInsight`, rendered when non-empty.

> Plan blocks are **read-only** (no tap handler). Sessions are started from Home's "Begin next block" → Focus.

---

## 8. Progress (`progress`)

Learning analytics dashboard. **14-day rolling view.**

### Readiness hero card
- Readiness score `score / 100` (serif, 46px)
- Week-on-week delta: "$arrow $gain this week" (arrow `↑ / ↓ / —` from `weeklyGain`)
- Predicted score range
- Gold meter (`AppMeter(gold: true)`) + AI pill
- **Hero subject selection** (`cubit.dart:216–228`): nearest upcoming exam's subject; fallback to the lowest-readiness subject

### Mastery **by subject**
- Per-**subject** progress bars (not per-topic) with trend arrows ↑ / — / ↓
- **"Weak"** badge when `readinessScore < 50`

### Quiz history chart
- 14-day bar chart (`scores` sliced to last 14): most recent bar gold (`accent`), older bars darker
- Hardcoded edge labels: "2 weeks ago" → "today"
- Footer: total quizzes / questions

### Stats row (3 cards)
- **Study streak** (days) · **This week** (hrs) · **Avg session** (min)

### AI insight card
- Gold/amber edge, serif headline (`AppText.h3.fra()`) + supporting data

---

## 9. Profile & Settings (`profile`)

### Header
- Avatar (initials), name, email, **X-close** icon _(not an edit button)_
- Quick stats: **Streak / Studied (hrs) / Readiness** (placeholder values today)

### Settings sections

**Account**
- Subjects & confidence (e.g. "5 subjects")
- Schedule & exams (e.g. "3.5 hrs/day")
- Material → Library (e.g. "42 items · 1.2 GB")
- Institution (e.g. "NUST · SEECS")

**AI Tutor**
- Citations toggle ("Show citations on every reply", default **on**)
- Tutor scope — read-only display ("Library + lectures")
- Reasoning depth — read-only display ("Balanced")

**Notifications**
- Block reminders · Daily check-in (8 PM) · Exam countdown (3-day / 1-day / morning-of)

**Appearance**
- Theme: Auto / Light / Dark (segmented)
- **Daily quote card** toggle (persisted via `AppProvider.dailyQuoteCard`)
- Hijri date toggle — _local-only, not persisted, and not yet rendered in headers_

**Language**
- App language: "English" (read-only; no locale switch)
- Urdu content rendering: "Use Nastaliq for Urdu passages in your material." (boolean, `useUrduNastaliq`). _This is a font toggle only — there is no switch that changes AI response language._

**Privacy & data**
- On-device processing: "On" (read-only)
- Cloud backup toggle (off by default; deferred in v1)
- Privacy policy
- _"Export my data" was removed (commit 0a5dd14)._

**Support**
- Help & feedback · Rate TaleemMate _(both present; onTap not yet wired)_
- _"About" section removed; version moved to the footer (below)._

**Danger zone**
- Sign out (ghost button)
- Delete account (rose/red link) — _no-op `onTap` (not yet wired)_

**Version footer**
- Tappable line `v{version} · {buildNo}`; tapping copies "Version: {version}, Build No: {buildNo}" to the clipboard with a success flash

> Most Profile toggles are **local-only** for now (no persistence wired), per the screen-state comment. The Daily quote card toggle is the exception — it persists via `AppProvider` / SharedPreferences.

---

## 10. Loading States

| Variant | Use when |
|---|---|
| `FullScreenLoader` (blur backdrop + spinner ring + title + optional subtitle + progress dots) | Blocking transient actions: sign-in. No interaction possible. |
| `StepwiseLoader` (checklist steps) | First-run onboarding setup — user witnesses each step complete. |

`FullScreenLoader` lives at `lib/ui/widgets/design/full_screen_loader/` (has a `.modal()` variant). `StepwiseLoader` is a first-run onboarding screen, not a reusable widget.

---

## Cross-cutting Concerns

### Islamic / cultural layer (current state)
- **Patience note** (*صَبْر*) shown during the post-onboarding loader — **implemented**
- **Prayer-named study windows**: "After Fajr" and "After Isha" exist as fixed-time selectable windows — **implemented** (these are named time slots, not computed prayer times)
- **Daily card**: currently a generic **English quote + author** (the `quotes` bloc), **not** an Arabic du'a with Nastaliq/translation — the earlier "du'a card" spec is **not** what ships
- **Hijri date** toggle exists in Profile but is **not rendered in headers yet** (local-only)
- **Urdu Nastaliq rendering** toggle exists (`useUrduNastaliq`) and applies via the `.urdu()` text modifier

### Subject colour system
There is **no predefined `sw-*` colour map keyed by subject name.** Each `Subject` carries its own `colorHex` string (default `#6B6B85`, grey-purple), rendered consistently across screens via `SubjectSwatch` / `.toColor()`. Colour is therefore per-subject data, not a static palette.

### AI grounding rule
**The tutor answers only from indexed library files** — grounded, never general knowledge. Quiz questions are likewise generated from source material. This is a product/UX rule enforced in the chat/quiz data providers, not just a prompt setting. (The planning AI — "Why this plan/week", Progress insights — reasons over the user's own schedule/score data, which is a separate concern from tutor grounding.)

### On-device privacy
- OCR and embeddings are processed locally (Drift/SQLite)
- Uploaded files are encrypted and used only to generate study content; nothing is shared
- Privacy notes appear in Library, Onboarding Step 4, and Profile → Privacy

### Bilingual UX
- Interface language: English (v1; no locale switch wired)
- Content language: a Nastaliq rendering toggle exists for Urdu passages in material. There is an `AppLanguage` enum (english, urdu) but it is **not** wired to a Profile control or to AI response language.
