---
name: mpf:init
description: >
  Initialize a new project with MPF scaffolding through a structured interview.
  Creates docs/ structure, CLAUDE.md, .claude/rules/, and project configuration.
  Use for greenfield projects or to add MPF to existing codebases.
  Also handles evolving existing MPF scaffolding (upgrade tier, add docs, change tracking).
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# mpf:init

Invoke the MPF skill by reading and following the instructions in `skills/mpf/SKILL.md`. This command is the entry point for the skill.

The skill will guide the user through a structured interview to understand their project, then generate the appropriate scaffolding: docs/ structure, CLAUDE.md, .claude/rules/, and project configuration files.

## Modes

- **New project**: Full interview and scaffolding generation for greenfield projects or existing codebases without MPF.
- **Evolve**: Upgrade an existing MPF project (change tier, add documents, switch tracking method).

## Brownfield Projects

For brownfield projects (existing codebases), run `mpf:map-codebase` first to analyze the codebase before running init. This gives init and discover full context about existing code structure.

## Hook Installation

Before installing the hook, verify the `.claude/` directory exists at the project root. If it does not exist, create it: `mkdir -p .claude`.

If the user selected hook-triggered doc updates (the default for Standard/Full tier), the skill installs a PostToolUse hook in `.claude/settings.json` that fires on Write/Edit tool calls. The hook script lives at `~/.claude/plugins/mpf/hooks/doc-update-hook.sh` and prints a reminder when source files are modified, prompting Claude to check if living documents need updating.

## Placeholder and Existing File Handling

When the skill creates placeholder documentation files (e.g., technical-spec stubs), it marks them with `<!-- MPF placeholder: to be populated by mpf:discover -->` so downstream commands can distinguish placeholders from populated content. If `docs/technical-specs/code-atlas.md` or `docs/technical-specs/high-level-architecture.md` already exist (e.g., from a prior `mpf:map-codebase` run), the skill preserves them rather than overwriting with placeholders.

## After Completion

Once `mpf:init` finishes, instruct the user to run `mpf:discover` to create the PRD and begin structured requirement gathering. The discover phase produces the product requirements document, technical spec, and data model that drive all subsequent phases.
