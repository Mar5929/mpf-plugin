# Phase 03: Context7 Integration

**Goal:** Give agents access to current library and framework documentation so generated code uses up-to-date APIs instead of stale training data. The planner annotates each task with the libraries it requires. The executor resolves those libraries via Context7 and pulls relevant docs into its context before implementing. Mapper specialists can optionally look up unfamiliar dependencies they discover during codebase analysis.

## Requirements Covered

- REQ-007: Task file Libraries field — new field in the task template for library/framework references
- REQ-008: Planner populates Libraries — planner agent fills the Libraries field during task generation
- REQ-009: Executor Context7 lookup — executor calls Context7 before implementing tasks with library references
- REQ-010: Mapper Context7 lookup — mapper-specialist can call Context7 for unfamiliar dependencies

## Success Criteria

1. The task file template in `skills/mpf/references/document-templates.md` includes a `Libraries:` field between the `Files` and `Action` sections, with format: `- {library-name}@{version-constraint} — {what it's used for in this task}`
2. `agents/mpf-planner.md` task decomposition rules include a step to identify and list libraries each task will use, derived from the project's tech stack (CLAUDE.md), the PRD, and the phase requirements
3. `agents/mpf-executor.md` context loading includes a new step between reading the task file and reading CLAUDE.md:
   - For each library in the Libraries field, call `Context7:resolve-library-id` to get the library ID
   - Then call `Context7:query-docs` with a query relevant to the task's action to fetch current documentation
   - Include the fetched docs in working context for the implementation step
4. `agents/mpf-executor.md` tool list includes Context7 tools (`Context7:resolve-library-id`, `Context7:query-docs`)
5. `agents/mpf-mapper-specialist.md` tool list includes Context7 tools
6. `agents/mpf-mapper-specialist.md` includes guidance: "When you encounter a dependency you are unfamiliar with, call Context7 to understand its purpose and API before documenting it"
7. If Context7 resolution fails (network error, library not found), the agent logs a warning and proceeds with training knowledge — execution is never blocked by Context7 unavailability

## Dependencies

- Phase 1 (model routing — so planner uses Opus when deciding which libraries are relevant)
- Phase 2 recommended but not required (team-based execution could allow sharing Context7 results across executors, but each executor can independently call Context7)

## Tasks

See `tasks/` directory for individual executable tasks.
