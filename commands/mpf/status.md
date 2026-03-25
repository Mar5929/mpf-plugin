---
name: mpf:status
description: >
  Display the current project status dashboard. Reads docs/PROJECT_STATUS.md
  and shows current phase, progress bars, active tasks, blockers, and session log.
  Run any time to check project state.
allowed-tools: Read, Grep, Glob
---

# mpf:status

Display a formatted project status dashboard by reading the current project state.

## Steps

1. **Read project status.** Read `docs/PROJECT_STATUS.md` to get the current phase, active work items, blockers, and session history.

2. **Read roadmap.** Read `docs/roadmap.md` to get the full phase plan with completion status.

3. **Display formatted summary.** Present the following sections:

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

### Active Tasks
Show the count of active tasks and list them briefly (from PROJECT_STATUS.md Section 3).

### Blockers
If any blockers exist (from PROJECT_STATUS.md Section 4), list them with their description and age. If none, display "No active blockers."

### Last Session Summary
Show the most recent entry from the Session Log (date, summary, docs updated).

### Suggested Next Action
Based on the current state, suggest what the user should do next. Examples:
- "Run `mpf:plan-tasks 2` to plan the next phase"
- "Run `mpf:execute 2` to begin implementation"
- "Run `mpf:verify 2` to validate completed work"
- "Phase 2 is complete. Run `mpf:plan-tasks 3` to continue"

## Error Handling

- If `docs/PROJECT_STATUS.md` does not exist, inform the user: "No PROJECT_STATUS.md found. Run `mpf:init` to set up the project first."
- If `docs/roadmap.md` does not exist, skip the phase summary table and note that no roadmap has been created yet.
