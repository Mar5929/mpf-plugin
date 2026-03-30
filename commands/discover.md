---
name: mpf:discover
description: Create the Product Requirements Document (PRD) through a structured interview. Produces docs/requirements/PRD.md, updates docs/requirements/requirements.md (if in-repo tracking), and populates technical-specs/ with architecture and data model decisions. Run after mpf:init, before mpf:plan-phases.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# mpf:discover

Guide the user through structured product discovery to produce a complete PRD and supporting technical documents.

## Prerequisites

Before starting, read these files to understand the project context:

1. `CLAUDE.md` at the project root (project overview, tier, tracking approach, tech stack)
2. `docs/PROJECT_STATUS.md` (current phase and state)
3. `docs/PROJECT.md` (project identity and problem statement)

If `CLAUDE.md` does not exist, tell the user: "No CLAUDE.md found. Run `mpf:init` first to set up the project."

## Template Reference

Read the PRD.md template from `skills/mpf/references/document-templates.md` (section "PRD.md") before generating the document. Follow that structure exactly.

## Interview Process

Conduct the interview in rounds. Each round collects a category of information. Present questions conversationally, not as a wall of text. Ask 2-4 questions per round, wait for the user's response, then proceed.

### Round 1: Product Vision & Problem

- What is the core problem this product solves?
- Who are the primary users? Describe them briefly.
- What does success look like for this product? (measurable outcomes if possible)
- Are there existing solutions? What falls short about them?

### Round 2: User Stories & Features

- Walk through the primary user workflows. For each workflow:
  - What does the user want to do?
  - What are the steps?
  - What constitutes success for this workflow?
- Capture each workflow as user stories in the format: "As a [user], I want [action] so that [benefit]"
- For each story, ask: "What are the acceptance criteria? How would you test this works?"

### Round 3: Feature Prioritization

Present the collected features in a table and ask the user to prioritize:

| Feature | Suggested Priority | User Priority |
|---------|-------------------|---------------|
| e.g., User login | P0 | ? |

Priority levels:
- **P0**: Must have for launch
- **P1**: Should have, high value
- **P2**: Nice to have, lower priority
- **P3**: Future consideration

### Round 4: Non-Functional Requirements

- Performance targets (response times, throughput, concurrent users)
- Security requirements (auth method, data encryption, compliance)
- Scalability expectations (expected growth, peak load)
- Reliability targets (uptime, error budget)
- Accessibility requirements (WCAG level, screen reader support)

Only ask about categories relevant to the project's tech stack and domain. Skip categories that don't apply (e.g., don't ask about WCAG for a CLI tool).

### Round 5: Boundaries & Open Questions

- What is explicitly out of scope for this version?
- Are there any unresolved questions that need stakeholder input?
- Are there any technical constraints or dependencies on external systems?

### Round 6: Technical Architecture (if not already captured in mpf:init)

Check if `docs/technical-specs/TECHNICAL_SPEC.md` already has substantive content. A file has substantive content if it contains more than just headings, placeholders (`<!-- MPF placeholder -->`), or template text. Specifically: if the file has at least one section with project-specific information (not just structural headings or HTML comment placeholders), treat it as having substantive content and merge rather than overwrite. If it's a placeholder, ask:

- What are the major system components?
- How do they communicate? (REST, GraphQL, message queue, etc.)
- What are the key data entities and their relationships?
- Are there any third-party integrations?

If the tech spec already has content, ask: "The technical spec has some content already. Want to review or update it, or move on?"

## Document Generation

After the interview, generate the following documents:

### 1. PRD.md

Write `docs/requirements/PRD.md` following the template in document-templates.md. Include all information gathered during the interview.

### 2. requirements.md (if in-repo tracking)

> **Ownership note:** `mpf:init` creates the placeholder file structure (empty `docs/requirements/requirements.md`). `mpf:discover` populates it with actual requirement content from user interviews and PRD analysis. If the file already exists as a placeholder from init, populate it rather than creating a new one.

Check CLAUDE.md to determine the tracking approach:
- **If in-repo tracking:** Update `docs/requirements/requirements.md` with atomic requirements extracted from the PRD. Each requirement gets an ID (REQ-001, REQ-002, etc.), a title, description, priority, and status (Not Started). If the file already exists as a placeholder from `mpf:init`, populate it in place.
- **If external tracker:** Skip this file. Requirements will be tracked as tickets in the external system.

### 3. traceability-matrix.md (if external tracker)

If the project uses an external tracker (check CLAUDE.md for tracking approach): create or update `docs/traceability-matrix.md` with requirement IDs from the PRD mapped to placeholder ticket IDs (to be populated by `mpf:plan-phases` or `mpf:sync-linear`). Each requirement extracted from the PRD should have a row in the matrix with its REQ-ID, PRD section reference, and a "TBD" placeholder for the ticket ID.

### 4. Technical Specs (if discussed in Round 6)

Update these files with any new architectural decisions:
- `docs/technical-specs/TECHNICAL_SPEC.md`: system design, component interactions
- `docs/technical-specs/DATA_MODEL.md`: data entities and relationships
- `docs/technical-specs/high-level-architecture.md`: component overview
- `docs/decisions.md`: any architectural decisions made during discovery (as ADR entries)

Only update files where new information was gathered. Don't overwrite existing content; append or merge.

If `docs/technical-specs/code-atlas.md` or other technical-spec files already exist (e.g., from `mpf:map-codebase`), read them first and merge new findings into the existing content rather than overwriting. Reference existing subsystem documentation when writing architecture sections. Preserve file paths, code examples, and module details from the mapper output.

### 5. PROJECT_STATUS.md

Update `docs/PROJECT_STATUS.md`:
- Set current phase to "Discovery: Complete" (or update as appropriate)
- Add a session log entry noting the PRD was created

## After Completion

Tell the user:
- Summarize what was created (list the files written/updated)
- Show the requirement count and priority breakdown (e.g., "12 requirements: 4 P0, 5 P1, 2 P2, 1 P3")
- Recommend: "Run `mpf:plan-phases` to break these requirements into implementation phases."

## Adaptation Rules

- **Short projects (< 5 requirements):** Compress rounds 1-3 into a single round. Skip round 4 if the user signals it's a simple project.
- **Complex projects (> 20 requirements):** Group features by domain area in round 2. Consider splitting into multiple PRD sections.
- **Brownfield projects:** If `docs/technical-specs/code-atlas.md` exists (from mpf:map-codebase), reference it during round 6 to ground architecture discussions in the existing codebase.
- **User provides a PRD:** If the user already has a PRD or equivalent document, skip the interview. Read their document, reformat it into the MPF PRD template, extract requirements, and confirm with the user before writing.

## Roadmap Update

If `docs/roadmap.md` exists, update it with a placeholder entry noting that requirements have been discovered and are ready for phase planning via `mpf:plan-phases`.
