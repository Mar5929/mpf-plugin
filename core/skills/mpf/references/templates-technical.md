# Technical Document Templates

Templates for technical specification documents. Read the relevant sections when generating each file.

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

## DATA_LINEAGE.md

**Purpose:** Maps data flow from source systems through transformations to destination systems. Used for data pipeline and ETL projects.

**Location:** `docs/technical-specs/DATA_LINEAGE.md`

**When to use:** Only for Data pipeline / ETL projects where the user opts in during Round 4.

**Structure:**
- **Source Systems table**: `Source | Type | Connection | Frequency | Format`
- **Destination Systems table**: `Destination | Type | Connection | Format`
- **Pipeline Inventory**: `Pipeline | Source(s) | Destination(s) | Schedule | Status`
- **Transform Chain** (per pipeline): ordered list of transformation steps with input schema to output schema
- **Data Quality Checks**: `Check | Pipeline | Rule | Severity (WARN/FAIL)`
- **Lineage Diagram**: Mermaid diagram showing data flow from sources through transforms to destinations

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
