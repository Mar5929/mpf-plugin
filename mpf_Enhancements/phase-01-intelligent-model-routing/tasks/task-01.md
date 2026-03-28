# Task 01: Update verifier model to opus

**Requirement:** REQ-001
**Phase:** 1

## Context
Read these files before implementing:
- `agents/mpf-verifier.md` -- current frontmatter has `model: sonnet`, needs to change to `model: opus`
- `mpf_Enhancements/phase-01-intelligent-model-routing/overview.md` -- rationale: verifier performs phase-level UAT reasoning that benefits from Opus-tier depth

## Files
- `agents/mpf-verifier.md` (modify) -- change model assignment in YAML frontmatter

## Action
In the YAML frontmatter block (lines 1-11), change `model: sonnet` to `model: opus` on line 4. No other changes to the file.

**Why only this file?** All other agents already have the correct model assignments:
- `mpf-planner.md`: already `model: opus` (correct)
- `mpf-mapper-lead.md`: already `model: opus` (correct)
- `mpf-executor.md`: already `model: sonnet` (correct)
- `mpf-mapper-specialist.md`: already `model: sonnet` (correct)
- `mpf-checker.md`: already `model: haiku` (correct, mechanical validation does not need reasoning depth)

## Verify
```bash
grep "model: opus" agents/mpf-verifier.md
grep "model: opus" agents/mpf-planner.md
grep "model: opus" agents/mpf-mapper-lead.md
grep "model: sonnet" agents/mpf-executor.md
grep "model: sonnet" agents/mpf-mapper-specialist.md
grep "model: haiku" agents/mpf-checker.md
```

## Done
- [ ] `agents/mpf-verifier.md` frontmatter specifies `model: opus`
- [ ] All six agents have their expected model tier confirmed

## Dependencies
**Wave:** 1
**Depends On:** none
