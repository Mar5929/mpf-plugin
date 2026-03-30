# Task 05: Create core command specs

**Requirement:** REQ-011
**Phase:** 4

## Context
Read these files before implementing:
- All files in `commands/mpf/` -- 9 command files: init.md, discover.md, map-codebase.md, plan-phases.md, plan-tasks.md, execute.md, verify.md, status.md, sync-linear.md
- `core/tool-mappings.yaml` -- abstract tool names from task 4-02
- `core/agents/mpf-planner.md` -- reference for the metadata format pattern

## Files
- `core/commands/mpf/init.md` (create)
- `core/commands/mpf/discover.md` (create)
- `core/commands/mpf/map-codebase.md` (create)
- `core/commands/mpf/plan-phases.md` (create)
- `core/commands/mpf/plan-tasks.md` (create)
- `core/commands/mpf/execute.md` (create)
- `core/commands/mpf/verify.md` (create)
- `core/commands/mpf/status.md` (create)
- `core/commands/mpf/sync-linear.md` (create)

## Action
For each command file in `commands/mpf/`, create a platform-neutral version in `core/commands/mpf/`:

### Transformation rules:
1. **Frontmatter format:** Replace the Claude Code YAML frontmatter with a comment-based metadata header:
   ```yaml
   # Command: mpf:execute
   # Description: Execute all tasks in a phase with wave-based parallelization
   # Tools: [file_read, file_write, file_edit, shell, text_search, file_search, agent_spawn, team_create, send_message, linear_api]
   ```

2. **allowed-tools:** Replace the `allowed-tools:` frontmatter field with a `# Tools:` comment using abstract names per `core/tool-mappings.yaml`.

3. **Tool references in body:** Replace all Claude Code tool names referenced in the command body with abstract names:
   - `Agent(subagent_type: "mpf-executor")` -> `agent_spawn(agent: "mpf-executor")`
   - `TeamCreate(name: ...)` -> `team_create(name: ...)`
   - `mcp__claude_ai_Linear__*` -> `linear_api`

4. **Plugin paths:** Replace absolute plugin paths like `~/.claude/plugins/mpf/...` with relative paths from the core directory (e.g., `../skills/mpf/references/document-templates.md`).

5. **Behavioral content:** Keep all orchestration logic, steps, error handling, and user interaction identical.

### Priority:
Focus most effort on `execute.md` (the most complex command with team creation, agent spawning, state injection, and inline verification). The simpler commands (status.md, sync-linear.md) need minimal transformation beyond tool name replacements.

## Verify
```bash
ls core/commands/mpf/ | wc -l  # Should be 9
grep -rl "allowed-tools:" core/commands/mpf/ && echo "FAIL: found allowed-tools" || echo "PASS"
grep -rl "Agent(" core/commands/mpf/ && echo "FAIL: found Agent(" || echo "PASS"
grep "agent_spawn" core/commands/mpf/execute.md
grep "team_create" core/commands/mpf/execute.md
```

## Done
- [ ] All 9 command specs exist in `core/commands/mpf/`
- [ ] No `allowed-tools:` frontmatter in any core command file
- [ ] No Claude Code tool names (`Agent`, `Read`, `Write`, `Bash`, etc.) in core command files
- [ ] `execute.md` uses `agent_spawn`, `team_create`, `send_message` abstractions
- [ ] All orchestration logic preserved identically

## Dependencies
**Wave:** 2
**Depends On:** task-02
