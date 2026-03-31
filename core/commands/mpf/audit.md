# Command: mpf:audit
# Description: Agent-driven implementation status analysis. Maps imported requirements against the existing codebase to determine what is Done, Partial, or Not Started. Produces docs/requirements/audit-report.md with evidence-based assessments. Supports --requirements flag to scope the audit to specific requirements only. Run after mpf:import, before mpf:reconcile.
# Tools: [file_read, file_write, file_edit, shell, text_search, file_search, agent_spawn]

# mpf:audit

Analyze the existing codebase against imported requirements to determine implementation status for each requirement. Produces an evidence-based audit report.

## Usage

```
mpf:audit                                          # Audit all requirements
mpf:audit --requirements REQ-045,REQ-046,REQ-047   # Audit specific requirements only
mpf:audit --requirements REQ-045-REQ-051            # Audit a range of requirements
```

### --requirements Flag

When `--requirements` is provided, the audit is scoped to only the listed requirements:

1. Parse the flag value as a comma-separated list of REQ IDs or a range (e.g., `REQ-045-REQ-051`).
2. Validate that all listed REQ IDs exist in `docs/requirements/requirements.md`. Warn about any IDs not found.
3. Pass only the matching requirements to the auditor agent.
4. When writing `docs/requirements/audit-report.md`:
   - If the file already exists, **merge** new assessments into the existing report. Update entries for the targeted requirements while preserving all other entries unchanged.
   - If the file does not exist, create it with only the targeted requirements (note in the report header that this is a partial audit).
5. When updating `docs/requirements/requirements.md` status column, only update the rows for the targeted requirements.

This mode is designed for:
- Auditing newly imported requirements without re-assessing the entire codebase
- Spot-checking specific requirements after code changes
- Incremental audits on large projects where a full audit is too slow

## When to Use

- **Brownfield onboarding:** Run after `mpf:import` to assess what has already been built.
- **Progress check:** Re-run after development to update implementation status.
- **Pre-reconcile:** Produces the audit report that `mpf:reconcile` consumes to align documentation.
- **Post-import (incremental):** Run with `--requirements` after adding new requirements via `mpf:import` to audit only the new ones.

## Prerequisites

1. `docs/requirements/requirements.md` must exist. If not, tell the user: "No requirements found. Run `mpf:import` first."
2. Check if `docs/technical-specs/code-atlas.md` exists:
   - **Exists:** It will be passed to the auditor agent for context.
   - **Does not exist:** Warn the user: "No code-atlas.md found. Consider running `mpf:map-codebase` first for better audit accuracy. Continuing with basic codebase scan." Proceed without it.

## Steps

### Step 1: Pre-flight Check

1. Verify `docs/requirements/requirements.md` exists. Abort with guidance if missing.
2. Read `docs/requirements/requirements.md` to get the requirements list.
3. If `--requirements` flag is provided, filter to only the specified requirements. Validate all listed IDs exist; warn about any not found. If none are found, abort: "None of the specified requirement IDs were found in requirements.md."
4. Check for `docs/technical-specs/code-atlas.md`. Read it if present.
5. Ensure `docs/requirements/` directory exists for output: `mkdir -p docs/requirements`

### Step 2: Spawn Auditor Agent

Spawn the mpf-auditor agent:

```
agent_spawn(
  subagent_type: "mpf-auditor",
  prompt: "Audit this codebase against the imported requirements.
    Project root: {absolute_path_to_cwd}.
    Requirements: {filtered requirements content (all requirements if no --requirements flag, or only the targeted subset)}.
    Code atlas: {code-atlas.md content or 'Not available - perform your own codebase discovery'}.
    Scope: {'Full audit' or 'Targeted audit for: REQ-045, REQ-046, ...'}.
    Analyze each requirement's acceptance criteria against the codebase and produce per-requirement assessments.",
  mode: "bypassPermissions"
)
```

The auditor handles all codebase analysis and produces the raw assessment report.

### Step 3: Coverage Report Generation

The auditor returns a per-requirement assessment containing:

- **Status:** Done | Partial | Not Started
- **Evidence:** File paths, function names, test files found
- **For Partial:** What is implemented vs what is missing
- **Confidence:** High (clear match) | Medium (likely match) | Low (uncertain)

Compile summary statistics from the auditor's output:
- Total requirements: X
- Done: Y (Z%)
- Partial: Y (Z%)
- Not Started: Y (Z%)

### Step 4: User Review

Present the coverage report to the user requirement by requirement:

1. Show each requirement's ID, title, status, confidence, and evidence summary.
2. Ask the user to confirm or correct each assessment.
3. Accept user corrections:
   - Status overrides (e.g., marking something as "Not Started" despite existing code if the user knows it needs a rewrite)
   - Notes (e.g., "intentionally descoped", "needs rewrite despite existing code", "handled by third-party service")
4. For Low confidence items, explicitly ask the user to verify.

### Step 5: Write Output

**Full audit (no --requirements flag):**
1. **Save confirmed report** to `docs/requirements/audit-report.md` with the full per-requirement breakdown and summary statistics.
2. **Update requirements.md** status column based on confirmed assessments.
3. **Update PROJECT_ROADMAP.md** (if it exists) with an audit summary section.

**Targeted audit (--requirements flag):**
1. **Merge into audit-report.md:** If the file exists, read the existing report. Replace entries for the targeted requirements with the new assessments. Preserve all other entries. Update the summary statistics to reflect the merged state. If the file does not exist, create it with only the targeted entries and note: "Partial audit: only {N} requirements assessed. Run `mpf:audit` without --requirements for a full audit."
2. **Update requirements.md** status column only for the targeted requirements. Do not touch other rows.
3. **Update PROJECT_ROADMAP.md** (if it exists) with a session log entry noting the targeted audit scope.

## After Completion

Report the audit results summary to the user:

```
Audit complete: {project_name}

  Done:        {X} requirements ({X%})
  Partial:     {Y} requirements ({Y%})
  Not Started: {Z} requirements ({Z%})

  High confidence: {N} | Medium: {N} | Low: {N}

Files written:
  - docs/requirements/audit-report.md
  - docs/requirements/requirements.md (status column updated)

Run `mpf:reconcile` to align your existing documentation with MPF's document structure.
```
