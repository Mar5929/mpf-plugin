---
name: mpf:init
description: Initialize a new project with MPF scaffolding through a structured interview. Creates docs/ structure, CLAUDE.md, .claude/rules/, and project configuration. Use for greenfield projects or to add MPF to existing codebases. Also handles evolving existing MPF scaffolding (upgrade tier, add docs, change tracking).
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# mpf:init

Invoke the MPF skill by reading and following the instructions in `skills/mpf/SKILL.md`. This command is the entry point for the skill.

The skill will guide the user through a structured interview to understand their project, then generate the appropriate scaffolding: docs/ structure, CLAUDE.md, .claude/rules/, and project configuration files.

## Modes

- **New project (Init)**: Full interview and scaffolding generation for greenfield projects or existing codebases without MPF and without significant existing work.
- **Onboard**: Adapted interview and scaffolding for brownfield projects with existing requirements, code, and documentation. Auto-detected when brownfield signals are present (50+ git commits, existing requirements/spec docs, established dependencies). Guides the user through the full onboarding flow: import, audit, reconcile, sync.
- **Evolve**: Upgrade an existing MPF project (change tier, add documents, switch tracking method).

## Brownfield Projects

For brownfield projects (existing codebases with established requirements and code), `mpf:init` auto-detects brownfield signals and offers ONBOARD mode. This provides:

- Pre-filled interview answers from existing project artifacts
- Onboard-specific questions about requirement sources and existing documentation
- Post-scaffolding guidance through the full onboarding flow: `mpf:import` > `mpf:audit` > `mpf:reconcile` > `mpf:sync-linear` > `mpf:plan-phases`

If the project has no code-atlas yet, run `mpf:map-codebase` first to give init full context about the existing codebase.

## Hook Installation

Before installing the hook, verify the `.claude/` directory exists at the project root. If it does not exist, create it: `mkdir -p .claude`.

If the user selected hook-triggered doc updates (the default for Standard/Full tier), the skill installs a PostToolUse hook in `.claude/settings.json` that fires on `Write`/`Edit` tool calls. The hook script lives at `skills/mpf/hooks/doc-update-hook.sh` and prints a reminder when source files are modified, prompting Claude to check if living documents need updating.

## Placeholder and Existing File Handling

When the skill creates placeholder documentation files (e.g., technical-spec stubs), it marks them with `<!-- MPF placeholder: to be populated by mpf:discover -->` so downstream commands can distinguish placeholders from populated content. If `docs/technical-specs/code-atlas.md` or `docs/technical-specs/high-level-architecture.md` already exist (e.g., from a prior `mpf:map-codebase` run), the skill preserves them rather than overwriting with placeholders.

## After Completion

Once `mpf:init` finishes:

- **Init mode:** Instruct the user to run `mpf:discover` to create the PRD and begin structured requirement gathering.
- **Onboard mode:** Display the full onboarding flow and instruct the user to run `mpf:import` next to bring in existing requirements.
- **Evolve mode:** Summarize what was changed and suggest next steps based on the upgrade.
