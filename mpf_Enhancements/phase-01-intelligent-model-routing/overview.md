# Phase 01: Intelligent Model Routing

**Goal:** Assign Opus to agents that make high-stakes reasoning decisions (planning, verification, architecture synthesis) and keep Sonnet for agents that follow well-defined specs (execution, specialist mapping, mechanical checks). Create a central routing reference so model assignments are documented, justified, and easy to update.

## Requirements Covered

- REQ-001: Static model routing — assign Opus to planner/verifier/mapper-lead, Sonnet to executor/specialist/checker
- REQ-002: Model routing table — central reference documenting assignments and rationale

## Success Criteria

1. `agents/mpf-planner.md` frontmatter specifies `model: opus`
2. `agents/mpf-verifier.md` frontmatter specifies `model: opus`
3. `agents/mpf-mapper-lead.md` frontmatter specifies `model: opus`
4. `agents/mpf-executor.md` frontmatter remains `model: sonnet`
5. `agents/mpf-mapper-specialist.md` frontmatter remains `model: sonnet`
6. `agents/mpf-checker.md` frontmatter remains `model: haiku` (or upgraded to `sonnet` if justified)
7. `skills/mpf/references/model-routing.md` exists with a routing table, per-agent rationale, and guidance on when to reconsider assignments
8. `skills/mpf/SKILL.md` Round 8 (MPF-Specific Configuration) references the routing table and allows users to override model assignments during project init

## Dependencies

None. This is the first phase.

## Tasks

See `tasks/` directory for individual executable tasks.
