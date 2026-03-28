# Task 12: Update repo README with new architecture

**Requirement:** REQ-014
**Phase:** 4

## Context
Read these files before implementing:
- `README.md` -- current repo README, documents installation and architecture for the v1 plugin structure
- `adapters/ADAPTER_GUIDE.md` -- from task 4-11, the adapter interface design document
- `mpf_Enhancements/phase-04-platform-abstraction/overview.md` -- success criterion 8: README updated to reflect new architecture

## Files
- `README.md` (modify) -- add architecture section explaining core/adapter pattern

## Action
Add a new section to the README after the existing architecture content. Do not remove existing content; extend it.

Add a section titled "## Architecture: Core and Adapters" with:

### 1. Overview
MPF v2 separates platform-neutral spec content from platform-specific delivery. The `core/` directory contains all agent behaviors, command logic, skills, and references using abstract tool names and model tiers. Platform adapters transform `core/` into a platform-specific plugin structure.

### 2. Directory structure
```
mpf/
  core/                          # Platform-neutral specs
    agents/                      # Agent behavior specs (abstract tiers and tools)
    commands/mpf/                # Command orchestration logic
    skills/mpf/                  # SKILL.md and references
    hooks/                       # Hook behavior specs
    model-tiers.yaml             # Abstract tier definitions
    tool-mappings.yaml           # Abstract tool name mappings
  adapters/
    claude-code/                 # Claude Code adapter
      generate.sh                # Transforms core/ into plugin structure
      tool-map.yaml              # Claude Code tool name mappings
      README.md                  # Adapter usage docs
    ADAPTER_GUIDE.md             # How to build new adapters
  dist/
    claude-code/                 # Generated Claude Code plugin (output of adapter)
```

### 3. Using with Claude Code
The current root-level plugin structure (`.claude-plugin/`, `agents/`, `commands/`, `skills/`, `hooks/`) is the Claude Code adapter output. To regenerate after editing core specs:
```bash
cd adapters/claude-code && ./generate.sh
```

### 4. Building adapters for other platforms
See `adapters/ADAPTER_GUIDE.md` for the full adapter interface specification.

## Verify
```bash
grep "Core and Adapters" README.md
grep "core/" README.md
grep "adapters/" README.md
grep "ADAPTER_GUIDE.md" README.md
```

## Done
- [ ] README has "Architecture: Core and Adapters" section
- [ ] Explains the core/adapter separation
- [ ] Shows the new directory structure
- [ ] Documents how to regenerate the Claude Code plugin
- [ ] References ADAPTER_GUIDE.md for building new adapters

## Dependencies
**Wave:** 4
**Depends On:** task-11
