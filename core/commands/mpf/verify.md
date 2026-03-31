# Command: mpf:verify
# Description: Run phase-level UAT verification after execution. Spawns mpf-verifier to check all task verify commands, success criteria, and project test suite. Usage: mpf:verify <phase_number>. Run after mpf:execute. Phase merges to main only after verify passes.
# Tools: [file_read, file_write, file_edit, shell, text_search, file_search, agent_spawn, linear_api]

# mpf:verify

Orchestrate phase-level verification by spawning the verifier agent and handling results.

## Usage

```
mpf:verify <phase_number>
```

Example: `mpf:verify 1`

## Prerequisites

1. Read Section 3 (Phase Roadmap) of `docs/PROJECT_ROADMAP.md` to confirm the phase exists.
2. Check that task files exist in `docs/requirements/phases/phase-{NN}-{name}/tasks/`.
3. Verify that at least some tasks have been executed (check for commits on the phase branch or Done checkboxes).
4. If no execution evidence found, tell the user: "Phase {N} doesn't appear to have been executed yet. Run `mpf:execute {N}` first."

## Steps

### Step 1: Spawn mpf-verifier

Launch the verifier agent:

```
agent_spawn(
  subagent_type: "mpf-verifier",
  prompt: "Verify phase {N} ({name}). Project root: {project_root}. Phase number: {N}. Phase name: {name}."
)
```

Wait for the verifier to complete.

### Step 2: Present Results

Display the verifier's report to the user with clear formatting.

### Step 3: Handle Outcome

#### If PASS (all automated checks pass)

1. Update `docs/PROJECT_ROADMAP.md`:
   - Section 2 (Current Phase): Mark the phase as "Verified", update progress to 100%
   - Section 3 (Phase Roadmap): Set phase status to "Done" (or "Verified" if manual checks remain), update progress to 100%
   - Section 7 (Session Log): Add session log entry

3. If in-repo tracking is configured, update `docs/BACKLOG.md` to mark all phase backlog items as Done. Update `docs/requirements/requirements.md` requirement statuses accordingly.

4. If there are MANUAL verification items, present them as a checklist:
   ```
   Manual verification needed:
   - [ ] UI renders the login form correctly
   - [ ] Email notifications arrive within 30 seconds

   Confirm these pass, then merge the branch.
   ```

5. Guide the user on merging:
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

3. Update `docs/PROJECT_ROADMAP.md`:
   - Section 6 (Blockers & Waiting): Add a blocker entry for each failure
   - Section 7 (Session Log): Add entry noting the verification failure

### Step 4: Linear Updates (if configured)

Check CLAUDE.md for Linear configuration. If enabled:
- To find the milestone ID: read the phase overview file at `docs/requirements/phases/phase-{NN}-{name}/overview.md` and look for the recorded milestone ID. If no milestone ID is recorded in the overview, search Linear milestones by phase name using `linear_api`. If no milestone is found, skip milestone updates and note this gap in the verification report.
- On PASS: Add a comment to the phase milestone noting verification passed
- On FAIL: Add comments to the relevant tickets noting which verifications failed

## After Final Phase

If this is the last phase in the roadmap and it passes:

1. Update `docs/PROJECT_ROADMAP.md` to reflect project completion (Section 2: Current Phase, Section 8: Phase History)
2. Tell the user: "All phases complete and verified. The project roadmap is fully implemented."
