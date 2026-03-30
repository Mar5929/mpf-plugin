# Task 02: Add consultation support to planner agent

**Requirement:** REQ-004
**Phase:** 2

## Context
Read these files before implementing:
- `agents/mpf-planner.md` -- full file. Current sections: Input, Context Loading, Task Decomposition Rules, Output, Completion. The new section goes after Completion (end of file).
- `mpf_Enhancements/phase-02-agent-orchestration/overview.md` -- success criterion 3: planner prompt includes "Consultation Support" section
- `mpf_Enhancements/PRD.md` -- US-002: planner responds with guidance when executor escalates

## Files
- `agents/mpf-planner.md` (modify) -- add Consultation Support section

## Action
Add a new section at the end of the file, after the "## Completion" section:

```markdown
## Consultation Support

During team-based execution (when `mpf:execute` creates a shared team), executor agents may send you escalation messages requesting guidance.

### When this applies
You will receive messages via `SendMessage` from executor agents that are blocked on implementation decisions. This only happens during `mpf:execute` when team-based spawning is active.

### Response format
Reply with a structured response:

```
GUIDANCE for task-{NN}
Decision: {the recommended approach}
Rationale: {why this approach, referencing the phase requirements or project conventions}
Files: {any specific file paths or patterns the executor should follow}
Note: {any spec gaps this reveals that should be reviewed post-execution}
```

### Scope of guidance
- **Do:** Clarify the spec, point to relevant patterns in existing code, recommend one approach over alternatives, reference CLAUDE.md conventions.
- **Do not:** Write implementation code, redesign the task, expand scope beyond the original task spec, or spend time re-analyzing the full phase.
- If the question reveals a genuine gap in the phase spec (missing requirement, unstated dependency), note it in your response so it can be reviewed after execution completes.

### Response style
Keep responses concise. The executor needs a clear decision, not a full analysis. One paragraph per field is sufficient.
```

## Verify
```bash
grep "Consultation Support" agents/mpf-planner.md
grep "GUIDANCE for task" agents/mpf-planner.md
grep "Scope of guidance" agents/mpf-planner.md
```

## Done
- [ ] "Consultation Support" section exists at the end of the planner agent file
- [ ] Response format is defined with Decision, Rationale, Files, and Note fields
- [ ] Scope of guidance distinguishes what the planner should and should not do
- [ ] Response style guidance emphasizes conciseness

## Dependencies
**Wave:** 1
**Depends On:** none
