# Task 04: Add inline verification step to execute command

**Requirement:** REQ-006
**Phase:** 2

## Context
Read these files before implementing:
- `commands/mpf/execute.md` -- as modified by task 2-03. The "Cross-Wave State Injection" sub-section should now exist after "Wave Completion Gate". The inline verification step goes after state injection and before the next wave starts.
- `agents/mpf-checker.md` -- to understand its interface (tools: Read, Grep, Glob; model: haiku; runs single-pass verification)
- `mpf_Enhancements/phase-02-agent-orchestration/overview.md` -- success criteria 6, 7, 8

## Files
- `commands/mpf/execute.md` (modify) -- add inline verification sub-step between waves

## Action

### 1. Add prerequisite check
In the "## Prerequisites" section (after step 4), add:

```markdown
5. Check CLAUDE.md for inline verification setting. Look for "Inline wave verification" under MPF configuration. Default: enabled if not specified.
```

### 2. Add inline verification sub-section
After the "#### Cross-Wave State Injection" sub-section (added in task 2-03), insert:

```markdown
#### Inline Verification (optional)

If inline wave verification is enabled (per CLAUDE.md or default):

1. After collecting wave results and before spawning the next wave, run the checker on completed tasks:
   ```
   Agent(
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
```

## Verify
```bash
grep "Inline Verification" commands/mpf/execute.md
grep "mpf-checker" commands/mpf/execute.md
grep "inline wave verification" commands/mpf/execute.md | head -1
grep "\[C\] Continue" commands/mpf/execute.md
```

## Done
- [ ] Prerequisite check for inline verification setting exists
- [ ] "Inline Verification" sub-section exists between state injection and next wave
- [ ] Checker is spawned on completed wave tasks
- [ ] User is presented with Continue/Stop/Retry options on failure
- [ ] Note that inline verification supplements but does not replace `mpf:verify`

## Dependencies
**Wave:** 3
**Depends On:** task-03
