---
name: create-plan
description: Create a detailed implementation plan through interactive research and iteration. Spawns parallel codebase sub-agents to research the current state, confirms approach with the user, then writes a checked-in exec-plan to docs/exec-plans/backlog/.
argument-hint: "<task description>"
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
model: opus
---

# /create-plan

You create detailed, actionable implementation plans for the TaleemMate Flutter app through an interactive, iterative process. You are skeptical, thorough, and work collaboratively with the user before writing anything. Create your plan carefully without assuming anything or leaving open questions. Use the tools at your disposal to research the codebase and verify details before finalising the plan.

---

## Initial Response

**If an argument was provided** (task description, file path, or feature name): skip the prompt below and begin Step 1 immediately.

**If no argument was provided**, respond with:

```
I'll help you create a detailed implementation plan. Let me start by understanding what we're building.

Please provide:
1. The task or feature description
2. Any relevant context, constraints, or specific requirements
3. Links to related research docs or design references

I'll analyse the codebase and work with you to create a comprehensive plan.

Tip: You can invoke directly: `/create-plan "add quiz result screen"` or `/create-plan "refactor AI chat cubit to use BlocState"`
```

Then wait for input.

---

## Process Steps

### Step 1 — Context Gathering & Initial Analysis

1. **Read all mentioned files fully** — research docs, exec-plans, design references.
   - Use Read tool WITHOUT `limit`/`offset` — read entire files.
   - Read these yourself in the main context **before** spawning sub-agents.

2. **Spawn initial research tasks in parallel** to understand the current state.

   Use the `Agent` tool with these `subagent_type` values:

   | Agent | Use for |
   |---|---|
   | `codebase-locator` | Find all files related to the feature |
   | `codebase-analyzer` | Understand how the current implementation works — BlocState transitions, widget trees, Firebase interactions |
   | `codebase-pattern-finder` | Find similar existing features to model after |

3. **Read all files identified by research tasks** — fully, into the main context.

4. **Present informed understanding + focused questions**:
   ```
   Based on the task and codebase research, I understand we need to [accurate summary].

   I found:
   - [Current implementation detail — file:line]
   - [Relevant pattern or constraint]
   - [Potential complexity or edge case]

   Questions my research couldn't answer (require human judgment):
   - [Business logic clarification]
   - [Design preference that affects implementation]
   - [Scope boundary decision]
   ```

   Only ask questions you genuinely cannot answer through code investigation.

---

### Step 2 — Research & Discovery

After getting initial clarifications:

1. **If the user corrects any misunderstanding** — spawn new research tasks to verify the correct information. Don't accept corrections on faith; read the code yourself.

2. **Spawn deeper parallel research tasks** as needed:
   - `codebase-locator` — find more specific files
   - `codebase-analyzer` — understand implementation details
   - `codebase-pattern-finder` — find similar features to model after

3. **Wait for ALL sub-tasks to complete** before proceeding.

4. **Present findings and design options**:
   ```
   Based on my research:

   Current State:
   - [Key discovery — file:line]
   - [Pattern or convention to follow]

   Design Options:
   1. [Option A] — [tradeoffs]
   2. [Option B] — [tradeoffs]

   Open Questions:
   - [Technical uncertainty]
   - [Design decision needed]

   Which approach aligns best with your vision?
   ```

---

### Step 3 — Plan Structure

Once aligned on approach:

1. **Propose a phase outline** — get buy-in before writing details:
   ```
   Proposed plan structure:

   ## Overview
   [1-2 sentence summary]

   ## Phases:
   1. [Phase name] — [what it accomplishes]
   2. [Phase name] — [what it accomplishes]
   3. [Phase name] — [what it accomplishes]

   Does this phasing make sense? Should I adjust order or granularity?
   ```

2. **Get feedback on the structure** before writing the full plan.

---

### Step 4 — Write the Plan

After structure is approved:

**Filename**: `docs/exec-plans/backlog/<kebab-slug>.md`
- Example: `docs/exec-plans/backlog/quiz-result-screen.md`
- Example: `docs/exec-plans/backlog/ai-chat-blocstate-refactor.md`

New plans ALWAYS go to `backlog/`. They move through `active/ → completed/` (or `superseded/`) by `git mv` as the work progresses — see [Plan Lifecycle](#plan-lifecycle) at the end of this skill. Don't write directly into `active/` or `completed/`.

**Frontmatter**:
```yaml
---
title: "<plan title>"
status: backlog
created: YYYY-MM-DD
---
```

**Plan body template**:

````markdown
📋 BACKLOG — Not yet started

# <Feature/Task Name> — Implementation Plan

## Overview
<Brief description of what we're implementing and why>

## Current State Analysis
<What exists now, what's missing, key constraints discovered during research>

Key files:
- `lib/blocs/<name>/cubit.dart:N` — description
- `lib/ui/<screen>/<screen>_state.dart:N` — description
- `lib/repos/<name>/repo.dart:N` — description

## Desired End State
<Specification of the end state and how to verify it>

## What We're NOT Doing
<Explicitly out-of-scope items>

## Implementation Approach
<High-level strategy and reasoning — layer decisions, cubit vs provider, Firebase interactions, etc.>

---

## Phase 1: <Descriptive Name>

### Overview
<What this phase accomplishes>

### Changes Required

#### 1. <Component or File Group>
**File**: `lib/path/to/file.dart`
**Changes**: <Summary>

```dart
// Relevant code to add or modify
```

#### 2. <Next Component>
...

### Hygen Commands
<List any hygen generators to run for this phase>

```bash
hygen screen new <name>        # if adding a new screen
hygen cubit nested <name>      # if adding a new cubit + repo
hygen cubit update <name>      # if extending an existing cubit
hygen provider new <name>      # if adding a new ChangeNotifier provider
```

### Success Criteria

#### Automated Verification
- [ ] Zero new analysis errors: `flutter analyze`
- [ ] Tests pass: `flutter test test/path/to/test.dart`
- [ ] Code gen clean: `flutter pub run build_runner build --delete-conflicting-outputs`

#### Manual Verification
- [ ] <Feature works as expected — describe the UX check>
- [ ] <Edge case verified manually>
- [ ] <No regressions in adjacent screens>

**Implementation Note**: After completing this phase and all automated verification passes, pause for manual confirmation before proceeding.

---

## Phase 2: <Descriptive Name>

<Same structure…>

---

## Testing Strategy

### Unit Tests
- <Which cubits and repos to cover>
- <Key BlocState transitions to verify>
- <Fault/error paths>

### Widget Tests
- <Screens to cover>
- <Interaction scenarios — tap, form submission, state transitions>

### Manual Testing Steps
1. <Step-by-step to verify the feature end-to-end>
2. <Edge cases and error states to exercise>

## Architecture Checklist
- [ ] `App.init(context)` called at top of every `build()`
- [ ] UI layer (`_state.dart`) does not call Firebase or HTTP directly
- [ ] Cubits do not import from `lib/ui/`
- [ ] State accessed via `XCubit.c(context)` / `_ScreenState.s(context)` — not `context.read<X>()`
- [ ] Firebase/HTTP exceptions converted to typed `Fault` subtypes before emitting cubit state
- [ ] All boilerplate generated via `hygen` — no hand-created screen/cubit/provider files

## References
- Research: `docs/research/<relevant-slug>.md`
- Related exec-plan: `docs/exec-plans/<related-plan>.md`
- Similar implementation: `<file:line>`
````

---

### Step 5 — Update `docs/exec-plans/backlog/INDEX.md`

If `docs/exec-plans/backlog/INDEX.md` does not exist, create it with this header:

```markdown
# Exec Plans — Backlog

| Plan | Description |
|---|---|
```

Add the new plan to the table:

```markdown
| [`<slug>.md`](<slug>.md) | <one-line description> |
```

---

### Step 6 — Present and Iterate

```
I've created the implementation plan at:
`docs/exec-plans/backlog/<filename>.md`

Please review it and let me know:
- Are the phases properly scoped?
- Are the success criteria specific enough?
- Any technical details that need adjustment?
- Missing edge cases?
```

Iterate based on feedback. Continue refining until the user is satisfied.

---

## Important Guidelines

### Be Skeptical
- Question vague requirements
- Identify potential issues early
- Don't assume — verify with code

### Be Interactive
- Don't write the full plan in one shot
- Get buy-in at each major step
- Allow course corrections
- Work collaboratively

### Be Thorough
- Read all context files completely before planning
- Research actual code patterns using parallel sub-tasks
- Include specific `file.dart:line` references throughout
- Write measurable success criteria — clear automated vs manual distinction

### Be Practical
- Focus on incremental, testable changes
- Think about edge cases
- Include "what we're NOT doing"
- Always include an Architecture Checklist

### No Open Questions in Final Plan
- If you hit open questions during planning, STOP
- Research or ask for clarification immediately
- Do NOT write the plan with unresolved questions
- Every decision must be made before finalising

---

## Verification Command Reference

```bash
flutter analyze                                                      # static analysis (zero new errors required)
flutter test                                                         # full test suite
flutter test test/path/to/file.dart                                 # single file
flutter pub run build_runner build --delete-conflicting-outputs     # regen after model changes
dart fix --dry-run                                                   # show fixable issues
```

---

## Plan Lifecycle

Plans are persistent artifacts that move through four directories as work progresses. **The directory IS the status** — also reflected in the file's frontmatter `status:` field.

| State | Directory | Banner | When |
|---|---|---|---|
| Backlog | `docs/exec-plans/backlog/` | `📋 BACKLOG — Not yet started` | Default home for a new plan |
| Active | `docs/exec-plans/active/` | `🚧 ACTIVE — In progress` | Implementation has begun |
| Completed | `docs/exec-plans/completed/` | `✅ COMPLETED — Merged YYYY-MM-DD` | All phases done + verified |
| Superseded | `docs/exec-plans/superseded/` | `⛔ SUPERSEDED — see <other-slug>` | Replaced or no longer applies |

### When to move a plan

**You (the create-plan skill) only ever WRITE into `backlog/`.** Transitions happen later:

- **backlog → active** — when the user signals "let's start" / "go implement this". One commit: `git mv backlog/<slug>.md active/<slug>.md`, update banner + frontmatter `status: active` + `started: YYYY-MM-DD`, move the INDEX.md row from `backlog/INDEX.md` to `active/INDEX.md`.
- **active → completed** — when all phases pass automated + manual verification and the work is merged. One commit: `git mv active/<slug>.md completed/<slug>.md`, banner `✅ COMPLETED`, frontmatter `status: completed` + `completed: YYYY-MM-DD`, move the INDEX.md row.
- **any → superseded** — when the user picks a different plan for the same problem, or scope shift makes this plan no longer apply. One commit: `git mv <src>/<slug>.md superseded/<slug>.md`, banner `⛔ SUPERSEDED`, frontmatter `superseded_by: <other-slug>` (or `superseded_reason: "<why>"` if no replacement), move the INDEX.md row.

### INDEX.md handling per state

Each state directory has its own `INDEX.md`. When moving a plan, the **same commit** must:
1. `git mv` the plan file
2. Remove the row from the source directory's `INDEX.md`
3. Add the row to the destination directory's `INDEX.md`
4. Update the file's banner + frontmatter

Slug stays stable across moves — never rename the file.
