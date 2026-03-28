# Task 06: Add inline verification config to SKILL.md Round 8

**Requirement:** REQ-006
**Phase:** 2

## Context
Read these files before implementing:
- `skills/mpf/SKILL.md` -- Round 8 starts at line 344. The "Verification depth" bullet (lines 358-361) currently defines "Inline only" and "Full UAT" options. This needs to be updated to clearly describe inline-between-waves behavior.
- `commands/mpf/execute.md` -- as modified by task 2-04, to understand what the inline verification setting controls

## Files
- `skills/mpf/SKILL.md` (modify) -- update Round 8 verification depth bullet

## Action
Update the "Verification depth" bullet in Round 8 (lines 358-361) to clarify the inline-between-waves concept. Replace:

```markdown
- **Verification depth:** How thorough should verification be?
  - **Inline only**: task-level verification during execution (lighter, faster)
  - **Full UAT**: inline verification plus dedicated mpf:verify pass at phase end (more thorough)
  - Default: both (inline + full UAT)
```

With:

```markdown
- **Verification depth:** How thorough should verification be?
  - **Inline only**: after each wave completes during `mpf:execute`, the checker agent runs a quick structural verification on the wave's tasks (requirement coverage, file existence, verify commands). Problems are caught between waves before later tasks build on them. No dedicated `mpf:verify` pass at phase end.
  - **Full UAT**: inline wave verification (as above) plus a dedicated `mpf:verify` pass at phase end that performs comprehensive UAT including cross-task integration testing and acceptance criteria evaluation.
  - **None**: no inline wave verification. Only the `mpf:verify` pass at phase end. Fastest execution, but problems compound across waves.
  - Default: Full UAT
  - The setting is stored in CLAUDE.md under MPF configuration and read by `mpf:execute` at runtime.
```

## Verify
```bash
grep "inline wave verification" skills/mpf/SKILL.md
grep "between waves" skills/mpf/SKILL.md
grep "CLAUDE.md under MPF configuration" skills/mpf/SKILL.md
```

## Done
- [ ] Verification depth bullet describes inline-between-waves behavior explicitly
- [ ] Three options: Inline only, Full UAT, None
- [ ] Default is Full UAT
- [ ] Notes that setting is stored in CLAUDE.md and read by `mpf:execute`

## Dependencies
**Wave:** 4
**Depends On:** task-04
