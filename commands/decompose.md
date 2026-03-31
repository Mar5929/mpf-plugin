---
name: mpf:decompose
description: Decompose ad-hoc TODOs or enhancement ideas into structured, executable task files without requiring the full PRD pipeline. Accepts input from a file, inline text, or interactive prompt. Reuses mpf-planner for complex decompositions. Run any time you have loose ideas to break down.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent, mcp__claude_ai_Linear__*
---

# mpf:decompose

Break ad-hoc TODOs into structured task files compatible with `mpf:execute`, without going through the full discover/plan-phases pipeline.

## Usage

```
mpf:decompose [source]
```

Where `source` is one of:
- A file path (e.g., `TODOs.md`, `docs/enhancements.md`)
- Inline text (user types TODOs directly in their prompt)
- No argument (prompts the user interactively)

Example: `mpf:decompose TODOs.md`

## Steps

### Step 1: Gather Input

1. If a file path is provided, read it.
   - If the file has multiple `##` sections, list the sections and ask the user which to decompose.
   - If the file is under 30 lines, use the whole thing.
2. If the user provided inline text (TODOs in their prompt), use it directly.
3. If no input is provided, ask: "What TODOs or enhancements do you want to decompose? Paste them here or provide a file path."

Parse the input into a numbered list of discrete TODO items. Each item should have a one-line summary. If the input is prose, extract the distinct action items from it.

Present the parsed list back to the user: "I found {N} items to decompose:" followed by the numbered list. Ask: "Does this capture everything? Want to add, remove, or rephrase any items?"

Wait for confirmation before proceeding.

### Step 2: Assess Complexity

Count the TODO items and assess their scope:

- **Simple (1-3 items, each clearly a single task):** Proceed with inline decomposition (no agents).
- **Complex (4+ items, or items with cross-dependencies):** Will spawn `mpf-planner` in Step 5.

Tell the user: "Found {N} items. I'll decompose these {inline / using the planner agent}."

### Step 3: Choose Destination

Read Section 3 (Phase Roadmap) of `docs/PROJECT_ROADMAP.md` (if it exists) to understand the current phase landscape.

Present options:

1. **New phase** (default): "Create phase {next_number} for these items and append to the roadmap."
2. **Existing phase**: "Add tasks to an existing phase. Which phase?" (list available phases with their names)

If `docs/PROJECT_ROADMAP.md` does not exist or Section 3 is empty, create the phase as Phase 1. Note: "No roadmap found. Creating Phase 1."

Wait for the user's choice before proceeding.

### Step 4: Generate Synthetic Phase Overview

**Skip this step if the user chose option 2 (existing phase):** that phase already has an overview.

For new phase destinations, generate a lightweight `overview.md`:

```markdown
# Phase {NN}: {Name}

**Goal:** {one-paragraph summary derived from the TODO themes}

**Source:** Ad-hoc decomposition via `mpf:decompose`

## Requirements Covered

| ID | Description | Priority |
|---|---|---|
| TODO-001 | {first TODO item summary} | Medium |
| TODO-002 | {second TODO item summary} | Medium |

## Success Criteria

1. {testable criterion derived from TODO-001}
2. {testable criterion derived from TODO-002}

## Dependencies

{List dependencies on prior phases, or "None" if standalone}
```

Use `TODO-xxx` IDs (not `REQ-xxx`) to distinguish ad-hoc items from PRD-derived requirements.

Write the overview to `docs/requirements/phases/phase-{NN}-{kebab-name}/overview.md`.

Create the `tasks/` subdirectory inside the phase directory.

### Step 5: Decompose into Tasks

Read the Task File template from `skills/mpf/references/templates-phases.md` (section "Task File").

#### Inline Path (1-3 simple items)

For each TODO item, write a task file directly:

1. Read `CLAUDE.md` for coding standards and tech stack.
2. Read relevant codebase files (check `docs/technical-specs/code-atlas.md` if it exists) to make the Action section specific with file paths, function signatures, and patterns.
3. Write each task file following the template exactly:
   - **Requirement:** `TODO-xxx`
   - **Linear Ticket:** Populated in Step 7, or "N/A"
   - **Files:** List specific files to create or modify
   - **Action:** Concrete implementation instructions
   - **Verify:** Test commands or observable checks
   - **Done:** Checkable criteria
   - **Wave:** Assign wave 1 for independent tasks; wave 2+ if a task depends on another

Write task files to `{target_directory}/tasks/task-{NN}.md`.

#### Agent Path (4+ items or complex dependencies)

Spawn the `mpf-planner` agent:

```
Agent(
  subagent_type: "mpf:mpf-planner",
  prompt: "Plan tasks for decomposed TODOs. Project root: {project_root}. Phase number: {NN}. Phase name: {kebab-name}. Linear ticket mapping: {ticket_id_map or 'N/A'}. NOTE: This is an ad-hoc decomposition from mpf:decompose, not a PRD-derived phase. The overview.md uses TODO-xxx IDs instead of REQ-xxx IDs. PRD.md may not exist for this project; if missing, skip it and rely on the phase overview and CLAUDE.md for context. Apply the same task decomposition rules, wave assignment, and coverage checks as normal."
)
```

Wait for the planner to complete and review its output.

### Step 6: Optional Validation

**For inline path (1-3 tasks):** Skip validation by default. If the user asks for it, run the checker.

**For agent path (4+ tasks):** Ask: "Run the checker to validate task coverage? (Recommended)"

If yes, spawn the `mpf-checker` agent:

```
Agent(
  subagent_type: "mpf:mpf-checker",
  prompt: "Check task plan for decomposed TODOs. Project root: {project_root}. Phase number: {NN}. Phase name: {kebab-name}."
)
```

Handle results:
- **PASS:** Proceed to Step 7.
- **FAIL:** Present the issues. Ask how to proceed:
  - "Fix these issues": Re-run the planner with instructions to address gaps, then re-check.
  - "Proceed anyway": Accept with noted gaps.
  - "Manual edit": Let the user edit task files, then re-run checker.

### Step 7: Linear Integration (conditional)

Check `CLAUDE.md` for the tracking approach. **If Linear is not configured, skip this step entirely.**

If Linear is configured:

1. If a new phase was created, create a Linear milestone for the phase.
2. After creating the milestone, add a `**Linear Milestone:** {milestone_id}` line to the phase `overview.md` file (below the Goal line). This is required for `mpf:verify` to find the milestone later.
3. For each task, create a Linear issue linked to the milestone.
   - Use team Rihm (`dfe15bc4-6dd0-4bde-8609-6620efc3140d`) and assignee Michael Rihm (`8d75f0a6-f848-41af-9f4b-d06036d6af82`).
4. Update task files with the Linear ticket IDs in the **Linear Ticket** field.
5. Link dependencies: for each task with "Depends On" entries, call `save_issue(id: ticket_id, blockedBy: [dependency_ticket_ids])` to create blocked-by relations in Linear.
6. Update `docs/traceability-matrix.md` with the new mappings (if the file exists).

### Step 8: Update Project Status

- **New phase:** Append the phase to `docs/PROJECT_ROADMAP.md` Section 3 (Phase Roadmap) and add a session log entry to Section 7.
- **Existing phase:** Add a session log entry to `docs/PROJECT_ROADMAP.md` Section 7 noting tasks were added to phase {N}.
- If `docs/requirements/REQUIREMENT_HIERARCHY.md` exists, update it with the new tasks.

If `docs/PROJECT_ROADMAP.md` does not exist, skip the status update.

### Step 9: Output Summary

Display:

```
Decomposed: {N} TODOs -> {task_count} tasks

Destination: Phase {NN} ({name})
Tasks: {count} across {waves} waves
Checker: PASS / FAIL / SKIPPED
Linear: {ticket_count} tickets created / N/A

Wave 1: task-01 ({title}), task-02 ({title})
Wave 2: task-03 ({title})
...

Next steps:
- Run `mpf:execute {N}` to implement these tasks
- Run `mpf:plan-tasks {N}` to refine the plan further
- Edit task files manually at {task_directory}
```

## Edge Cases

- **Empty input:** If the user provides a file or text with no actionable items, say: "I couldn't find any discrete TODOs to decompose. Try rephrasing as a list of specific changes or features."
- **Duplicate TODOs:** If a TODO matches an existing requirement in `docs/requirements/requirements.md`, flag it: "TODO-002 overlaps with REQ-015 ({description}). Use the existing requirement instead? (y/n)"
- **Single TODO:** Valid. Creates a single task file. Skip the checker (one task has nothing to cross-validate).
- **No roadmap:** If `docs/PROJECT_ROADMAP.md` does not exist or has no Section 3 content, create it with the new phase as Phase 1 rather than failing.
