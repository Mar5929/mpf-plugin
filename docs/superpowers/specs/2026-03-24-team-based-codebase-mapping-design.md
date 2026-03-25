# Team-Based Codebase Mapping Design

## Problem

The current `mpf-mapper` is a single agent that sequentially discovers the project, identifies subsystems, maps modules, identifies patterns, and writes all documentation. For larger codebases, this is slow and context-heavy: one agent must hold the entire codebase in its working memory.

## Solution

Replace the single `mpf-mapper` agent with a team-based approach using Claude Code agent teams. A lead agent handles discovery and synthesis; specialist agents map individual subsystems in parallel.

## Parallelism Mechanism

Agent teams in Claude Code provide true parallelism. The lead uses `TeamCreate` to create a team, then spawns specialists via the `Agent` tool with the `team_name` parameter. All spawned teammates run concurrently. Specialists communicate completion via `SendMessage` to the lead and mark tasks done via `TaskUpdate`. The lead receives automatic notifications when teammates complete or go idle, so it does not need to poll.

This is different from sequential `Agent` calls (which block): team members run independently once spawned.

## Agents

### mpf-mapper-lead

```yaml
---
name: mpf-mapper-lead
description: Discover project subsystems, orchestrate parallel specialist agents, synthesize top-level technical docs.
model: sonnet
tools:
  - Read
  - Bash
  - Grep
  - Glob
  - Write
  - Agent
---
```

The lead also uses team coordination tools (TeamCreate, SendMessage, TaskCreate, TaskList, TaskUpdate) which are available as SDK primitives to any agent spawned with a `team_name`. These do not need to be declared in the frontmatter `tools` array.

### mpf-mapper-specialist

```yaml
---
name: mpf-mapper-specialist
description: Deep-dive a single subsystem and write its architecture and code-module documentation.
model: sonnet
tools:
  - Read
  - Bash
  - Grep
  - Glob
  - Write
---
```

Specialists also use SendMessage, TaskList, and TaskUpdate via team SDK primitives (not declared in frontmatter).

## Execution Flow

### Phase 1: Discovery (lead, solo)

The lead performs lightweight exploration to build a project map:

1. Read package/config files (package.json, pyproject.toml, Cargo.toml, go.mod, etc.)
2. Glob for entry points (src/index.*, src/main.*, app.*, manage.py, server.*, cmd/)
3. Run `ls` on top-level and key subdirectories
4. Read existing docs (README.md, CLAUDE.md, docs/) if present
5. Identify 3-8 logical subsystems with:
   - Name (e.g., "auth", "api", "database")
   - Root paths (e.g., `src/auth/`, `src/middleware/auth.ts`)
   - File count
   - Brief context (purpose, key dependencies on other subsystems)

### Phase 2: Parallel Mapping (specialists)

**Small project shortcut:** If 1-2 subsystems are identified, the lead skips team creation and maps them inline using the specialist logic directly. No point spawning agents for trivial parallelism.

**Standard flow (3+ subsystems):**

1. Lead creates a team: `mpf-map-{project-name}`
2. Lead creates tasks in the team task list:
   - One task per subsystem (e.g., "Map subsystem: auth")
   - Two synthesis tasks: "Write high-level-architecture.md", "Write code-atlas.md" (blocked on all subsystem tasks)
3. Lead spawns one `mpf-mapper-specialist` per subsystem (max 8) via Agent tool with `team_name` parameter. All specialists launch concurrently. Each gets a scoped prompt containing:
   - The document templates for `architecture/{subsystem}.md` and `code-modules/{module}.md` (extracted by the lead from `~/.claude/plugins/mpf/skills/mpf/references/document-templates.md` and inlined into the prompt, so specialists do not need to read plugin files)
   - Subsystem assignment details:

```
You are mapping the "{subsystem_name}" subsystem.

Project root: {project_root}
Root paths: {comma-separated paths}
File count: {count}
Context: {brief description of what this subsystem does and its dependencies}
Existing docs: {true/false}

Write these files:
- docs/technical-specs/architecture/{subsystem_name}.md
- docs/technical-specs/code-modules/{subsystem_name}.md
  (Create additional code-modules/ files if the subsystem has distinct sub-modules)

## Document Templates
{inlined architecture/{subsystem}.md template}
{inlined code-modules/{module}.md template}

Only read files within your assigned paths. Do not scan the entire codebase.
If existing_docs is true, read existing files and update rather than overwrite.

When done, mark your task as completed via TaskUpdate and send a message to the lead
with a summary of what you wrote.
```

4. Lead receives automatic notifications as specialists complete. Waits until all specialist tasks are marked done.

**Cap at 8 specialists.** If more than 8 subsystems are identified, the lead groups related subsystems (e.g., combine "auth" and "session" into one specialist assignment).

### Phase 3: Synthesis (lead, solo)

After all specialists finish:

1. Read all generated `architecture/*.md` and `code-modules/*.md` files
2. Write `docs/technical-specs/high-level-architecture.md`:
   - System overview paragraph
   - ASCII component diagram showing subsystems and their relationships
   - Component table (Component | Purpose | Tech | Dependencies)
   - Communication patterns
   - Data flow description
   - Subsystem index linking to architecture/ files
3. Write `docs/technical-specs/code-atlas.md`:
   - Architecture overview with layer diagram
   - Database schema summary (from specialist findings)
   - Backend services table, API routes, frontend components (aggregated)
   - Key patterns and conventions (cross-cutting, prescriptive)
   - Cross-cutting concerns (auth, logging, config, etc.)
   - Appendix A: file-to-module reference (aggregated from all specialists)
   - Appendix B: dependency graph (built from specialist dependency sections)
4. Mark synthesis tasks complete
5. Shut down team (send shutdown_request to all specialists)
6. Return summary to orchestrating command

## Command Changes

### mpf:map-codebase

The command's role simplifies: pre-flight checks, spawn the lead, report results.

1. Pre-flight: verify project root, check existing docs, create directories
2. Spawn `mpf-mapper-lead` with project root and existing_docs flag (using `subagent_type: "mpf-mapper-lead"`)
3. Report the lead's summary to the user
4. Recommend next step (mpf:init or mpf:discover)

The command no longer creates teams directly; the lead handles that.

## Task List Structure

The team uses TaskCreate/TaskList/TaskUpdate (team task tools), not TodoWrite. TodoWrite is for local conversation-scoped tracking; team tasks are shared across all teammates.

```
Team: mpf-map-{project-name}

| ID | Task                              | Owner            | Status  | Blocked By |
|----|-----------------------------------|------------------|---------|------------|
| 1  | Discover project shape            | lead             | done    | -          |
| 2  | Map subsystem: auth               | specialist-auth  | done    | 1          |
| 3  | Map subsystem: api                | specialist-api   | done    | 1          |
| 4  | Map subsystem: database           | specialist-db    | done    | 1          |
| 5  | Write high-level-architecture.md  | lead             | done    | 2,3,4      |
| 6  | Write code-atlas.md               | lead             | done    | 2,3,4      |
```

## Writing Rules (apply to both lead and specialists)

- **File paths are mandatory.** Every reference to code must include the actual file path in backticks.
- **Be prescriptive.** Write "Use camelCase for function names" not "Functions use camelCase."
- **Current state only.** Describe what IS, not what was or could be.
- **Include code examples.** Show real code snippets (3-10 lines max) when describing patterns.
- **Skip inapplicable sections.** No empty placeholder sections.

## Edge Cases

| Scenario | Behavior |
|----------|----------|
| 1-2 subsystems | Lead maps inline, no team creation |
| 8+ subsystems | Lead groups related subsystems, cap at 8 specialists |
| Existing docs | Specialists read existing files and update gaps, not overwrite |
| Specialist fails | Lead cleans up any partial output from the failed specialist, then maps that subsystem itself as fallback |
| Partial specialist output | If a specialist writes some files but crashes before finishing, the lead deletes the partial files and remaps the subsystem inline to ensure consistency |
| Very large subsystem (200+ files) | Lead subdivides into logical sub-areas (e.g., split "api" into "api/routes" and "api/middleware") before assigning to separate specialists |
| Monolith (no clear subsystems) | Lead identifies logical boundaries by directory structure, even if loosely coupled |

## File Changes

| File | Action |
|------|--------|
| `agents/mpf-mapper.md` | Delete (replaced by two new agents) |
| `agents/mpf-mapper-lead.md` | Create (new agent with team orchestration) |
| `agents/mpf-mapper-specialist.md` | Create (new agent for single-subsystem mapping) |
| `commands/mpf/map-codebase.md` | Rewrite (spawn mpf-mapper-lead instead of mpf-mapper) |

## Verification

Run `mpf:map-codebase` on an existing project with 3+ distinct subsystems. Verify:

1. Lead correctly identifies subsystems and their file boundaries
2. Specialists run in parallel and write scoped documentation
3. Lead synthesizes top-level files that reference all specialist output
4. Small project shortcut works (1-2 subsystems, no team created)
5. Existing docs are updated, not overwritten
6. Specialist failure fallback: kill a specialist mid-run, verify lead detects the failure, cleans up partial output, and maps the subsystem itself
