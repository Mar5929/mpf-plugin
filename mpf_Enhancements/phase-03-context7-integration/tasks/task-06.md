# Task 06: Add Context7 lookup guidance to mapper-specialist (with graceful degradation)

**Requirement:** REQ-010
**Phase:** 3

## Context
Read these files before implementing:
- `agents/mpf-mapper-specialist.md` -- Process section, Step 1: Explore the Subsystem (lines 33-43). This step traces exports, imports, and patterns. The Context7 guidance goes here for unfamiliar dependencies.
- `agents/mpf-mapper-specialist.md` -- frontmatter tools list (as modified by task 3-03 to include Context7 tools)
- `mpf_Enhancements/phase-03-context7-integration/overview.md` -- success criteria 5, 6: mapper-specialist Context7 guidance, optional at agent discretion

## Files
- `agents/mpf-mapper-specialist.md` (modify) -- add Context7 lookup guidance to Step 1

## Action
In "### Step 1: Explore the Subsystem", after item 3 (Use Grep to trace exports, imports, patterns), add a new item 4:

```markdown
4. **Look up unfamiliar dependencies (optional):** When you encounter external dependencies you are unfamiliar with (identified via import statements, package manifests, or configuration files), call Context7 to understand them:
   a. Call `mcp__plugin_context7_context7__resolve-library-id` with the dependency name.
   b. Call `mcp__plugin_context7_context7__query-docs` with a query about the dependency's purpose and primary API.
   c. Use the fetched documentation to accurately describe how the subsystem uses the dependency in your architecture docs.

   **When to use:** Only for unfamiliar or niche dependencies where your training knowledge may be incomplete. Do not call Context7 for well-known standard libraries (e.g., `lodash`, `express`, `react`) unless the subsystem uses an unusual or advanced API from them.

   **Graceful degradation:** If Context7 fails or returns no results, proceed with available information. Note in your documentation: "Dependency: {name} (documentation not verified via Context7)." Never block mapping on Context7 unavailability.
```

## Verify
```bash
grep "unfamiliar dependencies" agents/mpf-mapper-specialist.md
grep "resolve-library-id" agents/mpf-mapper-specialist.md | grep -v "^---"
grep "Graceful degradation" agents/mpf-mapper-specialist.md
```

## Done
- [ ] Step 1 includes item 4 for Context7 lookup of unfamiliar dependencies
- [ ] Guidance is marked as optional, at the agent's discretion
- [ ] Lists when to use and when not to use (well-known vs. unfamiliar)
- [ ] Graceful degradation: proceeds with available info, notes unverified deps

## Dependencies
**Wave:** 2
**Depends On:** task-03
