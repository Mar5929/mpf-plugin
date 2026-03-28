# Task 03: Create core agent specs (reasoning tier)

**Requirement:** REQ-011, REQ-013
**Phase:** 4

## Context
Read these files before implementing:
- `agents/mpf-planner.md` -- current Claude Code-specific agent spec with `model: opus` and Claude Code tool names
- `agents/mpf-verifier.md` -- current spec with `model: opus` (after Phase 1)
- `agents/mpf-mapper-lead.md` -- current spec with `model: opus`
- `core/model-tiers.yaml` -- created in task 4-01, defines tier names
- `core/tool-mappings.yaml` -- created in task 4-02, defines abstract tool names
- `mpf_Enhancements/phase-04-platform-abstraction/overview.md` -- success criteria 2, 3: abstract tiers and tool names in core specs

## Files
- `core/agents/mpf-planner.md` (create) -- platform-neutral planner spec
- `core/agents/mpf-verifier.md` (create) -- platform-neutral verifier spec
- `core/agents/mpf-mapper-lead.md` (create) -- platform-neutral mapper-lead spec

## Action
For each of the three reasoning-tier agents, create a platform-neutral version in `core/agents/`:

### Transformation rules:
1. **Frontmatter format:** Replace YAML frontmatter delimiters (`---`) with a metadata block using YAML but without the frontmatter convention (which is Claude Code-specific). Use a comment header:
   ```yaml
   # Agent: mpf-planner
   # Tier: reasoning
   # Tools: [file_read, file_write, shell, text_search, file_search]
   ```

2. **Model tier:** Replace `model: opus` with `tier: reasoning`

3. **Tool names:** Replace all Claude Code tool names with abstract equivalents per `core/tool-mappings.yaml`:
   - `Read` -> `file_read`
   - `Write` -> `file_write`
   - `Edit` -> `file_edit`
   - `Bash` -> `shell`
   - `Grep` -> `text_search`
   - `Glob` -> `file_search`
   - `Agent` -> `agent_spawn`
   - `TeamCreate` -> `team_create`
   - `SendMessage` -> `send_message`

4. **Behavioral content:** Keep ALL behavioral content (sections, rules, instructions, templates) identical. Only change the metadata and tool references.

5. **Platform-specific syntax:** Remove any Claude Code-specific syntax patterns. For example, `Agent(subagent_type: "mpf-executor")` becomes `agent_spawn(agent: "mpf-executor")`.

### Per-agent notes:
- **mpf-planner:** Has tools Read, Write, Bash, Grep, Glob. References task template from `~/.claude/plugins/mpf/` -- change to a relative reference `../skills/mpf/references/document-templates.md`.
- **mpf-verifier:** Has tools Read, Write, Bash, Grep, Glob. No special tool references.
- **mpf-mapper-lead:** Has tools Read, Bash, Grep, Glob, Write, Agent, TeamCreate, SendMessage. Agent spawn calls need abstract syntax.

## Verify
```bash
test -f core/agents/mpf-planner.md && echo "planner exists"
test -f core/agents/mpf-verifier.md && echo "verifier exists"
test -f core/agents/mpf-mapper-lead.md && echo "mapper-lead exists"
# Verify no Claude Code-specific terms remain:
grep -l "model: opus" core/agents/ 2>/dev/null && echo "FAIL: found model: opus" || echo "PASS: no model: opus"
grep -l "^  - Read$" core/agents/ 2>/dev/null && echo "FAIL: found Read tool" || echo "PASS: no Read tool"
grep "tier: reasoning" core/agents/mpf-planner.md
grep "tier: reasoning" core/agents/mpf-verifier.md
grep "tier: reasoning" core/agents/mpf-mapper-lead.md
```

## Done
- [ ] `core/agents/mpf-planner.md` exists with `tier: reasoning` and abstract tool names
- [ ] `core/agents/mpf-verifier.md` exists with `tier: reasoning` and abstract tool names
- [ ] `core/agents/mpf-mapper-lead.md` exists with `tier: reasoning` and abstract tool names
- [ ] No Claude Code-specific model names (`opus`, `sonnet`, `haiku`) in core agent files
- [ ] No Claude Code-specific tool names (`Read`, `Write`, `Bash`, etc.) in core agent files
- [ ] All behavioral content preserved identically

## Dependencies
**Wave:** 2
**Depends On:** task-01, task-02
