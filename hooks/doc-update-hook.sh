#!/usr/bin/env bash
# MPF PostToolUse hook for Write/Edit tools.
# Reminds Claude to check if living documents need updating after source file modifications.
#
# Installed by mpf:init into the project's .claude/settings.json as:
#   hooks.PostToolUse[].command = "bash ~/.claude/plugins/mpf/hooks/doc-update-hook.sh \"$TOOL_INPUT\""
#   hooks.PostToolUse[].matcher = "Write|Edit"
#
# The hook inspects the file path from tool input. If the modified file is a source
# file (not a doc or config file), it prints a reminder to stdout. Claude sees
# this output and acts on the doc update rules in .claude/rules/mpf-doc-updates.md.

INPUT="$1"

# Extract file_path from the JSON tool input
FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)

# If we couldn't extract a path, exit silently
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Skip if the modified file is inside docs/, .claude/, archive/, or is a config/doc file
case "$FILE_PATH" in
  */docs/*|*/.claude/*|*/archive/*|*.md|*.json|*.yml|*.yaml|*.toml|*.lock|*.env*)
    exit 0
    ;;
esac

echo "[MPF] Source file modified: $FILE_PATH"
echo "[MPF] Check if docs/technical-specs/code-atlas.md, code-modules/, or PROJECT_STATUS.md need updating."
