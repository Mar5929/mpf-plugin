# Phase 02: Agent Orchestration Upgrades

**Goal:** Transform phase execution from isolated parallel agent runs into a collaborative team-based model. Executors can escalate ambiguous situations to the planner. The orchestrator shares completed-wave output with subsequent waves so dependent tasks have accurate context. An optional inline checker catches problems between waves before they compound.

## Requirements Covered

- REQ-003: Team-based execution — executor and planner agents on the same team during phase execution
- REQ-004: Executor escalation protocol — defined triggers and messaging for executor-to-planner consultation
- REQ-005: Cross-wave state injection — orchestrator injects wave completion summaries into next-wave executor context
- REQ-006: Inline verification — optional checker run between waves during execution

## Success Criteria

1. The `commands/mpf/execute.md` orchestration spawns a team containing the planner agent and all wave executors
2. The `agents/mpf-executor.md` prompt includes an "Escalation Protocol" section defining:
   - Trigger conditions (missing file, ambiguous spec, multiple valid approaches, scope creep, dependency on unspecified external system)
   - Message format for consulting the planner
   - How to incorporate the planner's response and continue
3. The `agents/mpf-planner.md` prompt includes a "Consultation Support" section defining how it responds to executor queries mid-execution
4. After each wave, `commands/mpf/execute.md` collects executor output summaries (files created/modified, deviations, key decisions) and injects them into the next wave's executor prompts as a "Prior Wave Context" block
5. The inject format is documented in the executor agent prompt (what the block looks like, how to use it)
6. `commands/mpf/execute.md` supports inline verification: after each wave, optionally spawns `mpf-checker` on the completed tasks before proceeding
7. Inline verification is configurable via MPF init Round 8 (new option: "Inline wave verification: enabled/disabled") and stored in the project's CLAUDE.md
8. The checker's inline report is surfaced to the user with the option to continue, stop, or retry failed tasks

## Dependencies

- Phase 1 (model routing must be set so planner runs on Opus within the team, executors on Sonnet)

## Tasks

See `tasks/` directory for individual executable tasks.
