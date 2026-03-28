# Task 02: Create model routing reference table

**Requirement:** REQ-002
**Phase:** 1

## Context
Read these files before implementing:
- `agents/mpf-planner.md` -- frontmatter line 4: `model: opus`
- `agents/mpf-verifier.md` -- will be `model: opus` after task 1-01
- `agents/mpf-mapper-lead.md` -- frontmatter: `model: opus`
- `agents/mpf-executor.md` -- frontmatter: `model: sonnet`
- `agents/mpf-mapper-specialist.md` -- frontmatter: `model: sonnet`
- `agents/mpf-checker.md` -- frontmatter: `model: haiku`
- `mpf_Enhancements/PRD.md` -- NFR-002: Opus calls < 20% of total agent calls per phase

## Files
- `skills/mpf/references/model-routing.md` (create) -- central reference for all agent model assignments

## Action
Create `skills/mpf/references/model-routing.md` with the following structure:

```markdown
# Model Routing Table

## Agent Assignments

| Agent | Model | Abstract Tier | Role | Rationale | Reconsider When |
|-------|-------|---------------|------|-----------|-----------------|
| mpf-planner | opus | reasoning | Break phases into executable tasks | Deep reasoning needed for dependency analysis, wave ordering, and requirement coverage | Tasks are simple enough that structured decomposition suffices |
| mpf-verifier | opus | reasoning | Phase-level UAT and acceptance testing | Must evaluate whether implementation meets requirements, a judgment call | Verification becomes a mechanical checklist with no ambiguity |
| mpf-mapper-lead | opus | reasoning | Discover subsystems and synthesize architecture | Architectural reasoning requires understanding system boundaries and abstractions | Codebase is small enough that a single specialist can map it |
| mpf-executor | sonnet | standard | Implement a single task per spec | Follows well-defined task specs; speed and cost matter more than reasoning depth | Tasks become architecturally complex (multi-system integration) |
| mpf-mapper-specialist | sonnet | standard | Deep-dive a single subsystem | Follows structured exploration protocol within defined boundaries | Subsystem requires cross-cutting architectural understanding |
| mpf-checker | haiku | fast | Validate plan structure and coverage | Mechanical checks: template completeness, requirement coverage, wave conflicts | Checks require semantic judgment beyond structural validation |

## Cost Guidance

Per NFR-002, Opus usage should stay below 20% of total agent calls per phase. In a typical phase execution:

- **1 planner call** (Opus) to generate tasks
- **N executor calls** (Sonnet) where N = number of tasks (typically 5-15)
- **1 checker call** (Haiku) to validate the plan
- **1 verifier call** (Opus) at phase end

This gives an Opus ratio of 2/(N+3), which is under 20% for any phase with 8+ tasks. For small phases (< 8 tasks), the ratio may exceed 20% but the absolute cost remains low.

## Customization

Per-project model overrides can be configured during `mpf:init` Round 8 (MPF-Specific Configuration). Overrides are stored in the project's CLAUDE.md and take precedence over these defaults.

Common override scenarios:
- **Budget-conscious projects:** Downgrade planner to sonnet (reduces planning quality but cuts cost)
- **High-stakes projects:** Upgrade executor to opus for critical phases (increases accuracy for complex implementations)
- **Large codebases:** Upgrade mapper-specialist to opus if subsystems have deep cross-cutting concerns
```

## Verify
```bash
test -f skills/mpf/references/model-routing.md && echo "File exists"
grep "mpf-planner" skills/mpf/references/model-routing.md
grep "mpf-verifier" skills/mpf/references/model-routing.md
grep "mpf-mapper-lead" skills/mpf/references/model-routing.md
grep "mpf-executor" skills/mpf/references/model-routing.md
grep "mpf-mapper-specialist" skills/mpf/references/model-routing.md
grep "mpf-checker" skills/mpf/references/model-routing.md
grep "NFR-002" skills/mpf/references/model-routing.md
```

## Done
- [ ] `skills/mpf/references/model-routing.md` exists
- [ ] Contains all six agents with model, tier, rationale, and reconsider-when columns
- [ ] Includes cost guidance section referencing NFR-002
- [ ] Includes customization section describing per-project overrides

## Dependencies
**Wave:** 1
**Depends On:** none
