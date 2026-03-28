# Task 03: Add routing reference to SKILL.md Round 8

**Requirement:** REQ-002
**Phase:** 1

## Context
Read these files before implementing:
- `skills/mpf/SKILL.md` -- Round 8 starts at line 344. Current bullets: Agent preferences, Verification depth, Phase granularity, Doc update frequency. The new bullet goes after "Doc update frequency" (around line 373).
- `skills/mpf/references/model-routing.md` -- created in task 1-02, contains the routing table and customization section

## Files
- `skills/mpf/SKILL.md` (modify) -- add model routing configuration bullet to Round 8

## Action
In Round 8 (line 344: "### Round 8: MPF-Specific Configuration"), add a new bullet after the "Doc update frequency" bullet (after line 372) and before the `---` separator (line 374). Insert:

```markdown
- **Model routing:** Which model tier should each agent use? Default assignments are documented in `skills/mpf/references/model-routing.md` (Opus for planner/verifier/mapper-lead, Sonnet for executor/mapper-specialist, Haiku for checker). Options:
  - **Default (recommended)**: use the assignments from the routing table
  - **Custom**: specify per-agent overrides (e.g., downgrade planner to Sonnet for budget projects, upgrade executor to Opus for critical phases)
  - If custom, store the overrides in CLAUDE.md under a "Model Routing Overrides" section.
  - Default: Default
```

Also update the "MPF Agent Configuration" entry in the Phase 3 creation summary checklist (around line 409) to include model routing:
- Change `MPF Agent Configuration (which agents enabled, verification depth, phase granularity, doc update frequency)` to `MPF Agent Configuration (which agents enabled, model routing, verification depth, phase granularity, doc update frequency)`

## Verify
```bash
grep "Model routing" skills/mpf/SKILL.md
grep "model-routing.md" skills/mpf/SKILL.md
grep "model routing" skills/mpf/SKILL.md
```

## Done
- [ ] Round 8 includes a "Model routing" bullet with Default and Custom options
- [ ] The bullet references `skills/mpf/references/model-routing.md`
- [ ] Phase 3 creation summary checklist mentions model routing

## Dependencies
**Wave:** 2
**Depends On:** task-02
