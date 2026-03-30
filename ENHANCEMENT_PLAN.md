# MPF Plugin Enhancement Plan

## Context

The MPF plugin creates project scaffolding with too many overlapping documents (PROJECT.md, PROJECT_STATUS.md, roadmap.md), lacks a usage guide for new users, doesn't guarantee session startup instructions for Light-tier projects, and doesn't create dependency links between Linear tickets. This plan addresses all four issues.

## Changes Overview

| # | Change | Files Affected |
|---|--------|---------------|
| 1 | Consolidate 3 docs into `PROJECT_ROADMAP.md` | 12 core files |
| 2 | Add Session Startup Checklist to Light tier | 2 core files |
| 3 | Add `MPF_GUIDE.md` on project init | 2 core files |
| 4 | Enforce atomic task decomposition + Linear blocked-by/blocks linking + hierarchy doc | 4 core files |

---

## 1. Consolidate PROJECT.md + PROJECT_STATUS.md + roadmap.md into `docs/PROJECT_ROADMAP.md`

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

- **`core/commands/mpf/execute.md`** - update `PROJECT_ROADMAP.md` references
- **`core/commands/mpf/verify.md`** - update references
- **`core/commands/mpf/discover.md`** - update references
- **`core/commands/mpf/decompose.md`** - update references
- **`core/commands/mpf/status.md`** - read single file instead of two
- **`core/commands/mpf/sync-linear.md`** - update references
- **`core/agents/mpf-planner.md`** - context loading item 4: `PROJECT_ROADMAP.md` Section 3
- **`core/skills/mpf/references/workflow-rules.md`** - all dashboard/roadmap references
- **`core/hooks/doc-update-hook.md`** - update reference

---

## 2. Session Startup Checklist for All Tiers (Including Light)

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

## 3. Add `docs/MPF_GUIDE.md` on Project Init

New instructional document generated during `mpf:init` for all tiers.

**Structure:**

```
# MPF Usage Guide

## What is MPF?
  One-paragraph explanation

## Quick Reference: Commands
  Table: Command | Purpose | When to Use (all 10 commands)

## Workflows
  ### Greenfield Project (New from Scratch)
    Numbered steps: init -> discover -> plan-phases -> [plan-tasks -> execute -> verify] per phase

  ### Brownfield Project (Existing Codebase)
    Numbered steps: map-codebase -> init -> discover -> same cycle

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

## 4. Enhanced Decomposition + Linear Dependency Linking + Hierarchy Document

### 4a. Tighter Task Decomposition Rules

- **`core/agents/mpf-planner.md`** (Granularity section, lines 36-53)
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

### 4b. Requirement Hierarchy Document: `docs/requirements/REQUIREMENT_HIERARCHY.md`

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

### 4c. Linear Blocked-By/Blocks Relations

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

## Implementation Order

1. **Document consolidation** (Req 1) first, since it touches nearly every file and all subsequent changes reference `PROJECT_ROADMAP.md`
2. **Session startup for Light tier** (Req 2) next, small and focused
3. **MPF Usage Guide** (Req 3) next, adds new template and generation logic
4. **Enhanced decomposition + Linear linking** (Req 4) last, most complex behavioral change

After all changes: `bash build.sh` to regenerate output directories.

## Verification

1. Run `bash build.sh` and confirm it completes without errors
2. Check generated output in `commands/`, `skills/`, `agents/`, `hooks/` for correct tool/tier resolution
3. Grep for stale references: `PROJECT_STATUS.md`, `PROJECT.md` (standalone), `roadmap.md` (standalone) should not appear in any core/ file
4. Verify all new template sections (PROJECT_ROADMAP.md, MPF_GUIDE.md, REQUIREMENT_HIERARCHY.md) appear in document-templates.md ToC
5. Verify SKILL.md tier definitions table reflects new section counts (Light: 7 sections, Standard: 10, Full: 13)
6. Verify plan-tasks.md has the new Step 5 for Linear dependency linking
7. Verify mpf-planner.md has the tightened granularity rules and decomposition depth example
