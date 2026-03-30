# Task 02: Create core/tool-mappings.yaml

**Requirement:** REQ-011
**Phase:** 4

## Context
Read these files before implementing:
- All agent files in `agents/` -- to catalog every tool used across agents
- `mpf_Enhancements/phase-04-platform-abstraction/overview.md` -- success criterion 3: abstract tool names (file_read, file_write, etc.)

## Files
- `core/tool-mappings.yaml` (create) -- abstract tool name definitions with descriptions

## Action
Create `core/tool-mappings.yaml` cataloging every tool used by MPF agents, mapped to an abstract name:

```yaml
# Tool Mappings
# Maps abstract tool names to descriptions and platform-specific implementations.
# Platform adapters read this file to resolve tool names in agent specs.
# Each agent spec references tools by abstract name; the adapter translates.

tools:
  file_read:
    description: "Read file contents from the filesystem"
    platforms:
      claude_code: Read

  file_write:
    description: "Write a complete file to the filesystem (create or overwrite)"
    platforms:
      claude_code: Write

  file_edit:
    description: "Make targeted edits to an existing file (find and replace)"
    platforms:
      claude_code: Edit

  shell:
    description: "Execute shell commands and return output"
    platforms:
      claude_code: Bash

  text_search:
    description: "Search file contents using regex patterns (ripgrep-based)"
    platforms:
      claude_code: Grep

  file_search:
    description: "Find files by glob pattern"
    platforms:
      claude_code: Glob

  agent_spawn:
    description: "Launch a subagent to handle a task autonomously"
    platforms:
      claude_code: Agent

  team_create:
    description: "Create a named team for inter-agent communication"
    platforms:
      claude_code: TeamCreate

  send_message:
    description: "Send a message to another agent on the same team"
    platforms:
      claude_code: SendMessage

  task_update:
    description: "Update the status of a tracked task"
    platforms:
      claude_code: TaskUpdate

  context7_resolve:
    description: "Resolve a library name to its Context7 identifier"
    platforms:
      claude_code: mcp__plugin_context7_context7__resolve-library-id

  context7_query:
    description: "Fetch documentation for a resolved library from Context7"
    platforms:
      claude_code: mcp__plugin_context7_context7__query-docs

  linear_api:
    description: "Interact with Linear issue tracker (wildcard: all Linear operations)"
    platforms:
      claude_code: "mcp__claude_ai_Linear__*"
```

## Verify
```bash
test -f core/tool-mappings.yaml && echo "File exists"
grep "file_read:" core/tool-mappings.yaml
grep "shell:" core/tool-mappings.yaml
grep "agent_spawn:" core/tool-mappings.yaml
grep "context7_resolve:" core/tool-mappings.yaml
grep "claude_code:" core/tool-mappings.yaml
```

## Done
- [ ] `core/tool-mappings.yaml` exists
- [ ] Maps all 13 tools used across MPF agents
- [ ] Each tool has description and at least a claude_code platform mapping
- [ ] Abstract names are snake_case and descriptive

## Dependencies
**Wave:** 1
**Depends On:** none
