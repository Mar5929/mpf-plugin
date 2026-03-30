# Task 09: Create Claude Code adapter generate script

**Requirement:** REQ-012
**Phase:** 4

## Context
Read these files before implementing:
- `adapters/claude-code/tool-map.yaml` -- from task 4-08, contains tool and tier mappings
- All files in `core/` -- the input to the adapter (agents, commands, skills, hooks, model-tiers.yaml, tool-mappings.yaml)
- Current root-level plugin structure (`.claude-plugin/`, `agents/`, `commands/`, `skills/`, `hooks/`) -- the expected output format
- `mpf_Enhancements/phase-04-platform-abstraction/overview.md` -- success criterion 6: generate script produces functionally equivalent output in `dist/claude-code/`

## Files
- `adapters/claude-code/generate.sh` (create) -- adapter script that transforms core/ into Claude Code plugin structure

## Action
Create `adapters/claude-code/generate.sh` as a bash script that reads `core/` and produces a complete Claude Code plugin structure in `dist/claude-code/`.

The script should:

### 1. Setup
```bash
#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CORE_DIR="$REPO_ROOT/core"
TOOL_MAP="$SCRIPT_DIR/tool-map.yaml"
OUTPUT_DIR="$REPO_ROOT/dist/claude-code"

# Clean and create output directory
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"/{.claude-plugin,agents,commands/mpf,skills/mpf/references,hooks}
```

### 2. Generate plugin.json
Copy or generate `.claude-plugin/plugin.json` with the current plugin metadata.

### 3. Transform agents
For each file in `core/agents/`:
- Read the comment-based metadata header
- Convert `tier: reasoning/standard/fast` to `model: opus/sonnet/haiku` using the tier_to_model mapping
- Convert abstract tool names to Claude Code names using the mappings section
- Wrap in YAML frontmatter (`---` delimiters)
- Write to `$OUTPUT_DIR/agents/`

### 4. Transform commands
For each file in `core/commands/mpf/`:
- Read the comment-based metadata header
- Convert tool list to `allowed-tools:` frontmatter format (comma-separated Claude Code names)
- Convert abstract tool names in the body to Claude Code names
- Wrap in YAML frontmatter
- Write to `$OUTPUT_DIR/commands/mpf/`

### 5. Transform skills and references
- Copy skill and reference files, replacing abstract tool names and tier references with Claude Code equivalents
- Write to `$OUTPUT_DIR/skills/mpf/`

### 6. Generate hooks
- Read `core/hooks/doc-update-hook.md` behavioral spec
- Generate `hooks/doc-update-hook.sh` shell script implementing the specified behavior
- Write to `$OUTPUT_DIR/hooks/`

### 7. Validation
At the end, print a summary:
```
Generated Claude Code plugin structure at: dist/claude-code/
  agents/: {count} files
  commands/mpf/: {count} files
  skills/mpf/: {count} files
  hooks/: {count} files
```

### Implementation note:
Use `sed` for simple string replacements (tool name swaps). For the metadata header to frontmatter conversion, use a combination of `grep`, `sed`, and `awk`. The script should be portable bash (no exotic dependencies). Keep it readable over clever.

## Verify
```bash
test -f adapters/claude-code/generate.sh && echo "File exists"
test -x adapters/claude-code/generate.sh && echo "Is executable" || chmod +x adapters/claude-code/generate.sh
grep "CORE_DIR" adapters/claude-code/generate.sh
grep "TOOL_MAP" adapters/claude-code/generate.sh
grep "tier_to_model\|tier: reasoning\|model: opus" adapters/claude-code/generate.sh
```

## Done
- [ ] `adapters/claude-code/generate.sh` exists and is executable
- [ ] Reads from `core/` directory
- [ ] Outputs to `dist/claude-code/` with correct directory structure
- [ ] Transforms tiers to models and abstract tools to Claude Code tools
- [ ] Handles agents, commands, skills, references, and hooks
- [ ] Prints validation summary on completion
- [ ] Script is idempotent (clean run every time)

## Dependencies
**Wave:** 3
**Depends On:** task-03, task-04, task-05, task-06, task-07
