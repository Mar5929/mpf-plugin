# MPF (Mike Project Framework)

A cross-platform AI plugin for lean project management: phased execution, codebase mapping, state tracking, and atomic commits. Currently targets Claude Code, with Cursor and Codex adapters planned.

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
| `mpf:status` | Show current project status (with Linear counts, git status, sync health) |
| `mpf:sync-linear` | Compare local project state with Linear tickets; report and fix discrepancies |
| `mpf:decompose` | Break ad-hoc TODOs into structured task files without the full PRD pipeline |

## Installation

### Via Plugin System (Recommended)

In Claude Code, run:

```
/plugin marketplace add Mar5929/mpf-plugin
/plugin install mpf@Mar5929/mpf-plugin
```

This installs to **user scope** (available in all projects) by default.

For **project scope** (shared with collaborators) or **local scope** (just you, this repo only), use the interactive `/plugin` UI > Discover tab > select MPF > choose your scope.

### Via CLI Flag (Development/Testing)

```bash
git clone https://github.com/Mar5929/mpf-plugin.git ~/mpf-plugin
claude --plugin-dir ~/mpf-plugin
```

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated

### Updating

If installed via the plugin system, Claude Code handles updates automatically when the version in `plugin.json` is bumped.

If using `--plugin-dir`, pull and rebuild:

```bash
cd ~/mpf-plugin
git pull
bash build.sh
```

Then run `/reload-plugins` in your Claude session.

### Uninstalling

Via plugin system: `/plugin uninstall mpf`

Via CLI: Remove the cloned directory.

## Architecture

```
core/                          <- SOURCE OF TRUTH. Edit here.
  agents/                      <- Agent behavior specs (abstract tool/tier names)
  commands/mpf/                <- Command orchestration specs
  skills/mpf/                  <- Skill definition + reference docs
  hooks/                       <- Hook behavior specs
  model-tiers.yaml             <- Tier definitions (reasoning/standard/fast)
  tool-mappings.yaml           <- Abstract tool name mappings

adapters/claude-code/          <- Transforms core/ into Claude Code format
  generate.sh                  <- Build script
  tool-map.yaml                <- Claude Code tool + tier mappings

agents/, commands/, skills/, hooks/   <- GENERATED. Do not hand-edit.
```

### Development workflow

1. Edit files in `core/`
2. Run `bash build.sh`
3. In Claude: `/reload-plugins`
4. Test your changes

### Building adapters for other platforms

See `adapters/ADAPTER_GUIDE.md` for the adapter interface specification.

## Codebase Mapping

`mpf:map-codebase` uses a team-based approach for larger projects:

1. **Lead agent** discovers the project structure and identifies 3-8 subsystems
2. **Specialist agents** map each subsystem in parallel (one per subsystem, max 8)
3. **Lead agent** synthesizes the specialist output into top-level documentation

For small projects (1-2 subsystems), the lead handles everything inline without spawning specialists.

Output goes to `docs/technical-specs/`.

## License

Private. Not for redistribution.
