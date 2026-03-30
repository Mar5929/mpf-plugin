# Task 07: Update workflow-rules.md with orchestration patterns

**Requirement:** REQ-003, REQ-004, REQ-005, REQ-006
**Phase:** 2

## Context
Read these files before implementing:
- `skills/mpf/references/workflow-rules.md` -- full file (181 lines). The "MPF Phase Execution Rules" section (lines 57-63) is the most relevant insertion point. The new orchestration patterns section goes after it.
- `commands/mpf/execute.md` -- as modified by tasks 2-03 and 2-04, for the team-based execution and inline verification details
- `agents/mpf-executor.md` -- as modified by tasks 2-01 and 2-05, for the escalation protocol and logging details

## Files
- `skills/mpf/references/workflow-rules.md` (modify) -- add orchestration patterns section

## Action
Insert a new section after "## MPF Phase Execution Rules" (after line 63) and before "## Living Document Hook Rules" (line 66). Add:

```markdown
## Agent Orchestration Rules

These rules apply when `mpf:execute` runs with team-based execution (the default for Standard and Full tier projects).

### Team-Based Execution
- The orchestrator creates a team (`mpf-execute-phase-{N}`) containing the planner and all executors for the phase.
- The planner is spawned in the background at team creation and remains available for the duration of execution.
- Executors are spawned on the same team, enabling direct communication via `SendMessage`.
- The team is dissolved after all waves complete (or execution is halted).

### Escalation Flow
- Executors encountering ambiguity check trigger conditions (missing file, ambiguous spec, scope creep, unspecified dependency) before stopping.
- On trigger match, the executor sends a structured escalation message to the planner.
- The planner responds with guidance (decision, rationale, file references).
- The executor incorporates guidance and continues. If the planner cannot resolve, the executor stops with an error report.
- All escalation events are logged in the executor's output for post-execution review.

### Cross-Wave State Injection
- After each wave completes, the orchestrator collects structured summaries from each executor (files changed, deviations, key decisions).
- These summaries are formatted as a "Prior Wave Context" block and injected into the next wave's executor prompts.
- Executors should read prior wave context to understand dependencies but should not modify files from prior waves unless explicitly listed in their task spec.
- Wave 1 has no prior context (skipped).

### Inline Verification
- If enabled, the orchestrator spawns `mpf-checker` after each wave to verify completed tasks.
- On failure, the user chooses: Continue, Stop, or Retry.
- Inline verification is a structural check, not a replacement for the comprehensive `mpf:verify` pass.
- Configuration is set during `mpf:init` Round 8 and stored in CLAUDE.md.
```

## Verify
```bash
grep "Agent Orchestration Rules" skills/mpf/references/workflow-rules.md
grep "Team-Based Execution" skills/mpf/references/workflow-rules.md
grep "Escalation Flow" skills/mpf/references/workflow-rules.md
grep "Cross-Wave State Injection" skills/mpf/references/workflow-rules.md
grep "Inline Verification" skills/mpf/references/workflow-rules.md
```

## Done
- [ ] "Agent Orchestration Rules" section exists in workflow-rules.md
- [ ] Covers team-based execution, escalation flow, cross-wave state injection, and inline verification
- [ ] Placed after MPF Phase Execution Rules and before Living Document Hook Rules
- [ ] Consistent with the changes made to execute.md and executor agent

## Dependencies
**Wave:** 4
**Depends On:** task-03, task-04
