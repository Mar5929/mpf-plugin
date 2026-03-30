---
name: mpf:status
description: Display the current project status dashboard. Reads docs/PROJECT_STATUS.md, roadmap, Linear ticket counts, git branch status, and sync health. Run any time to check project state.
allowed-tools: Read, Grep, Glob, Bash, mcp__claude_ai_Linear__*
---

# mpf:status

Display a formatted project status dashboard by reading the current project state.

## Steps

1. **Read project status.** Read `docs/PROJECT_STATUS.md` to get the current phase, active work items, blockers, and session history.

2. **Read roadmap.** Read `docs/roadmap.md` to get the full phase plan with completion status.

3. **Check Linear configuration.** Read `CLAUDE.md` and check whether the project uses external tracking with Linear. Note the result for conditional sections below.

4. **Display formatted summary.** Present the following sections:

### Current Phase
Show the active phase name and a text-based progress bar. Example:
```
Phase 2: Authentication  [=========>          ] 45%
```

### Phase Summary Table
Show all phases from the roadmap with progress indicators:
```
| Phase | Name              | Status      | Progress            |
|-------|-------------------|-------------|---------------------|
| 1     | Project Setup     | Complete    | [====================] 100% |
| 2     | Authentication    | In Progress | [=========>          ] 45%  |
| 3     | Core Features     | Not Started | [                    ] 0%   |
```

### Linear Ticket Status (conditional: only if Linear is configured)

If Linear is configured:

1. Read `docs/traceability-matrix.md` to get all ticket IDs (RIH-XXX) mapped to phases.
2. Query `mcp__claude_ai_Linear__*` for team Rihm to get current ticket states.
3. Display a per-phase ticket breakdown:

```
| Phase | Name              | Tickets | Backlog | In Progress | Done | Cancelled |
|-------|-------------------|---------|---------|-------------|------|-----------|
| 1     | Project Setup     | 6       | 0       | 0           | 6    | 0         |
| 2     | Authentication    | 8       | 3       | 2           | 3    | 0         |
| 3     | Core Features     | 5       | 5       | 0           | 0    | 0         |
| Total |                   | 19      | 8       | 2           | 9    | 0         |
```

If `mcp__claude_ai_Linear__*` tools are unavailable or the query fails, display: "Linear status unavailable. Run `mpf:sync-linear` for detailed tracking."

If Linear is not configured, skip this section entirely.

### Git Status

Run `git branch --show-current` and `git status --porcelain` to show the current branch and working tree state:

```
Branch: feature/phase-02-auth  |  Clean (no uncommitted changes)
```

Or if the working tree has changes:
```
Branch: feature/phase-02-auth  |  3 modified, 1 untracked
```

### Sync Health (conditional: only if sync report exists)

Check for `docs/sync-report.md`. If it exists:
- Read the Summary section to extract the last sync date and discrepancy count.
- Display a one-line indicator:

```
Last sync: 2026-03-24  |  2 discrepancies found (run `mpf:sync-linear` to review)
```

Or if the last sync was clean:
```
Last sync: 2026-03-24  |  Clean (no discrepancies)
```

If no sync report exists, display: "No sync report found. Run `mpf:sync-linear` to check Linear alignment."

### Active Tasks
Show the count of active tasks and list them briefly (from PROJECT_STATUS.md Section 4).

### Blockers
If any blockers exist (from PROJECT_STATUS.md Section 5), list them with their description and age. If none, display "No active blockers."

### Last Session Summary
Show the most recent entry from the Session Log (date, summary, docs updated).

### Suggested Next Action
Based on the current state, suggest what the user should do next. Examples:
- "Run `mpf:plan-tasks 2` to plan the next phase"
- "Run `mpf:execute 2` to begin implementation"
- "Run `mpf:verify 2` to validate completed work"
- "Phase 2 is complete. Run `mpf:plan-tasks 3` to continue"
- "Sync discrepancies detected. Run `mpf:sync-linear` to resolve."

## Error Handling

- If `docs/PROJECT_STATUS.md` does not exist, inform the user: "No PROJECT_STATUS.md found. Run `mpf:init` to set up the project first."
- If `docs/roadmap.md` does not exist, skip the phase summary table and note that no roadmap has been created yet.
- If `mcp__claude_ai_Linear__*` query fails, skip the Linear Ticket Status section gracefully and note it in Suggested Next Action.
- If `git` is not available, skip the Git Status section.
