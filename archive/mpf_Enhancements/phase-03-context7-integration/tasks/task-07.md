# Task 07: Update model-routing.md with Context7 tool additions

**Requirement:** REQ-009, REQ-010
**Phase:** 3

## Context
Read these files before implementing:
- `skills/mpf/references/model-routing.md` -- created in Phase 1 task 1-02. Currently has columns: Agent, Model, Abstract Tier, Rationale, Reconsider When. Needs a Tools column to reflect which agents have Context7 access.
- `agents/mpf-executor.md` -- tools list now includes Context7 tools (after task 3-02)
- `agents/mpf-mapper-specialist.md` -- tools list now includes Context7 tools (after task 3-03)

## Files
- `skills/mpf/references/model-routing.md` (modify) -- add Tools column to routing table

## Action
Update the Agent Assignments table to include a "Key Tools" column that highlights notable tool additions beyond the standard set (Read, Write, Edit, Bash, Grep, Glob). This documents which agents have access to external documentation sources and inter-agent communication.

Update the table to:

| Agent | Model | Abstract Tier | Key Tools | Rationale | Reconsider When |
|-------|-------|---------------|-----------|-----------|-----------------|
| mpf-planner | opus | reasoning | (standard set) | Deep reasoning for dependency analysis and wave ordering | Tasks are simple enough that structured decomposition suffices |
| mpf-verifier | opus | reasoning | (standard set) | Evaluates whether implementation meets requirements | Verification becomes a mechanical checklist |
| mpf-mapper-lead | opus | reasoning | Agent, TeamCreate, SendMessage | Orchestrates parallel specialists, synthesizes architecture | Codebase is small enough for a single specialist |
| mpf-executor | sonnet | standard | SendMessage, Context7 | Follows well-defined task specs with library doc lookup | Tasks become architecturally complex |
| mpf-mapper-specialist | sonnet | standard | TaskUpdate, SendMessage, Context7 | Deep-dives a single subsystem with optional doc lookup | Subsystem requires cross-cutting understanding |
| mpf-checker | haiku | fast | (read-only subset) | Mechanical structural validation | Checks require semantic judgment |

Add a note below the table:

```markdown
**Context7 tools** (`resolve-library-id`, `query-docs`): Available to executor and mapper-specialist agents for fetching current library documentation. Usage is optional and degrades gracefully if unavailable. See NFR-003.
```

## Verify
```bash
grep "Context7" skills/mpf/references/model-routing.md
grep "Key Tools" skills/mpf/references/model-routing.md
grep "SendMessage" skills/mpf/references/model-routing.md
```

## Done
- [ ] Routing table includes "Key Tools" column
- [ ] Executor row shows SendMessage and Context7
- [ ] Mapper-specialist row shows TaskUpdate, SendMessage, and Context7
- [ ] Note explains Context7 tool purpose and graceful degradation

## Dependencies
**Wave:** 3
**Depends On:** task-05, task-06
