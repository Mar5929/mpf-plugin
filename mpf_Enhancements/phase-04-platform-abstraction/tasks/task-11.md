# Task 11: Create adapter interface design document

**Requirement:** REQ-014
**Phase:** 4

## Context
Read these files before implementing:
- `adapters/claude-code/` -- reference implementation (generate.sh, tool-map.yaml, README.md) from tasks 4-08 through 4-10
- `core/model-tiers.yaml` -- tier definitions from task 4-01
- `core/tool-mappings.yaml` -- abstract tool definitions from task 4-02
- `mpf_Enhancements/phase-04-platform-abstraction/overview.md` -- success criterion 7: ADAPTER_GUIDE.md covers all mapping topics
- `mpf_Enhancements/PRD.md` -- REQ-014 acceptance criteria

## Files
- `adapters/ADAPTER_GUIDE.md` (create) -- adapter interface design document

## Action
Create `adapters/ADAPTER_GUIDE.md` as a comprehensive guide for building platform adapters. Structure:

### 1. Overview
What an adapter does: transforms `core/` platform-neutral specs into a platform-specific plugin/extension structure.

### 2. Input: The core/ directory
Document each subdirectory and file:
- `core/agents/` -- agent behavior specs with abstract tiers and tools
- `core/commands/mpf/` -- command orchestration specs
- `core/skills/mpf/` -- skill definitions and references
- `core/hooks/` -- hook behavior specs
- `core/model-tiers.yaml` -- tier-to-model mappings
- `core/tool-mappings.yaml` -- abstract-to-platform tool mappings

### 3. Output requirements
What the adapter must produce:
- Agent definitions in the platform's format
- Command/slash-command routing in the platform's format
- Skill/reference file delivery
- Hook implementation (or equivalent)
- Plugin manifest/configuration

### 4. Mapping: Abstract tiers to models
How to read `model-tiers.yaml` and resolve `tier: reasoning` to a provider-specific model. Include the fallback strategy if a provider isn't listed.

### 5. Mapping: Abstract tools to platform tools
How to read `tool-mappings.yaml` and resolve abstract names. What to do if a platform doesn't support a tool (skip, substitute, or error).

### 6. Mapping: Command routing
How to translate MPF command names (`mpf:execute`, `mpf:verify`) to the platform's invocation mechanism (slash commands, keybindings, CLI commands, etc.).

### 7. Mapping: Platform-specific features
How to handle features that differ across platforms:
- **Agent spawning:** Claude Code uses `Agent()` with `subagent_type`; other platforms may use function calls, API requests, or subprocess spawning.
- **Teams and messaging:** Claude Code has `TeamCreate` and `SendMessage`; platforms without teams may need a different coordination pattern.
- **Hooks:** Claude Code uses PostToolUse hooks; other platforms may use event listeners, middleware, or have no equivalent.
- **Frontmatter:** Claude Code uses YAML frontmatter; other platforms may use JSON config, environment variables, or programmatic registration.

### 8. Reference implementation
Point to `adapters/claude-code/` as the reference. Walk through how it implements each mapping.

### 9. Adapter checklist
A checklist for verifying a new adapter is complete:
- [ ] All agents generated with correct model and tools
- [ ] All commands routed and accessible
- [ ] Skills and references delivered
- [ ] Hooks implemented or substituted
- [ ] Plugin manifest/config generated
- [ ] Output tested against the platform

## Verify
```bash
test -f adapters/ADAPTER_GUIDE.md && echo "File exists"
grep "Abstract tiers" adapters/ADAPTER_GUIDE.md
grep "Abstract tools" adapters/ADAPTER_GUIDE.md
grep "Command routing" adapters/ADAPTER_GUIDE.md
grep "Platform-specific features" adapters/ADAPTER_GUIDE.md
grep "Reference implementation" adapters/ADAPTER_GUIDE.md
grep "Adapter checklist" adapters/ADAPTER_GUIDE.md
```

## Done
- [ ] `adapters/ADAPTER_GUIDE.md` exists
- [ ] Covers input (core/ directory structure)
- [ ] Covers output requirements
- [ ] Covers tier-to-model mapping
- [ ] Covers tool name mapping
- [ ] Covers command routing
- [ ] Covers platform-specific features (teams, hooks, frontmatter)
- [ ] References Claude Code adapter as implementation example
- [ ] Includes adapter completeness checklist

## Dependencies
**Wave:** 4
**Depends On:** task-08, task-09
