---
name: mpf:plan-tasks
description: Break a phase into granular executable tasks. Spawns mpf-planner to create task files, then mpf-checker to verify coverage. Usage: mpf:plan-tasks <phase_number> Run after mpf:plan-phases, before mpf:execute.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent, mcp__claude_ai_Linear__*
---

# mpf:plan-tasks

Orchestrate task planning for a single phase by spawning the planner and checker agents.

## Usage

```
mpf:plan-tasks <phase_number>
```

Example: `mpf:plan-tasks 1`

## Prerequisites

1. Read Section 3 (Phase Roadmap) of `docs/PROJECT_ROADMAP.md` to confirm the requested phase exists.
2. Read `docs/requirements/phases/phase-{NN}-{name}/overview.md` to confirm the phase has requirements and success criteria defined.
3. If neither exists, tell the user: "Phase {N} not found. Run `mpf:plan-phases` first."

## Steps

### Step 1: Resolve Phase Info

From `docs/PROJECT_ROADMAP.md` Section 3, extract:
- Phase number and name (for directory naming)
- Phase status (should be "Not Started" or "Planned")

If the phase already has task files in its `tasks/` directory, ask the user: "Phase {N} already has {count} task files. Replace them or keep the existing plan?"

### Step 2: Linear Ticket Creation (if configured)

Check CLAUDE.md for Linear configuration. **If Linear is not configured for this project, skip this step entirely and pass `linear_ticket_mapping: 'N/A'` to the planner agent in Step 3.**

If Linear is enabled:

1. Read the phase overview for requirements covered
2. For each requirement, create a Linear ticket (or check if one already exists)
3. Use team Rihm (`dfe15bc4-6dd0-4bde-8609-6620efc3140d`) and assignee Michael Rihm (`8d75f0a6-f848-41af-9f4b-d06036d6af82`)
4. Record ticket IDs for the planner to reference in task files
5. Update `docs/traceability-matrix.md` with the new ticket mappings

### Step 3: Spawn mpf-planner

Launch the mpf-planner agent with:

```
Agent(
  subagent_type: "mpf-planner",
  prompt: "Plan tasks for phase {N} ({name}). Project root: {project_root}. Phase number: {N}. Phase name: {name}. Linear ticket mapping: {ticket_id_map or 'N/A'}."
)
```

Wait for the planner to complete and review its output summary.

### Step 4: Spawn mpf-checker

After the planner finishes, launch the mpf-checker agent:

```
Agent(
  subagent_type: "mpf-checker",
  prompt: "Check task plan for phase {N} ({name}). Project root: {project_root}. Phase number: {N}. Phase name: {name}."
)
```

### Step 5: Coarse-Task Check

After the checker finishes, scan the generated task files for potential under-specification:

1. Read each task file in the `tasks/` directory
2. Flag any task where:
   - The Action section is fewer than 5 lines (may be under-specified)
   - The Files section lists more than 3 files (may need splitting)
   - The Verify section is empty or has only a placeholder
3. If flags are found, present them to the user:
   ```
   Coarse-task warnings:
   - task-03: Action section is only 3 lines (may need more detail)
   - task-07: Touches 4 files (consider splitting)
   ```
4. Ask: "Want me to refine these tasks, or proceed as-is?"

### Step 6: Link Linear Dependencies (if configured)

If Linear is not configured, skip this step.

If Linear is enabled:

1. Read all task files to extract dependency info (Wave number and "Depends On" fields)
2. Build a task-to-ticket map from Step 2 ticket creation
3. For each task with "Depends On" entries:
   - Look up the ticket ID for the current task and each dependency task
   - Call `save_issue(id: current_ticket_id, blockedBy: [dependency_ticket_ids])` to create the blocked-by relation
4. For cross-phase dependencies:
   - Link Phase N Wave 1 tickets as blockedBy the final wave tickets from Phase N-1 (if Phase N-1 tickets exist)
5. Report all relations created:
   ```
   Linear dependency links created:
   - RIH-105 blocked by RIH-101, RIH-102
   - RIH-106 blocked by RIH-103
   ```

### Step 7: Handle Checker Results

- **If PASS:** Tell the user the plan is ready. Show the task count, wave count, and requirement coverage summary. Recommend: "Run `mpf:execute {N}` to begin implementation."
- **If FAIL:** Present the checker's issues to the user. Ask how they want to proceed:
  - "Fix these issues": Re-run the planner with specific instructions to address the gaps, then re-check.
  - "Proceed anyway": Accept the plan as-is with noted gaps.
  - "Manual edit": Let the user edit the task files directly, then re-run the checker.

### Step 8: Update Project Status

Update `docs/PROJECT_ROADMAP.md`:
- Section 5 (Active Work Items): Note that Phase {N} has been planned with {count} tasks across {wave_count} waves
- Section 7 (Session Log): Add a session log entry
- If `docs/requirements/REQUIREMENT_HIERARCHY.md` exists, update it with the task breakdown: populate the Tasks column in the Hierarchy Tree and Coverage Matrix for this phase's requirements.

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
