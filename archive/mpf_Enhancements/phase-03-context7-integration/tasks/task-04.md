# Task 04: Add Libraries population step to planner

**Requirement:** REQ-008
**Phase:** 3

## Context
Read these files before implementing:
- `agents/mpf-planner.md` -- Task Decomposition Rules section (starts around line 43). The "What Makes a Good Task" sub-section (line 49) lists: Specific, Actionable, Verifiable, Independent within its wave. A new "Library-aware" rule is added here.
- `agents/mpf-planner.md` -- Output section (line 76) shows the task file template. This template needs the Libraries field added.
- `skills/mpf/references/document-templates.md` -- as modified by task 3-01, to see the updated task template with Libraries field

## Files
- `agents/mpf-planner.md` (modify) -- add library identification rule and update output template

## Action

### 1. Add library-aware rule to Task Decomposition Rules
In the "### What Makes a Good Task" sub-section, after the "Independent within its wave" bullet (around line 54), add:

```markdown
- **Library-aware:** If the task involves external libraries or frameworks, populate the `## Libraries` section listing each library with version constraint and purpose. Derive library references from:
  - The project's tech stack in CLAUDE.md
  - Package manifests (package.json, requirements.txt, go.mod, etc.) in the project root
  - The phase requirements and PRD
  - Include version constraints when discoverable from package manifests. If unknown, omit the version: `react -- UI component rendering`
```

### 2. Update the output task file template
In the "## Output" section, update the task file template to include the Libraries field. The template currently shows: Files, Action, Verify, Done, Dependencies. Add Libraries between Files and Action:

```markdown
## Libraries
- {library-name}@{version} -- {purpose in this task}

## Action
```

### 3. Add Libraries to the Coverage section
In the "## Completion" section's coverage report, add a note that library references should be traceable to the project's tech stack.

## Verify
```bash
grep "Library-aware" agents/mpf-planner.md
grep "## Libraries" agents/mpf-planner.md
grep "package.json\|requirements.txt\|go.mod" agents/mpf-planner.md
```

## Done
- [ ] "Library-aware" rule exists in What Makes a Good Task
- [ ] Planner knows to derive library references from CLAUDE.md, package manifests, and phase requirements
- [ ] Output task file template includes `## Libraries` section
- [ ] Version constraint guidance is included (use when discoverable, omit when unknown)

## Dependencies
**Wave:** 2
**Depends On:** task-01
