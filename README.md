# MPF (Mike Project Framework)

A Claude Code plugin for lean project management: phased execution, codebase mapping, state tracking, and atomic commits.

## Commands

| Command | Description |
|---------|-------------|
| `mpf:init` | Initialize a new project with structured interview and scaffolding |
| `mpf:map-codebase` | Analyze an existing codebase and generate technical documentation |
| `mpf:discover` | Discover requirements and generate a project roadmap |
| `mpf:plan-phases` | Break a roadmap into executable phases |
| `mpf:plan-tasks` | Generate task-level plans for a phase |
| `mpf:execute` | Execute a phase plan with atomic commits |
| `mpf:verify` | Verify phase completion against acceptance criteria |
| `mpf:status` | Show current project status |

## Installation

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- Git

### Steps

1. **Clone into your Claude Code plugins directory:**

   ```bash
   # macOS / Linux
   git clone https://github.com/Mar5929/mpf-plugin.git ~/.claude/plugins/mpf

   # Windows
   git clone https://github.com/Mar5929/mpf-plugin.git %USERPROFILE%\.claude\plugins\mpf
   ```

   If `~/.claude/plugins/` does not exist yet, create it first:

   ```bash
   mkdir -p ~/.claude/plugins
   ```

2. **Restart Claude Code.** The plugin is detected automatically on startup via the `.claude-plugin/plugin.json` manifest. No settings changes needed.

3. **Verify installation.** In a Claude Code session, type any MPF command (e.g., `/mpf:status`). If the command is recognized, the plugin is loaded.

### Updating

Pull the latest changes:

```bash
cd ~/.claude/plugins/mpf
git pull
```

Then restart Claude Code.

### Uninstalling

Remove the plugin directory:

```bash
rm -rf ~/.claude/plugins/mpf
```

Then restart Claude Code.

## Architecture

```
mpf/
  .claude-plugin/
    plugin.json          # Plugin manifest
  agents/
    mpf-mapper-lead.md   # Discovers subsystems, orchestrates parallel mapping
    mpf-mapper-specialist.md  # Maps a single subsystem (spawned by lead)
    mpf-checker.md       # Validates phase output
    mpf-executor.md      # Executes task plans
    mpf-planner.md       # Generates task-level plans
    mpf-verifier.md      # Verifies phase completion
  commands/mpf/          # Slash commands (one file per command)
  hooks/                 # Git and doc-update hooks
  skills/mpf/            # Skill definitions and reference docs
    references/
      document-templates.md   # Templates for generated documentation
      workflow-rules.md       # Execution and commit conventions
```

## Codebase Mapping

`mpf:map-codebase` uses a team-based approach for larger projects:

1. **Lead agent** discovers the project structure and identifies 3-8 subsystems
2. **Specialist agents** map each subsystem in parallel (one per subsystem, max 8)
3. **Lead agent** synthesizes the specialist output into top-level documentation

For small projects (1-2 subsystems), the lead handles everything inline without spawning specialists.

Output goes to `docs/technical-specs/` with architecture diagrams, code atlases, and per-subsystem documentation.

## License

Private. Not for redistribution.
