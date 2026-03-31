---
name: mpf:reconcile
description: Document overlap detection and resolution. Scans existing project documentation, identifies overlap with MPF-generated docs, and lets the user choose per document whether to absorb (merge into MPF doc and archive original), reference (link from MPF doc, keep original), or skip. Run after mpf:audit, before mpf:sync-linear.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent
---

# mpf:reconcile

Scan existing project documentation, detect overlap with MPF-generated docs, and let the user decide per document how to handle each overlap.

## Workflow

### Step 1: Scan for Existing Documents

Search the project for documentation files in common locations:

1. Check these paths and directories for markdown, text, and doc files:
   - `docs/` (recursive)
   - `specs/` (recursive)
   - `design/` (recursive)
   - `README.md`
   - `ARCHITECTURE.md`
   - `CHANGELOG.md`
   - `CONTRIBUTING.md`
   - `API.md`
   - Any other `.md` files in the project root

2. For each document found, read its content and categorize by overlap with MPF docs:

   | Overlap Target | Document Signals |
   |----------------|-----------------|
   | `PROJECT_ROADMAP.md` | Project overview, status tracking, roadmaps, timelines, milestones |
   | `code-atlas.md` | Architecture docs, module descriptions, system design diagrams, component maps |
   | `TECHNICAL_SPEC.md` | Design specs, API docs, interface definitions, data formats |
   | `requirements.md` | Requirements docs (note: already handled by `mpf:import`, flag but do not re-process) |
   | No overlap | Project-specific docs MPF does not generate (e.g., CONTRIBUTING.md, CHANGELOG.md, test plans) |

3. Build a list of overlapping documents with their overlap target and a one-line content summary.

If no overlapping documents are found, tell the user: "No document overlap detected. Your existing docs do not conflict with MPF-generated documents. Run `mpf:sync-linear` to check tracker alignment."

### Step 2: Present Per-Document Choices

Display the overlap findings and ask the user to choose an action for each document:

```
Document overlap detected. Choose an action for each:

1. docs/architecture.md
   Contains: System architecture overview, component diagram descriptions
   Overlaps with: code-atlas.md
   Recommendation: Absorb (content fits naturally into code-atlas.md sections)
   Action? [absorb / reference / skip]

2. docs/api-design.md
   Contains: REST API endpoint definitions, request/response schemas
   Overlaps with: TECHNICAL_SPEC.md
   Recommendation: Absorb (API specs belong in tech spec)
   Action? [absorb / reference / skip]

3. README.md
   Contains: Project overview, setup instructions, team info
   Overlaps with: PROJECT_ROADMAP.md (Section 1 only)
   Recommendation: Reference (README serves a different audience than roadmap)
   Action? [absorb / reference / skip]
```

**Action definitions:**

- **Absorb**: Extract relevant content from the document, merge it into the corresponding MPF doc, and move the original to `docs/archive/pre-mpf/`.
- **Reference**: Add a link in the corresponding MPF doc pointing to the original document. The original stays in place and remains authoritative.
- **Skip**: No action. The document has no meaningful overlap or the user wants to leave it alone.

Wait for the user to choose an action for each document before proceeding.

### Step 3: Execute Reconciliation

Spawn the `mpf-reconciler` agent with the following input:

- List of documents with their user-chosen action (absorb, reference, or skip)
- For each document: the source file path, the target MPF doc, and a content summary
- The project root path

The mpf-reconciler agent handles:

**For absorbed documents:**
1. Read the source document fully
2. Extract content relevant to the target MPF doc
3. Restructure and merge content into the MPF doc's section format
4. Add attribution at the point of insertion: "Originally from {filename}, absorbed during MPF onboarding"
5. Move the original file to `docs/archive/pre-mpf/{original-filename}`
6. If a source doc has content for multiple MPF docs, split and merge into each

**For referenced documents:**
1. Identify the most relevant section in the target MPF doc
2. Add a reference note: "See {path} for {brief description of what it covers}"
3. Do not modify the original document

Create `docs/archive/pre-mpf/` directory if any documents are absorbed.

### Step 4: Source of Truth Assignment

After reconciliation, record source-of-truth decisions:

| Document Type | Source of Truth | Rationale |
|---------------|----------------|-----------|
| Structured external tools (Linear, Notion) | External tool | MPF syncs from them, not the reverse |
| Absorbed markdown files | MPF docs | Original archived, MPF doc is canonical |
| Referenced docs | Original file | MPF links to it, original stays authoritative |

Record these decisions in `docs/PROJECT_ROADMAP.md` Section 6 (or append a "Source of Truth" section if it does not exist). If `CLAUDE.md` has an update protocol section, add a note there as well.

### Step 5: Summary Report

Display a reconciliation summary to the user and write it to `docs/reconciliation-report.md`:

```markdown
# Reconciliation Report

**Generated:** {YYYY-MM-DD}
**Project:** {project name}

## Summary

| Action | Count | Details |
|--------|-------|---------|
| Absorbed | {N} | {N} docs archived, content merged into {M} MPF docs |
| Referenced | {N} | {N} docs linked from MPF docs |
| Skipped | {N} | {N} docs (no overlap or user chose to skip) |

## Absorbed Documents

| Original File | Archived To | Merged Into |
|---------------|-------------|-------------|
| docs/architecture.md | docs/archive/pre-mpf/architecture.md | code-atlas.md |

## Referenced Documents

| Original File | Referenced From | Description |
|---------------|----------------|-------------|
| README.md | PROJECT_ROADMAP.md | Project overview and setup instructions |

## Skipped Documents

| File | Reason |
|------|--------|
| CHANGELOG.md | No MPF overlap |

## Source of Truth Assignments

| Scope | Authority | Notes |
|-------|-----------|-------|
| {scope} | {authority} | {notes} |
```

## After Completion

Tell the user:

```
Reconciliation complete:
- Absorbed: {N} docs archived, content merged into {M} MPF docs
- Referenced: {N} docs linked from MPF docs
- Skipped: {N} docs

Run `mpf:sync-linear` to check tracker alignment.
```

## Error Handling

- If no MPF docs exist yet (PROJECT_ROADMAP.md, code-atlas.md, TECHNICAL_SPEC.md), tell the user: "MPF documents have not been generated yet. Run `mpf:init` first, then re-run `mpf:reconcile`."
- If a document marked for absorption cannot be parsed (binary file, corrupt encoding), skip it and report: "Could not process {filename}: {reason}. Skipped."
- If the mpf-reconciler agent fails mid-operation, report which documents were processed and which were not.
- If `docs/archive/pre-mpf/` already exists (re-running reconcile), warn the user and ask whether to overwrite or create a timestamped subdirectory.
