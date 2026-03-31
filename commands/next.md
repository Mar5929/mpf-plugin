---
name: mpf:next
description: Auto-detect the current project state and route to the next logical MPF workflow step. Checks scaffolding, PRD, phases, tasks, execution, and verification status to recommend the next command. Run at any time to advance the workflow.
allowed-tools: Read, Glob, Bash, Grep, mcp__claude_ai_Linear__*
---

# mpf:next

Detect the current project state and recommend (or auto-run) the next MPF command.

## Steps

### Step 1: Read Project State

Check these files in order, stopping at the first gap:

1. `CLAUDE.md` at the project root
2. `docs/PROJECT_ROADMAP.md`
3. `docs/requirements/PRD.md`
4. `docs/PROJECT_ROADMAP.md` Section 3 (Phase Roadmap) for defined phases
5. Phase directories under `docs/requirements/phases/`

### Step 2: Determine Next Action

Walk through this decision tree:

**No `CLAUDE.md`?**
> "No project scaffolding found. Run `mpf:init` to set up the project."

**`CLAUDE.md` exists but no `docs/requirements/PRD.md` (or PRD is a placeholder)?**
Check if the PRD contains `<!-- MPF placeholder` or has fewer than 20 lines of content.
> "Project scaffolded but no PRD. Run `mpf:discover` to create the product requirements."

**PRD exists but no phases defined?**
Check `docs/PROJECT_ROADMAP.md` Section 3 for phase entries. If empty or all phases are "TBD":
> "PRD complete but no phases planned. Run `mpf:plan-phases` to break requirements into implementation phases."

**Phases exist: find the current active phase.**
Read `docs/PROJECT_ROADMAP.md` Section 2 to identify the current phase number. If not clear, find the first phase with status "Not Started" or "In Progress".

**Current phase has no task files?**
Check `docs/requirements/phases/phase-{NN}-{name}/tasks/` for task-*.md files.
> "Phase {N} ({name}) has no tasks. Run `mpf:plan-tasks {N}` to create executable tasks."

**Tasks exist but not all executed?**
Check each task file for Done checkboxes. If any tasks have unchecked Done criteria:
> "Phase {N} has {M} tasks remaining. Run `mpf:execute {N}` to implement."

**All tasks done but no verification report?**
Check for `docs/requirements/phases/phase-{NN}-{name}/verify-report.md`.
> "Phase {N} tasks complete. Run `mpf:verify {N}` to validate before merging."

**Verification report exists and passed?**
Check if verify-report.md contains "PASS" or all criteria are met.

If there are more phases after the current one:
> "Phase {N} verified. Next up: Phase {N+1} ({next-name}). Run `mpf:plan-tasks {N+1}` to continue."

If this was the last phase:
> "All phases complete and verified. Project implementation is done."

**Verification failed?**
> "Phase {N} verification failed. Run `mpf:execute {N}` to fix failed tasks, then re-verify."

### Step 3: Present Recommendation

Show the recommendation with:
1. Current state summary (one line)
2. Recommended next command (with the exact command to copy)
3. Brief explanation of what it does

Example:
```
Current: Phase 2 (User Auth) - 5/8 tasks complete
Next: mpf:execute 2
This will resume execution of the 3 remaining tasks in Phase 2.
```

Ask: "Run this now, or would you like to do something else?"
