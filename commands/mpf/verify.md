---
name: mpf:verify
description: >
  Run phase-level UAT verification after execution. Spawns mpf-verifier to check
  all task verify commands, success criteria, and project test suite.
  Usage: mpf:verify <phase_number>
  Run after mpf:execute. Phase merges to main only after verify passes.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent
---

# mpf:verify

Orchestrate phase-level verification by spawning the verifier agent and handling results.

## Usage

```
mpf:verify <phase_number>
```

Example: `mpf:verify 1`

## Prerequisites

1. Read `docs/roadmap.md` to confirm the phase exists.
2. Check that task files exist in `docs/requirements/phases/phase-{NN}-{name}/tasks/`.
3. Verify that at least some tasks have been executed (check for commits on the phase branch or Done checkboxes).
4. If no execution evidence found, tell the user: "Phase {N} doesn't appear to have been executed yet. Run `mpf:execute {N}` first."

## Steps

### Step 1: Spawn mpf-verifier

Launch the verifier agent:

```
Agent(
  subagent_type: "mpf-verifier",
  prompt: "Verify phase {N} ({name}). Project root: {project_root}. Phase number: {N}. Phase name: {name}."
)
```

Wait for the verifier to complete.

### Step 2: Present Results

Display the verifier's report to the user with clear formatting.

### Step 3: Handle Outcome

#### If PASS (all automated checks pass)

1. Update `docs/PROJECT_STATUS.md`:
   - Mark the phase as "Verified"
   - Update progress to 100%
   - Add session log entry

2. Update `docs/roadmap.md`:
   - Set phase status to "Done" (or "Verified" if manual checks remain)
   - Update progress to 100%

3. If there are MANUAL verification items, present them as a checklist:
   ```
   Manual verification needed:
   - [ ] UI renders the login form correctly
   - [ ] Email notifications arrive within 30 seconds

   Confirm these pass, then merge the branch.
   ```

4. Guide the user on merging:
   - If version control enabled: "Phase {N} is verified. Merge `feature/phase-{N}-{name}` to main when ready, then run `mpf:plan-tasks {N+1}` for the next phase."
   - If no version control: "Phase {N} is verified. Run `mpf:plan-tasks {N+1}` for the next phase."

#### If FAIL

1. Save the verification report to `docs/requirements/phases/phase-{NN}-{name}/verify-report.md` for reference during re-execution.

2. Present the failures clearly:
   ```
   Phase {N} Verification: FAIL

   {count} issues found:
   1. Task 02: auth middleware - test timeout on login endpoint
   2. Success criterion 3: "Passwords are hashed" - bcrypt check failed

   Recommended: Run `mpf:execute {N}` to fix these issues, then `mpf:verify {N}` again.
   ```

3. Update `docs/PROJECT_STATUS.md`:
   - Add a blocker entry for each failure
   - Add session log entry noting the verification failure

### Step 4: Linear Updates (if configured)

Check CLAUDE.md for Linear configuration. If enabled:
- On PASS: Add a comment to the phase milestone noting verification passed
- On FAIL: Add comments to the relevant tickets noting which verifications failed

## After Final Phase

If this is the last phase in the roadmap and it passes:

1. Update `docs/PROJECT_STATUS.md` to reflect project completion
2. Tell the user: "All phases complete and verified. The project roadmap is fully implemented."
