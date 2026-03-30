# MPF - Mike Project Framework

A cross-platform AI plugin framework for project management with phased execution, state tracking, and atomic commits. Currently targets Claude Code, with Cursor and Codex adapters planned.

## Architecture

```
core/                          <- SOURCE OF TRUTH. Edit here.
  agents/                      <- Agent behavior specs (abstract tool/tier names)
  commands/mpf/                <- Command orchestration specs
  skills/mpf/                  <- Skill definition + reference docs
  hooks/                       <- Hook behavior specs
  model-tiers.yaml             <- Maps tiers (reasoning/standard/fast) to provider models
  tool-mappings.yaml           <- Maps abstract tool names to platform implementations

adapters/claude-code/          <- Transforms core/ into Claude Code format
  generate.sh                  <- Build script (called by build.sh)
  tool-map.yaml                <- Claude Code-specific tool + tier mappings

agents/, commands/, skills/, hooks/   <- GENERATED OUTPUT. Do not hand-edit.
```

## Workflow

1. Edit files in `core/`
2. Run `bash build.sh`
3. In your Claude session: `/reload-plugins`
4. Test your changes

## Key Rules

- **Never hand-edit** files in top-level `agents/`, `commands/`, `skills/`, or `hooks/`. They are overwritten by `build.sh`.
- Always edit `core/` files, which use abstract names (`file_read` not `Read`, `reasoning` not `opus`).
- The `core/` comment header format: `# Agent: name`, `# Tier: reasoning`, `# Tools: [file_read, shell]`

## Adding New Content

**New command:** Create `core/commands/mpf/my-command.md` with comment headers, run `bash build.sh`.

**New agent:** Create `core/agents/my-agent.md` with comment headers, run `bash build.sh`.

**New platform adapter:** Create `adapters/<platform>/` with a `generate.sh` and `tool-map.yaml`. See `adapters/claude-code/` as reference.

## Loading the Plugin

### Via Plugin System (Recommended)

```
/plugin marketplace add Mar5929/mpf-plugin
/plugin install mpf@Mar5929/mpf-plugin
```

### Via CLI Flag (Development/Testing)

```bash
claude --plugin-dir ~/mpf-plugin
```
