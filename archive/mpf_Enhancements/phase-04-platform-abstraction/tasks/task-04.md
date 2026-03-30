# Task 04: Create core agent specs (standard and fast tier)

**Requirement:** REQ-011, REQ-013
**Phase:** 4

## Context
Read these files before implementing:
- `agents/mpf-executor.md` -- current spec with `model: sonnet`, includes Phase 2 and 3 additions (SendMessage, Context7 tools, Escalation Protocol)
- `agents/mpf-mapper-specialist.md` -- current spec with `model: sonnet`, includes Phase 3 Context7 additions
- `agents/mpf-checker.md` -- current spec with `model: haiku`
- `core/model-tiers.yaml` -- tier definitions from task 4-01
- `core/tool-mappings.yaml` -- abstract tool names from task 4-02
- `core/agents/mpf-planner.md` -- reference for the transformation pattern applied in task 4-03

## Files
- `core/agents/mpf-executor.md` (create) -- platform-neutral executor spec
- `core/agents/mpf-mapper-specialist.md` (create) -- platform-neutral mapper-specialist spec
- `core/agents/mpf-checker.md` (create) -- platform-neutral checker spec

## Action
Apply the same transformation rules from task 4-03 to the three standard/fast tier agents:

### Transformation rules (same as 4-03):
1. Replace frontmatter with comment-based metadata header
2. Replace `model: sonnet` with `tier: standard`, `model: haiku` with `tier: fast`
3. Replace all Claude Code tool names with abstractions per `core/tool-mappings.yaml`
4. Keep all behavioral content identical
5. Remove Claude Code-specific syntax patterns

### Per-agent notes:
- **mpf-executor:** Has tools Read, Write, Edit, Bash, Grep, Glob, SendMessage, Context7 (resolve + query). Replace Context7 MCP tool names: `mcp__plugin_context7_context7__resolve-library-id` -> `context7_resolve`, `mcp__plugin_context7_context7__query-docs` -> `context7_query`. The Escalation Protocol section references `SendMessage` by name -- replace with `send_message`. Tier: `standard`.
- **mpf-mapper-specialist:** Has tools Read, Bash, Grep, Glob, Write, TaskUpdate, SendMessage, Context7. Same Context7 and SendMessage transformations. Tier: `standard`.
- **mpf-checker:** Has tools Read, Grep, Glob. Tier: `fast`.

## Verify
```bash
test -f core/agents/mpf-executor.md && echo "executor exists"
test -f core/agents/mpf-mapper-specialist.md && echo "mapper-specialist exists"
test -f core/agents/mpf-checker.md && echo "checker exists"
grep "tier: standard" core/agents/mpf-executor.md
grep "tier: standard" core/agents/mpf-mapper-specialist.md
grep "tier: fast" core/agents/mpf-checker.md
# Verify no Claude Code tool names:
grep -rn "^  - Read$\|^  - Write$\|^  - Bash$" core/agents/mpf-executor.md core/agents/mpf-mapper-specialist.md core/agents/mpf-checker.md && echo "FAIL" || echo "PASS"
grep "context7_resolve" core/agents/mpf-executor.md
grep "context7_query" core/agents/mpf-executor.md
```

## Done
- [ ] `core/agents/mpf-executor.md` exists with `tier: standard` and abstract tool names
- [ ] `core/agents/mpf-mapper-specialist.md` exists with `tier: standard` and abstract tool names
- [ ] `core/agents/mpf-checker.md` exists with `tier: fast` and abstract tool names
- [ ] Context7 tool references use abstract names (`context7_resolve`, `context7_query`)
- [ ] SendMessage references use abstract name (`send_message`)
- [ ] All behavioral content preserved identically

## Dependencies
**Wave:** 2
**Depends On:** task-01, task-02
