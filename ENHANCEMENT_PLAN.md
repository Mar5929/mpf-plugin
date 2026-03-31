# MPF Plugin Enhancement Plan

## Overview

This plan is structured into two milestones. Milestone 1 addresses document consolidation, UX improvements, and a bug fix in the current framework. Milestone 2 adds brownfield onboarding: the ability to adopt MPF on existing projects that already have requirements and partial implementations.

---

## Milestone 1: Foundation Improvements

### 1.1 Consolidate PROJECT.md + PROJECT_STATUS.md + roadmap.md into `docs/PROJECT_ROADMAP.md`

**New document structure (8 sections):**

| Section | Content Source | Light Tier |
|---------|--------------|------------|
| 1: Project Overview | PROJECT.md (name, problem, users, stack, key decisions) | Yes |
| 2: Current Phase | PROJECT_STATUS.md S1 (phase name, progress bar, next preview) | Yes |
| 3: Phase Roadmap | roadmap.md (summary table + per-phase details with goals, reqs, criteria) | Yes |
| 4: Responsibility Matrix | PROJECT_STATUS.md S3 | No |
| 5: Active Work Items | PROJECT_STATUS.md S4 | No |
| 6: Blockers & Waiting | PROJECT_STATUS.md S5 | Yes |
| 7: Session Log | PROJECT_STATUS.md S6 | No |
| 8: Phase History | PROJECT_STATUS.md S7 | No |

**Files to modify:**

- **`core/skills/mpf/references/document-templates.md`**
  - Remove templates: `## PROJECT_STATUS.md`, `## roadmap.md`, `## PROJECT.md`
  - Add new `## PROJECT_ROADMAP.md` template with 8-section structure
  - Update Table of Contents
  - Update CLAUDE.md Section 3 (workspace structure example) to show `PROJECT_ROADMAP.md` instead of 3 files
  - Update CLAUDE.md Section 4 (update protocol) references
  - Update CLAUDE.md Section 8 (session startup) references
  - Update all `.claude/rules/` templates: `session-protocol.md`, `golden-rules.md`, `document-updates.md`, `mpf-doc-updates.md`

- **`core/skills/mpf/SKILL.md`**
  - Phase 0: detect `docs/PROJECT_ROADMAP.md` instead of `docs/PROJECT_STATUS.md`
  - Evolve mode: update all references
  - Tier definitions: replace 3 files with 1 in "always generated" lists
  - Phase 4 (file generation): single generation block for `PROJECT_ROADMAP.md`
  - Light-to-Standard upgrade diffs: reference expanded sections

- **`core/commands/mpf/plan-phases.md`**
  - Step 4: write to Section 3 of `PROJECT_ROADMAP.md` instead of separate `roadmap.md`
  - Step 6: update `PROJECT_ROADMAP.md` instead of `PROJECT_STATUS.md`

- **`core/commands/mpf/plan-tasks.md`**
  - Prerequisites: read Section 3 of `PROJECT_ROADMAP.md` instead of `roadmap.md`
  - Step 6: update `PROJECT_ROADMAP.md`

- **`core/commands/mpf/execute.md`**: update `PROJECT_ROADMAP.md` references
- **`core/commands/mpf/verify.md`**: update references
- **`core/commands/mpf/discover.md`**: update references
- **`core/commands/mpf/decompose.md`**: update references
- **`core/commands/mpf/status.md`**: read single file instead of two
- **`core/commands/mpf/sync-linear.md`**: update references
- **`core/agents/mpf-planner.md`**: context loading item 4: `PROJECT_ROADMAP.md` Section 3
- **`core/skills/mpf/references/workflow-rules.md`**: all dashboard/roadmap references
- **`core/hooks/doc-update-hook.md`**: update reference

---

### 1.2 Session Startup Checklist for All Tiers (Including Light)

Currently Section 8 (Session Startup Checklist) only exists for Standard/Full tiers. Light-tier projects get no reading-order instructions.

**Changes:**

- **`core/skills/mpf/references/document-templates.md`**
  - CLAUDE.md tier table: change Section 8 from `- | Yes | Yes` to `Yes | Yes | Yes`
  - Add Light-tier variant of Section 8:
    ```
    1. CLAUDE.md (this file)
    2. docs/PROJECT_ROADMAP.md for current phase, roadmap, and session history
    3. If a task is in progress, read the relevant task file
    ```
  - Create simplified `session-protocol.md` variant for Light tier (reading order only, no briefing/end-of-session protocol)

- **`core/skills/mpf/SKILL.md`**
  - Tier definitions: Light tier CLAUDE.md sections change from `1, 2, 3, 5, 7, 12` to `1, 2, 3, 5, 7, 8, 12`
  - Phase 4 `.claude/rules/`: create `session-protocol.md` for all tiers (simplified for Light)

---

### 1.3 Add `docs/MPF_GUIDE.md` on Project Init

New instructional document generated during `mpf:init` for all tiers.

**Structure:**

```
# MPF Usage Guide

## What is MPF?
  One-paragraph explanation

## Quick Reference: Commands
  Table: Command | Purpose | When to Use (all commands)

## Workflows
  ### Greenfield Project (New from Scratch)
    Numbered steps: init -> discover -> plan-phases -> [plan-tasks -> execute -> verify] per phase

  ### Brownfield Project (Existing Codebase)
    Numbered steps: map-codebase -> init -> import -> audit -> reconcile -> sync-linear -> plan-phases -> same cycle

  ### Ad-Hoc Task (Quick TODO)
    decompose -> execute -> verify

  ### Upgrading Your Project
    mpf:init on existing project enters Evolve mode

## Document Map
  Table: Document | Purpose | Updated By (adapted to enabled docs)

## Tips
  Bullet list of practical tips
```

**Files to modify:**

- **`core/skills/mpf/references/document-templates.md`**
  - Add `## MPF_GUIDE.md` template section
  - Update Table of Contents
  - Update CLAUDE.md Section 3 workspace structure to include `MPF_GUIDE.md`

- **`core/skills/mpf/SKILL.md`**
  - Tier definitions: add `docs/MPF_GUIDE.md` to "always generated" for all tiers
  - Phase 3 creation summary: include `MPF_GUIDE.md`
  - Phase 4: add generation block (adapt content based on tier, tracking approach, project type)

---

### 1.4 Enhanced Decomposition + Linear Dependency Linking + Hierarchy Document

#### 1.4a Tighter Task Decomposition Rules

- **`core/agents/mpf-planner.md`** (Granularity section)
  - Add rules:
    - Each task implements ONE logical unit. If "and" connects two distinct behaviors, split.
    - Prefer 1-3 files per task. 5-file limit is a hard cap, not a target.
    - Action section must include: specific file paths, function names, input/output types, pattern references.
    - If a requirement has multiple testable acceptance criteria spanning different system areas, create one task per behavior.
    - Separate: migration tasks from code-using-migration, route creation from service logic from tests.
  - Add `### Decomposition Depth` section with example showing REQ-005 "password reset" broken into 7 tasks across 4 waves (not 1 monolithic task).

- **`core/commands/mpf/plan-phases.md`**
  - Step 2: add "Each requirement should decompose into 3-10 tasks. If a phase would produce more than 40 tasks, split the phase."

- **`core/commands/mpf/plan-tasks.md`**
  - After planner finishes, add a coarse-task check: flag any task with <5-line Action or >3 files as potentially under-specified.

#### 1.4b Requirement Hierarchy Document: `docs/requirements/REQUIREMENT_HIERARCHY.md`

New document showing the full PRD -> Requirements -> Phases -> Tasks -> Linear Tickets tree.

**Structure:**

```
# Requirement Hierarchy

## Overview
  Totals: N requirements -> M phases -> P tasks -> Q Linear tickets

## Hierarchy Tree
  Per-requirement blocks:
    REQ-001: {title}
      Priority, Phase, Linear Tickets
      Tasks with wave, dependency, and ticket references

## Dependency Graph
  Phase-level dependencies
  Per-phase task dependency chains (wave structure)

## Coverage Matrix
  Table: Requirement | Phase | Tasks | Tickets | Status
  Gap rows for unplanned requirements
```

**Files to modify:**

- **`core/skills/mpf/references/document-templates.md`**: add template, update ToC and workspace structure
- **`core/commands/mpf/plan-phases.md`**: Step 4 creates initial hierarchy doc with REQ -> Phase mapping (tasks empty until plan-tasks)
- **`core/commands/mpf/plan-tasks.md`**: after planner finishes, update hierarchy doc with task breakdown
- **`core/agents/mpf-planner.md`**: completion section outputs dependency chain summary + updates hierarchy doc
- **`core/commands/mpf/decompose.md`**: Step 8 also updates hierarchy doc

#### 1.4c Linear Blocked-By/Blocks Relations

The Linear MCP `save_issue` supports `blockedBy` and `blocks` arrays. Currently unused.

**Changes to `core/commands/mpf/plan-tasks.md`:**

Add new **Step 5: Link Linear Dependencies** (after planner + checker, before status update):

```
1. Read all task files to extract dependency info (wave + "Depends On" fields)
2. Build task-to-ticket map from Step 2 ticket creation
3. For each task with "Depends On" entries:
   - Look up ticket IDs for current task and each dependency
   - Call save_issue(id: ticket_id, blockedBy: [dependency_ticket_ids])
4. For cross-phase dependencies:
   - Link Phase N Wave 1 tickets as blockedBy Phase N-1 final wave tickets
5. Report all relations created
```

**Changes to `core/commands/mpf/decompose.md`:**
- Step 7 (Linear integration): after creating all tickets, apply same dependency linking logic.

**Changes to `core/agents/mpf-planner.md`:**
- Completion section: output a structured `Dependency Chain` block for easy parsing by the orchestrator.

**Changes to `core/commands/mpf/sync-linear.md`:**
- Step 4: add new check type `Missing dependency link` (Medium severity) when task file has "Depends On" but Linear tickets lack the relation.
- Step 6: add auto-fix for missing dependency links.

---

### 1.5 Replace Abstract Tier System with Direct Claude Model Names

**Problem:** The abstract tier layer (`reasoning`/`standard`/`fast` mapped to `opus`/`sonnet`/`haiku` via `model-tiers.yaml` and `tool-map.yaml`) causes failures. Claude Code reports it cannot find a "reasoning" model and falls back to Opus by default, breaking the intended model routing.

**Solution:** Remove the abstract tier indirection. Use Claude model names directly in `core/` agent files. The multi-platform adapter story (Cursor, Codex) hasn't arrived yet; when it does, the mapping layer can be reintroduced with proper testing.

**Changes:**

- **`core/agents/mpf-planner.md`**: `# Tier: reasoning` -> `# Model: opus`
- **`core/agents/mpf-verifier.md`**: `# Tier: reasoning` -> `# Model: opus`
- **`core/agents/mpf-mapper-lead.md`**: `# Tier: reasoning` -> `# Model: opus`
- **`core/agents/mpf-executor.md`**: `# Tier: standard` -> `# Model: sonnet`
- **`core/agents/mpf-mapper-specialist.md`**: `# Tier: standard` -> `# Model: sonnet`
- **`core/agents/mpf-checker.md`**: `# Tier: fast` -> `# Model: haiku`

- **`adapters/claude-code/generate.sh`**:
  - Change metadata extraction regex from `# Tier:` to `# Model:`
  - Remove `TIER_MODELS` lookup
  - Use extracted model name directly in output frontmatter
  - Add deprecation warning if old-style `# Tier:` comments are found

- **`adapters/claude-code/tool-map.yaml`**: remove `tier_to_model` section
- **`core/model-tiers.yaml`**: keep as documentation/reference only, add header noting it is not used by the build pipeline
- **`core/skills/mpf/SKILL.md`**: replace tier terminology ("Reasoning-tier usage") with model names ("Opus usage")

---

### Milestone 1 Implementation Order

1. **1.5 Tier fix** first: small, targeted, unblocks correct agent behavior for all subsequent work
2. **1.1 Document consolidation** next: touches nearly every file, all subsequent changes reference `PROJECT_ROADMAP.md`
3. **1.2 Session startup for Light tier**: small, focused
4. **1.3 MPF Usage Guide**: adds new template and generation logic
5. **1.4 Enhanced decomposition + Linear linking**: most complex behavioral change

### Milestone 1 Verification

1. Run `bash build.sh` and confirm it completes without errors
2. Check generated output in `commands/`, `skills/`, `agents/`, `hooks/` for correct model resolution (no `reasoning`/`standard`/`fast` in generated files)
3. Grep for stale references: `PROJECT_STATUS.md`, `PROJECT.md` (standalone), `roadmap.md` (standalone), `# Tier:` should not appear in any core/ agent file
4. Verify all new template sections (PROJECT_ROADMAP.md, MPF_GUIDE.md, REQUIREMENT_HIERARCHY.md) appear in document-templates.md ToC
5. Verify SKILL.md tier definitions table reflects new section counts (Light: 7 sections, Standard: 10, Full: 13)
6. Verify plan-tasks.md has the new Step 5 for Linear dependency linking
7. Verify mpf-planner.md has the tightened granularity rules and decomposition depth example

---

## Milestone 2: Brownfield Onboarding

### Problem

MPF currently assumes greenfield projects. When adopting MPF on an existing project with requirements already documented (in Linear, markdown, Notion, etc.) and code already partially implemented, there is no structured way to:

- Import existing requirements into MPF's tracking format
- Determine what's already been built vs what remains
- Reconcile existing documentation with MPF's document structure
- Get into the normal MPF workflow without losing existing context

### Design Decisions

These decisions were made during the planning interview:

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Entry point | Third mode in `mpf:init` (ONBOARD) | Single front door; auto-detected |
| Requirement import | Hybrid: import to MPF format + preserve source links | Best of both: MPF tracking with traceability to originals |
| Implementation audit | Agent audit + user confirmation | Agent catches what user forgets; user corrects what agent gets wrong |
| Doc overlap handling | User chooses per document (absorb or reference) | No one-size-fits-all; some docs should stay, others consolidate |
| Source of truth | Depends on source type: Linear stays authoritative (synced), scattered markdown gets consolidated | Structured tools keep their role; unstructured files get unified |
| Completed work in roadmap | "Pre-MPF Work" summary section, not synthetic phases | Clean; doesn't pretend MPF managed work it didn't |
| Partial implementations | Finish-up tasks for remaining work only, confirmed by user | No fake "done" tasks; focus on what's left |
| Linear ticket mismatches | Flag in sync report, user decides | Bulk-closing is risky; per-ticket asking is tedious |
| Command structure | Separate commands with AI-guided flow | Keeps context windows clean; natural checkpoints |
| New agents | Opus tier (direct model name) | Import and audit require deep reasoning over varied formats |
| `mpf:import` standalone use | Yes, usable mid-project for batch requirement import | Useful beyond onboarding |

---

### 2.1 ONBOARD Mode in `mpf:init`

**Detection logic:**

| Signal | Weight |
|--------|--------|
| No `CLAUDE.md` (rules out EVOLVE) | Required |
| Significant git history (50+ commits) | Strong |
| Existing requirements/PRD/spec docs in common locations | Strong |
| `package.json`, `pyproject.toml`, etc. with dependencies | Medium |
| Existing test suite | Medium |
| Existing `docs/` folder with content | Medium |

If no `CLAUDE.md` AND 2+ medium/strong signals detected: prompt user "Detected existing project with requirements. Enter onboard mode? [Y/n]".

**ONBOARD mode differences from INIT:**

- **Phase 1 (Project Profiling):** Pre-fills answers from detected project state (package.json for stack, existing docs for project description, git history for project maturity)
- **Phase 2 (Interview):** Skips questions MPF can answer from existing artifacts. Adds onboard-specific questions:
  - Where do your requirements live? (Linear project, markdown files, Notion, other)
  - Which docs do you want MPF to manage vs leave alone?
  - Any requirements that are fully implemented and should not be re-planned?
- **Phase 3 (Scaffolding):** Generates MPF docs that reference existing project state rather than starting from blank templates
- **Post-scaffolding:** Guides user to run `mpf:import` next (displays the full onboarding flow)

**Files to modify:**

- **`core/skills/mpf/SKILL.md`**
  - Phase 0: add ONBOARD mode detection logic (signal scanning)
  - Phase 1: add pre-fill behavior when ONBOARD mode
  - Phase 2: add onboard-specific interview questions
  - Phase 3/4: adapt scaffolding for ONBOARD
  - Add "Onboarding Flow" section documenting the full command sequence

- **`core/commands/mpf/init.md`** (if mode detection lives here rather than SKILL.md)

---

### 2.2 `mpf:import` Command (New)

Import requirements from external sources into MPF's `docs/requirements/requirements.md` format.

**Supported sources:**

| Source | Detection | Parse Method |
|--------|-----------|-------------|
| Linear tickets | User provides project key or label; auto-matched by title | Linear MCP: list issues, read descriptions, extract acceptance criteria |
| Markdown files | Scan common locations (`docs/`, `requirements/`, `specs/`); user can specify via `--sources` flag | Parse headings, bullet lists, numbered requirements |
| Notion pages | User provides page URL or database ID | Notion MCP: fetch page content, extract structured requirements |
| Inline text | User pastes or describes requirements during interactive prompt | Parse free-form text into structured requirements |

**Workflow:**

```
1. Source discovery
   - Scan for markdown files with requirement-like content (headings with "requirement", "feature", "user story", numbered lists with acceptance criteria)
   - If `--sources` flag provided, use those directly
   - Present discovered sources to user for confirmation
   - User can add additional sources (Linear project, Notion page, more files)

2. Parse and normalize
   - Spawn mpf-importer agent (opus)
   - Agent reads each source, extracts individual requirements
   - Normalizes to MPF format: REQ-xxx ID, title, description, priority, acceptance criteria
   - Deduplicates across sources (same requirement in Linear AND a markdown file)

3. Source linking
   - Each REQ-xxx entry records its origin(s):
     - `Source: RIH-42` (Linear ticket)
     - `Source: docs/old-spec.md, Section 2.1` (markdown file)
     - `Source: Notion/page-id` (Notion page)
   - If Linear is the source, populate traceability-matrix.md with REQ -> ticket mapping

4. User review
   - Present the full imported requirements list
   - User can: merge duplicates, adjust priorities, edit descriptions, remove irrelevant items
   - Confirm final list

5. Write output
   - Generate/update docs/requirements/requirements.md
   - Generate/update docs/traceability-matrix.md (if external tracking enabled)
   - Update PROJECT_ROADMAP.md with import summary
```

**Standalone use (mid-project):**

`mpf:import` is usable outside onboarding. When run on a project that already has `requirements.md`, it:
- Reads existing requirements to avoid duplicates
- Assigns next available REQ-xxx IDs
- Appends new requirements
- Reports what was added

**`--sources` flag:**

```
mpf:import --sources "docs/old-prd.md, docs/features.md"
mpf:import --sources "linear:PROJECT-KEY"
mpf:import --sources "notion:page-id"
```

When `--sources` is provided, skip the discovery scan and parse the specified sources directly.

**New files:**

- **`core/commands/mpf/import.md`**: command orchestration spec
- **`core/agents/mpf-importer.md`**: agent behavior spec

**Agent: mpf-importer**

```
# Agent: mpf-importer
# Model: opus
# Tools: [file_read, file_write, file_edit, shell, text_search, file_search, agent_spawn, linear_list_issues, linear_get_issue, notion_fetch, notion_search]
```

- Reads multiple source formats (markdown, Linear, Notion)
- Extracts structured requirements from unstructured content
- Deduplicates by semantic similarity (not just title matching)
- Preserves source links as metadata on each requirement
- Handles edge cases: requirements split across multiple sources, nested sub-requirements, acceptance criteria embedded in descriptions

**Files to modify:**

- **`core/skills/mpf/references/document-templates.md`**: update requirements.md template to include `Source:` field per requirement
- **`core/skills/mpf/SKILL.md`**: add `mpf:import` to command list, document standalone use
- **`core/skills/mpf/references/workflow-rules.md`**: add import-related workflow rules

---

### 2.3 `mpf:audit` Command (New)

Agent-driven implementation status analysis. Maps imported requirements against the existing codebase to determine what's Done, Partial, or Not Started.

**Workflow:**

```
1. Prerequisites
   - requirements.md must exist (run mpf:import first)
   - code-atlas.md should exist (run mpf:map-codebase first, or mpf:audit triggers a mapping pass)

2. Spawn mpf-auditor agent (opus)
   - Reads requirements.md (full requirement list with acceptance criteria)
   - Reads code-atlas.md (codebase structure and patterns)
   - For each requirement, searches the codebase for evidence of implementation:
     - Route/endpoint existence
     - Database models/migrations
     - Service/business logic
     - Test coverage
     - UI components (if applicable)

3. Coverage report generation
   - Per-requirement assessment:
     - Status: Done | Partial | Not Started
     - Evidence: file paths, function names, test files found
     - For Partial: what's implemented vs what's missing
     - Confidence: High (clear match) | Medium (likely match) | Low (uncertain)
   - Summary statistics: X done, Y partial, Z not started

4. User review
   - Present the coverage report requirement by requirement
   - User confirms or corrects each assessment
   - User can add notes ("this was intentionally descoped", "needs rewrite despite existing code")

5. Write output
   - Save confirmed report to docs/requirements/audit-report.md
   - Update requirements.md status column based on confirmed assessments
   - Update PROJECT_ROADMAP.md with audit summary
```

**New files:**

- **`core/commands/mpf/audit.md`**: command orchestration spec
- **`core/agents/mpf-auditor.md`**: agent behavior spec

**Agent: mpf-auditor**

```
# Agent: mpf-auditor
# Model: opus
# Tools: [file_read, shell, text_search, file_search]
```

- Deep codebase analysis against requirement acceptance criteria
- Produces evidence-based assessments (not guesses)
- Handles ambiguity explicitly: flags low-confidence assessments for user review
- Understands common implementation patterns (REST routes, DB models, test files) to assess completeness

**Files to modify:**

- **`core/skills/mpf/references/document-templates.md`**: add audit-report.md template
- **`core/skills/mpf/SKILL.md`**: add `mpf:audit` to command list

---

### 2.4 `mpf:reconcile` Command (New)

Document overlap detection and resolution. Handles the transition from the project's existing docs to MPF's document structure.

**Workflow:**

```
1. Scan for existing documents
   - Check common locations: docs/, README.md, ARCHITECTURE.md, CHANGELOG.md, specs/, etc.
   - Categorize each found doc by overlap with MPF docs:
     - PROJECT_ROADMAP.md overlap (project overview, status tracking)
     - code-atlas.md overlap (architecture docs, module descriptions)
     - TECHNICAL_SPEC.md overlap (design specs, API docs)
     - requirements.md overlap (already handled by mpf:import)
     - No overlap (project-specific docs MPF doesn't generate)

2. Present per-document choices
   - For each overlapping doc, show:
     - What it contains
     - Which MPF doc it overlaps with
     - Recommendation: absorb or reference
   - User chooses per document:
     - **Absorb**: content is pulled into the corresponding MPF doc, original moved to docs/archive/pre-mpf/
     - **Reference**: MPF doc includes a link ("See docs/architecture.md for system architecture"), original stays in place
     - **Skip**: no action, doc is unrelated

3. Execute reconciliation
   - Spawn mpf-reconciler agent (sonnet)
   - For absorbed docs: extract relevant content, merge into MPF doc sections, archive original
   - For referenced docs: add reference links to appropriate MPF doc sections
   - Create docs/archive/pre-mpf/ directory if any docs are absorbed

4. Source of truth assignment
   - Structured external tools (Linear, Notion): remain authoritative, MPF syncs from them
   - Absorbed markdown files: MPF docs become the source of truth
   - Referenced docs: original stays authoritative, MPF references it
   - Record decisions in PROJECT_ROADMAP.md or CLAUDE.md update protocol

5. Summary report
   - List all reconciliation actions taken
   - Absorbed: N docs archived, content merged into M MPF docs
   - Referenced: N docs linked from MPF docs
   - Skipped: N docs (no overlap)
```

**New files:**

- **`core/commands/mpf/reconcile.md`**: command orchestration spec
- **`core/agents/mpf-reconciler.md`**: agent behavior spec

**Agent: mpf-reconciler**

```
# Agent: mpf-reconciler
# Model: sonnet
# Tools: [file_read, file_write, file_edit, shell, text_search, file_search]
```

- Detects document overlap by content analysis (not just filename matching)
- Merges content intelligently (not copy-paste: restructures into MPF's section format)
- Preserves attribution ("Originally from docs/architecture.md, absorbed during MPF onboarding")
- Handles partial overlap (doc has some content for code-atlas.md and some for TECHNICAL_SPEC.md)

**Files to modify:**

- **`core/skills/mpf/references/document-templates.md`**: add archive directory convention, add "Source" attribution pattern for absorbed content
- **`core/skills/mpf/SKILL.md`**: add `mpf:reconcile` to command list

---

### 2.5 Enhanced `mpf:sync-linear` for Onboarding

Extend the existing sync command to handle post-onboarding mismatches.

**New check types:**

| Check | Severity | Description |
|-------|----------|-------------|
| Done in code, open in Linear | Medium | Audit marked requirement as Done but Linear ticket is still open |
| Untracked requirement | Low | Imported requirement has no corresponding Linear ticket |
| Orphan ticket | Low | Linear ticket exists but no matching requirement in requirements.md |

**New capabilities:**

- **Flag-only mode (default):** produces sync-report.md with all mismatches and recommended actions
- **Create tickets for untracked requirements:** optional, user-confirmed. For requirements imported from markdown/Notion that have no Linear ticket, offer to create one.
- **Post-onboarding sync report:** when run as part of the onboarding flow, produces a comprehensive initial sync report that serves as the starting health check

**Files to modify:**

- **`core/commands/mpf/sync-linear.md`**
  - Step 4: add three new check types above
  - Step 6: add auto-fix option for creating tickets for untracked requirements
  - Add onboarding context flag: when run after `mpf:reconcile`, include audit-report.md data in the sync analysis

---

### 2.6 `PROJECT_ROADMAP.md` Pre-MPF Work Section

When `mpf:init` runs in ONBOARD mode and `mpf:audit` has produced results, the generated `PROJECT_ROADMAP.md` includes a special section:

```markdown
## Pre-MPF Work

Summary of work completed before MPF adoption, based on the implementation audit.

| Requirement | Status | Evidence |
|-------------|--------|----------|
| REQ-001: User authentication | Done | src/auth/, tests/auth/, migration 003 |
| REQ-003: Dashboard layout | Partial | src/components/Dashboard.tsx exists, no tests |
| REQ-007: Email notifications | Done | src/services/email.ts, tests/email.spec.ts |

**Completed:** 5 of 12 requirements fully implemented
**Partial:** 3 requirements need additional work
**Remaining:** 4 requirements not started

Detailed audit: docs/requirements/audit-report.md
```

Phases in Section 3 (Phase Roadmap) start at Phase 1 and only cover remaining/partial work.

**Files to modify:**

- **`core/skills/mpf/references/document-templates.md`**: add Pre-MPF Work section template to PROJECT_ROADMAP.md (conditional on ONBOARD mode)
- **`core/skills/mpf/SKILL.md`**: Phase 4 scaffolding checks for audit-report.md and populates Pre-MPF Work section if found

---

### 2.7 `mpf:plan-phases` Adaptation for Onboarding

When `mpf:plan-phases` runs after onboarding, it must account for partial implementations:

- **Done requirements**: excluded from phase planning entirely (already in Pre-MPF Work section)
- **Partial requirements**: create finish-up tasks only for remaining work. The phase overview notes what already exists and what's missing.
- **Not Started requirements**: normal phase planning

**Changes to `core/commands/mpf/plan-phases.md`:**

- Step 1: read audit-report.md if it exists. Filter requirements by status.
- Step 2: exclude Done requirements from grouping. For Partial requirements, note the "remaining work" description from the audit.
- Step 3: when presenting phases to user, distinguish between "new implementation" phases and "completion" phases (phases that finish partially-built work).
- Phase overview files for completion phases include: what already exists (from audit), what remains, why it was marked partial.

---

### Onboarding Flow Summary

The complete guided flow, with each command in its own context window:

```
mpf:map-codebase
  Agent scans codebase, produces architecture docs and code-atlas
  AI guides: "Codebase mapped. Run mpf:init next."

mpf:init (ONBOARD mode auto-detected)
  Signal scan detects brownfield project
  Adapted interview with pre-filled answers
  Scaffolding generation (PROJECT_ROADMAP.md, CLAUDE.md, rules, MPF_GUIDE.md)
  AI guides: "Project initialized. Run mpf:import to bring in your existing requirements."

mpf:import
  Scans for requirement sources (or uses --sources flag)
  Parses, normalizes, deduplicates into REQ-xxx format
  User reviews and confirms
  AI guides: "Requirements imported. Run mpf:audit to assess implementation status."

mpf:audit
  Agent analyzes codebase against requirements
  Produces coverage report (Done/Partial/Not Started)
  User reviews and corrects
  AI guides: "Audit complete. Run mpf:reconcile to align your existing docs with MPF."

mpf:reconcile
  Detects document overlaps
  User chooses per-doc: absorb, reference, or skip
  Executes merges and archiving
  AI guides: "Documents reconciled. Run mpf:sync-linear to check tracker alignment."

mpf:sync-linear
  Produces mismatch report (done code vs open tickets, untracked reqs)
  Optionally creates tickets for untracked requirements
  AI guides: "Sync complete. Your project is onboarded. Run mpf:plan-phases to plan remaining work."

mpf:plan-phases (normal flow, audit-aware)
  Plans phases for Partial and Not Started requirements only
  Then: mpf:plan-tasks -> mpf:execute -> mpf:verify per phase
```

---

### Milestone 2 New Files Summary

| File | Type | Model |
|------|------|-------|
| `core/commands/mpf/import.md` | Command spec | N/A (orchestrator) |
| `core/commands/mpf/audit.md` | Command spec | N/A (orchestrator) |
| `core/commands/mpf/reconcile.md` | Command spec | N/A (orchestrator) |
| `core/agents/mpf-importer.md` | Agent spec | opus |
| `core/agents/mpf-auditor.md` | Agent spec | opus |
| `core/agents/mpf-reconciler.md` | Agent spec | sonnet |

### Milestone 2 Modified Files Summary

| File | Changes |
|------|---------|
| `core/skills/mpf/SKILL.md` | ONBOARD mode detection, adapted interview, new commands in command list |
| `core/skills/mpf/references/document-templates.md` | audit-report.md template, Pre-MPF Work section, requirements.md Source field, archive conventions |
| `core/skills/mpf/references/workflow-rules.md` | Import and reconciliation workflow rules |
| `core/commands/mpf/plan-phases.md` | Audit-aware phase planning (exclude Done, finish-up for Partial) |
| `core/commands/mpf/sync-linear.md` | New check types, untracked requirement ticket creation |

### Milestone 2 Implementation Order

1. **2.1 ONBOARD mode** in `mpf:init`: detection logic and adapted interview
2. **2.2 `mpf:import`**: command + agent, standalone-capable
3. **2.3 `mpf:audit`**: command + agent, depends on requirements.md existing
4. **2.4 `mpf:reconcile`**: command + agent, depends on audit for full context
5. **2.5 `mpf:sync-linear` enhancements**: new check types
6. **2.6 Pre-MPF Work section**: PROJECT_ROADMAP.md template update
7. **2.7 `mpf:plan-phases` adaptation**: audit-aware phase planning

### Milestone 2 Verification

1. Run `bash build.sh` and confirm all new commands/agents generate correctly
2. Verify `mpf:init` detects ONBOARD mode when brownfield signals present (mock test with a project that has git history + existing docs)
3. Verify `mpf:import` produces valid requirements.md with Source links from:
   - Markdown file input
   - Linear ticket input (via `--sources "linear:PROJECT-KEY"`)
   - Mixed sources with deduplication
4. Verify `mpf:import` works standalone on a project that already has requirements.md (appends, doesn't overwrite)
5. Verify `mpf:audit` produces coverage report with Done/Partial/Not Started per requirement
6. Verify `mpf:reconcile` correctly: absorbs docs (content in MPF doc + original archived), references docs (link in MPF doc + original untouched)
7. Verify `mpf:sync-linear` reports new check types (done-but-open, untracked, orphan)
8. Verify `mpf:plan-phases` excludes Done requirements and creates finish-up tasks for Partial requirements
9. End-to-end: run full onboarding flow on a test project with existing code, requirements in markdown, and Linear tickets
10. Verify generated MPF_GUIDE.md includes the brownfield workflow with all onboarding commands
