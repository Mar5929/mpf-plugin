# Command: mpf:audit
# Description: Agent-driven implementation status analysis. Maps imported requirements against the existing codebase to determine what is Done, Partial, or Not Started. Produces docs/requirements/audit-report.md with evidence-based assessments. Run after mpf:import, before mpf:reconcile.
# Tools: [file_read, file_write, file_edit, shell, text_search, file_search, agent_spawn]

# mpf:audit

Analyze the existing codebase against imported requirements to determine implementation status for each requirement. Produces an evidence-based audit report.

## Usage

```
mpf:audit
```

No arguments. Runs against the current working directory.

## When to Use

- **Brownfield onboarding:** Run after `mpf:import` to assess what has already been built.
- **Progress check:** Re-run after development to update implementation status.
- **Pre-reconcile:** Produces the audit report that `mpf:reconcile` consumes to align documentation.

## Prerequisites

1. `docs/requirements/requirements.md` must exist. If not, tell the user: "No requirements found. Run `mpf:import` first."
2. Check if `docs/technical-specs/code-atlas.md` exists:
   - **Exists:** It will be passed to the auditor agent for context.
   - **Does not exist:** Warn the user: "No code-atlas.md found. Consider running `mpf:map-codebase` first for better audit accuracy. Continuing with basic codebase scan." Proceed without it.

## Steps

### Step 1: Pre-flight Check

1. Verify `docs/requirements/requirements.md` exists. Abort with guidance if missing.
2. Read `docs/requirements/requirements.md` to get the full requirements list.
3. Check for `docs/technical-specs/code-atlas.md`. Read it if present.
4. Ensure `docs/requirements/` directory exists for output: `mkdir -p docs/requirements`

### Step 2: Spawn Auditor Agent

Spawn the mpf-auditor agent:

```
agent_spawn(
  subagent_type: "mpf-auditor",
  prompt: "Audit this codebase against the imported requirements.
    Project root: {absolute_path_to_cwd}.
    Requirements: {requirements.md content}.
    Code atlas: {code-atlas.md content or 'Not available - perform your own codebase discovery'}.
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

1. **Save confirmed report** to `docs/requirements/audit-report.md` with the full per-requirement breakdown and summary statistics.
2. **Update requirements.md** status column based on confirmed assessments.
3. **Update PROJECT_ROADMAP.md** (if it exists) with an audit summary section.

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
