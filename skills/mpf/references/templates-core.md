# Core Document Templates

Templates for the core documents generated during `mpf:init`. Read the relevant sections when generating each file.

---

## CLAUDE.md Structure

**Tier-dependent generation.** The full 13-section structure below applies to Full tier. Standard tier omits sections 6, 11, and 13. Light tier generates only sections 1, 2, 3, 5, 7, 8, and 12. When generating for a lower tier, skip the omitted sections entirely (don't include them as empty placeholders).

| Section | Light | Standard | Full |
|---|---|---|---|
| 1. Project Overview | Yes | Yes | Yes |
| 2. Golden Rules | Yes | Yes | Yes |
| 3. Workspace Structure | Yes | Yes | Yes |
| 4. Update Protocol | - | Yes | Yes |
| 5. Coding Standards | Yes | Yes | Yes |
| 6. Tech Stack Reference | - | - | Yes |
| 7. Key Commands | Yes | Yes | Yes |
| 8. Session Startup Checklist | Yes | Yes | Yes |
| 9. Git Commit Protocol | - | Yes | Yes |
| 10. Clarification Protocol | - | Yes | Yes |
| 11. Context Window Management | - | - | Yes |
| 12. Bug-Prevention Facts | Yes | Yes | Yes |
| 13. References | - | - | Yes |

Generate with the following **13-section structure**, tailored based on interview answers. Use HTML comment placeholders (`<!-- -->`) for values not yet known.

### Section 1: Project Overview
- Project Name and one-line description
- Stack summary (languages, frameworks, key dependencies)
- Hosting (where frontend, backend, and database are deployed)
- Repo type (mono-repo or multi-repo, package manager)
- Related projects (links to prior work or predecessor projects, if any)

### Section 2: Golden Rules
- Numbered list of invariants Claude must never violate, derived from the interview
- Always include these defaults (unless the user overrides):
  1. Ask before assuming: never guess at business logic, data model relationships, or security rules
  2. Document as you build: every change must be reflected in the living documents under `docs/` in the same response
  3. Minimize token waste: concise code, reference files by path, don't re-print unchanged files
  4. Incremental, deployable changes: each change should be small enough to test independently; never leave the project broken
  5. Always confirm data model changes with the user before proceeding
- Add any project-specific golden rules from the interview

### Section 3: Workspace Structure
- ASCII directory tree showing the full project layout
- Include `CLAUDE.md`, `.claude/rules/` listing all generated rule files, `docs/` folder with the MPF docs layout, `src/` or `apps/` directories
- Use comments to describe each directory's purpose
- Keep updated as the project evolves

**MPF docs layout example:**

```
docs/
  PROJECT_ROADMAP.md                  # Project overview, status dashboard, and phase roadmap
  MPF_GUIDE.md                        # MPF usage guide and command reference
  CHANGELOG.md                        # Change history
  decisions.md                        # Architecture Decision Records
  requirements/
    requirements.md                   # Functional and non-functional requirements
    PRD.md                            # Product Requirements Document
    REQUIREMENT_HIERARCHY.md          # Requirement traceability tree
    phases/
      phase-01-{name}/
        overview.md                   # Phase definition and success criteria
        tasks/
          task-01.md                  # Individual executable tasks
          task-02.md
      phase-02-{name}/
        overview.md
        tasks/
  technical-specs/
    TECHNICAL_SPEC.md                 # Technical design document
    DATA_MODEL.md                     # Database schema
    DATA_LINEAGE.md                   # Data flow mapping (pipeline/ETL projects)
    code-atlas.md                     # Codebase context memory
    high-level-architecture.md        # System overview and components
    architecture/
      {subsystem}.md                  # Per-subsystem documentation
    code-modules/
      {module}.md                     # Per-module code documentation
  traceability-matrix.md              # Requirement-to-ticket mapping
```

### Section 4: Living Documents: Update Protocol

For the update protocol, reference the rules file: "See `.claude/rules/document-updates.md` for the event-to-action update protocol."

Include a brief note about format rules: compact Markdown (tables and bullet lists preferred over prose), use IDs (`REQ-001`, `ADR-001`, `NFR-001`), ISO dates (`YYYY-MM-DD`).

### Section 5: Coding Standards
- Create per-language subsections based on the tech stack identified during the interview
- Each language section should cover (as applicable): strict mode / compiler settings, naming conventions, component/module patterns, state management, styling approach, data fetching patterns, form handling, file structure, import conventions
- Include a **Database** subsection covering: naming conventions, primary key strategy, timestamp columns, migration workflow, indexing strategy
- Populate with specifics from interview answers; use HTML comment placeholders for anything not yet decided

### Section 6: Tech Stack Quick Reference
- Table with columns: `Layer | Technology | Version | Purpose`
- Include rows for every applicable layer
- For web apps: Frontend Framework, UI Components, Styling, Frontend Language, Auth, Backend Framework, Backend Language, ORM, Database, Cache, Testing (Backend), Testing (Frontend), Testing (E2E), CI/CD, Frontend Hosting, Backend Hosting, Database Hosting
- Use HTML comment placeholders for rows where details aren't yet known

### Section 7: Key Commands
- Group by: **Local Development**, **Testing**, **Deployment**
- Each group uses bash code blocks with commented command descriptions
- Use HTML comment placeholders where specific commands aren't yet known

### Section 8: Session Startup Checklist
- Numbered list of files Claude should read at the start of every session, in priority order.

**Light tier variant (simplified):**
  1. `CLAUDE.md` (this file)
  2. `docs/PROJECT_ROADMAP.md` for current phase, roadmap, and session history
  3. If a task is in progress, read the relevant task file in `docs/requirements/phases/`

**If using in-repo tracking:**
  1. `CLAUDE.md` (this file)
  2. `docs/PROJECT_ROADMAP.md` for project overview, current phase, roadmap, active items, blockers, and session history
  3. `docs/technical-specs/code-atlas.md` for codebase context
  4. `docs/BACKLOG.md` for outstanding work items
  5. Skim `docs/requirements/requirements.md` if working on a feature
  6. Deliver the session-start briefing (see `.claude/rules/session-protocol.md`)

**If using external tracker + traceability matrix:**
  1. `CLAUDE.md` (this file)
  2. `docs/PROJECT_ROADMAP.md` for project overview, current phase, roadmap, active items, blockers, and session history
  3. `docs/technical-specs/code-atlas.md` for codebase context
  4. `docs/traceability-matrix.md` to understand requirement-to-ticket mapping
  5. `docs/technical-specs/TECHNICAL_SPEC.md` if working on architecture or a new feature
  6. Check external tracker for current backlog and priorities
  7. Deliver the session-start briefing (see `.claude/rules/session-protocol.md`)

### Section 9: Git Commit Protocol (include if version control enabled)
- Commit message format depends on the tracking approach:
  - **In-repo backlog:** `feat(BL-XXX): Short summary of what was done` (references backlog item IDs)
  - **External tracker:** `feat(TICKET-XXX): Short summary of what was done` (references tracker ticket IDs, e.g., `feat(RIH-150): ...` for Linear)
- Rules: only commit after tests pass, one commit per work item, include doc updates in same commit
- Branching strategy and push policy from interview
- **Note:** If the tracking approach changes (e.g., migrating from in-repo to external tracker), update the commit prefix format accordingly

### Section 10: Clarification Protocol
- Template for how Claude should present clarification questions:
  ```
  **Clarification Needed**
  Before I proceed, I need to confirm:
  1. [Specific question]
  2. [Question about data model choice]
  > My default assumption would be: [state default].
  ```
- List categories that ALWAYS require clarification (from interview). Defaults: security/auth decisions, database/data model schema changes, third-party integrations, anything contradicting the product requirements (PRD or tracker ticket acceptance criteria)

### Section 11: Context Window Management
- Rules for efficient context usage:
  1. Don't re-read files already read this session unless changed
  2. Reference by path: say "see `docs/traceability-matrix.md` REQ-003" or "see `docs/BACKLOG.md` BL-003" instead of pasting content
  3. Use `docs/` as external memory: write decisions to docs files for future sessions
  4. Read `docs/technical-specs/code-atlas.md` for code context instead of scanning source files
  5. Checkpoint conversations: if getting long, suggest starting a new chat

### Section 12: Bug-Prevention Facts
- Empty section with note: "Populated as you discover gotchas. Empty at project start."
- Format as a bullet list; add entries during development

### Section 13: References
- Table with columns: `Resource | Description`
- Populated from interview answers and updated as project evolves

---

## PROJECT_ROADMAP.md

**Purpose:** Consolidated project document combining project overview, live status dashboard, and phase roadmap. Single place to understand the project identity, current state, who owns what, phase plan, and session history. Claude updates this at the end of every session.

**Always generated:** Yes, for all tiers. Light tier gets sections 1, 2, 3, 6 only (marked in table below).

**Location:** `docs/PROJECT_ROADMAP.md`

**Metadata header (include at the top of the generated file):**
```
**Scaffolding tool:** mpf
**Scaffolding tier:** Light | Standard | Full
**Upgrade available:** Yes/No
```

**Section availability by tier:**

| Section | Light | Standard | Full |
|---|---|---|---|
| 1: Project Overview | Yes | Yes | Yes |
| 2: Current Phase | Yes | Yes | Yes |
| 3: Phase Roadmap | Yes | Yes | Yes |
| 4: Responsibility Matrix | - | Yes | Yes |
| 5: Active Work Items | - | Yes | Yes |
| 6: Blockers & Waiting | Yes | Yes | Yes |
| 7: Session Log | - | Yes | Yes |
| 8: Phase History | - | Yes | Yes |

**Conditional section (ONBOARD mode only):**

When PROJECT_ROADMAP.md is generated during ONBOARD mode and `mpf:audit` has been run, include a **Pre-MPF Work** section between Section 1 (Project Overview) and Section 2 (Current Phase):

### Pre-MPF Work

Summary of work completed before MPF adoption, based on the implementation audit.

| Requirement | Status | Evidence |
|-------------|--------|----------|
| REQ-001: {title} | Done | {file paths} |
| REQ-003: {title} | Partial | {file paths, what's missing} |
| REQ-007: {title} | Done | {file paths} |

**Completed:** {N} of {total} requirements fully implemented
**Partial:** {N} requirements need additional work
**Remaining:** {N} requirements not started

Detailed audit: `docs/requirements/audit-report.md`

_Phases in Section 3 (Phase Roadmap) cover only remaining and partial work. Completed requirements are recorded here, not re-planned._

**Structure:**

### Section 1: Project Overview

- **Project Name** and one-paragraph description
- **Problem Statement:** what problem the project solves and for whom
- **Target Users:** brief description of primary users
- **Tech Stack:** summary table or bullet list of key technologies
- **Key Decisions:** link to `docs/decisions.md` for the full ADR log; optionally list the 2-3 most important architectural decisions inline

### Section 2: Current Phase

- Phase name and number (e.g., "Phase 2: User Auth")
- One-line description of what this phase covers
- Phase start date
- Target completion (if known)
- Next phase preview (what comes after this)
- Progress bar:
  ```
  Phase 2: User Auth  |  ████████░░░░░░░░  48%
  ```

### Section 3: Phase Roadmap

#### Phase Summary

| Phase | Name | Status | Progress |
|---|---|---|---|
| 1 | Foundation | Done | ████████████████ 100% |
| 2 | User Auth | In Progress | ████████░░░░░░░░ 48% |
| 3 | Core Features | Not Started | ░░░░░░░░░░░░░░░░ 0% |

#### Phase Details

One section per phase:

```markdown
### Phase {NN}: {Name}

**Goal:** {one-paragraph description}

**Requirements Covered:** REQ-001, REQ-002, REQ-005

**Success Criteria:**
1. {criterion}
2. {criterion}

**Estimated Scope:** {number of tasks} tasks across {number of waves} waves
```

### Section 4: Responsibility Matrix

Table with columns: `Area | Owner | Exceptions`

Owner values:
- **Claude (auto):** Claude does this automatically with no user input needed
- **Claude (proposes):** Claude drafts or proposes, user reviews/approves
- **User (decides):** User makes the decision, Claude executes if asked
- **Shared:** Both contribute; Claude drafts, user reviews

Default matrix (adapt based on which docs/workflows are enabled):

| Area | Owner | Exceptions |
|---|---|---|
| code-atlas.md | Claude (auto) | New top-level modules: naming approval needed |
| CHANGELOG.md | Claude (auto) | - |
| TECHNICAL_SPEC.md | Shared | Claude drafts sections, user reviews before finalizing |
| DATA_MODEL.md | User (decides) | Claude proposes changes, user must confirm before any schema modification |
| traceability-matrix.md | Claude (auto) | Phase reassignments: user approval needed | *(external tracker only)* |
| BACKLOG.md | Claude (auto) | Priority changes: user approval needed | *(in-repo tracking only)* |
| requirements.md | Shared | Claude updates status, user approves scope changes | *(in-repo tracking only)* |
| decisions.md | Shared | Claude records decisions from conversation, user confirms status |
| PRD / Requirements | User (decides) | Claude flags contradictions but does not modify |
| Tracker ticket status | Claude (auto) | Follows ticket lifecycle protocol | *(external tracker only)* |
| Git commits | Claude (auto) | Follows git protocol; force pushes: never |
| Git branching | Claude (auto) | Branch deletion: user approval needed |
| Dependency upgrades | User (decides) | Claude flags outdated deps, user approves upgrades |
| Security/auth changes | User (decides) | Claude always asks first |

Only include rows for enabled workflows. Rows marked *(external tracker only)* should only appear if the project uses an external tracker (e.g., Linear). Rows marked *(in-repo tracking only)* should only appear if the project uses in-repo tracking.

### Section 5: Active Work Items

Table with columns: `ID | Title | Status | Assignee | Blockers`

- Pull from external tracker or BACKLOG.md depending on tracking approach
- Show only active and blocked items (not backlog/done)
- Include a count: "3 active, 1 blocked, 12 in backlog"

### Section 6: Blockers & Waiting

Table with columns: `Item | Blocked By | Since | Action Needed`

- External blockers (waiting on a person, API access, decision)
- Internal blockers (depends on another ticket, needs design decision)
- Include who needs to act (user, external stakeholder, Claude)

### Section 7: Session Log

Table with columns: `Date | Session Summary | Docs Updated | Next Up`

- Claude appends a row at the end of every session
- Keep the last 10 sessions; move older entries to a "Previous Sessions" collapsed section or archive
- "Docs Updated" column lists which living docs were modified (e.g., "code-atlas, CHANGELOG, LINEAR:RIH-54 to Done")
- "Next Up" column is Claude's suggestion for what to work on next session

### Section 8: Phase History

Table with columns: `Phase | Focus | Started | Completed | Key Outcomes`

- Completed phases with a one-line summary of what was accomplished
- Current phase row has Completed = "In Progress"

---

## README.md

**Purpose:** Standard project README for humans and GitHub.

**Structure:**
- Project name heading with one-line description
- **What's Inside**: ASCII directory tree
- **Quick Start**: Prerequisites, Clone & Install, Environment Setup, Start Development, Run Tests
- **Architecture Overview**: brief description, summary table
- **Documentation**: index table linking to each doc file
- **Key Commands**: grouped bash code blocks
- **Contributing**: brief guidelines
- **License**: reference

---

## GETTING_STARTED.md

**Purpose:** Bootstrap prompt for Claude at the start of each new session.

**Structure:**
- Read `CLAUDE.md`, then docs in priority order
- If migration: note original source location
- Summary of what `docs/` contains
- If using in-repo tracking, direct Claude to start with the first backlog item (`BL-001`). If using an external tracker, direct Claude to start with the first ticket ID from the tracker.
- Keep concise: bootstrap prompt, not full spec

---

## MIGRATION_REFERENCE.md

**Purpose:** Rosetta Stone between original and new codebases.

**Structure (7 sections):**
1. **Service / Module Layer Mapping**: per-module tables: `Original | New | Change Notes`
2. **UI Component Mapping**: `Original Feature | New Implementation`
3. **Data Model Mapping**: Object/Table Mapping, Field Type Translation
4. **Pattern Translation Guide**: side-by-side code blocks
5. **API Mapping**: Original to New Endpoint Map
6. **Constants & Enums Reference**: carried forward, removed
7. **Key Differences Summary**: `Original Limitation / Pattern | New Solution`

---

## MPF_GUIDE.md

**Purpose:** Instructional guide for using MPF commands and workflows. Generated during `mpf:init` for all tiers. Adapted based on tier, tracking approach, and project type.

**Always generated:** Yes, for all tiers.

**Location:** `docs/MPF_GUIDE.md`

**Structure:**

### What is MPF?

One-paragraph explanation of the Mike Project Framework: what it does, why it exists, and how it helps manage projects through phased execution with AI agents.

### Quick Reference: Commands

| Command | Purpose | When to Use |
|---|---|---|
| `mpf:init` | Initialize or upgrade project scaffolding | Starting a new project or upgrading an existing one |
| `mpf:discover` | Create the PRD and flesh out requirements | After init, when requirements need to be defined |
| `mpf:plan-phases` | Break requirements into implementation phases | After PRD is complete |
| `mpf:plan-tasks` | Break a phase into executable tasks | Before implementing a phase |
| `mpf:execute` | Implement tasks for a phase | When tasks are planned and ready |
| `mpf:verify` | Verify phase completion against acceptance criteria | After executing a phase |
| `mpf:decompose` | Break ad-hoc TODOs into tasks | Quick task breakdown without the full PRD pipeline |
| `mpf:status` | Show project dashboard | Any time, to check current state |
| `mpf:next` | Auto-detect and route to the next workflow step | Any time, to advance the workflow |
| `mpf:help` | Show command quick reference | Any time |
| `mpf:sync-linear` | Sync local state with Linear | When using Linear tracking, to detect drift |
| `mpf:map-codebase` | Analyze codebase and generate architecture docs | Before init on existing codebases, or to refresh code atlas |
| `mpf:import` | Import requirements from external sources | Bringing existing requirements into MPF format |
| `mpf:audit` | Assess implementation status of requirements | After import, to determine what's already built |
| `mpf:reconcile` | Align existing docs with MPF structure | After audit, to handle document overlap |

### Workflows

#### Greenfield Project (New from Scratch)

1. `mpf:init` to scaffold the project
2. `mpf:discover` to create the PRD
3. `mpf:plan-phases` to break work into phases
4. For each phase:
   a. `mpf:plan-tasks <N>` to create executable tasks
   b. `mpf:execute <N>` to implement
   c. `mpf:verify <N>` to confirm completion

#### Brownfield Project (Existing Codebase)

1. `mpf:map-codebase` to analyze what exists
2. `mpf:init` (enters Onboard mode automatically)
3. `mpf:import` to bring in existing requirements
4. `mpf:audit` to assess implementation status
5. `mpf:reconcile` to align existing docs with MPF
6. `mpf:sync-linear` to check tracker alignment
7. `mpf:plan-phases` to plan remaining work
8. Continue with plan-tasks, execute, verify per phase

#### Ad-Hoc Task (Quick TODO)

1. `mpf:decompose` with your TODO list
2. `mpf:execute <N>` to implement
3. `mpf:verify <N>` to confirm

#### Upgrading Your Project

Run `mpf:init` on an existing MPF project to enter Evolve mode. Options: upgrade tier, add documents, change tracking approach, or refresh the dashboard.

### Document Map

| Document | Purpose | Updated By |
|---|---|---|
| `CLAUDE.md` | Project configuration and rules | `mpf:init` (generated), manual edits |
| `docs/PROJECT_ROADMAP.md` | Project overview, status, and phase roadmap | `mpf:plan-phases`, session end updates |
| `docs/requirements/PRD.md` | Product requirements | `mpf:discover` |
| `docs/requirements/requirements.md` | Atomic requirements (in-repo tracking) | `mpf:discover`, manual |
| `docs/traceability-matrix.md` | Requirement-to-ticket mapping (external tracking) | `mpf:plan-phases`, `mpf:plan-tasks` |
| `docs/technical-specs/TECHNICAL_SPEC.md` | Technical design | `mpf:discover`, manual |
| `docs/technical-specs/code-atlas.md` | Codebase context memory | `mpf:map-codebase`, auto-updated |
| `docs/CHANGELOG.md` | Change history | Auto-updated on commits |
| `docs/decisions.md` | Architecture Decision Records | Manual |

_(Adapt this table based on which documents are enabled for the project.)_

### Tips

- Run `mpf:status` at any time to see where you are
- Run `mpf:next` to auto-advance to the next step
- Each MPF command builds on the outputs of the previous one in the workflow
- Task files in `docs/requirements/phases/` are the atomic units of work
- The planner agent creates tasks; the executor agent implements them; the verifier agent checks them
- For quick one-off tasks, `mpf:decompose` skips the full PRD pipeline
- Keep `docs/PROJECT_ROADMAP.md` open as your project dashboard
- Session protocol (if enabled) gives Claude reading-order instructions at session start

---

## .claude/rules/ Directory

**Purpose:** Project-specific rules that auto-load into every Claude Code conversation. These contain behavioral constraints Claude must always follow, without relying on CLAUDE.md being explicitly read. CLAUDE.md remains the comprehensive human-readable reference; rules files ensure enforcement.

**Location:** `.claude/rules/` at the project root (not the global `~/.claude/rules/`).

**Key principle:** Rules files contain **only behavioral constraints**: the "must do / must not do" rules that Claude must follow automatically. CLAUDE.md contains the full project reference including context that rules files should not duplicate: workspace structure, tech stack details, key commands, session startup checklist, bug-prevention facts, and references. Do not duplicate content between CLAUDE.md and rules files. Rules files should reference CLAUDE.md sections where appropriate (e.g., "See CLAUDE.md Section 6 for the full tech stack") rather than repeating the information. The only exception is the Golden Rules, which appear in both places because they are the most critical invariants and benefit from redundancy.

### golden-rules.md (always created)

```markdown
## Golden Rules

[Numbered list of invariants from CLAUDE.md Section 2, derived from interview]

## Clarification Protocol

Categories that ALWAYS require clarification before proceeding:
- [List from interview, including defaults: security/auth, database schema changes,
  third-party integrations, anything contradicting the product requirements]

Template:
**Clarification Needed**
Before I proceed, I need to confirm:
1. [Specific question]
> My default assumption would be: [state default].

## Context Refresh Trigger

After every 10th turn in a session, re-read:
1. This file (golden-rules.md) to refresh behavioral constraints
2. `docs/PROJECT_ROADMAP.md` Section 5 (Active Work Items) to stay oriented

This is a lightweight refresh, not a full re-read of all docs.

## Session Start Invariant

You must NEVER begin working on a task without first completing the session-start protocol. If the user immediately asks you to do something before you've delivered the briefing, deliver the briefing first (it takes 10 seconds), then address their request.
```

### coding-standards.md (always created)

```markdown
## Coding Standards

[Per-language subsections from CLAUDE.md Section 5]
[Database conventions subsection if applicable]
```

### document-updates.md (created if any living documents are enabled)

**If using in-repo tracking (requirements.md + BACKLOG.md):**

```markdown
## Document Update Protocol

| Event | Action |
|---|---|
| New feature requested | Add to docs/requirements/requirements.md > Add to docs/technical-specs/TECHNICAL_SPEC.md > Update docs/BACKLOG.md |
| New table/column/object created | Add to docs/technical-specs/DATA_MODEL.md |
| Architecture decision made | Add ADR entry to docs/decisions.md |
| Any code committed | Add entry to docs/CHANGELOG.md |
| Requirement changed | Update docs/requirements/requirements.md, mark old version as superseded |
| Feature completed | Mark status as [DONE] in docs/requirements/requirements.md > Update docs/BACKLOG.md |
| Code added/modified | Update docs/technical-specs/code-atlas.md + relevant docs/technical-specs/code-modules/ file |
| Function/class added/changed | Update relevant docs/technical-specs/code-modules/ file |
| Request to modify backlog | Update docs/BACKLOG.md |
| Task completed | Mark done in task file + update phase overview.md |

## Maintenance Rules

1. Proactive updates: when you write or modify code, update all affected docs in the same response
2. Cross-reference: use IDs (BL-xxx, ADR-xxx, REQ-xxx, NFR-xxx) to link between documents
3. No stale docs: if you notice an enabled doc is out of date, fix it immediately
4. Atomic consistency: if a change affects multiple docs, update all of them together
5. Summarize, don't dump: tables and bullet lists over prose

## Update Completion Check

After every code change, before ending your response, verify:
- [ ] Did I update docs/technical-specs/code-atlas.md?
- [ ] Did I update the tracker ticket status (if applicable)?
- [ ] Did I add a CHANGELOG entry?
- [ ] Did I update any other affected docs from the update protocol table?

If any box is unchecked, either complete the update or explicitly flag it as remaining.
```

**If using external tracker + traceability matrix:**

```markdown
## Document Update Protocol

| Event | Action |
|---|---|
| New feature requested | Create tracker ticket > Add to docs/traceability-matrix.md > Add to docs/technical-specs/TECHNICAL_SPEC.md |
| New table/column/object created | Add to docs/technical-specs/DATA_MODEL.md |
| Architecture decision made | Add ADR entry to docs/decisions.md |
| Any code committed | Add entry to docs/CHANGELOG.md |
| Ticket created, split, or phase changed | Update docs/traceability-matrix.md |
| Feature completed | Update tracker ticket to Done |
| Code added/modified | Update docs/technical-specs/code-atlas.md + relevant docs/technical-specs/code-modules/ file |
| Function/class added/changed | Update relevant docs/technical-specs/code-modules/ file |
| Requirements change | Update PRD (if applicable) + docs/traceability-matrix.md |
| Task completed | Mark done in task file + update phase overview.md |

## Maintenance Rules

1. Proactive updates: when you write or modify code, update all affected docs in the same response
2. Cross-reference: use IDs (REQ-xxx, ADR-xxx, NFR-xxx) to link between documents
3. No stale docs: if you notice an enabled doc is out of date, fix it immediately
4. Atomic consistency: if a change affects multiple docs, update all of them together
5. Summarize, don't dump: tables and bullet lists over prose

## Update Completion Check

After every code change, before ending your response, verify:
- [ ] Did I update docs/technical-specs/code-atlas.md?
- [ ] Did I update the tracker ticket status (if applicable)?
- [ ] Did I add a CHANGELOG entry?
- [ ] Did I update any other affected docs from the update protocol table?

If any box is unchecked, either complete the update or explicitly flag it as remaining.
```

### mpf-doc-updates.md (created for MPF projects)

```markdown
## MPF Document Update Rules

| Event | Action |
|---|---|
| New file created | Update docs/technical-specs/code-atlas.md + relevant code-modules/ file |
| Function/class added/changed | Update relevant docs/technical-specs/code-modules/ file |
| Architecture decision made | Add entry to docs/decisions.md |
| Phase completed | Update docs/PROJECT_ROADMAP.md Section 2 (progress) + Section 3 (roadmap status) |
| Requirements change | Update docs/traceability-matrix.md (external tracker) or docs/requirements/requirements.md (in-repo) |
| Task completed | Mark done in task file + update phase overview.md |
```

### git-protocol.md (created if version control is enabled)

```markdown
## Git Commit Protocol

**Branching strategy:** [from interview, e.g., GitHub Flow]
**Branch naming:** [e.g., feature/short-description, fix/short-description]

**Commit message format:**
[format from interview, e.g., Conventional Commits: feat(BL-XXX): Short summary]

**Rules:**
- Only commit after tests pass
- Include doc updates in the same commit as the code change
- [Push policy from interview]
- [PR creation policy from interview]
- [Conflict resolution policy from interview]
```

### traceability.md (created only if external tracker + traceability matrix is enabled)

```markdown
## Source of Truth Hierarchy

Each document has ONE job. When sources conflict, this priority order applies:
1. **PRD / Product Requirements** (what to build): authoritative for product decisions
2. **Tech Spec + Design Specs** (how to build): authoritative for architecture
3. **External Tracker** (status): authoritative for ticket status, acceptance criteria, assignments
4. **Traceability Matrix** (mapping): authoritative for requirement-to-ticket-to-phase mapping
5. **Code Atlas** (current state): authoritative for what exists in the codebase now

## Traceability Rules

- Every implementation task must trace to a product requirement AND a tracker ticket via docs/traceability-matrix.md
- Never invent requirements not traceable to a PRD section or tracker ticket
- Flag any product requirements with no corresponding tracker ticket (coverage gap)
- Flag any tracker tickets with no product requirement traceability (orphan ticket)
- Commit messages must include the tracker ticket identifier (e.g., feat(RIH-150): ...). The prefix uses the tracker's ticket ID format, not backlog item IDs.

## Linear-Specific Configuration (include only if Linear is the external tracker)

- Team: Rihm (ID: `dfe15bc4-6dd0-4bde-8609-6620efc3140d`)
- Default assignee: Michael Rihm (ID: `8d75f0a6-f848-41af-9f4b-d06036d6af82`)
- Follow ticket lifecycle protocol from global rule `linear-ticket-management.md`:
  - Move tickets to **In Progress** before writing code
  - Add comments at significant milestones
  - Move tickets to **Done** only after all acceptance criteria are met
  - Add a final summary comment on completion

## Agent Planning Protocol

When creating an implementation plan for a phase:
1. Read docs/traceability-matrix.md to identify the phase's tickets
2. Query the external tracker for each ticket's acceptance criteria and current status
3. Read the PRD sections referenced in the matrix for domain context
4. Read docs/technical-specs/TECHNICAL_SPEC.md and relevant design specs for architectural decisions
5. Read docs/technical-specs/code-atlas.md for current codebase state
6. Use `mpf:plan-tasks` to create the implementation plan
7. Execute via `mpf:execute`
8. Verify via `mpf:verify`
```

### session-protocol.md (created for Standard and Full tier projects)

```markdown
## Session Start Protocol

At the start of every new session:

1. Read `CLAUDE.md` for project configuration
2. Read `docs/PROJECT_ROADMAP.md` for current state
3. Read `docs/technical-specs/code-atlas.md` for codebase context
4. If external tracker is configured, check for any ticket status changes since last session
5. Deliver the session-start briefing (format below)
6. Wait for the user to choose what to work on

### Briefing Format

Print this at the start of every session:

**[Project Name]: Session Briefing**
- **Phase:** [current phase from PROJECT_ROADMAP.md Section 2]
- **Last session:** [date]: [one-line summary from most recent session log entry]
- **Active items:** [count] active, [count] blocked
- **Blockers:** [list any items from Section 5, or "None"]
- **Suggested next:** [ticket/item ID and title: pick the highest-priority unblocked item]

If anything was auto-updated since the last session (e.g., by another tool or a CI pipeline), note it:
- **Auto-handled:** [list of changes, or omit this line if nothing changed]

Then ask: "What would you like to work on?"

### Session End Protocol

When the user indicates they're done (says "done", "that's it for now", "stopping here", "wrapping up", or similar):

1. Append a row to `docs/PROJECT_ROADMAP.md` Section 7 (Session Log) with:
   - Today's date
   - One-line summary of what was accomplished
   - Which docs were updated
   - Suggested next item for the following session
2. Update Section 5 (Active Work Items) if any items changed status
3. Update Section 6 (Blockers) if any were added or resolved
4. Confirm: "Dashboard updated. Next session I'll suggest starting with [item]."

### Fallback: If PROJECT_ROADMAP.md Is Missing or Corrupt

If `docs/PROJECT_ROADMAP.md` does not exist, cannot be read, or appears empty/corrupt:

1. Do NOT proceed without orientation. Say: "I can't find or read the project dashboard. Let me reconstruct the current state."
2. Read `CLAUDE.md` for project configuration
3. Read `docs/technical-specs/code-atlas.md` for what exists in the codebase
4. Check the external tracker (if configured) for current ticket status
5. Check `git log --oneline -10` for recent commit history
6. Reconstruct a minimal PROJECT_ROADMAP.md from the above sources
7. Present the reconstructed state to the user for confirmation before proceeding
8. Ask: "Does this look right? What would you like to work on?"

### CLAUDE.md Read Verification

After reading CLAUDE.md, confirm to yourself (internally, not to the user) that you can answer these three questions:
1. What is the project's tech stack? (from Section 6 or Section 1)
2. What are the golden rules? (from Section 2)
3. What is the event-to-action update protocol? (from Section 4)

If you cannot answer all three, re-read CLAUDE.md before proceeding.

### Conflict Detection (during session start reads)

While reading CLAUDE.md and rules files, if you detect any contradictions between them (different commit formats, different golden rules, different update protocols), flag them immediately:

"I found a conflict between CLAUDE.md and `.claude/rules/[file]`:
- CLAUDE.md says: [X]
- Rule file says: [Y]
Which should I follow? I'll update the other to match."
```

---

## Archive Conventions

**Purpose:** Preserve original documents when absorbing them into MPF docs during reconciliation.

**Location:** `docs/archive/pre-mpf/`

**Convention:**
- When `mpf:reconcile` absorbs an existing document, the original is moved to `docs/archive/pre-mpf/{original-filename}`
- Absorbed content in MPF docs includes attribution: "Originally from {filename}, absorbed during MPF onboarding"
- Archive files are kept for reference but are not maintained by MPF
- The `docs/archive/` directory is distinct from the project root `archive/` directory (which stores superseded MPF docs)
