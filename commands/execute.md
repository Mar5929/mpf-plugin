---
name: mpf:execute
description: Execute all tasks in a phase with wave-based parallelization and atomic commits. Creates a feature branch, spawns mpf-executor agents per task, and pushes to remote. Usage: mpf:execute <phase_number> Run after mpf:plan-tasks, before mpf:verify.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent, TeamCreate, SendMessage, mcp__claude_ai_Linear__*
---

# mpf:execute

Orchestrate task execution for a single phase by managing branches, spawning executor agents in waves, and tracking progress.

## Usage

```
mpf:execute <phase_number>
```

Example: `mpf:execute 1`

## Prerequisites

1. Read `docs/roadmap.md` to confirm the phase exists.
2. Check that task files exist in `docs/requirements/phases/phase-{NN}-{name}/tasks/`.
3. If no task files exist, tell the user: "No tasks found for Phase {N}. Run `mpf:plan-tasks {N}` first."
4. Read `CLAUDE.md` for version control configuration and Linear settings.
5. Check CLAUDE.md for inline verification setting. Look for "Inline wave verification" under MPF configuration. Default: enabled if not specified.

## Steps

### Step 1: Branch Setup

Check CLAUDE.md for version control configuration.

**If version control is enabled:**

1. Verify the current branch. If a phase branch already exists (`feature/phase-{N}-{name}`):
   - Check if it has prior commits (re-execution after verify failure).
   - Switch to the existing branch.
   - Read any verification report from a prior `mpf:verify` run to identify which tasks need re-execution.
2. If no branch exists:
   - Confirm we're on the main branch (or the branch specified in CLAUDE.md).
   - If this is Phase 2+, verify the prior phase branch has been merged to main. If not, warn the user.
   - Create the branch: `git checkout -b feature/phase-{N}-{name}`
   - Push the branch: `git push -u origin feature/phase-{N}-{name}`

**If version control is not enabled:** Skip branch management entirely.

### Step 2: Build Task Queue

Read all task files and organize by wave:

1. Parse each task file's Dependencies section for wave assignment.
2. Group tasks by wave number.
3. For re-executions (after verify failure): filter to only tasks that failed or need fixes. Skip already-completed tasks (Done checkboxes all checked and verify passing).

Present the execution plan to the user:

```
Execution Plan: Phase {N}

Wave 1 (parallel): task-01, task-02, task-03
Wave 2 (parallel): task-04, task-05
Wave 3 (sequential): task-06

Total: {count} tasks, {wave_count} waves
```

### Step 3: Execute Waves

For each wave, in order:

#### Team Setup

Create a team for this phase execution so the planner and executors can communicate:

1. Create the team:
   ```
   TeamCreate(
     name: "mpf-execute-phase-{N}",
     description: "Phase {N} execution team: planner + executors"
   )
   ```

2. Spawn the planner agent on the team (it will stay available for executor consultations throughout execution):
   ```
   Agent(
     subagent_type: "mpf-planner",
     name: "phase-{N}-planner",
     team_name: "mpf-execute-phase-{N}",
     prompt: "You are on standby for executor consultations during Phase {N} execution. Read the phase overview at {phase_overview_path} for context. Respond to any escalation messages from executors using your Consultation Support protocol.",
     run_in_background: true
   )
   ```

#### Parallel Execution (tasks in the same wave)

Check if tasks in this wave have file overlaps:
- **No overlaps:** Spawn one mpf-executor agent per task, all in parallel.
- **Overlaps detected:** Execute overlapping tasks sequentially within the wave.

For each task, spawn the executor:

```
Agent(
  subagent_type: "mpf-executor",
  team_name: "mpf-execute-phase-{N}",
  prompt: "Execute task. Task file: {task_path}. Project root: {project_root}. Phase branch: {branch_name}. Linear enabled: {true/false}. Ticket ID: {ticket_id or N/A}. Planner agent name: phase-{N}-planner.{prior_wave_context}"
)
```

If Linear is not configured, pass `linear_enabled: false` and `ticket_id: 'N/A'` to the executor. The executor uses these values to skip Linear updates in its Step 6.

```
```

#### Wave Completion Gate

After all tasks in a wave complete:
- Collect results from all executor agents.
- If any task FAILED: report the failure and ask the user whether to:
  - Continue to the next wave (if the failure doesn't block later tasks)
  - Stop execution and fix the issue
  - Retry the failed task

Only proceed to the next wave when the user confirms or all tasks passed.

#### Cross-Wave State Injection

After all tasks in a wave pass the completion gate, collect structured summaries before spawning the next wave:

1. From each completed executor's output, extract:
   - Task number and title
   - Files created or modified
   - Any deviations from the original spec
   - Key implementation decisions made

2. Format as a "Prior Wave Context" block:
   ```
   Prior Wave Context:
   - Wave {N} completed ({count} tasks):
     - task-01 ({title}): created src/models/user.ts, modified src/index.ts. No deviations.
     - task-02 ({title}): created src/auth/middleware.ts. Deviation: used JWT instead of session tokens per escalation guidance from planner.
   ```

3. Append this block to the prompt of every executor in the next wave. The executor should read this context to understand what earlier waves produced, but should not modify files from prior waves unless its own task spec explicitly lists them.

If this is the first wave (Wave 1), there is no prior wave context to inject. Skip this step.

#### Inline Verification (optional)

If inline wave verification is enabled (per CLAUDE.md or default):

1. After collecting wave results and before spawning the next wave, run the checker on completed tasks:
   ```
   Agent(
     subagent_type: "mpf-checker",
     prompt: "Verify tasks completed in Wave {N} of Phase {P}. Task files: {list of task paths from this wave}. Project root: {project_root}. Check: requirement coverage, file existence, verify commands pass. Report PASS or FAIL per task."
   )
   ```

2. Present the checker's results to the user:
   ```
   Wave {N} Inline Verification:
   - task-01: PASS
   - task-02: FAIL (missing test file: src/tests/user.test.ts)

   Options:
   [C] Continue to Wave {N+1} (proceed despite failures)
   [S] Stop execution (fix issues before continuing)
   [R] Retry failed tasks (re-run task-02)
   ```

3. If the user chooses:
   - **Continue**: proceed to the next wave. Note the failures in the execution summary.
   - **Stop**: halt execution. Report current state and recommend fixes.
   - **Retry**: re-spawn executor agents for the failed tasks only. After retry, re-run the checker. If still failing, present the options again.

4. **This does not replace `mpf:verify`.** Inline verification is a quick structural check between waves. The full `mpf:verify` pass at phase end performs comprehensive UAT including cross-task integration testing.

If inline verification is disabled, skip this step and proceed directly to the next wave after state injection.

### Step 4: Progress Tracking

After each wave completes, update `docs/PROJECT_STATUS.md`:
- Update the active tasks section
- Update the phase progress percentage (completed tasks / total tasks)

### Step 5: Completion

After all waves complete:

1. Show the execution summary:

```
Phase {N} Execution Complete

| Task | Title | Status | Commit |
|------|-------|--------|--------|
| 01 | Create User model | PASS | a1b2c3d |
| 02 | Add auth middleware | PASS | e4f5g6h |
| 03 | Write user tests | FAIL | - |

Passed: {count}/{total}
```

2. Update `docs/PROJECT_STATUS.md` with execution results.

3. If all tasks passed: Recommend "Run `mpf:verify {N}` to validate the phase before merging."

4. If some tasks failed: Show failure details and recommend fixing before verification.

## Re-execution Mode

When `mpf:execute` is run on a phase that was already partially executed:

1. Read the existing task files and check "Done" criteria. A task is considered "already done" only if ALL Done checkboxes are checked AND the task's verify commands pass when re-run. If Done checkboxes are checked but verify commands fail, the task needs re-execution to fix the regression.
2. Read the verification report at `docs/requirements/phases/phase-{NN}-{name}/verify-report.md` if it exists. Use this report to identify which tasks failed and need re-execution.
3. Build a list of tasks that need (re-)execution:
   - Tasks with unchecked Done criteria
   - Tasks flagged as FAIL in a prior verify report
   - New fix tasks added after verify failure
4. Execute only those tasks, preserving prior work.

## Error Handling

- **Branch conflicts:** If the feature branch has diverged from main, warn the user. Do not force-push or rebase without explicit permission.
- **Executor crash:** If an executor agent fails to respond, mark the task as FAILED and continue with the next task in the wave.
- **All tasks fail in a wave:** Stop execution, report the situation, and ask the user for guidance.
