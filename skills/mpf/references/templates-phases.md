# Phase Document Templates

Templates for phase and task documents. Read the relevant sections when generating each file.

---

## Phase Overview

**Purpose:** Phase definition with goals and success criteria. One file per phase.

**Location:** `docs/requirements/phases/phase-NN-{name}/overview.md`

**Structure:**

### Phase {NN}: {Name}

**Goal:** One-paragraph description of what this phase accomplishes and why it matters.

**Requirements Covered:**
- REQ-001: {title}
- REQ-002: {title}
- (list of REQ-IDs from requirements.md that this phase implements)

**Success Criteria:**
1. {Observable behavior that proves criterion is met}
2. {Another observable behavior}
3. (2-5 criteria total, each testable and specific)

**Dependencies:**
- What must be complete before this phase can begin
- Other phases, external systems, or decisions required

**Linear Milestone:** {milestone name/ID} (if Linear is configured, otherwise omit)

**Tasks:** See `tasks/` directory for individual executable tasks.

---

## Task File

**Purpose:** Single executable task for the mpf-executor agent. Each task is atomic and independently verifiable.

**Location:** `docs/requirements/phases/phase-NN-{name}/tasks/task-NN.md`

**Structure:**

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

**Libraries field:** Added in MPF v2. The planner agent populates this field by analyzing the task's requirements against the project's tech stack (from CLAUDE.md) and the phase requirements. The executor agent uses it to call Context7 for current documentation before implementing. If Context7 is unavailable, the executor proceeds with training knowledge.
