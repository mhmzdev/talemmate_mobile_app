---
name: research-codebase
description: Document how the TaleemMate codebase works today by spawning parallel sub-agents and synthesising findings into docs/research/. Pure documentation — no suggestions, no critiques, no root cause analysis.
argument-hint: "<question or topic to research>"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
model: opus
---

# /research-codebase

You are conducting comprehensive research across the TaleemMate Flutter codebase to answer the user's question. You spawn parallel sub-agents, synthesise their findings, and write a committed research artifact to `docs/research/`.

## Invocation modes

This skill serves two purposes depending on who invokes it and why.

**Mode A — Feature research (human-initiated)**
The user typed `/research-codebase "question"` as the primary request for a session or feature cycle.
After writing the artifact: present findings to the user and wait.
The human reviews, then decides the next step (typically `/create-plan`).
The human review gate is intentional — it is a planning checkpoint.

**Mode B — Agent exploration (agent-initiated, mid-task)**
You invoked this skill because you hit a trigger condition from the Research Protocol in CLAUDE.md.
You are mid-task — debugging, tracing a flow, understanding code before making a change.
After writing the artifact: read it yourself, extract what you need, and continue your current task.
Do not surface a review request. Do not pause for sign-off. The artifact is your context, not a deliverable.

**How to tell which mode you're in:**
- The user's message IS the skill invocation → Mode A.
- You are mid-task and invoked the skill to resolve a knowledge gap → Mode B.

**Research is always on demand.** Even if an artifact for this topic already exists, always run fresh research from the code. Artifacts are persisted outputs — they get overwritten, never reused as answers.

---

## CRITICAL: YOUR ONLY JOB IS TO DOCUMENT THE CODEBASE AS IT EXISTS TODAY
- DO NOT suggest improvements or changes
- DO NOT perform root cause analysis
- DO NOT propose future enhancements
- DO NOT critique the implementation or identify problems
- DO NOT recommend refactoring or architectural changes
- ONLY describe what exists, where it exists, how it works, and how components interact

---

## Initial Setup

When invoked with no argument, respond with:

```
I'm ready to research the codebase. Please provide your research question or area of interest and I'll map it thoroughly by exploring relevant components and connections.
```

Then wait for the user's query.

If a question was passed as an argument (e.g. `/research-codebase "how does the AI chat flow work?"`), skip the prompt and begin immediately.

---

## Steps

### Step 1 — Read any directly mentioned files first

If the user references specific files, docs, or features, read them **fully** (no `limit`/`offset`) before spawning sub-agents. This gives you the context to decompose the research correctly.

### Step 2 — Analyse and decompose the research question

Break the question into composable research areas. Think about:
- Which domains are touched (auth, onboarding, AI chat/tutor, subjects, quizzes, progress, profile, settings)?
- Which layers: UI (`_state.dart` / screen widgets), Cubits (`lib/blocs/<name>/`), Repos (`lib/repos/<name>/`), Services, Models (`freezed`/`json_serializable`)?
- Which cross-cutting concerns: routing (`AppRoutes`/`FadeRoute`), Firebase services, design tokens (`App.init`), forms (`flutter_form_builder`)?

Create a mental research plan. Identify which directories and patterns are most relevant.

### Step 3 — Spawn parallel sub-agents

Use the `Agent` tool to run all independent searches concurrently in a **single message with multiple tool blocks**.

**Available specialist agents** (pass `subagent_type` in the Agent call):

| Agent | Use when |
|---|---|
| `codebase-locator` | Finding WHERE files and components live |
| `codebase-analyzer` | Understanding HOW specific code works — data flow, BlocState transitions, widget trees, Firebase interactions |
| `codebase-pattern-finder` | Finding existing pattern examples with concrete code snippets |

**Writing each sub-agent prompt:**
- Tell the agent exactly what to find or explain
- Give the specific directories or files to focus on (e.g. `lib/blocs/`, `lib/ui/`, `lib/repos/`)
- Remind agents they are documentarians — describe what exists, not what's wrong
- Request `file:line` references in their responses

### Step 4 — Wait for all sub-agents to complete

**IMPORTANT**: Do not synthesise until ALL sub-agent tasks finish.

### Step 5 — Gather metadata

Run these commands to populate the research document frontmatter:

```bash
git log -1 --format="%H"    # current commit hash
git branch --show-current    # current branch
```

Today's date is available as the `currentDate` context variable.

### Step 6 — Write the research document

Research docs are overwritten, not duplicated. Always write fresh findings — never copy from a previous artifact.

```bash
ls docs/research/ 2>/dev/null | grep -v "^INDEX" | grep "<slug>"
```

- If `docs/research/` does not exist → create it with `mkdir -p docs/research/` before writing.
- If a file with a matching slug exists → **overwrite it** (same filename, update frontmatter `date`, `git_commit`, `branch`, `last_updated`). Update the existing INDEX.md row's date — do not add a duplicate row.
- If no match → create a new dated file and add a new INDEX.md row (Step 7 below).

**Filename**: `docs/research/YYYY-MM-DD-<kebab-slug>.md`

Use this template:

```markdown
---
date: YYYY-MM-DDTHH:MM:SS+05:00
researcher: Claude (claude-sonnet-4-6 / claude-opus-4-7)
git_commit: <hash>
branch: <branch>
repository: taleemmate
topic: "<user's question>"
tags: [research, codebase, <relevant-component-tags>]
status: complete
last_updated: YYYY-MM-DD
---

# Research: <Topic>

**Date**: YYYY-MM-DD
**Git Commit**: `<hash>`
**Branch**: `<branch>`

## Research Question
<original user query verbatim>

## Summary
<2-4 sentence answer to the question — what exists and how it works>

## Detailed Findings

### <Component or Area 1>
- Description of what exists (`lib/path/to/file.dart:line`)
- How it connects to other components
- Current implementation details

### <Component or Area 2>
...

## Code References
- `lib/path/to/file.dart:123` — description of what's there

## Architecture Documentation
<Patterns, conventions, and design implementations found — layer boundaries, BlocState transitions, Firebase interactions, etc.>

## Related Docs
<Links to exec-plans, feature docs, or other research that covers adjacent ground>

## Open Questions
<Any areas that need further investigation>
```

### Step 7 — Update `docs/research/INDEX.md`

If `docs/research/INDEX.md` does not exist, create it with this header before adding the row:

```markdown
# Research Index

| Document | Description | Date |
|---|---|---|
```

Add a row to the Contents table:

```markdown
| [YYYY-MM-DD — Topic](YYYY-MM-DD-<slug>.md) | <one-line description> | YYYY-MM-DD |
```

### Step 8 — Present findings

**Mode A (human-initiated):** give the user a concise summary:
- What you found (key facts, file references)
- Path to the committed research document
- Ask if they have follow-up questions

**Mode B (agent-initiated, mid-task):**
- One line: "Research complete: `docs/research/<filename>.md`"
- Then immediately continue your current task using the artifact as context
- Do not present a findings summary or ask for follow-up — you are the next step

### Step 9 — Handle follow-up questions

If the user follows up, **append** to the same research document rather than creating a new one:
- Add a `## Follow-up: <timestamp>` section at the end
- Update `last_updated` in the frontmatter
- Spawn new sub-agents as needed
- Re-present the summary

---

## Important Notes

- **Always research from code** — existing artifacts are stale by definition; they are outputs to overwrite, not inputs to reuse
- **Parallel > sequential** — spawn sub-agents concurrently to minimise time and context usage
- **Concrete references** — every claim should link to a `file.dart:line`
- **No placeholder frontmatter** — run the git commands before writing the document; never write `<hash>` literally
- **Follow steps in order** — read files first, spawn agents, wait for all, then write
- **You are a documentarian, not a critic** — document what IS, not what SHOULD BE

---

## Research Lifecycle

Research lives in a **single flat folder**: `docs/research/`. There is no backlog / active / completed distinction — a research document either exists (current snapshot of how something works) or it doesn't.

| Action | When | How |
|---|---|---|
| **Create** | First time researching a topic | Write `docs/research/YYYY-MM-DD-<slug>.md`, add row to `INDEX.md` |
| **Overwrite** | Same topic researched again (any reason) | Same filename, fresh content from code, update frontmatter `date` + `git_commit` + `branch` + `last_updated`, update the date column in the existing `INDEX.md` row (do NOT add a new row) |
| **Append** | Mode A follow-up question on the same research | Add `## Follow-up: YYYY-MM-DD` section at the end, bump `last_updated` |
| **Archive** | Never | Research is a living snapshot. If a doc is obsolete it gets overwritten or deleted, not moved. |

This is **deliberately simpler than the plan lifecycle** in `/create-plan`. Plans have explicit states because the same plan exists across multiple sessions and needs status tracking. Research is just "what does this code do right now" — there is only ever one current answer per topic.

`INDEX.md` is the table-of-contents. One row per slug. Sort by date descending.
