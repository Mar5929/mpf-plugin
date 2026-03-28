# Task 05: Add escalation logging to executor output section

**Requirement:** REQ-004
**Phase:** 2

## Context
Read these files before implementing:
- `agents/mpf-executor.md` -- as modified by task 2-01. The "## Output" section (around line 109) currently reports: Task number, Title, Status, Commit, Files changed, Verify. The escalation log extends this output format.
- `mpf_Enhancements/PRD.md` -- US-002 acceptance criterion 4: escalation events are logged in the task file's output section

## Files
- `agents/mpf-executor.md` (modify) -- extend Output section with escalation logging

## Action
In the "## Output" section, update the completion report template to include an `Escalations` field. Change the existing output template from:

```
Task {NN}: {Title}
Status: COMPLETE / FAILED
Commit: {short hash} {commit message}
Files changed: {list}
Verify: PASS / FAIL ({details if failed})
```

To:

```
Task {NN}: {Title}
Status: COMPLETE / FAILED
Commit: {short hash} {commit message}
Files changed: {list}
Verify: PASS / FAIL ({details if failed})
Escalations: {count} or "none"
  - [{trigger type}] {one-line summary of question and resolution}
```

Add a note below the template:

```markdown
If no escalations occurred during execution, report `Escalations: none`. If escalations occurred, list each one with the trigger type (from Step 2b) and a one-line summary of the question asked and the guidance received. This log is used by the orchestrator (mpf:execute) to track how often executors need planner guidance and to identify recurring spec gaps.
```

## Verify
```bash
grep "Escalations:" agents/mpf-executor.md
grep "trigger type" agents/mpf-executor.md
```

## Done
- [ ] Output template includes `Escalations:` field
- [ ] Format shows count and per-escalation summary with trigger type
- [ ] Explanatory note describes how the log is used

## Dependencies
**Wave:** 3
**Depends On:** task-03
