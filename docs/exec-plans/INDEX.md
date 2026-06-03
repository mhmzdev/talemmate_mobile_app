# Execution Plans

Multi-phase implementation plans live here. Each plan moves through four states by being `git mv`'d between subdirectories — the directory IS the status.

| State | Directory | Meaning |
|---|---|---|
| 📋 Backlog | [`backlog/`](backlog/INDEX.md) | New plan, not yet started |
| 🚧 Active | [`active/`](active/INDEX.md) | Implementation in progress |
| ✅ Completed | [`completed/`](completed/INDEX.md) | Merged + verified |
| ⛔ Superseded | [`superseded/`](superseded/INDEX.md) | Replaced by another plan or no longer applies |

## Workflow

1. **Create** — `/create-plan <description>` writes a plan into `backlog/` and adds a row to `backlog/INDEX.md`.
2. **Activate** — when work starts: `git mv backlog/<slug>.md active/<slug>.md`, update the file's banner to `🚧 ACTIVE`, update its frontmatter `status: active`, and move the INDEX.md row.
3. **Complete** — after merge + manual verification: `git mv active/<slug>.md completed/<slug>.md`, banner `✅ COMPLETED`, frontmatter `status: completed` + `completed: YYYY-MM-DD`, move the INDEX.md row.
4. **Supersede** — if a different plan is chosen for the same problem: `git mv <state>/<slug>.md superseded/<slug>.md`, banner `⛔ SUPERSEDED`, frontmatter `superseded_by: <other-slug>` (or `superseded_reason:` if no replacement), move the INDEX.md row.

Every move is a single commit: the `git mv` + both `INDEX.md` edits + the in-file banner/frontmatter update.

Naming: `<kebab-slug>.md`. Slug stays stable across moves.
