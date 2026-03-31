# Tracking Document Templates

Templates for work tracking and history documents. Read the relevant sections when generating each file.

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
