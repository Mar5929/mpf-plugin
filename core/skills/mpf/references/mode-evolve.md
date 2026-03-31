# Evolve Mode

Read the existing CLAUDE.md and PROJECT_ROADMAP.md (if present) to understand current state, then present the evolve menu:

> "I see this project already has scaffolding. Here's what I found:
>
> **Current tier:** [Light/Standard/Full, or "Unknown" if no PROJECT_ROADMAP.md]
> **Existing docs:** [list of docs/ files found]
> **Existing rules:** [list of .claude/rules/ files found]
> **Missing from [current/next] tier:** [list of docs and rules that could be added]
>
> What would you like to do?
> 1. **Upgrade tier**: move from [current] to [target] (adds [N] docs, expands CLAUDE.md)
> 2. **Add specific document(s)**: add individual docs without changing tier
> 3. **Change tracking approach**: switch between in-repo backlog and external tracker
> 4. **Refresh dashboard**: update PROJECT_ROADMAP.md with current project state
> 5. **Full re-interview**: start over as if this were a new project (preserves existing files, generates only what's missing or changed)"

## Upgrade Tier

When upgrading tiers:
1. Diff current docs against target tier's doc list. Explicit diffs by upgrade path:
   - **Light to Standard adds:** `docs/technical-specs/code-atlas.md`, `docs/CHANGELOG.md`, `docs/decisions.md`, `docs/technical-specs/TECHNICAL_SPEC.md`, `.claude/rules/document-updates.md`, `.claude/rules/session-protocol.md`, `.claude/rules/coding-standards.md`. CLAUDE.md sections added: 4 (Update Protocol), 8 (Tracking), 9 (Git Protocol), 10 (Clarification Protocol). PROJECT_ROADMAP.md expanded to full 8-section format.
   - **Light to Full adds:** Everything in Light-to-Standard, plus: `docs/technical-specs/DATA_MODEL.md`, `GETTING_STARTED.md`, tracker-specific docs (`docs/traceability-matrix.md` or `docs/requirements/requirements.md` + `docs/BACKLOG.md`), `.claude/rules/traceability.md`. CLAUDE.md sections added: 4, 6 (Tech Stack), 8, 9, 10, 11 (Context Window), 13 (References).
   - **Standard to Full adds:** `docs/technical-specs/DATA_MODEL.md`, `GETTING_STARTED.md`, tracker-specific docs, `.claude/rules/traceability.md`. CLAUDE.md sections added: 6 (Tech Stack), 11 (Context Window), 13 (References).
2. Show exactly which files will be created and which CLAUDE.md sections will be added
3. Run a **focused mini-interview** covering only the rounds relevant to the new tier that weren't covered by the current tier (e.g., Light to Standard means asking R2, R3, and R4 only). For interview round details, read `references/mode-init.md` Phase 2.
4. Present a creation summary (same as Phase 3 in mode-init.md) showing only the new/modified files
5. Wait for approval before creating anything
6. After creation, update PROJECT_ROADMAP.md tier metadata and session log

## Add Specific Document

1. Ask which document(s) the user wants to add
2. If the document requires interview context not yet gathered (e.g., adding docs/traceability-matrix.md requires knowing the tracker tool), ask those specific questions
3. Generate the document using the relevant template file from `references/` (templates-core.md, templates-requirements.md, templates-technical.md, templates-tracking.md, or templates-phases.md)
4. Update CLAUDE.md Section 3 (Workspace Structure) and Section 4 (Update Protocol) to include the new doc
5. Update or create the relevant `.claude/rules/` file
6. Update PROJECT_ROADMAP.md responsibility matrix (Section 4) with the new doc's ownership row

## Change Tracking Approach

This is a significant change. Walk through it carefully:
1. Confirm the user wants to switch (e.g., from in-repo backlog to external tracker)
2. Ask the necessary questions for the new approach (which tracker, team/project details)
3. Explain what will change: which docs are replaced, how commit messages change, what happens to existing backlog items
4. If `archive/` does not exist, create it before moving files.
5. Generate the new tracking docs (e.g., docs/traceability-matrix.md) and archive the old ones (move to `archive/`)
6. Update CLAUDE.md sections 4, 8, and 9 to reflect the new approach
7. Update relevant `.claude/rules/` files
8. Update PROJECT_ROADMAP.md
9. **Validate the switch:** After switching tracking approach, validate that no artifacts from the previous tracking approach remain active. Check that only one set of tracking files exists (either `docs/BACKLOG.md` + `docs/requirements/requirements.md` for in-repo, OR `docs/traceability-matrix.md` for external). Flag any gaps where requirements were not migrated to the new system.

## Refresh Dashboard

1. Read all existing docs and the current codebase state
2. If external tracker is configured, query it for current ticket status
3. Rebuild PROJECT_ROADMAP.md sections 1, 2, 5 from current state
4. Preserve sections 4, 7, 8 (responsibility matrix, session log, phase history)

## Full Re-Interview

1. Read `references/mode-init.md` and run the complete interview from Phase 1
2. Compare answers against existing scaffolding
3. Generate only files that are missing or whose content would change
4. Present a diff summary showing what will be added/modified
5. Wait for approval before making changes
