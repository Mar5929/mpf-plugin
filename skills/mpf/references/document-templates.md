# Document Templates Reference

This file defines the exact structure for every document the MPF skill can generate. Read the relevant sections when generating each file.

---

## Table of Contents

1. [CLAUDE.md Structure](#claudemd-structure)
2. [BACKLOG.md](#backlogmd)
3. [decisions.md](#decisionsmd)
4. [CHANGELOG.md](#changelogmd)
5. [requirements.md](#requirementsmd)
6. [traceability-matrix.md](#traceability-matrixmd)
7. [TECHNICAL_SPEC.md](#technical_specmd)
8. [DATA_MODEL.md](#data_modelmd)
9. [code-atlas.md](#code-atlasmd)
10. [README.md](#readmemd)
11. [GETTING_STARTED.md](#getting_startedmd)
12. [MIGRATION_REFERENCE.md](#migration_referencemd)
13. [PROJECT_STATUS.md](#project_statusmd)
14. [DATA_LINEAGE.md](#data_lineagemd)
15. [high-level-architecture.md](#high-level-architecturemd)
16. [architecture/{subsystem}.md](#architecturesubsystemmd)
17. [code-modules/{module}.md](#code-modulesmodulemd)
18. [PRD.md](#prdmd)
19. [Phase Overview](#phase-overview)
20. [Task File](#task-file)
21. [roadmap.md](#roadmapmd)
22. [PROJECT.md](#projectmd)

---

## CLAUDE.md Structure

**Tier-dependent generation.** The full 13-section structure below applies to Full tier. Standard tier omits sections 6, 11, and 13. Light tier generates only sections 1, 2, 3, 5, 7, and 12. When generating for a lower tier, skip the omitted sections entirely (don't include them as empty placeholders).

| Section | Light | Standard | Full |
|---|---|---|---|
| 1. Project Overview | Yes | Yes | Yes |
| 2. Golden Rules | Yes | Yes | Yes |
| 3. Workspace Structure | Yes | Yes | Yes |
| 4. Update Protocol | - | Yes | Yes |
| 5. Coding Standards | Yes | Yes | Yes |
| 6. Tech Stack Reference | - | - | Yes |
| 7. Key Commands | Yes | Yes | Yes |
| 8. Session Startup Checklist | - | Yes | Yes |
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
  PROJECT.md                          # What the project is
  PROJECT_STATUS.md                   # Living project dashboard
  CHANGELOG.md                        # Change history
  decisions.md                        # Architecture Decision Records
  roadmap.md                          # Phase overview and order
  requirements/
    requirements.md                   # Functional and non-functional requirements
    PRD.md                            # Product Requirements Document
    phases/
      phase-01-{name}/
        overview.md                   # Phase definition and success criteria
        tasks/
          task-01.md                  # Individual executable tasks
          task-02.md
      phase-02-{name}/
        overview.md
        tasks/
          task-01.md
  technical-specs/
    TECHNICAL_SPEC.md                 # Technical design document
    DATA_MODEL.md                     # Database schema
    code-atlas.md                     # Codebase context memory
    high-level-architecture.md        # System overview and components
    architecture/
      {subsystem}.md                  # Per-subsystem documentation
    code-modules/
      {module}.md                     # Per-module code documentation
  traceability-matrix.md              # Requirement-to-ticket mapping
```

### Section 4: Living Documents: Update Protocol
- A table mapping events to required document updates. Only include rows for enabled documents.

**If using in-repo tracking (requirements.md + BACKLOG.md):**

  | Event | Action |
  |---|---|
  | New feature requested | Add to `docs/requirements/requirements.md` > Add technical approach to `docs/technical-specs/TECHNICAL_SPEC.md` > Update `docs/BACKLOG.md` |
  | New table/column/object created | Add to `docs/technical-specs/DATA_MODEL.md` |
  | Architecture decision made | Add ADR entry to `docs/decisions.md` |
  | Any code committed | Add entry to `docs/CHANGELOG.md` |
  | Requirement changed | Update `docs/requirements/requirements.md`, mark old version as superseded |
  | Feature completed | Mark status as `[DONE]` in `docs/requirements/requirements.md` > Update `docs/BACKLOG.md` |
  | Code added/modified | Update `docs/technical-specs/code-atlas.md` + relevant `docs/technical-specs/code-modules/` file |
  | Function/class added/changed | Update relevant `docs/technical-specs/code-modules/` file |
  | Request to modify backlog | Update `docs/BACKLOG.md` |
  | End of session | Append session log entry to `docs/PROJECT_STATUS.md` |
  | Phase transition | Update current phase + phase history in `docs/PROJECT_STATUS.md` + update `docs/roadmap.md` status |
  | Blocker identified | Add to blockers table in `docs/PROJECT_STATUS.md` |
  | Task completed | Mark done in task file + update phase `overview.md` |

**If using external tracker + traceability matrix:**

  | Event | Action |
  |---|---|
  | New feature requested | Create tracker ticket > Add to `docs/traceability-matrix.md` > Add technical approach to `docs/technical-specs/TECHNICAL_SPEC.md` |
  | New table/column/object created | Add to `docs/technical-specs/DATA_MODEL.md` |
  | Architecture decision made | Add ADR entry to `docs/decisions.md` |
  | Any code committed | Add entry to `docs/CHANGELOG.md` |
  | Ticket created, split, or phase changed | Update `docs/traceability-matrix.md` |
  | Feature completed | Update tracker ticket to Done |
  | Code added/modified | Update `docs/technical-specs/code-atlas.md` + relevant `docs/technical-specs/code-modules/` file |
  | Function/class added/changed | Update relevant `docs/technical-specs/code-modules/` file |
  | Requirements change | Update `docs/requirements/requirements.md` + `docs/traceability-matrix.md` |
  | End of session | Append session log entry to `docs/PROJECT_STATUS.md` |
  | Phase transition | Update current phase + phase history in `docs/PROJECT_STATUS.md` + update `docs/roadmap.md` status |
  | Phase completed | Update `docs/PROJECT_STATUS.md` progress + `docs/roadmap.md` status |
  | Blocker identified | Add to blockers table in `docs/PROJECT_STATUS.md` |
  | Task completed | Mark done in task file + update phase `overview.md` |

- Format rules: compact Markdown (tables and bullet lists preferred over prose), use IDs (`REQ-001`, `ADR-001`, `NFR-001`), ISO dates (`YYYY-MM-DD`)

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

**If using in-repo tracking:**
  1. `CLAUDE.md` (this file)
  2. `docs/PROJECT_STATUS.md` for current phase, active items, blockers, and session history
  3. `docs/technical-specs/code-atlas.md` for codebase context
  4. `docs/BACKLOG.md` for outstanding work items
  5. Skim `docs/requirements/requirements.md` if working on a feature
  6. Deliver the session-start briefing (see `.claude/rules/session-protocol.md`)

**If using external tracker + traceability matrix:**
  1. `CLAUDE.md` (this file)
  2. `docs/PROJECT_STATUS.md` for current phase, active items, blockers, and session history
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

## BACKLOG.md

**Purpose:** Single source of truth for all planned, in-progress, and completed work items.

**Location:** `docs/BACKLOG.md` (if in-repo tracking)

**Structure:**
- **Phases Overview table** at the top: columns for Phase number, Focus area, Duration/Timeline, and Backlog Item ID range
- **Per-phase sections** (e.g., "Phase 1: Foundation"), each containing:
  - Summary table: `ID | Title | Priority | Status | Implements`
  - Detailed description block for each item: `### BL-001: Title` with `**Details**:` paragraph
- **Completed section** at the bottom: `ID | Title | Completed (date) | Notes`

**Status values:** `NOT STARTED | IN PROGRESS | DONE | BLOCKED | DEFERRED`
**Priority values:** `P0 (Critical) | P1 (High) | P2 (Medium) | P3 (Low)`

Auto-create new items when TODOs or tech debt are discovered during development.

---

## decisions.md

**Purpose:** Architectural Decision Record (ADR) log.

**Location:** `docs/decisions.md`

**Structure:**
- **Decision Index table** at the top: `ID | Title | Status | Date`
- **Per-decision sections** (`### ADR-001: Title`):
  - **Date**
  - **Status:** `PROPOSED | ACCEPTED | DEPRECATED | SUPERSEDED`
  - **Context:** What motivated this decision?
  - **Options Considered:** Numbered list with `Pros: / Cons:` each
  - **Decision:** What was chosen
  - **Consequences:** Positive and negative results
  - **Related:** Cross-references to `REQ-XXX`, `BL-XXX`, or `ADR-XXX`

---

## CHANGELOG.md

**Purpose:** Human-readable history of what changed and when.

**Location:** `docs/CHANGELOG.md`

**Format:** [Keep a Changelog](https://keepachangelog.com/) conventions. Reverse chronological.

**Structure per entry:**
- Heading: `## YYYY-MM-DD: Release Title or Version`
- Categories (only those that apply): Added, Changed, Fixed, Removed, Deprecated, Security
- Each bullet references relevant backlog IDs (e.g., `(BL-XXX)`)

Initialize with a "Project Bootstrap" entry listing all created documentation files.

---

## requirements.md

**Purpose:** Defines what the project must do: the "what" document.

**Location:** `docs/requirements/requirements.md`

**Structure:**
- **Requirement Index table**: `ID | Title | Priority | Status`
- **Functional Requirements** (`### REQ-001: Title`):
  - Priority, Status (`DRAFT | APPROVED | IN PROGRESS | DONE | DEFERRED | SUPERSEDED`)
  - Description, Acceptance Criteria (numbered checkbox list), Dependencies, Notes
- **Non-Functional Requirements** (`### NFR-001: Title`):
  - Priority, Description, Acceptance Criteria (measurable)
- **Glossary** table: `Term | Definition`

---

## traceability-matrix.md

**Purpose:** Maps every product requirement to its implementation phase and external tracker tickets. Replaces requirements.md and BACKLOG.md when an external tracker is used.

**Location:** `docs/traceability-matrix.md`

**When to use:** Only for projects using an external tracker (Linear, Jira, GitHub Issues, etc.). Do NOT generate this for projects using in-repo BACKLOG.md + requirements.md.

**Structure:**
- **Header** with one-line description and link to the PRD or product requirements doc
- **Functional Requirements table**: `PRD Section | Req ID | Requirement | Phase | Tracker Ticket(s)`
  - One row per functional requirement (REQ-001, REQ-002, etc.)
  - Phase column: the implementation phase this requirement belongs to (e.g., "Phase 1", "Phase 2", "TBD")
  - Tracker Ticket(s) column: the external tracker ticket IDs that implement this requirement
- **Non-Functional Requirements table**: same columns
  - One row per non-functional requirement (NFR-001, NFR-002, etc.)
- **Foundation Tickets table** (optional): for cross-cutting tickets that support multiple requirements
  - `Tracker Ticket | Description | Phase | Supports`
- **Coverage Gaps section**: Requirements with no tracker ticket or incomplete ticket coverage
  - Explicitly list any PRD requirements without a corresponding tracker ticket
- **Ticket-to-Requirement Reverse Index**: every tracker ticket maps back to at least one requirement
  - `Tracker Ticket | Requirement(s)`
  - Ensures no orphan tickets exist

**Key rules:**
- Status and acceptance criteria live in the external tracker, NOT in this doc
- This doc tracks structural mapping only: which requirement maps to which ticket in which phase
- Update this doc when tickets are created, split, or phases are restructured
- Every ticket must trace to a requirement. Every requirement must trace to a ticket (or an explicit gap notation).

**Initial population:**
- During Discovery: populate Req ID and Requirement columns from the PRD, Phase set to TBD
- During Decomposition: fill in Tracker Ticket(s) as tickets are created
- During Phase Definition: fill in Phase column as phases are defined

---

## TECHNICAL_SPEC.md

**Purpose:** The authoritative technical design document: the "how" companion to requirements.

**Location:** `docs/technical-specs/TECHNICAL_SPEC.md`

**Structure (10 sections):**
1. **Architecture Overview**: goals, system context, ASCII architecture diagram
2. **Tech Stack Reference**: `Layer | Technology | Version | Purpose`
3. **API Route Design**: route convention, route groups table, detailed endpoint schemas
4. **Service Layer**: `Service Module | Purpose | Key Methods`
5. **Frontend Component Tree**: ASCII directory structure, key component listing
6. **Security Model**: Authentication, Authorization, Secrets Management
7. **Background Tasks**: `Task | Schedule | Purpose` (remove if not applicable)
8. **Third-Party Integrations**: `Service | Purpose | Auth Method` (remove if not applicable)
9. **Deployment Architecture**: per-environment details, CI/CD pipeline
10. **Open Questions**: `# | Question | Status (OPEN/RESOLVED) | Decision`

---

## DATA_MODEL.md

**Purpose:** Database schema definition: single source of truth for all tables, columns, relationships, and conventions.

**Location:** `docs/technical-specs/DATA_MODEL.md`

**For SQL databases:**
- **Table Inventory**: `Table | Description | Status (PLANNED/CREATED/MODIFIED)`
- **Schema Definitions** grouped by logical area, each table with full `CREATE TABLE` DDL
- **Relationships**: `Parent | Child | FK Column | On Delete`
- **ERD Diagram**: Mermaid `erDiagram` syntax
- **Naming Conventions**: `Aspect | Convention | Example`
- **Migration Notes**: tool, file location, workflow

---

## code-atlas.md

**Purpose:** Persistent context memory for Claude. Read this instead of scanning source files. Populated incrementally.

**Location:** `docs/technical-specs/code-atlas.md`

**Structure (8 sections + appendices):**
1. **Architecture Overview**: platform bullet list, ASCII layer diagram
2. **Database Schema**: reference to DATA_MODEL.md, summary table
3. **Backend Services**: `Module | Purpose | Key Methods`
4. **API Routes**: `Method | Path | Purpose | Service`
5. **Background Tasks**: `Task | Schedule | Purpose` (remove if not applicable)
6. **Frontend Components**: `Component | Path | Purpose`
7. **Key Patterns & Conventions**: numbered subsections for recurring patterns
8. **Cross-Cutting Concerns**: Authentication, Error Handling, Logging
- **Appendix A:** File to Module Reference
- **Appendix B:** Dependency Graph

---

## high-level-architecture.md

**Purpose:** System overview and component architecture. Provides the bird's-eye view of how all parts of the system fit together.

**Location:** `docs/technical-specs/high-level-architecture.md`

**Structure:**

### System Overview
- One-paragraph description of the system, its purpose, and primary capabilities

### Architecture Diagram
- ASCII or Mermaid component diagram showing all major components and their relationships

### Component Table

| Component | Purpose | Tech | Dependencies |
|---|---|---|---|
| e.g., API Server | Handles client requests | Node.js + Express | Database, Auth Service |
| e.g., Database | Persistent storage | PostgreSQL 16 | - |

### Communication Patterns
- How components interact (REST, gRPC, message queues, etc.)
- Sync vs async patterns
- Error propagation strategy

### Data Flow
- High-level description of how data moves through the system
- Primary read and write paths

### Subsystem Index

| Subsystem | Purpose | Doc |
|---|---|---|
| e.g., auth | Authentication and authorization | `architecture/auth.md` |
| e.g., api | REST API layer | `architecture/api.md` |

---

## architecture/{subsystem}.md

**Purpose:** Detailed subsystem documentation. One file per major subsystem, linked from `high-level-architecture.md`.

**Location:** `docs/technical-specs/architecture/{subsystem}.md`

**Structure:**

### {Subsystem Name}
- One-paragraph description of the subsystem and its role in the overall architecture

### Responsibilities
- Bullet list of what this subsystem owns and is responsible for

### Interfaces
- **Exposes:** APIs, events, or services this subsystem provides to others
- **Consumes:** APIs, events, or services this subsystem depends on from others

### Internal Structure
- Key classes, modules, or files that make up this subsystem
- Internal data flow if applicable

### Dependencies
- **External:** third-party libraries, services, or APIs
- **Internal:** other subsystems this one depends on

### Configuration
- Environment variables this subsystem reads
- Settings files or configuration objects
- Default values and required overrides

---

## code-modules/{module}.md

**Purpose:** Detailed module-level code documentation. Provides a granular breakdown beyond what code-atlas.md covers. One file per logical module.

**Location:** `docs/technical-specs/code-modules/{module}.md`

**Structure:**

### {Module Name}
- One-paragraph description of the module's purpose and scope

### File Listing

| File | Purpose | Key Exports |
|---|---|---|
| e.g., `src/auth/login.ts` | Login handler | `handleLogin`, `validateCredentials` |

### Key Functions/Classes

| Name | Purpose | Parameters | Returns |
|---|---|---|---|
| e.g., `handleLogin` | Processes login requests | `credentials: LoginDTO` | `AuthToken` |

### Dependencies
- **Internal imports:** other project modules this module uses
- **External imports:** third-party packages

### Patterns
- Module-specific conventions, naming rules, or architectural patterns

### Test Coverage
- Test file locations (e.g., `src/auth/__tests__/login.test.ts`)
- Coverage notes and any known gaps

---

## PRD.md

**Purpose:** Product Requirements Document. Defines the product vision, user needs, and feature requirements.

**Location:** `docs/requirements/PRD.md`

**Structure:**

### Product Vision
- One-paragraph vision statement describing what the product aims to achieve

### Problem Statement
- What problem this product solves and why existing solutions fall short

### Target Users
- User personas or descriptions of the primary audience
- Key characteristics, needs, and pain points for each persona

### User Stories
- Organized by feature area
- Each story follows the format: "As a [user], I want [action] so that [benefit]"
- Each story includes acceptance criteria as a numbered checkbox list

### Feature Requirements

| Feature | Priority | Description | Acceptance Criteria |
|---|---|---|---|
| e.g., User login | P0 | Email/password authentication | Users can log in with valid credentials |

### Non-Functional Requirements

| NFR-ID | Category | Requirement | Target |
|---|---|---|---|
| e.g., NFR-001 | Performance | Page load time | < 2 seconds on 3G |
| e.g., NFR-002 | Security | Password hashing | bcrypt with 12 rounds |

### Out of Scope
- Explicitly excluded items and features that will NOT be built (at least not in this version)

### Open Questions
- Unresolved product questions that need stakeholder input

---

## Phase Overview

**Purpose:** Phase definition with goals and success criteria. One file per phase.

**Location:** `docs/requirements/phases/phase-NN-{name}/overview.md`

**Structure:**

### Phase {NN}: {Name}

**Goal:** One-paragraph description of what this phase accomplishes and why it matters.

**Requirements Covered:**
- REQ-001: {title}
- REQ-002: {title}
- (list of REQ-IDs from requirements.md that this phase implements)

**Success Criteria:**
1. {Observable behavior that proves criterion is met}
2. {Another observable behavior}
3. (2-5 criteria total, each testable and specific)

**Dependencies:**
- What must be complete before this phase can begin
- Other phases, external systems, or decisions required

**Linear Milestone:** {milestone name/ID} (if Linear is configured, otherwise omit)

**Tasks:** See `tasks/` directory for individual executable tasks.

---

## Task File

**Purpose:** Single executable task for the mpf-executor agent. Each task is atomic and independently verifiable.

**Location:** `docs/requirements/phases/phase-NN-{name}/tasks/task-NN.md`

**Structure:**

```markdown
# Task {NN}: {Title}

**Requirement:** REQ-{XXX} (the requirement ID(s) this task implements)
**Linear Ticket:** {ticket ID} (if Linear is configured, otherwise omit)

## Files
- `path/to/file1.ts` (create)
- `path/to/file2.ts` (modify)

## Action
Specific implementation instructions. What to build, how to build it, and any constraints or patterns to follow.

## Verify
```bash
# Test commands to run after completion
npm test -- --grep "relevant test"
```

## Done
- [ ] {Observable criterion that proves the task is complete}
- [ ] {Another criterion}

## Dependencies
**Wave:** {1|2|3|...} (1 = no dependencies, 2+ = depends on earlier waves)
**Depends On:** task-01, task-03 (list of task numbers this depends on, or "none")
```

---

## roadmap.md

**Purpose:** Phase overview and implementation order. Provides the high-level picture of how the project progresses from start to finish.

**Location:** `docs/roadmap.md`

**Structure:**

### Project Roadmap

#### Phase Summary

| Phase | Name | Status | Progress |
|---|---|---|---|
| 1 | Foundation | Done | 100% |
| 2 | User Auth | In Progress | 48% |
| 3 | Core Features | Not Started | 0% |

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

---

## PROJECT.md

**Purpose:** What the project is. Focused on project context for developers and Claude, not external-facing like README.

**Location:** `docs/PROJECT.md`

**Structure:**

### {Project Name}
- One-paragraph project description

### Problem Statement
- What problem the project solves and for whom

### Target Users
- Brief description of primary users

### Tech Stack
- Summary table or bullet list of key technologies

### Key Decisions
- Link to `docs/decisions.md` for the full ADR log
- Optionally list the 2-3 most important architectural decisions inline

### Current State
- Link to `docs/PROJECT_STATUS.md` for the live dashboard
- One-line summary of current phase and progress

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
- Directive to start with `BL-001`
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

## DATA_LINEAGE.md

**Purpose:** Maps data flow from source systems through transformations to destination systems. Used for data pipeline and ETL projects.

**When to use:** Only for Data pipeline / ETL projects where the user opts in during Round 4.

**Structure:**
- **Source Systems table**: `Source | Type | Connection | Frequency | Format`
- **Destination Systems table**: `Destination | Type | Connection | Format`
- **Pipeline Inventory**: `Pipeline | Source(s) | Destination(s) | Schedule | Status`
- **Transform Chain** (per pipeline): ordered list of transformation steps with input schema to output schema
- **Data Quality Checks**: `Check | Pipeline | Rule | Severity (WARN/FAIL)`
- **Lineage Diagram**: Mermaid diagram showing data flow from sources through transforms to destinations

---

## PROJECT_STATUS.md

**Purpose:** Living project dashboard. Single place to understand current state, who owns what, and what happened recently. Claude updates this at the end of every session. The user can also update it manually.

**Always generated:** Yes, for all tiers. Light tier gets a simplified version (sections 1, 2, and 5 only).

**Metadata header (include at the top of the generated file):**
```
**Scaffolding tool:** mpf
**Scaffolding tier:** Light | Standard | Full
**Upgrade available:** Yes/No
```

**Structure:**

### Section 1: Current Phase
- Phase name and number (e.g., "Phase 2: User Auth")
- One-line description of what this phase covers
- Phase start date
- Target completion (if known)
- Next phase preview (what comes after this)
- Progress bar:
  ```
  Phase 2: User Auth  |  ████████░░░░░░░░  48%
  ```

### Section 2: Phase Summary

| Phase | Name | Status | Progress |
|---|---|---|---|
| 1 | Foundation | Done | ████████████████ 100% |
| 2 | User Auth | In Progress | ████████░░░░░░░░ 48% |
| 3 | Core Features | Not Started | ░░░░░░░░░░░░░░░░ 0% |

### Section 3: Responsibility Matrix
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
| traceability-matrix.md | Claude (auto) | Phase reassignments: user approval needed |
| decisions.md | Shared | Claude records decisions from conversation, user confirms status |
| PRD / Requirements | User (decides) | Claude flags contradictions but does not modify |
| Tracker ticket status | Claude (auto) | Follows ticket lifecycle protocol |
| Git commits | Claude (auto) | Follows git protocol; force pushes: never |
| Git branching | Claude (auto) | Branch deletion: user approval needed |
| Dependency upgrades | User (decides) | Claude flags outdated deps, user approves upgrades |
| Security/auth changes | User (decides) | Claude always asks first |

Only include rows for enabled workflows. For example, if no external tracker, omit the tracker row. If no decisions.md, omit that row.

### Section 4: Active Work Items
Table with columns: `ID | Title | Status | Assignee | Blockers`

- Pull from external tracker or BACKLOG.md depending on tracking approach
- Show only active and blocked items (not backlog/done)
- Include a count: "3 active, 1 blocked, 12 in backlog"

### Section 5: Blockers & Waiting
Table with columns: `Item | Blocked By | Since | Action Needed`

- External blockers (waiting on a person, API access, decision)
- Internal blockers (depends on another ticket, needs design decision)
- Include who needs to act (user, external stakeholder, Claude)

### Section 6: Session Log
Table with columns: `Date | Session Summary | Docs Updated | Next Up`

- Claude appends a row at the end of every session
- Keep the last 10 sessions; move older entries to a "Previous Sessions" collapsed section or archive
- "Docs Updated" column lists which living docs were modified (e.g., "code-atlas, CHANGELOG, LINEAR:RIH-54 to Done")
- "Next Up" column is Claude's suggestion for what to work on next session

### Section 7: Phase History
Table with columns: `Phase | Focus | Started | Completed | Key Outcomes`

- Completed phases with a one-line summary of what was accomplished
- Current phase row has Completed = "In Progress"

---

## .claude/rules/ Directory

**Purpose:** Project-specific rules that auto-load into every Claude Code conversation. These contain behavioral constraints Claude must always follow, without relying on CLAUDE.md being explicitly read. CLAUDE.md remains the comprehensive human-readable reference; rules files ensure enforcement.

**Location:** `.claude/rules/` at the project root (not the global `~/.claude/rules/`).

**Key principle:** Rules files contain **only behavioral constraints**: the "must do / must not do" rules that Claude must follow automatically. CLAUDE.md contains the full project reference including context that rules files should not duplicate: workspace structure, tech stack details, key commands, session startup checklist, bug-prevention facts, and references. Do not duplicate content between CLAUDE.md and rules files. Rules files should reference CLAUDE.md sections where appropriate (e.g., "See CLAUDE.md Section 6 for the full tech stack") rather than repeating the information. The only exception is the Golden Rules, which appear in both places because they are the most critical invariants and benefit from redundancy.

---

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
2. `docs/PROJECT_STATUS.md` Section 4 (Active Work Items) to stay oriented

This is a lightweight refresh, not a full re-read of all docs.

## Session Start Invariant

You must NEVER begin working on a task without first completing the session-start protocol. If the user immediately asks you to do something before you've delivered the briefing, deliver the briefing first (it takes 10 seconds), then address their request.
```

---

### coding-standards.md (always created)

```markdown
## Coding Standards

[Per-language subsections from CLAUDE.md Section 5]
[Database conventions subsection if applicable]
```

---

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
| Requirements change | Update docs/requirements/requirements.md + docs/traceability-matrix.md |
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

---

### mpf-doc-updates.md (created for MPF projects)

```markdown
## MPF Document Update Rules

| Event | Action |
|---|---|
| New file created | Update docs/technical-specs/code-atlas.md + relevant code-modules/ file |
| Function/class added/changed | Update relevant docs/technical-specs/code-modules/ file |
| Architecture decision made | Add entry to docs/decisions.md |
| Phase completed | Update docs/PROJECT_STATUS.md progress + docs/roadmap.md status |
| Requirements change | Update docs/requirements/requirements.md + docs/traceability-matrix.md |
| Task completed | Mark done in task file + update phase overview.md |
```

---

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

---

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
6. Invoke brainstorming skill if the phase involves design uncertainty
7. Invoke writing-plans skill to create the implementation plan
8. Execute via subagent-driven-development skill
```

---

### session-protocol.md (created for Standard and Full tier projects)

```markdown
## Session Start Protocol

At the start of every new session:

1. Read `CLAUDE.md` for project configuration
2. Read `docs/PROJECT_STATUS.md` for current state
3. Read `docs/technical-specs/code-atlas.md` for codebase context
4. If external tracker is configured, check for any ticket status changes since last session
5. Deliver the session-start briefing (format below)
6. Wait for the user to choose what to work on

### Briefing Format

Print this at the start of every session:

**[Project Name]: Session Briefing**
- **Phase:** [current phase from PROJECT_STATUS.md Section 1]
- **Last session:** [date]: [one-line summary from most recent session log entry]
- **Active items:** [count] active, [count] blocked
- **Blockers:** [list any items from Section 5, or "None"]
- **Suggested next:** [ticket/item ID and title: pick the highest-priority unblocked item]

If anything was auto-updated since the last session (e.g., by another tool or a CI pipeline), note it:
- **Auto-handled:** [list of changes, or omit this line if nothing changed]

Then ask: "What would you like to work on?"

### Session End Protocol

When the user indicates they're done (says "done", "that's it for now", "stopping here", "wrapping up", or similar):

1. Append a row to `docs/PROJECT_STATUS.md` Section 6 (Session Log) with:
   - Today's date
   - One-line summary of what was accomplished
   - Which docs were updated
   - Suggested next item for the following session
2. Update Section 4 (Active Work Items) if any items changed status
3. Update Section 5 (Blockers) if any were added or resolved
4. Confirm: "Dashboard updated. Next session I'll suggest starting with [item]."

### Fallback: If PROJECT_STATUS.md Is Missing or Corrupt

If `docs/PROJECT_STATUS.md` does not exist, cannot be read, or appears empty/corrupt:

1. Do NOT proceed without orientation. Say: "I can't find or read the project dashboard. Let me reconstruct the current state."
2. Read `CLAUDE.md` for project configuration
3. Read `docs/technical-specs/code-atlas.md` for what exists in the codebase
4. Check the external tracker (if configured) for current ticket status
5. Check `git log --oneline -10` for recent commit history
6. Reconstruct a minimal PROJECT_STATUS.md from the above sources
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
