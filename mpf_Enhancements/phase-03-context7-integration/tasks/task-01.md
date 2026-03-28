# Task 01: Add Libraries field to task file template

**Requirement:** REQ-007
**Phase:** 3

## Context
Read these files before implementing:
- `skills/mpf/references/document-templates.md` -- Task File section starts at line 580. Current template has sections: Files, Action, Verify, Done, Dependencies. The Libraries field goes between Files and Action.
- `mpf_Enhancements/phase-03-context7-integration/overview.md` -- success criterion 1: Libraries field format

## Files
- `skills/mpf/references/document-templates.md` (modify) -- add Libraries field to task file template

## Action
In the Task File template (starting at line 588), insert a `## Libraries` section between `## Files` and `## Action`. Update the template to:

```markdown
# Task {NN}: {Title}

**Requirement:** REQ-{XXX} (the requirement ID(s) this task implements)
**Linear Ticket:** {ticket ID or "N/A" if Linear is not configured}

## Files
- `path/to/file1.ts` (create)
- `path/to/file2.ts` (modify)

## Libraries
- {library-name}@{version-constraint} -- {what it is used for in this task}
- {another-library}@{version} -- {purpose}

_(Optional. Populated by the planner agent. Omit this section if the task does not use external libraries. The executor uses this list to fetch current documentation from Context7 before implementing.)_

## Action
Specific implementation instructions. What to build, how to build it, and any constraints or patterns to follow.

## Verify
```bash
# Test commands to run after completion
npm test -- --grep "relevant test"
```

## Done
- [ ] {Observable criterion that proves the task is complete}
- [ ] {Another criterion}

## Dependencies
**Wave:** {1|2|3|...} (1 = no dependencies, 2+ = depends on earlier waves)
**Depends On:** task-01, task-03 (list of task numbers this depends on, or "none")
```

Also add a note after the template explaining the Libraries field:

```markdown
**Libraries field:** Added in MPF v2. The planner agent populates this field by analyzing the task's requirements against the project's tech stack (from CLAUDE.md) and the phase requirements. The executor agent uses it to call Context7 for current documentation before implementing. If Context7 is unavailable, the executor proceeds with training knowledge.
```

## Verify
```bash
grep "## Libraries" skills/mpf/references/document-templates.md
grep "Context7" skills/mpf/references/document-templates.md
grep "version-constraint" skills/mpf/references/document-templates.md
```

## Done
- [ ] Task file template includes `## Libraries` section between Files and Action
- [ ] Format shows `{library-name}@{version-constraint} -- {purpose}`
- [ ] Section is marked as optional with explanatory note
- [ ] Explanation of Libraries field added after the template

## Dependencies
**Wave:** 1
**Depends On:** none
