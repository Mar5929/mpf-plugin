---
name: mpf:plan-phases
description: Break PRD requirements into implementation phases and generate the project roadmap. Produces docs/roadmap.md and phase overview files under docs/requirements/phases/. Creates Linear milestones if external tracking is configured. Run after mpf:discover, before mpf:plan-tasks.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, mcp__claude_ai_Linear__*
---

# mpf:plan-phases

Analyze the PRD and requirements to produce a phased implementation roadmap.

## Prerequisites

Read these files before starting:

1. `CLAUDE.md` (tier, tracking approach, tech stack, version control config)
2. `docs/requirements/PRD.md` (the product requirements)
3. `docs/technical-specs/TECHNICAL_SPEC.md` (architecture decisions)
4. `docs/technical-specs/DATA_MODEL.md` (data model, if exists)
5. `docs/requirements/requirements.md` (if in-repo tracking) or check external tracker for existing tickets

If `docs/requirements/PRD.md` does not exist or is a placeholder, tell the user: "No PRD found. Run `mpf:discover` first to create the product requirements."

## Template Reference

Read the roadmap.md and Phase Overview templates from `skills/mpf/references/document-templates.md` before generating documents.

## Phase Decomposition

### Step 1: Identify Requirement Groups

Group requirements by dependency and domain:
- Which requirements depend on each other? (e.g., "user profile" depends on "user auth")
- Which requirements share infrastructure? (e.g., all API endpoints need the base server setup)
- Which requirements form a coherent user-facing feature?

### Step 2: Define Phases

Create phases following these principles:

1. **Foundation first.** Phase 1 is always project setup, infrastructure, and shared dependencies (database schema, auth, base API, dev tooling).
2. **Dependency order.** A phase's requirements must not depend on requirements in a later phase.
3. **Deployable increments.** Each phase should produce something testable and demonstrable. No "half-built" phases.
4. **Balanced scope.** Target 3-8 requirements per phase. If a phase has more than 10, split it. If fewer than 2, merge with an adjacent phase.
5. **P0 before P1.** Higher-priority requirements should land in earlier phases, but respect dependency order over priority when they conflict.

### Step 3: Present the Plan

Show the user a summary table before writing any files:

```
Proposed Phases:

| Phase | Name | Requirements | Est. Tasks |
|-------|------|-------------|------------|
| 1 | Foundation & Setup | REQ-001, REQ-002 | 4-6 |
| 2 | User Authentication | REQ-003, REQ-004, REQ-005 | 6-8 |
| 3 | Core Features | REQ-006, REQ-007, REQ-008 | 8-10 |
...
```

For each phase, briefly explain:
- **Goal:** What this phase accomplishes
- **Why this order:** Why it comes before/after adjacent phases

Ask: "Does this breakdown look right? Want to move, merge, or split any phases?"

Wait for user confirmation before proceeding to file generation.

### Step 4: Generate Files

After user approval, create:

#### roadmap.md

Write `docs/roadmap.md` following the template. Include the phase summary table and a detail section for each phase.

#### Phase Overview Files

For each phase, create the directory and overview file:
- `docs/requirements/phases/phase-{NN}-{kebab-name}/overview.md`

Follow the Phase Overview template. Include:
- Phase goal
- Requirements covered (with REQ-IDs)
- Success criteria (2-5 testable criteria per phase)
- Dependencies on prior phases
- Linear milestone reference (if external tracking configured)

Create the `tasks/` subdirectory inside each phase folder (empty; tasks are created by `mpf:plan-tasks`).

#### requirements.md Updates (if in-repo tracking)

Update each requirement's phase assignment in `docs/requirements/requirements.md` to show which phase implements it.

#### traceability-matrix.md Updates (if external tracking)

If the project uses an external tracker with traceability matrix:
- Update `docs/traceability-matrix.md` to map each requirement to its phase
- Ticket IDs will be added later when `mpf:plan-tasks` creates individual tickets

**If the project uses in-repo tracking** (no external tracker configured), skip `docs/traceability-matrix.md` updates in this step. Use `docs/BACKLOG.md` and `docs/requirements/requirements.md` instead.

### Step 5: Linear Integration (if configured)

Check CLAUDE.md Section 4 (Update Protocol) for the tracking approach. If the tracking approach is "external" and the tracker is "Linear", proceed with Linear milestone creation. If Linear is enabled:

1. Create a Linear milestone for each phase using the phase name
2. Record the milestone ID in the phase overview file
3. Update the traceability matrix with milestone references

Use team Rihm (`dfe15bc4-6dd0-4bde-8609-6620efc3140d`) and assignee Michael Rihm (`8d75f0a6-f848-41af-9f4b-d06036d6af82`).

### Step 6: Update Project Status

Update `docs/PROJECT_STATUS.md`:
- Set current phase to "Phase 1: {name}" (or whatever the first phase is)
- Add a session log entry noting the roadmap was created with N phases
- Update the phase summary section

## After Completion

Tell the user:
- List all files created/updated
- Show the final phase count and total requirement coverage
- Flag any requirements not assigned to a phase (should be zero)
- Recommend: "Run `mpf:plan-tasks 1` to break Phase 1 into executable tasks."

## Edge Cases

- **Single-phase project:** If all requirements fit in one phase, that's fine. Create a single phase with all requirements.
- **Circular dependencies:** If requirements have circular dependencies, flag them to the user and ask how to resolve (usually by splitting a requirement or combining phases).
- **Existing roadmap:** If `docs/roadmap.md` already exists with content, ask the user whether to replace it or merge with the existing plan. Do not silently overwrite.
- **Too many phases (>10):** Warn the user that many phases can be hard to track. Suggest grouping related phases or increasing scope per phase.
