# Task 03: Add Context7 tools to mapper-specialist frontmatter

**Requirement:** REQ-010
**Phase:** 3

## Context
Read these files before implementing:
- `agents/mpf-mapper-specialist.md` -- frontmatter tools list (lines 5-12): Read, Bash, Grep, Glob, Write, TaskUpdate, SendMessage. Context7 tools are added to this list.
- `mpf_Enhancements/phase-03-context7-integration/overview.md` -- success criterion 5: Context7 tools in mapper-specialist tool list

## Files
- `agents/mpf-mapper-specialist.md` (modify) -- add Context7 MCP tools to frontmatter

## Action
Add Context7 tools to the mapper-specialist's YAML frontmatter tools list. After `SendMessage`, add:

```yaml
tools:
  - Read
  - Bash
  - Grep
  - Glob
  - Write
  - TaskUpdate
  - SendMessage
  - mcp__plugin_context7_context7__resolve-library-id
  - mcp__plugin_context7_context7__query-docs
```

## Verify
```bash
grep "context7" agents/mpf-mapper-specialist.md
grep "resolve-library-id" agents/mpf-mapper-specialist.md
grep "query-docs" agents/mpf-mapper-specialist.md
```

## Done
- [ ] `mcp__plugin_context7_context7__resolve-library-id` is in the mapper-specialist's tools list
- [ ] `mcp__plugin_context7_context7__query-docs` is in the mapper-specialist's tools list

## Dependencies
**Wave:** 1
**Depends On:** none
