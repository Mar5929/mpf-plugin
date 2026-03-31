---
name: mpf:sync-linear
description: Compare local MPF project artifacts with Linear ticket status. Reports gaps, orphan tickets, status mismatches, and missing traceability. Optionally fixes discrepancies by updating Linear or local docs. Run any time to audit project-tracker alignment.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, mcp__claude_ai_Linear__*
---

# mpf:sync-linear

Compare local project state (roadmap, traceability matrix, task files) with Linear ticket state. Detect discrepancies and optionally fix them.

## Prerequisites

### Step 1: Validate Configuration

1. Read `CLAUDE.md` and check for Linear configuration (external tracking approach, team ID).
2. If Linear is not configured, tell the user: "Linear integration is not configured for this project. Run `mpf:init` with external tracking to set up Linear."
3. Read `docs/traceability-matrix.md`. If it does not exist, tell the user: "No traceability matrix found. This command requires external tracker integration. Run `mpf:plan-phases` to create the matrix."
4. Read `docs/PROJECT_ROADMAP.md`.

## Sync Process

### Step 2: Collect Local State

Build a local state map from project files:

1. **Traceability matrix** (`docs/traceability-matrix.md`):
   - Extract all REQ-XXX to RIH-XXX mappings
   - Note phase assignments for each requirement
   - Identify requirements with no ticket ID (coverage gaps)

2. **Roadmap** (`docs/PROJECT_ROADMAP.md` Section 3):
   - Extract phase statuses: Not Started, In Progress, Done

3. **Phase overview files** (`docs/requirements/phases/phase-{NN}-{name}/overview.md`):
   - Extract milestone IDs (if recorded)
   - Extract success criteria status

4. **Task files** (`docs/requirements/phases/phase-{NN}-{name}/tasks/task-*.md`):
   - Extract ticket IDs per task
   - Check Done checkbox state (all checked = task complete)

### Step 3: Collect Linear State

Query Linear for the current ticket state:

1. Use `mcp__claude_ai_Linear__*` for team Rihm (`dfe15bc4-6dd0-4bde-8609-6620efc3140d`) to get all tickets.
2. For each ticket, record: ticket ID, title, state (Backlog, Todo, In Progress, Done, Cancelled), assignee, milestone.
3. Build a lookup map: ticketId -> { title, state, assignee, milestone }.

If `mcp__claude_ai_Linear__*` tools are unavailable, tell the user: "Linear MCP server is not connected. Check that the Linear MCP server is configured in your Claude Code settings."

### Step 4: Compare and Detect Discrepancies

**Onboarding context:** When run as part of the onboarding flow (after `mpf:reconcile`), also read `docs/requirements/audit-report.md` if it exists. Use the audit data to:
- Cross-reference "Done" assessments in the audit with Linear ticket states
- Include audit evidence in the sync report for "Done in code, open in Linear" checks
- Add an "Onboarding Sync" section to the report header noting this is an initial alignment check

Run each of these checks and collect all discrepancies:

| Check | What to Compare | Severity |
|-------|----------------|----------|
| **Missing ticket** | REQ-XXX in traceability matrix has empty Tracker Ticket(s) column | High |
| **Orphan ticket** | RIH-XXX exists in Linear (team Rihm) but has no row in traceability matrix | Medium |
| **Status: local ahead** | Local task file has all Done checkboxes checked, but Linear ticket state is not Done | High |
| **Status: Linear ahead** | Linear ticket state is Done, but local task file Done checkboxes are not all checked | Medium |
| **Phase: local ahead** | Phase marked Done in PROJECT_ROADMAP.md but has associated tickets not in Done state in Linear | High |
| **Phase: Linear ahead** | All tickets for a phase are Done in Linear but PROJECT_ROADMAP.md still shows In Progress or Not Started | Medium |
| **Missing milestone** | Phase overview file references a milestone ID that does not exist in Linear | Low |
| **Unassigned ticket** | Ticket in Linear has no assignee (should be Michael Rihm) | Low |
| **Missing dependency link** | Task file has "Depends On" entries but corresponding Linear tickets lack blocked-by/blocks relations | Medium |
| **Done in code, open in Linear** | audit-report.md marks requirement as Done but corresponding Linear ticket state is not Done | Medium |
| **Untracked requirement** | Imported requirement in requirements.md has no corresponding Linear ticket (no entry in traceability-matrix.md) | Low |
| **Orphan ticket (unmatched)** | Linear ticket exists but has no matching requirement in requirements.md (different from "Orphan ticket" which checks traceability matrix only; this also checks requirements.md) | Low |

### Step 5: Generate Report

Display the report to the user and write it to `docs/sync-report.md`.

**Report structure:**

```markdown
# Linear Sync Report

**Generated:** {YYYY-MM-DD}
**Team:** Rihm
**Project:** {project name from CLAUDE.md}

## Summary

| Metric | Count |
|--------|-------|
| Requirements tracked | {N} |
| Linear tickets found | {N} |
| Discrepancies | {N} |
| High severity | {N} |
| Medium severity | {N} |
| Low severity | {N} |

Overall: {CLEAN / N DISCREPANCIES FOUND}

## Ticket Status by Phase

| Phase | Name | Local Status | Tickets | Backlog | In Progress | Done | Cancelled |
|-------|------|-------------|---------|---------|-------------|------|-----------|

## Discrepancies

### High Severity

#### 1. {Check type}: {REQ-ID or RIH-ID}
- **Local:** {local state description}
- **Linear:** {Linear state description}
- **Fix:** {recommended action}

### Medium Severity
{same format}

### Low Severity
{same format}

## Orphan Tickets

| Ticket | Title | State | Suggested Action |
|--------|-------|-------|------------------|

## Onboarding Alignment (if audit-report.md exists)

| Requirement | Audit Status | Linear Status | Action Needed |
|-------------|-------------|---------------|---------------|
| REQ-001 | Done | Open | Close ticket or dispute audit |
| REQ-003 | Partial | Open | Expected: partial work remains |
| REQ-005 | Not Started | No ticket | Create ticket |

## Coverage Summary

| Requirement | Ticket(s) | Phase | Status |
|-------------|-----------|-------|--------|
```

If there are zero discrepancies, display: "All local project state is aligned with Linear. No action needed."

### Step 6: Offer Fixes (Interactive)

If discrepancies were found, present fix options to the user:

```
{N} discrepancies found. How would you like to proceed?

1. Fix all automatically (update Linear tickets and local docs)
2. Fix only high-severity issues
3. Review one by one (I'll ask for each discrepancy)
4. Skip fixes (keep the report for reference)
```

Wait for the user's choice before proceeding.

**Fix actions by discrepancy type:**

- **Missing ticket:** Create a new Linear ticket via `mcp__claude_ai_Linear__*` with the requirement description, assign to Michael Rihm, set appropriate state. Update `docs/traceability-matrix.md` with the new ticket ID.
- **Orphan ticket:** Ask the user if the ticket belongs to this project. If yes, add it to `docs/traceability-matrix.md` mapped to the appropriate requirement. If no, skip it.
- **Status mismatch (local ahead):** Update the Linear ticket state to match local status via `mcp__claude_ai_Linear__*`. Add a comment via `mcp__claude_ai_Linear__*`: "Status synced from local project state: task completed."
- **Status mismatch (Linear ahead):** Update the local task file to check all Done checkboxes. Update `docs/PROJECT_ROADMAP.md` Section 5 (Active Work Items).
- **Phase mismatch (local ahead):** Update Linear tickets for the phase to Done state.
- **Phase mismatch (Linear ahead):** Update `docs/PROJECT_ROADMAP.md` Section 3 (Phase Roadmap) phase status to Done and Section 2 (Current Phase) summary.
- **Missing milestone:** Note in the report. Do not auto-create milestones (user may have restructured in Linear).
- **Unassigned ticket:** Assign to Michael Rihm (`8d75f0a6-f848-41af-9f4b-d06036d6af82`) via `mcp__claude_ai_Linear__*`.
- **Missing dependency link:** Read the task file's "Depends On" field, look up ticket IDs, and call `save_issue(id: ticket_id, blockedBy: [dependency_ticket_ids])` to create the missing relation.
- **Done in code, open in Linear:** Update the Linear ticket state to Done via `mcp__claude_ai_Linear__*`. Add a comment via `mcp__claude_ai_Linear__*`: "Marked done based on implementation audit: code exists and acceptance criteria met."
- **Untracked requirement:** Create a new Linear ticket via `mcp__claude_ai_Linear__*` using the requirement's title and description from `docs/requirements/requirements.md`. Assign to Michael Rihm (`8d75f0a6-f848-41af-9f4b-d06036d6af82`), team Rihm (`dfe15bc4-6dd0-4bde-8609-6620efc3140d`). Update `docs/traceability-matrix.md` with the new ticket ID.
- **Orphan ticket (unmatched):** Ask the user if the ticket maps to an existing requirement (link it in `docs/traceability-matrix.md`) or should be imported as a new requirement (create a REQ entry in `docs/requirements/requirements.md` and add the mapping to the traceability matrix).

### Step 7: Post-Fix Summary

After applying fixes, display a summary:

```
Sync fixes applied:
- {list each change: "Updated RIH-142 to Done in Linear", "Added RIH-157 to traceability matrix for REQ-007", etc.}

Run `mpf:status` to see the updated dashboard.
```

Update the sync report file (`docs/sync-report.md`) to reflect the fixes applied.

## Error Handling

- If `mcp__claude_ai_Linear__*` tools are not available (server not connected), tell the user: "Linear MCP server is not connected. Check that the Linear MCP server is configured in your Claude Code settings."
- If `docs/traceability-matrix.md` does not exist, tell the user: "No traceability matrix found. This command requires external tracker integration. Run `mpf:init` with external tracking, then `mpf:plan-phases` to create the matrix."
- If `mcp__claude_ai_Linear__*` calls fail or rate limit, report partial results and note which phases could not be checked.
- If no phases exist yet (empty roadmap), tell the user: "No phases found in roadmap. Run `mpf:plan-phases` first."
