# Task 10: Create Claude Code adapter README

**Requirement:** REQ-012
**Phase:** 4

## Context
Read these files before implementing:
- `adapters/claude-code/generate.sh` -- from task 4-09, to document its usage
- `adapters/claude-code/tool-map.yaml` -- from task 4-08, to document customization

## Files
- `adapters/claude-code/README.md` (create) -- adapter usage documentation

## Action
Create `adapters/claude-code/README.md` documenting the adapter:

```markdown
# Claude Code Adapter

Transforms MPF's platform-neutral core specs into a Claude Code plugin structure.

## Usage

```bash
cd adapters/claude-code
./generate.sh
```

Output is written to `dist/claude-code/` with the following structure:

```
dist/claude-code/
  .claude-plugin/plugin.json
  agents/
    mpf-planner.md
    mpf-executor.md
    mpf-verifier.md
    mpf-checker.md
    mpf-mapper-lead.md
    mpf-mapper-specialist.md
  commands/mpf/
    init.md, discover.md, map-codebase.md, plan-phases.md,
    plan-tasks.md, execute.md, verify.md, status.md, sync-linear.md
  skills/mpf/
    SKILL.md
    references/
      document-templates.md, workflow-rules.md, model-routing.md, salesforce.md
  hooks/
    doc-update-hook.sh
```

## What the adapter does

1. Reads agent specs from `core/agents/` and converts abstract tiers (`reasoning`, `standard`, `fast`) to Claude Code model names (`opus`, `sonnet`, `haiku`)
2. Converts abstract tool names (`file_read`, `shell`, `agent_spawn`) to Claude Code tool names (`Read`, `Bash`, `Agent`)
3. Wraps metadata in YAML frontmatter (`---` delimiters) as required by Claude Code's agent/command format
4. Generates the `allowed-tools:` frontmatter field for command files
5. Generates `hooks/doc-update-hook.sh` from the platform-neutral hook spec

## Customization

### Changing model mappings
Edit `tool-map.yaml` under the `tier_to_model:` section to change which Claude model each tier resolves to.

### Adding tools
Add new entries to `tool-map.yaml` under `mappings:` and reference the abstract name in core agent/command specs.

## Prerequisites

- Bash 4.0+
- Standard Unix tools: sed, awk, grep, mkdir
```

## Verify
```bash
test -f adapters/claude-code/README.md && echo "File exists"
grep "generate.sh" adapters/claude-code/README.md
grep "dist/claude-code" adapters/claude-code/README.md
grep "tool-map.yaml" adapters/claude-code/README.md
```

## Done
- [ ] `adapters/claude-code/README.md` exists
- [ ] Documents usage (how to run generate.sh)
- [ ] Documents output structure
- [ ] Explains what the adapter does (tier mapping, tool mapping, frontmatter)
- [ ] Documents customization options

## Dependencies
**Wave:** 3
**Depends On:** task-09
