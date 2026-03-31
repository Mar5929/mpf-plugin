# Model Routing Reference

## Cost Guidance

Per NFR-002, Opus usage should stay below 20% of total agent calls per phase. In a typical phase execution:

- **1 planner call** (opus) to generate tasks
- **N executor calls** (sonnet) where N = number of tasks (typically 5-15)
- **1 checker call** (haiku) to validate the plan
- **1 verifier call** (opus) at phase end

This gives an opus ratio of 2/(N+3), which is under 20% for any phase with 8+ tasks. For small phases (< 8 tasks), the ratio may exceed 20% but the absolute cost remains low.

## When to Reconsider Defaults

| Agent | Default | Upgrade When | Downgrade When |
|-------|---------|-------------|----------------|
| mpf-planner | opus | N/A (already highest) | Tasks are simple enough that structured decomposition suffices |
| mpf-verifier | opus | N/A | Verification becomes a mechanical checklist with no ambiguity |
| mpf-mapper-lead | opus | N/A | Codebase is small enough that a single specialist can map it |
| mpf-executor | sonnet | Tasks involve multi-system integration | N/A (sonnet is baseline) |
| mpf-mapper-specialist | sonnet | Subsystem has deep cross-cutting concerns | N/A |
| mpf-checker | haiku | Checks require semantic judgment beyond structural validation | N/A |

**Context7 tools** (`resolve-library-id`, `query-docs`): Available to executor and mapper-specialist agents for fetching current library documentation. Usage is optional and degrades gracefully if unavailable.

## Customization

Per-project model overrides can be configured during `mpf:init` Round 8 (MPF-Specific Configuration). Overrides are stored in the project's CLAUDE.md and take precedence over agent defaults.

Common override scenarios:
- **Budget-conscious projects:** Downgrade planner to sonnet (reduces planning quality but cuts cost)
- **High-stakes projects:** Upgrade executor to opus for critical phases (increases accuracy for complex implementations)
- **Large codebases:** Upgrade mapper-specialist to opus if subsystems have deep cross-cutting concerns
