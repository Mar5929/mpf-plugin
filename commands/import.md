---
name: mpf:import
description: Import requirements from external sources (Linear tickets, markdown files, Notion pages, inline text) or through interactive conversation into MPF's requirements.md format. Supports --sources flag for direct source specification and --interactive flag for conversational requirement gathering. Usable standalone mid-project or as part of the onboarding flow.
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Agent, mcp__claude_ai_Linear__*, notion_api
---

# mpf:import

Import requirements from external sources into MPF's `docs/requirements/requirements.md` format. Supports brownfield onboarding (importing from an existing project's artifacts), incremental imports (adding new requirements to an existing MPF project), and interactive conversational gathering.

## Usage

```
mpf:import                                    # Auto-discover sources in the project
mpf:import --sources "docs/spec.md, linear:RIH"  # Import from specific sources
mpf:import --interactive                      # Describe requirements conversationally
```

## Interactive Mode (--interactive)

When `--interactive` is passed, skip source discovery entirely. Instead, gather requirements through a focused conversation:

### Step I-1: Context Setup

1. Read `docs/requirements/requirements.md` (if it exists) to determine the next available REQ ID and understand existing requirements.
2. Read `docs/requirements/PRD.md` (if it exists) to understand the product context.
3. Tell the user: "Describe your new requirements. You can list them all at once, or describe them one at a time. I'll help structure them into REQ format with acceptance criteria."

### Step I-2: Requirement Gathering

For each requirement the user describes:

1. Extract the core requirement (what needs to be built or changed).
2. Ask clarifying questions if the description is vague:
   - "What does success look like for this?" (acceptance criteria)
   - "What priority: P0 (must have), P1 (should have), or P2 (nice to have)?"
   - "Does this depend on any existing requirements?"
3. Draft the requirement in MPF format (REQ-xxx with title, priority, description, acceptance criteria).
4. Show the draft to the user for confirmation before moving to the next.

Keep the conversation focused and efficient. Do not run a full 6-round discovery interview; this is lighter-weight. Ask 1-2 clarifying questions per requirement, not more.

After the user indicates they're done (e.g., "that's all", "done", or no more items), proceed to Step 3 (User Review) with the collected requirements.

### Step I-3: PRD Update (Optional)

If `docs/requirements/PRD.md` exists, ask: "Should I add these requirements to the PRD as well, or just to requirements.md?"

If yes, append a new section to the PRD for each requirement (or group them into a single "Additional Requirements" section).

After completing interactive gathering, proceed to Step 3 (User Review) and Step 4 (Write Output) as normal.

---

## Step 1: Source Discovery

If `--interactive` is passed, skip this step entirely (handled above).

If the `--sources` flag is provided, use those sources directly and skip discovery.

Otherwise, scan for markdown files containing requirement-like content. Look for:

- Headings containing "requirement", "feature", "user story", "epic", "spec"
- Numbered lists with acceptance criteria
- Patterns like "As a user, I want..." or "The system shall..."
- Checkbox lists that look like acceptance criteria

Scan these directories (relative to project root):

- `docs/`
- `requirements/`
- `specs/`
- Project root (top-level `.md` files only)

Present discovered sources to the user in a numbered list. The user can confirm, remove items, or add additional sources before proceeding.

### Source Format Examples

Markdown files:

```
mpf:import --sources "docs/old-prd.md, docs/features.md"
```

Linear project (all issues under a project key):

```
mpf:import --sources "linear:PROJECT-KEY"
```

Notion page (fetches page content and child pages):

```
mpf:import --sources "notion:page-id"
```

Mixed sources:

```
mpf:import --sources "docs/spec.md, linear:RIH, notion:abc123"
```

## Step 2: Parse and Normalize

Spawn the `mpf-importer` agent with the confirmed source list.

The agent reads each source, extracts individual requirements, and normalizes them to MPF format:

```
### REQ-{XXX}: {Title}
- **Priority:** {P0/P1/P2}
- **Source:** {source reference}
- **Description:** {requirement description}
- **Acceptance Criteria:**
  - [ ] {criterion 1}
  - [ ] {criterion 2}
```

Each requirement records its origin:

- `Source: RIH-42` (Linear ticket)
- `Source: docs/old-spec.md, Section 2.1` (markdown file with section reference)
- `Source: Notion/page-id` (Notion page)

The agent deduplicates across sources. If the same requirement appears in both a Linear ticket and a markdown file, it flags the duplicate for user review rather than silently merging.

If Linear is a source, the agent also prepares traceability-matrix entries mapping REQ IDs to Linear ticket IDs.

## Step 3: User Review

Present the full imported requirements list in a summary table:

| REQ ID | Title | Priority | Source | Duplicates? |
|--------|-------|----------|--------|-------------|
| REQ-001 | User authentication | P0 | RIH-42 | -- |
| REQ-002 | Dashboard layout | P1 | docs/spec.md, Section 3 | Possible dup of REQ-005 |

The user can:

- **Merge** flagged duplicates into a single requirement
- **Adjust** priorities (P0/P1/P2)
- **Edit** titles or descriptions
- **Remove** irrelevant items
- **Confirm** the final list

Do not proceed until the user explicitly confirms.

## Step 4: Write Output

Generate or update these files:

1. **`docs/requirements/requirements.md`**: Write the confirmed requirements in MPF format.
2. **`docs/traceability-matrix.md`**: If any source was Linear, populate the REQ-to-ticket mapping. If this file already exists, append new mappings.
3. **`docs/PROJECT_ROADMAP.md`**: Add an import summary entry noting the date, source count, and requirement count.

## Standalone Use (Mid-Project)

When run on a project that already has `docs/requirements/requirements.md`:

1. Read existing requirements to get the current highest REQ ID and existing requirement titles.
2. Assign new REQ IDs starting from the next available number.
3. Deduplicate against existing requirements (flag matches, do not silently skip).
4. Append new requirements after the existing ones.
5. Report what was added versus what was skipped as duplicates.

## After Completion

Tell the user:

- How many requirements were imported, from how many sources
- Any duplicates that were merged or skipped
- File paths that were created or updated

Then recommend: "Run `mpf:audit` to assess which requirements are already implemented in the codebase."
