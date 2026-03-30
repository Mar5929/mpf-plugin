# Task 01: Add escalation protocol and team tools to executor agent

**Requirement:** REQ-004
**Phase:** 2

## Context
Read these files before implementing:
- `agents/mpf-executor.md` -- full file. Current tools list (lines 6-11): Read, Write, Edit, Bash, Grep, Glob. Escalation protocol goes after Step 2 (Implement) and before Step 3 (Verify). Step 2 deviation rules (line 52) currently say "Stop and return an error report" for architectural/scope issues.
- `mpf_Enhancements/phase-02-agent-orchestration/overview.md` -- escalation trigger conditions and messaging requirements
- `mpf_Enhancements/PRD.md` -- US-002 acceptance criteria

## Files
- `agents/mpf-executor.md` (modify) -- add SendMessage tool and Escalation Protocol section

## Action

### 1. Update frontmatter tools list
Add `SendMessage` to the tools list after `Glob`:
```yaml
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
  - SendMessage
```

### 2. Add Escalation Protocol section
Insert a new section between Step 2 (Implement) and Step 3 (Verify). Place it after the "Coding standards" sub-section of Step 2 (after the writing style rules bullet):

```markdown
### Step 2b: Escalation Protocol

When executing within a team (team-based execution via `mpf:execute`), you can consult the planner agent before stopping on issues that would otherwise block you.

**Trigger conditions** (escalate instead of stopping):
1. A file listed in the task as "modify" does not exist and cannot be located via search
2. The Action section is ambiguous with multiple valid interpretations that lead to different implementations
3. The task's scope appears to exceed what is described (requires touching files or systems not mentioned)
4. The task depends on an external system, API, or service not specified in the project's tech stack

**How to escalate:**
1. Send a structured message to the planner via `SendMessage`:
   ```
   ESCALATION from task-{NN}
   Trigger: {trigger type from list above}
   Context: {what you were implementing when the issue arose}
   Question: {specific question that, if answered, unblocks you}
   Options considered: {the approaches you see, with tradeoffs}
   ```
2. Wait for the planner's response.
3. Incorporate the planner's guidance and continue implementation.
4. If the planner cannot resolve the issue, stop and return an error report as in Step 2 deviation rules.

**When NOT to escalate** (handle yourself):
- Import errors, missing type declarations, minor syntax fixes (auto-fix per Step 2 deviation rules)
- Linting issues, test fixture setup
- Questions answerable by reading CLAUDE.md or existing code
```

### 3. Update Step 2 deviation rules
In the "Stop and return an error report" bullet (line 52), add a qualifier:

Change:
```
- **Stop and return an error report:** Architectural changes not in the task, new dependencies not specified, changes to files not listed in the task, scope creep beyond the task's requirements.
```

To:
```
- **Stop and return an error report (or escalate if on a team):** Architectural changes not in the task, new dependencies not specified, changes to files not listed in the task, scope creep beyond the task's requirements. If executing within a team, attempt escalation (Step 2b) before stopping.
```

## Verify
```bash
grep "SendMessage" agents/mpf-executor.md
grep "Escalation Protocol" agents/mpf-executor.md
grep "ESCALATION from task" agents/mpf-executor.md
grep "or escalate if on a team" agents/mpf-executor.md
```

## Done
- [ ] `SendMessage` is in the executor's frontmatter tools list
- [ ] "Escalation Protocol" section exists between Step 2 and Step 3
- [ ] Four trigger conditions are defined
- [ ] Structured message format is specified
- [ ] Step 2 deviation rules reference escalation as an alternative to stopping

## Dependencies
**Wave:** 1
**Depends On:** none
