# Task 07: Create core hooks spec

**Requirement:** REQ-011
**Phase:** 4

## Context
Read these files before implementing:
- `hooks/doc-update-hook.sh` -- current shell script that fires on Write/Edit tool use and reminds Claude to update living docs
- `core/tool-mappings.yaml` -- from task 4-02, for abstract tool name references

## Files
- `core/hooks/doc-update-hook.md` (create) -- platform-neutral hook behavior specification

## Action
Create `core/hooks/doc-update-hook.md` as a behavioral specification (not a shell script). The adapter will generate the platform-specific implementation.

```markdown
# Hook: doc-update-hook

## Trigger
Fires after any use of `file_write` or `file_edit` tools (the platform adapter maps these to the platform's specific tool names).

## Input
The tool invocation's input, specifically the `file_path` parameter.

## Behavior

### Skip conditions
Do not fire the reminder if the modified file matches any of these patterns:
- Path contains `docs/` (documentation files, already part of the update flow)
- Path contains `.claude/` (configuration files)
- Path contains `archive/` (archived content)
- File is a config/doc file: `*.md`, `*.json`, `*.yaml`, `*.yml`, `*.toml`, `*.env*`

### Action
If the file does not match skip conditions, output a reminder:

```
[MPF] Source file modified: {file_path}. Check if code-atlas, code-modules/, or PROJECT_STATUS.md need updating.
```

### Purpose
Ensures living documentation stays synchronized with code changes. This is a soft reminder, not a blocker. The agent should evaluate whether doc updates are actually needed based on the nature of the change.

## Platform Implementation Notes
- **Claude Code:** Implemented as a PostToolUse hook in `.claude/settings.json`, triggered on `Write` and `Edit` tools. Runs as a bash script.
- **Other platforms:** Implement as the platform's equivalent of a post-tool callback or event listener. Some platforms may not support hooks, in which case this behavior can be embedded in agent instructions instead.
```

## Verify
```bash
test -f core/hooks/doc-update-hook.md && echo "File exists"
grep "file_write" core/hooks/doc-update-hook.md
grep "file_edit" core/hooks/doc-update-hook.md
grep "Skip conditions" core/hooks/doc-update-hook.md
grep "Platform Implementation Notes" core/hooks/doc-update-hook.md
```

## Done
- [ ] `core/hooks/doc-update-hook.md` exists
- [ ] Uses abstract tool names (`file_write`, `file_edit`)
- [ ] Defines trigger, skip conditions, action, and purpose
- [ ] Includes platform implementation notes for Claude Code and generic guidance

## Dependencies
**Wave:** 2
**Depends On:** task-02
