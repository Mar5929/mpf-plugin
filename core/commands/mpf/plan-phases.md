# Command: mpf:plan-phases
# Description: Break PRD requirements into implementation phases and generate the project roadmap. Updates Section 3 (Phase Roadmap) of docs/PROJECT_ROADMAP.md and generates phase overview files under docs/requirements/phases/. Creates Linear milestones if external tracking is configured. Supports --new-only flag to add phases for unphased requirements without touching existing phases. Run after mpf:discover, before mpf:plan-tasks.
# Tools: [file_read, file_write, file_edit, shell, text_search, file_search, linear_api]

# mpf:plan-phases

Analyze the PRD and requirements to produce a phased implementation roadmap.

## Usage

```
mpf:plan-phases              # Full roadmap generation (default)
mpf:plan-phases --new-only   # Only create phases for unphased requirements; preserve existing roadmap
```

### --new-only Mode

When `--new-only` is passed, the command operates in additive mode:

1. Read `docs/requirements/requirements.md` and identify requirements that have **no phase assignment** (no "Phase: N" field, or phase field is empty/TBD).
2. Read `docs/PROJECT_ROADMAP.md` Section 3 to determine the current highest phase number.
3. Only plan new phases for the unphased requirements. New phases are numbered starting from the next available number (e.g., if Phase 5 is the last existing phase, new phases start at Phase 6).
4. Preserve all existing phase content in PROJECT_ROADMAP.md Section 3. Append the new phases after existing ones.
5. Do not reassign, reorder, or modify any existing phases or their requirements.
6. Existing phase overview files under `docs/requirements/phases/` are left untouched.

If no unphased requirements are found, tell the user: "All requirements already have phase assignments. Nothing to plan. Use `mpf:import` to add new requirements first."

In `--new-only` mode, skip all audit-aware filtering logic (Done/Partial/Not Started). The assumption is that newly imported requirements are unaudited or have already been audited separately via `mpf:audit --requirements`.

## Prerequisites

Read these files before starting:

1. `CLAUDE.md` (tier, tracking approach, tech stack, version control config)
2. `docs/requirements/PRD.md` (the product requirements)
3. `docs/technical-specs/TECHNICAL_SPEC.md` (architecture decisions)
4. `docs/technical-specs/DATA_MODEL.md` (data model, if exists)
5. `docs/requirements/requirements.md` (if in-repo tracking) or check external tracker for existing tickets
6. `docs/requirements/audit-report.md` (if exists; produced by `mpf:audit` during onboarding)

If `docs/requirements/PRD.md` does not exist or is a placeholder, tell the user: "No PRD found. Run `mpf:discover` first to create the product requirements."

## Template Reference

Read the PROJECT_ROADMAP.md template from `skills/mpf/references/templates-core.md` and the Phase Overview template from `skills/mpf/references/templates-phases.md` before generating documents.

## Phase Decomposition

### Step 1: Identify Requirement Groups

**Audit-aware filtering (if audit-report.md exists):**

Read `docs/requirements/audit-report.md` and filter requirements by status:
- **Done requirements:** Exclude from phase planning entirely. These are already recorded in the Pre-MPF Work section of PROJECT_ROADMAP.md.
- **Partial requirements:** Include in phase planning, but the phase overview must note what already exists and what remains. Create finish-up tasks only for the missing work.
- **Not Started requirements:** Normal phase planning (no special handling).

If all requirements are Done, tell the user: "All imported requirements are already implemented. No phases to plan. Consider running `mpf:discover` to define new requirements."

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
5. **Task count guidance.** Each requirement should decompose into 3-10 tasks. If a phase would produce more than 40 tasks, split the phase. If fewer than 5 tasks, consider merging with an adjacent phase.
6. **P0 before P1.** Higher-priority requirements should land in earlier phases, but respect dependency order over priority when they conflict.
7. **Completion phases.** When mixing Partial and Not Started requirements, prefer grouping Partial requirements into early phases ("completion" phases) so existing work gets finished before new features begin. Label these phases clearly: "Phase 1: Complete {feature area}".

### Step 3: Present the Plan

Show the user a summary table before writing any files.

When presenting phases, add a "Type" column to distinguish between completion phases and new implementation phases:

```
Proposed Phases:

| Phase | Name | Type | Requirements | Est. Tasks |
|-------|------|------|-------------|------------|
| 1 | Complete Authentication | Completion | REQ-003 (Partial), REQ-004 (Partial) | 3-5 |
| 2 | Dashboard Features | New | REQ-006, REQ-007 | 6-8 |
...
```

For completion phases, also show:
- What already exists (from audit evidence)
- What remains to be built
- Why it was marked partial

If no audit-report.md exists, omit the "Type" column and use the standard table format:

```
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

#### PROJECT_ROADMAP.md Section 3: Phase Roadmap

Update Section 3 (Phase Roadmap) of `docs/PROJECT_ROADMAP.md` with the phase summary table and a detail section for each phase. Follow the template structure.

#### Phase Overview Files

For each phase, create the directory and overview file:
- `docs/requirements/phases/phase-{NN}-{kebab-name}/overview.md`

Follow the Phase Overview template. Include:
- Phase goal
- Requirements covered (with REQ-IDs)
- Success criteria (2-5 testable criteria per phase)
- Dependencies on prior phases
- Linear milestone reference (if external tracking configured)

For completion phases (containing Partial requirements), the phase overview file must include:
- An "Existing Implementation" section listing files/components that already exist (from audit evidence)
- A "Remaining Work" section listing what's missing per acceptance criterion
- A note: "This phase completes work started before MPF adoption. See docs/requirements/audit-report.md for the full audit."

Create the `tasks/` subdirectory inside each phase folder (empty; tasks are created by `mpf:plan-tasks`).

#### REQUIREMENT_HIERARCHY.md (if external tracking)

If the project uses external tracking, create or update `docs/requirements/REQUIREMENT_HIERARCHY.md`:
- Populate the Overview section with requirement and phase counts
- Populate the Hierarchy Tree with REQ -> Phase mapping (tasks left empty; filled by `mpf:plan-tasks`)
- Populate the Coverage Matrix with initial status (all "Planned" or "GAP: Unplanned")

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

Update `docs/PROJECT_ROADMAP.md`:
- Section 2 (Current Phase): Set to "Phase 1: {name}" (or whatever the first phase is)
- Section 7 (Session Log): Add entry noting the roadmap was created with N phases

## After Completion

Tell the user:
- List all files created/updated
- Show the final phase count and total requirement coverage
- Flag any requirements not assigned to a phase (should be zero)
- Recommend: "Run `mpf:plan-tasks 1` to break Phase 1 into executable tasks."

## Edge Cases

- **Single-phase project:** If all requirements fit in one phase, that's fine. Create a single phase with all requirements.
- **Circular dependencies:** If requirements have circular dependencies, flag them to the user and ask how to resolve (usually by splitting a requirement or combining phases).
- **Existing roadmap (default mode):** If Section 3 of `docs/PROJECT_ROADMAP.md` already has phase content, ask the user whether to replace it or merge with the existing plan. Suggest using `--new-only` if they only want to add phases for new requirements. Do not silently overwrite.
- **Existing roadmap (--new-only mode):** Existing phases are never modified. New phases append after the last existing phase. Dependencies from new phases on existing phases are allowed and should be noted in the new phase overviews.
- **Too many phases (>10):** Warn the user that many phases can be hard to track. Suggest grouping related phases or increasing scope per phase.
- **New requirements depend on each other:** In `--new-only` mode, the dependency ordering rules still apply within the new phases. If a new requirement depends on an existing (already-phased) requirement, note the cross-phase dependency but do not move the existing requirement.
