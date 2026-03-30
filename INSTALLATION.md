# MPF Plugin Installation

## During Development

Load the plugin for a single session using `--plugin-dir` with the **full path** (Windows does not expand `~`):

```bash
claude --plugin-dir C:/Users/michael.rihm/.claude/plugins/mpf
```

To pick up code changes without restarting:

```
/reload-plugins
```

Verify it loaded by typing `/mpf:status`. If the command is recognized, the plugin is active.

### Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| `Path not found: ...~\.claude\plugins\mpf` | `~` not expanded on Windows | Use full absolute path |
| Commands not found | Commands nested in `commands/mpf/` subdirectory | Flatten to `commands/*.md` |
| Plugin not listed in `/plugin` | `--plugin-dir` plugins are session-only, not registered | Expected behavior during dev |

Run `claude doctor` to check for plugin errors.

## Publishing as an Official Plugin

To make MPF installable via `/plugin install`, it needs to be listed in a plugin marketplace (a GitHub repo with a specific structure).

### 1. Create a marketplace repo

Create a new GitHub repo (e.g., `Mar5929/claude-plugins-mpf`) with this structure:

```
plugins/
  mpf/
    .claude-plugin/
      plugin.json
    commands/
      discover.md
      execute.md
      init.md
      map-codebase.md
      plan-phases.md
      plan-tasks.md
      status.md
      sync-linear.md
      verify.md
    skills/
      mpf/
        SKILL.md
        references/
    README.md
README.md
```

The `plugins/` directory at the repo root is required. Each subdirectory under `plugins/` is one installable plugin.

### 2. Register the marketplace

Users add the marketplace once:

```
/plugin marketplace add Mar5929/claude-plugins-mpf
```

This writes an entry to `~/.claude/plugins/known_marketplaces.json`.

### 3. Install from the marketplace

After the marketplace is registered:

```
/plugin install mpf
```

This copies the plugin into `~/.claude/plugins/cache/`, registers it in `installed_plugins.json`, and loads it automatically on every session.

### 4. Alternative: Submit to the official marketplace

Open a PR to [anthropics/claude-plugins-official](https://github.com/anthropics/claude-plugins-official) adding MPF under `external_plugins/` or `plugins/`. If accepted, users can install without adding a custom marketplace:

```
/plugin install mpf
```

### Plugin manifest reference

`.claude-plugin/plugin.json`:

```json
{
  "name": "mpf",
  "description": "Mike Project Framework - lean project management with phased execution, state tracking, and atomic commits.",
  "version": "0.1.0",
  "author": {
    "name": "Michael Rihm"
  }
}
```

### Updating published plugins

Users pull updates with:

```
/plugin update mpf
```

Claude Code fetches the latest commit from the marketplace repo and replaces the cached copy.
