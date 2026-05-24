# Feature Catalogue — TaleemMate

> Source of truth for what each feature does, its v1 scope, and its key data.
> If you are building a screen or cubit, read the relevant section here first.

TaleemMate is an AI-powered study companion for Pakistani university students. The AI tutor answers only from the student's own uploaded material — it is grounded, not general. All data is stored locally (Drift/SQLite). Firebase handles auth only; cloud sync is not in v1.

---

## Feature Map

| Feature | Main Screen(s) | AI? | Status |
|---|---|---|---|
| Auth | `login`, `create_account` | No | v1 |
| Onboarding | 4-step flow (post sign-up) | No | v1 |
| Home dashboard | `home` | Yes | v1 |
| Library | `library` | Yes (indexing) | v1 |
| AI Tutor | `tutor` | Yes (core) | v1 |
| Quiz | `quiz` (modal/push from tutor) | Yes | v1 |
| Study Plan | `plan` | Yes | v1 |
| Progress | `progress` | Yes (insights) | v1 |
| Profile & Settings | `profile` | No | v1 |

---

## 1. Auth

### Login
- Email + password fields, show/hide password toggle
- "Forgot password?" link (password reset flow — Firebase Auth)
- "Create account" link → sign-up flow
- Full-screen loader ("Signing you in…") while Firebase Auth completes
- Islamic footer: *عِلْم نُور ہے* — "Knowledge is light."

### Sign-up (3 steps, `create_account`)
- Step 01/03: Full name, email, password + confirm, password strength bar, Terms agreement
- After account creation → Onboarding (4 steps)
- Steps 02–03 of sign-up are covered inside Onboarding below

### Sign-out
- Triggered from Profile
- Two dialog variants: centered alert or bottom sheet (use bottom sheet — more detail + network caveat)
- Data (library, progress) stays on device after sign-out; needs network connection to sign back in

---

## 2. Onboarding (4 steps — post sign-up)

Runs once immediately after account creation. Collects everything needed to generate the first study plan. Backed by a stepwise loader at the end.

### Step 1 — About you
- Full name, institution (text, e.g. "NUST · School of EE & CS")
- *Note: shown in the "So far" recap on Step 2*

### Step 2 — Subjects & confidence
- User adds subjects: course code (CS-301) + name (Algorithms)
- Confidence slider per subject: Shaky (< 35%) / Getting there (35–65%) / Confident (> 65%)
- "Add another subject" button
- "So far" recap card shows name, institution, midterm window, daily hours

### Step 3 — Study rhythm
- Time windows (multi-select toggles): After Fajr (05:30–07:00), Morning, Afternoon, Evening, After Isha (21:00–23:00)
- Daily target hours slider (0.5 – 6 hrs, step 0.5)
- Exam dates section: subject + date + relative countdown ("in 4 days"), "Add exam" button

### Step 4 — Material upload
- Drop/pick area: PDF, Photos, Slides, Voice memos (up to 50 MB each)
- Source shortcuts: Files, Photos, Drive
- "Added so far" list with processing states: Indexed (AI badge) or Processing (spinner)
- Privacy note: *"Files are processed privately on your device for OCR & embeddings. Nothing is uploaded unless you turn on cloud sync."*
- "Skip for now" — user can add material later from Library

### Post-onboarding loader (Stepwise)
Steps shown while system sets up:
1. Saving your subjects
2. Indexing uploaded material
3. Calibrating today's plan
4. Almost there — readying your home screen

Arabic footer: *صَبْر* — "Patience."

---

## 3. Home

Dashboard. Shows today's plan, AI reasoning, recent uploads, quick tutor entry.

### Today's plan card
- Progress indicator: "3 of 5" blocks done
- Serif AI-generated sentence summarising the day ("Two focused blocks before Maghrib.")
- Meter bar (progress %)
- List of study blocks: each has time, duration, subject (colour swatch), topic, done/active/upcoming state
- "Begin next block" CTA + reschedule icon button

### "Why this plan" AI card
- Amber left edge, "AI" pill
- Text: AI reasoning — references exam countdowns and recent quiz scores
- Footer pills: upcoming exam, available hours today
- Timestamp ("Updated 06:12")

### Recently added
- Horizontal scroll of upload tiles: PDF / IMG with colour, title, metadata
- "See all →" links to Library

### Quick tutor
- Amber-edged card with "Ask anything from your uploaded notes."
- Text input + mic icon → opens Tutor screen with the query pre-filled
- Urdu locale: shows Urdu placeholder ("TCP slow start kya hota hai?") when Urdu mode is on

### Daily du'a card
- Gold left bar, Arabic verse (Nastaliq), English translation in italic serif
- Configurable in Profile → Appearance ("Daily du'a card" toggle)

---

## 4. Library

Manages all uploaded study material. Organised by subject. Source of truth for what the AI tutor can reference.

### Header
- Title "Library" + total count + storage used (e.g. "42 documents · 1.2 GB")
- Search icon

### Search & filter
- Search bar: "Search notes, slides, photos…"
- Filter chips: All + one per subject

### Subject groups
- Each subject gets a collapsible section: swatch + name + course code + item count
- Items inside: file type badge (PDF / IMG / SLIDE / NOTE), name, metadata, badges

### File item states
- `AI Indexed` — processed, available to tutor
- Processing (gold spinner) — OCR/embedding in progress
- Reading in progress — user has partially read the document in-app

### File types and colours
| Type | Colour | Description |
|---|---|---|
| PDF | #5A7A6E (muted green) | Papers, textbooks, lecture notes |
| IMG | #8A6B45 (warm brown) | Photos of whiteboards / lecture boards |
| SLIDE | #6B6B85 (grey-purple) | Slide decks |
| NOTE | #A0644F (rust) | Markdown / plain text notes |

### Upload affordance
- Dashed "Add new material" card at bottom
- Accepts: PDF, Photos of notes, Slide decks, Voice memos
- Privacy note: on-device OCR + embeddings, no upload unless cloud sync is on

---

## 5. AI Tutor

Chat interface. The AI answers only from the student's uploaded, indexed library — never from general knowledge.

### Header
- "Tutor" title + "AI" pill + subject context ("Networks · grounded in 3 sources")

### Message types
- **User bubble**: right-aligned, dark surface, rounded
- **AI reply**: left-aligned, gold left border, surface background. Contains:
  - Main response text
  - Structured breakdown (e.g. Slow start vs Congestion avoidance as labelled sections)
  - **Citations**: source name + page/date → tappable → opens that page in Library
  - **Kicker**: follow-up offer ("Want a worked example or a quick 3-question check?")
- **Typing indicator**: 3 gold dots + "Reading 2 sources…"

### Suggested follow-ups
- AI-generated chip row after each reply (e.g. "Walk me through cwnd over 6 RTTs", "Explain in Urdu")
- Selecting a chip sends it as the next user message

### Composer
- Attach icon (add more material inline), text input, mic button, send button
- Placeholder: "Ask about your material…"

### Scope
- Tutor only answers from indexed library files
- Subject context is set from current active study block or most recent library filter
- Urdu responses available ("Explain in Urdu" chip or Urdu locale mode)

---

## 6. Quiz

AI-generated quiz. Accessible from the Tutor ("Quick 3-question check") and from the daily plan (Recall block).

### Structure
- 8 questions, single-answer MCQ (A/B/C/D)
- Progress bar across top (question N of 8)
- Timer displayed ("0:42")

### Question anatomy
- "Generated from [source]" AI pill
- Question text (serif, large)
- Answer options: letter badge + text

### Answer states
- Unselected: neutral
- Selected: dark badge
- After answering: correct = green border + green badge; wrong = red border + red badge; correct option always revealed green

### Feedback card (shown after answering)
- "AI Feedback" pill + "Correct" / "Not quite" label (colour-coded)
- Explanation text referencing the specific wrong/right answers
- Citation: source + page + "See in source" link

### Navigation
- Skip (ghost button) + Next question (primary, disabled until answered)
- Flag icon (header) to report a bad question

---

## 7. Study Plan

Weekly view of AI-generated study schedule.

### Week strip
- 7-day horizontal selector: day abbreviation + date number + dot count (blocks per day)
- Red dot indicator on days with exams
- Today is highlighted
- Note banner when an exam is imminent: "Networks midterm Saturday — 4 days"

### "Why this week" AI card
- Gold left edge, AI pill
- Text explains weighting logic (exam proximity, recent quiz scores, topic stability)
- "Adjust →" button for user to request a reschedule

### Daily timeline
Vertical spine with time column on the left and block cards on the right.

**Block card states:**
| State | Visual |
|---|---|
| Done | Dimmed (55% opacity), text struck through |
| Now | Highlighted surface, dark left border, "Now" badge |
| Upcoming | Transparent, light border |
| Recall (gold) | Gold left border, gold subject swatch |

**Block card fields:** time, duration, subject (swatch), topic title, method ("Tutor + Forouzan Ch. 24")

**AI insight bubble** on the highest-impact block: "Highest-impact block today (+8% predicted on midterm)"

### Block methods
| Method tag | Meaning |
|---|---|
| Recall + N questions | AI-generated quiz |
| Read + summarize | Library document reading session |
| Tutor + [source] | AI tutor session grounded in a specific source |
| Read + take notes | Freeform reading with note-taking |

---

## 8. Progress

Learning analytics dashboard. 14-day rolling view.

### Midterm readiness hero card
- Subject-specific readiness score (0–100)
- Week-on-week delta ("↑ 6 this week")
- Predicted score range ("62 – 74")
- Progress meter (gold)
- AI insight: recommended action to cross the next threshold

### Mastery by topic
- Per-topic progress bars with subject label
- Trend arrows: ↑ up / — flat / ↓ down
- "Weak" badge (red pill) for topics below ~50%

### Quiz history chart
- 14-day bar chart, most recent bar gold, older bars dark at varying opacity
- Date labels: "2 weeks ago" → "today"
- Footer: total quizzes and questions answered

### Stats row (3 cards)
- Study streak (days)
- This week (hrs)
- Avg session (min)

### AI insight card
- Amber edge, serif headline, supporting data
- Example: "You retain best in the morning." + "Your quiz scores from 7–10 AM average 9 points higher than evening blocks."
- AI may act on insight: "I've moved Networks recall to mornings starting Wednesday."

---

## 9. Profile & Settings

### Header
- Avatar (initials), name, email, edit button
- Quick stats: Streak / Studied (hrs) / Readiness — mirrors Progress screen

### Settings sections

**Account**
- Subjects & confidence → re-runs subject/confidence editor from Onboarding Step 2
- Schedule & exams → re-runs time window + exam editor from Onboarding Step 3
- Material → links to Library
- Institution (text)

**AI Tutor**
- Citations toggle (show source links on every reply, default on)
- Tutor scope (Library + lectures / Library only)
- Reasoning depth (Balanced / Deep / Quick)

**Notifications**
- Block reminders (nudge when a study block starts)
- Daily check-in (8 PM nudge if no study recorded)
- Exam countdown (3-day, 1-day, morning-of)

**Appearance**
- Theme: Auto / Light / Dark (segmented control)
- Daily du'a card toggle
- Hijri date toggle (show alongside Gregorian date in headers)

**Language**
- App language (English — only option in v1)
- Urdu content rendering (Nastaliq font for Urdu passages in material)

**Privacy & data**
- On-device processing (always on, read-only)
- Cloud backup toggle (off by default — v1 has no cloud sync, toggle is visible but deferred)
- Export my data
- Privacy policy

**Support**
- Help & feedback
- Rate TaleemMate
- About (version + build number)

**Danger zone**
- Sign out (bottom of screen, ghost button)
- Delete account (text link, rose/red)

---

## 10. Loading States

Two loader variants — use the right one for the context:

| Variant | Use when |
|---|---|
| `FullscreenLoader` (spinner + title + subtitle) | Blocking transient actions: sign-in, payment, sync. No interaction possible. |
| `StepwiseLoader` (checklist steps) | Onboarding setup — user should witness progress. Shows each step completing. |

`FullscreenLoader` already exists as `lib/ui/widgets/design/full_screen_loader/`. `StepwiseLoader` is a first-run onboarding screen, not a reusable widget.

---

## Cross-cutting Concerns

### Islamic cultural layer
- **Hijri date** shown in headers alongside Gregorian (configurable)
- **Prayer-aware scheduling**: study windows include "After Fajr" and "After Isha" time slots
- **Daily du'a card** on Home: Arabic verse (Nastaliq) + English italic translation
- **Arabic patience note** (*صَبْر*) shown during the post-onboarding loader
- **Urdu content**: Nastaliq rendering for Urdu text in material and tutor replies

### Subject colour system
Each subject has a consistent colour swatch used across all screens:

| Subject | CSS class | Approximate colour |
|---|---|---|
| Algorithms | `sw-algo` | Muted green |
| Operating Systems | `sw-os` | Teal |
| Computer Networks | `sw-net` | Blue-grey |
| FYP | `sw-fyp` | Grey-purple |
| Pakistan Studies | `sw-pak` | Warm tan |

Implement as a consistent colour map keyed by subject ID, not hardcoded per screen.

### AI grounding rule
**The tutor never answers from general knowledge.** Every AI response must be grounded in indexed library files. If no relevant source exists, the tutor should say so and prompt the user to upload relevant material. This is a product/UX rule, not just a prompt setting.

### On-device privacy
- OCR and embeddings are processed locally (Drift)
- Nothing leaves the device until the user explicitly enables cloud backup
- Privacy note appears in Library, Onboarding Step 4, and Profile → Privacy

### Bilingual UX
- Interface language: English (v1)
- Content language: English + Urdu (Nastaliq), toggled via Urdu locale switch
- Urdu renders right-to-left within cards; interface chrome stays LTR
