# Requirement Document Templates

Templates for requirement-related documents. Read the relevant sections when generating each file.

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

## requirements.md

**Purpose:** Defines what the project must do: the "what" document.

**Location:** `docs/requirements/requirements.md`

**Structure:**
- **Requirement Index table**: `ID | Title | Priority | Status`
- **Functional Requirements** (`### REQ-001: Title`):
  - Priority, Status (`DRAFT | APPROVED | IN PROGRESS | DONE | DEFERRED | SUPERSEDED`)
  - Source: {origin of this requirement, e.g., "Linear: RIH-42", "docs/old-spec.md, Section 2.1", "Notion/page-id", "Interview", "mpf:discover"}
  - Description, Acceptance Criteria (numbered checkbox list), Dependencies, Notes

  The Source field is optional for greenfield projects (defaults to "mpf:discover") but required for imported requirements.
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

## REQUIREMENT_HIERARCHY.md

**Purpose:** Shows the full requirement traceability tree: PRD to requirements to phases to tasks to Linear tickets. Provides a single view of project decomposition and coverage.

**Conditionally generated:** Yes, for Standard and Full tiers with external tracking. Created by `mpf:plan-phases`, updated by `mpf:plan-tasks`.

**Location:** `docs/requirements/REQUIREMENT_HIERARCHY.md`

**Structure:**

### Overview

Summary statistics:
- **Requirements:** {N} total ({done} done, {partial} partial, {remaining} remaining)
- **Phases:** {M} planned
- **Tasks:** {P} total across all phases
- **Linear Tickets:** {Q} tracked

### Hierarchy Tree

Per-requirement blocks:

```
REQ-001: {title}
  Priority: {P0/P1/P2/P3}
  Phase: {N} ({phase-name})
  Linear Tickets: {RIH-xxx, RIH-yyy}
  Tasks:
    - task-01 [Wave 1]: {title} (RIH-xxx)
    - task-02 [Wave 1]: {title} (RIH-xxx)
    - task-03 [Wave 2]: {title} (RIH-yyy) -> depends on task-01
```

### Dependency Graph

Phase-level dependencies showing which phases must complete before others.

Per-phase task dependency chains:
```
Phase 1:
  Wave 1: task-01, task-02, task-03 (parallel)
  Wave 2: task-04 (depends on task-01), task-05 (depends on task-02)
  Wave 3: task-06 (depends on task-04, task-05)
```

### Coverage Matrix

| Requirement | Phase | Tasks | Tickets | Status |
|---|---|---|---|---|
| REQ-001 | 1 | 3 | RIH-101, RIH-102 | Planned |
| REQ-002 | 1 | 2 | RIH-103 | Planned |
| REQ-003 | - | - | - | **GAP: Unplanned** |

Gap rows highlight requirements with no phase assignment or no tasks.

---

## audit-report.md

**Purpose:** Implementation status analysis results. Maps imported requirements against the existing codebase to determine what is Done, Partial, or Not Started. Produced by `mpf:audit`.

**Conditionally generated:** Yes, only during brownfield onboarding (ONBOARD mode). Created by `mpf:audit`.

**Location:** `docs/requirements/audit-report.md`

**Structure:**

### Audit Summary

| Metric | Count |
|--------|-------|
| Total requirements | {N} |
| Done | {N} |
| Partial | {N} |
| Not Started | {N} |
| High confidence assessments | {N} |
| Low confidence (needs review) | {N} |

### Requirement Assessments

Per-requirement blocks:

#### REQ-{XXX}: {Title}

- **Status:** Done | Partial | Not Started
- **Confidence:** High | Medium | Low
- **Evidence:**
  - `{file path}`: {what it implements}
  - `{test file}`: {what it tests}
- **Implemented:** {list of satisfied acceptance criteria}
- **Missing:** {list of unsatisfied acceptance criteria}
- **Notes:** {observations about code quality, completeness, or tech debt}

### Coverage Summary

| Requirement | Status | Confidence | Evidence Files | Missing Criteria |
|-------------|--------|------------|----------------|-----------------|
| REQ-001 | Done | High | 4 files | 0 |
| REQ-002 | Partial | Medium | 2 files | 2 criteria |
| REQ-003 | Not Started | High | 0 files | 5 criteria |

### Audit Metadata

- **Audit date:** {YYYY-MM-DD}
- **Code atlas used:** Yes | No
- **User corrections:** {N} assessments corrected during review
