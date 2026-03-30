# Task 05: Add Context7 resolution step to executor (with graceful degradation)

**Requirement:** REQ-009
**Phase:** 3

## Context
Read these files before implementing:
- `agents/mpf-executor.md` -- Context Loading section (lines 28-37). Current steps: 1. Read task file, 2. Read CLAUDE.md, 3. Read files listed in task, 4. Read code-atlas if needed. The Context7 step goes between step 1 and step 2.
- `agents/mpf-executor.md` -- frontmatter tools list (as modified by task 3-02 to include Context7 tools)
- `mpf_Enhancements/phase-03-context7-integration/overview.md` -- success criterion 3: Context7 resolution step in context loading
- `mpf_Enhancements/PRD.md` -- NFR-003: graceful degradation when Context7 unavailable

## Files
- `agents/mpf-executor.md` (modify) -- add Context7 resolution step to Context Loading section

## Action
In the "## Context Loading" section, insert a new step between step 1 (read task file) and step 2 (read CLAUDE.md). Renumber subsequent steps.

Update the ordered list to:

```markdown
Read in order:

1. The task file at `{task_file}`
2. **Library documentation (if Libraries section exists):** For each library listed in the task's `## Libraries` section:
   a. Call `mcp__plugin_context7_context7__resolve-library-id` with the library name to get its Context7 identifier.
   b. Call `mcp__plugin_context7_context7__query-docs` with the resolved library ID and a query derived from the task's Action section (e.g., if the task says "create a REST endpoint with Express," query "Express routing and middleware").
   c. Include the fetched documentation in your working context for the implementation step.
   d. **Graceful degradation:** If `resolve-library-id` returns no match, or `query-docs` fails (network error, timeout, empty response), log a warning in your output (`Context7: {library-name} not resolved, proceeding with training knowledge`) and continue. Never block execution on Context7 unavailability.
3. `{project_root}/CLAUDE.md` for coding standards, golden rules, and conventions
4. Each file listed in the task's "Files" section (if they exist, to understand current state)
5. `{project_root}/docs/technical-specs/code-atlas.md` only if you need to understand module relationships
```

Add a note after the list:

```markdown
**Context7 usage guidance:** Prefer specific queries over broad ones. "Express error handling middleware" is better than "Express documentation." If a library is well-known and the task is straightforward, a single query is sufficient. For unfamiliar libraries, query for the specific API or pattern referenced in the Action section.
```

## Verify
```bash
grep "resolve-library-id" agents/mpf-executor.md | grep -v "^---" | head -3
grep "query-docs" agents/mpf-executor.md | grep -v "^---" | head -3
grep "Graceful degradation" agents/mpf-executor.md
grep "Context7 usage guidance" agents/mpf-executor.md
```

## Done
- [ ] Context Loading step 2 describes Context7 resolution for each library
- [ ] Steps include resolve-library-id followed by query-docs
- [ ] Graceful degradation: logs warning and proceeds if Context7 fails
- [ ] Usage guidance recommends specific queries over broad ones
- [ ] Subsequent context loading steps are renumbered correctly

## Dependencies
**Wave:** 2
**Depends On:** task-02
