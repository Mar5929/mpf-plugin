---
name: mpf:plan-tasks
description: >
  Break a phase into granular executable tasks. Spawns mpf-planner to create task files,
  then mpf-checker to verify coverage. Usage: mpf:plan-tasks <phase_number>
  Run after mpf:plan-phases, before mpf:execute.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent
---

# mpf:plan-tasks

Orchestrate task planning for a single phase by spawning the planner and checker agents.

## Usage

```
mpf:plan-tasks <phase_number>
```

Example: `mpf:plan-tasks 1`

## Prerequisites

1. Read `docs/roadmap.md` to confirm the requested phase exists.
2. Read `docs/requirements/phases/phase-{NN}-{name}/overview.md` to confirm the phase has requirements and success criteria defined.
3. If neither exists, tell the user: "Phase {N} not found. Run `mpf:plan-phases` first."

## Steps

### Step 1: Resolve Phase Info

From `docs/roadmap.md`, extract:
- Phase number and name (for directory naming)
- Phase status (should be "Not Started" or "Planned")

If the phase already has task files in its `tasks/` directory, ask the user: "Phase {N} already has {count} task files. Replace them or keep the existing plan?"

### Step 2: Linear Ticket Creation (if configured)

Check CLAUDE.md for Linear configuration. If Linear is enabled:

1. Read the phase overview for requirements covered
2. For each requirement, create a Linear ticket (or check if one already exists)
3. Use team Rihm (`dfe15bc4-6dd0-4bde-8609-6620efc3140d`) and assignee Michael Rihm (`8d75f0a6-f848-41af-9f4b-d06036d6af82`)
4. Record ticket IDs for the planner to reference in task files
5. Update `docs/traceability-matrix.md` with the new ticket mappings

### Step 3: Spawn mpf-planner

Launch the mpf-planner agent with:

```
Agent(
  subagent_type: "mpf-planner",
  prompt: "Plan tasks for phase {N} ({name}). Project root: {project_root}. Phase number: {N}. Phase name: {name}. Linear ticket mapping: {ticket_id_map or 'N/A'}."
)
```

Wait for the planner to complete and review its output summary.

### Step 4: Spawn mpf-checker

After the planner finishes, launch the mpf-checker agent:

```
Agent(
  subagent_type: "mpf-checker",
  prompt: "Check task plan for phase {N} ({name}). Project root: {project_root}. Phase number: {N}. Phase name: {name}."
)
```

### Step 5: Handle Checker Results

- **If PASS:** Tell the user the plan is ready. Show the task count, wave count, and requirement coverage summary. Recommend: "Run `mpf:execute {N}` to begin implementation."
- **If FAIL:** Present the checker's issues to the user. Ask how they want to proceed:
  - "Fix these issues": Re-run the planner with specific instructions to address the gaps, then re-check.
  - "Proceed anyway": Accept the plan as-is with noted gaps.
  - "Manual edit": Let the user edit the task files directly, then re-run the checker.

### Step 6: Update Project Status

Update `docs/PROJECT_STATUS.md`:
- Note that Phase {N} has been planned with {count} tasks across {wave_count} waves
- Add a session log entry

## Output

Display a summary to the user:

```
Phase {N}: {Name} - Task Plan Complete

Tasks: {count} across {waves} waves
Checker: PASS/FAIL

Wave 1: task-01 ({title}), task-02 ({title})
Wave 2: task-03 ({title}), task-04 ({title})
...

Requirement coverage: {covered}/{total}
Next: Run `mpf:execute {N}` to begin implementation.
```
