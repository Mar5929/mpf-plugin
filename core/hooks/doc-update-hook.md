# Hook: doc-update-hook

# Trigger: file_write, file_edit
# Type: post-tool

## Purpose

Reminds the agent to check whether living project documents need updating after a source file is modified. Acts as a guardrail so documentation stays in sync with code changes.

## Trigger Conditions

This hook fires after every successful `file_write` or `file_edit` tool invocation that targets a source file. The hook extracts the `file_path` from the tool's JSON input and evaluates it against the skip conditions below.

## Skip Conditions

The hook exits silently (no output, no action) when any of these are true:

- The tool input contains no extractable `file_path` value
- The modified file is inside a `docs/` directory (any depth)
- The modified file is inside a `.claude/` directory (any depth)
- The modified file is inside an `archive/` directory (any depth)
- The modified file has any of these extensions:
  - `.md` (Markdown)
  - `.json` (JSON config)
  - `.yml` or `.yaml` (YAML config)
  - `.toml` (TOML config)
  - `.lock` (lock files)
  - `.env` or any `.env*` variant (environment files)

## Action

When the hook fires (file path is present and none of the skip conditions match), it emits two messages to the agent's context:

1. **Identification**: names the source file that was modified
2. **Reminder**: prompts the agent to check whether these living documents need updating:
   - `docs/technical-specs/code-atlas.md`
   - `code-modules/` directory contents
   - `PROJECT_STATUS.md`

The agent then applies its doc-update rules (defined in `.claude/rules/mpf-doc-updates.md`) to decide whether any of those documents require changes.

## Platform Implementation Notes

### Claude Code

Map this hook to a `PostToolUse` event in the project's `.claude/settings.json`:

- **Matcher**: `Write|Edit` (the platform-specific tool names for file_write and file_edit)
- **Command**: a script or inline logic that receives `$TOOL_INPUT` as the first argument, extracts `file_path` from the JSON, applies the skip conditions, and prints the reminder messages to stdout
- **Behavior**: Claude Code surfaces the hook's stdout to the agent, which then acts on the reminder

### Generic

Any agent platform can implement this behavior by:

1. Subscribing to post-invocation events for file-writing and file-editing tools
2. Extracting the target file path from the tool's input parameters
3. Applying the skip conditions (directory and extension checks) to filter out non-source files
4. Injecting a context message that reminds the agent to review the living documentation files listed above
