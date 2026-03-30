# Task 08: Create Claude Code adapter tool-map.yaml

**Requirement:** REQ-012
**Phase:** 4

## Context
Read these files before implementing:
- `core/tool-mappings.yaml` -- from task 4-02, defines abstract tool names with claude_code mappings
- `mpf_Enhancements/phase-04-platform-abstraction/overview.md` -- success criterion 5: adapters/claude-code/ contains tool-map.yaml

## Files
- `adapters/claude-code/tool-map.yaml` (create) -- Claude Code-specific tool name mappings

## Action
Create `adapters/claude-code/tool-map.yaml` that maps every abstract tool name to its Claude Code equivalent. This is the adapter's lookup table used by the generate script.

```yaml
# Claude Code Tool Mappings
# Used by generate.sh to transform abstract tool names in core/ specs
# into Claude Code-specific tool names.

mappings:
  file_read: Read
  file_write: Write
  file_edit: Edit
  shell: Bash
  text_search: Grep
  file_search: Glob
  agent_spawn: Agent
  team_create: TeamCreate
  send_message: SendMessage
  task_update: TaskUpdate
  context7_resolve: mcp__plugin_context7_context7__resolve-library-id
  context7_query: mcp__plugin_context7_context7__query-docs
  linear_api: "mcp__claude_ai_Linear__*"

# Frontmatter format for Claude Code agents:
# ---
# name: {agent-name}
# model: {resolved from model-tiers.yaml}
# tools:
#   - {tool1}
#   - {tool2}
# ---

# Frontmatter format for Claude Code commands:
# ---
# name: mpf:{command-name}
# description: {description}
# allowed-tools: {comma-separated tool list}
# ---

# Model tier mappings (from core/model-tiers.yaml -> providers.claude):
tier_to_model:
  reasoning: opus
  standard: sonnet
  fast: haiku
```

## Verify
```bash
test -f adapters/claude-code/tool-map.yaml && echo "File exists"
grep "file_read: Read" adapters/claude-code/tool-map.yaml
grep "shell: Bash" adapters/claude-code/tool-map.yaml
grep "agent_spawn: Agent" adapters/claude-code/tool-map.yaml
grep "tier_to_model:" adapters/claude-code/tool-map.yaml
```

## Done
- [ ] `adapters/claude-code/tool-map.yaml` exists
- [ ] All 13 abstract tool names mapped to Claude Code equivalents
- [ ] Includes tier_to_model section mapping abstract tiers to Claude model names
- [ ] Comments document the expected frontmatter formats

## Dependencies
**Wave:** 3
**Depends On:** task-02
