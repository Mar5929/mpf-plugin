# Task 02: Add Context7 tools to executor frontmatter

**Requirement:** REQ-009
**Phase:** 3

## Context
Read these files before implementing:
- `agents/mpf-executor.md` -- frontmatter tools list (lines 6-12, as modified by Phase 2 to include SendMessage). Context7 tools are added to this list.
- `mpf_Enhancements/phase-03-context7-integration/overview.md` -- success criterion 4: Context7 tools in executor tool list

## Files
- `agents/mpf-executor.md` (modify) -- add Context7 MCP tools to frontmatter

## Action
Add Context7 tools to the executor's YAML frontmatter tools list. After `SendMessage` (added in Phase 2), add:

```yaml
tools:
  - Read
  - Write
  - Edit
  - Bash
  - Grep
  - Glob
  - SendMessage
  - mcp__plugin_context7_context7__resolve-library-id
  - mcp__plugin_context7_context7__query-docs
```

These are the plugin-level Context7 tool names (using the `plugin:context7:context7` MCP server prefix).

## Verify
```bash
grep "context7" agents/mpf-executor.md
grep "resolve-library-id" agents/mpf-executor.md
grep "query-docs" agents/mpf-executor.md
```

## Done
- [ ] `mcp__plugin_context7_context7__resolve-library-id` is in the executor's tools list
- [ ] `mcp__plugin_context7_context7__query-docs` is in the executor's tools list

## Dependencies
**Wave:** 1
**Depends On:** none
