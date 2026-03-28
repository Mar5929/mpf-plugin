# Phase 04: Platform Abstraction Layer

**Goal:** Separate MPF's intellectual content (interview logic, workflow rules, agent behaviors, document templates) from Claude Code's specific delivery format (plugin manifests, frontmatter syntax, tool names, slash commands). Define a platform-neutral "core" representation and build a Claude Code adapter that transforms it into the current plugin structure. Document the adapter interface so future adapters for Cursor, Copilot, or other tools can be written.

## Requirements Covered

- REQ-011: Core/adapter separation — separate platform-neutral specs from platform-specific delivery
- REQ-012: Claude Code adapter — adapter that generates the current v1-compatible structure (with v2 upgrades)
- REQ-013: Abstract model tiers — replace concrete model names with abstract tier names in core specs
- REQ-014: Adapter interface design doc — documentation of the adapter pattern for new platforms

## Success Criteria

1. A `core/` directory exists at the repo root with the following structure:
   ```
   core/
     agents/           # Agent behavior specs with abstract tiers and tool names
     commands/          # Command specs with platform-neutral orchestration logic
     skills/            # SKILL.md and references (content unchanged)
     hooks/             # Hook logic in platform-neutral form
     model-tiers.yaml   # Abstract tier definitions and default mappings
     tool-mappings.yaml # Abstract tool names to descriptions
   ```
2. Core agent files use `tier: reasoning` / `tier: standard` / `tier: fast` instead of `model: opus` / `model: sonnet` / `model: haiku`
3. Core agent files use abstract tool names (`file_read`, `file_write`, `file_edit`, `shell`, `text_search`, `file_search`, `agent_spawn`) instead of Claude Code names (`Read`, `Write`, `Edit`, `Bash`, `Grep`, `Glob`, `Agent`)
4. `model-tiers.yaml` maps abstract tiers to provider-specific models:
   ```yaml
   tiers:
     reasoning:
       claude: opus
       openai: o3
       description: "Complex planning, architecture, verification"
     standard:
       claude: sonnet
       openai: gpt-4.1
       description: "Code execution, following specs"
     fast:
       claude: haiku
       openai: gpt-4.1-mini
       description: "Mechanical checks, simple lookups"
   ```
5. An `adapters/claude-code/` directory contains:
   - `generate.sh` (or `.py` or `.js`): script that reads `core/` and produces the current plugin directory structure
   - `tool-map.yaml`: maps abstract tool names to Claude Code tool names
   - `README.md`: how to run the adapter, what it produces
6. Running the Claude Code adapter produces output in a `dist/claude-code/` directory that is functionally equivalent to the current root-level plugin structure (`.claude-plugin/`, `agents/`, `commands/`, `skills/`, `hooks/`)
7. `adapters/ADAPTER_GUIDE.md` documents:
   - What a platform adapter receives as input (the `core/` directory structure)
   - What it must produce as output (platform-specific plugin structure)
   - How to map abstract tiers to concrete models
   - How to map abstract tools to platform tools
   - How to translate command routing (slash commands, keybindings, etc.)
   - How to handle platform-specific features (hooks, teams, agent spawning)
8. The repo README is updated to explain the new architecture and how to use the adapter

## Dependencies

- Phases 1-3 must be complete (all content upgrades finalized before abstracting delivery)

## Tasks

See `tasks/` directory for individual executable tasks.
