# Model Routing Table

## Agent Assignments

| Agent | Abstract Tier | Key Tools | Role | Rationale | Reconsider When |
|-------|---------------|-----------|------|-----------|-----------------|
| mpf-planner | reasoning | (standard set) | Break phases into executable tasks | Deep reasoning needed for dependency analysis, wave ordering, and requirement coverage | Tasks are simple enough that structured decomposition suffices |
| mpf-verifier | reasoning | (standard set) | Phase-level UAT and acceptance testing | Must evaluate whether implementation meets requirements, a judgment call | Verification becomes a mechanical checklist with no ambiguity |
| mpf-mapper-lead | reasoning | agent_spawn, team_create, send_message | Discover subsystems and synthesize architecture | Architectural reasoning requires understanding system boundaries and abstractions | Codebase is small enough that a single specialist can map it |
| mpf-executor | standard | send_message, context7_resolve, context7_query | Implement a single task per spec | Follows well-defined task specs with library doc lookup | Tasks become architecturally complex (multi-system integration) |
| mpf-mapper-specialist | standard | task_update, send_message, context7_resolve, context7_query | Deep-dive a single subsystem | Follows structured exploration protocol with optional doc lookup | Subsystem requires cross-cutting architectural understanding |
| mpf-checker | fast | (read-only subset) | Validate plan structure and coverage | Mechanical checks: template completeness, requirement coverage, wave conflicts | Checks require semantic judgment beyond structural validation |

**Context7 tools** (`context7_resolve`, `context7_query`): Available to executor and mapper-specialist agents for fetching current library documentation. Usage is optional and degrades gracefully if unavailable. See NFR-003.

## Cost Guidance

Per NFR-002, reasoning-tier usage should stay below 20% of total agent calls per phase. In a typical phase execution:

- **1 planner call** (reasoning tier) to generate tasks
- **N executor calls** (standard tier) where N = number of tasks (typically 5-15)
- **1 checker call** (fast tier) to validate the plan
- **1 verifier call** (reasoning tier) at phase end

This gives a reasoning-tier ratio of 2/(N+3), which is under 20% for any phase with 8+ tasks. For small phases (< 8 tasks), the ratio may exceed 20% but the absolute cost remains low.

## Customization

Per-project model overrides can be configured during `mpf:init` Round 8 (MPF-Specific Configuration). Overrides are stored in the project's CLAUDE.md and take precedence over these defaults.

Common override scenarios:
- **Budget-conscious projects:** Downgrade planner to standard tier (reduces planning quality but cuts cost)
- **High-stakes projects:** Upgrade executor to reasoning tier for critical phases (increases accuracy for complex implementations)
- **Large codebases:** Upgrade mapper-specialist to reasoning tier if subsystems have deep cross-cutting concerns
