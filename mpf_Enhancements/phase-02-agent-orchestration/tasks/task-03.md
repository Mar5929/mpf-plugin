# Task 03: Refactor execute command for team-based spawning with cross-wave state injection

**Requirement:** REQ-003, REQ-005
**Phase:** 2

## Context
Read these files before implementing:
- `commands/mpf/execute.md` -- full file (152 lines). Key areas to modify: frontmatter `allowed-tools` (line 8), Step 3: Execute Waves (line 72+), and the Agent() spawn call template (line 83-88).
- `agents/mpf-executor.md` -- to understand the executor's Input parameters and the new SendMessage/escalation capabilities from task 2-01
- `agents/mpf-planner.md` -- to understand the planner's Consultation Support from task 2-02
- `mpf_Enhancements/phase-02-agent-orchestration/overview.md` -- success criteria 1, 4, 5

## Files
- `commands/mpf/execute.md` (modify) -- add team creation, team-based spawning, and cross-wave state injection

## Action
This is the largest task in Phase 2. Make these changes to `commands/mpf/execute.md`:

### 1. Update frontmatter allowed-tools
Add `TeamCreate` and `SendMessage` to the allowed-tools list:
```
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent, TeamCreate, SendMessage, mcp__claude_ai_Linear__*
```

### 2. Add team creation to Step 3 (before wave execution)
Insert a new sub-section at the start of Step 3, before "#### Parallel Execution":

```markdown
#### Team Setup

Create a team for this phase execution so the planner and executors can communicate:

1. Create the team:
   ```
   TeamCreate(
     name: "mpf-execute-phase-{N}",
     description: "Phase {N} execution team: planner + executors"
   )
   ```

2. Spawn the planner agent on the team (it will stay available for executor consultations throughout execution):
   ```
   Agent(
     subagent_type: "mpf-planner",
     name: "phase-{N}-planner",
     team_name: "mpf-execute-phase-{N}",
     prompt: "You are on standby for executor consultations during Phase {N} execution. Read the phase overview at {phase_overview_path} for context. Respond to any escalation messages from executors using your Consultation Support protocol.",
     run_in_background: true
   )
   ```
```

### 3. Update the executor Agent() spawn call
Modify the existing executor spawn template (around line 83) to include `team_name` and prior wave context:

```markdown
For each task, spawn the executor:

```
Agent(
  subagent_type: "mpf-executor",
  team_name: "mpf-execute-phase-{N}",
  prompt: "Execute task. Task file: {task_path}. Project root: {project_root}. Phase branch: {branch_name}. Linear enabled: {true/false}. Ticket ID: {ticket_id or N/A}. Planner agent name: phase-{N}-planner.{prior_wave_context}"
)
```
```

### 4. Add cross-wave state injection
Insert a new sub-section after "#### Wave Completion Gate" and before the next wave starts:

```markdown
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
```

## Verify
```bash
grep "TeamCreate" commands/mpf/execute.md
grep "team_name" commands/mpf/execute.md
grep "Prior Wave Context" commands/mpf/execute.md
grep "Cross-Wave State Injection" commands/mpf/execute.md
grep "phase-{N}-planner" commands/mpf/execute.md
```

## Done
- [ ] Frontmatter includes `TeamCreate` and `SendMessage` in allowed-tools
- [ ] Step 3 begins with team creation (TeamCreate + planner spawn)
- [ ] Executor spawn call includes `team_name` parameter
- [ ] Cross-Wave State Injection sub-section exists after Wave Completion Gate
- [ ] Prior Wave Context format is documented with example
- [ ] First wave correctly skips state injection

## Dependencies
**Wave:** 2
**Depends On:** task-01, task-02
