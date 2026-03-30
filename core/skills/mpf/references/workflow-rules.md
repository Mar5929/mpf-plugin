# Workflow Rules Reference

These rules apply after scaffolding is created, scoped to whichever workflows the user enabled during the interview. Include the relevant rules in the generated CLAUDE.md.

---

## Dashboard Maintenance Rules (always apply)

1. **Session log.** At the end of every session (or when the user says they're done for now), append a row to the Session Log in `docs/PROJECT_STATUS.md` with: today's date, a one-line summary of what was accomplished, which docs were updated, and a suggestion for next session.
2. **Phase transitions.** When the project moves to a new phase (e.g., Discovery to Implementation, or Sprint 1 to Sprint 2), update Section 1 (Current Phase) and add a completed row to Section 7 (Phase History). Confirm phase transitions with the user before updating.
3. **Blocker tracking.** When a blocker is identified during work (waiting on external input, blocked dependency, needs decision), add it to Section 5 (Blockers & Waiting). When a blocker is resolved, remove it and note the resolution in the session log.
4. **Active items sync.** Keep Section 4 (Active Work Items) in sync with the tracker or `docs/BACKLOG.md`. When items are started, completed, or blocked, update this section in the same response.
5. **Responsibility matrix updates.** If a new document or workflow is added to the project (via evolve mode or manually), add the corresponding row to the responsibility matrix. If ownership changes are agreed upon during conversation, update the matrix immediately.

---

## Document Maintenance Rules (apply only to enabled documents)

1. **Proactive updates.** When you write or modify code, update all affected enabled docs in the same response. Do not defer documentation to a later step.
2. **Cross-reference.** Use IDs (`BL-xxx`, `ADR-xxx`, `REQ-xxx`, `NFR-xxx`) to link between documents. A changelog entry should reference the backlog item it closes. A backlog item should reference the requirement it implements. A decision should list related requirements, backlog items, and other ADRs.
3. **No stale docs.** If you notice an enabled doc is out of date during any task, fix it immediately.
4. **Atomic consistency.** If a change affects multiple docs (e.g., completing a backlog item also updates the changelog, the requirements status, and possibly the code atlas), update all of them together.
5. **Summarize, don't dump.** Keep entries concise and scannable. Use tables and bullet lists over prose paragraphs.
6. **Follow the Update Protocol.** Refer to the event-to-action table in CLAUDE.md Section 4 for which docs to update for each type of event.
7. **Session length check.** If a session exceeds 15 turns, Claude should proactively suggest: "We've been going for a while. Want me to update all living docs with the current state and start a fresh session? Long sessions increase the chance I'll miss doc updates." This is not a hard rule: the user may decline.
8. **Prioritized update order.** When a single action requires updating multiple docs, follow this priority order. If you cannot complete all updates in one response, complete as many as possible in priority order, then explicitly state which updates remain.
   - Priority 1 (must complete): `docs/technical-specs/code-atlas.md`, tracker ticket status
   - Priority 2 (should complete): `docs/traceability-matrix.md` or `docs/BACKLOG.md`, CHANGELOG.md
   - Priority 3 (complete if possible): `docs/decisions.md`, `docs/technical-specs/TECHNICAL_SPEC.md`, `docs/PROJECT_STATUS.md`
9. **Incomplete update disclosure.** If you complete a code change but cannot update all required docs in the same response, you MUST explicitly say: "I still need to update: [list of docs]. Want me to do that now?" Never silently skip a doc update.
10. **Show your work for doc updates.** When updating a living document, show the relevant diff or the new content you're adding. For small updates (1-5 lines), include the actual content in your response. For larger updates, show a summary of what changed. This makes it verifiable and reduces hallucinated updates.
11. **Rules-CLAUDE.md consistency.** Whenever you update a section of CLAUDE.md that has a corresponding `.claude/rules/` file, update both in the same response. If you notice a conflict between a rules file and CLAUDE.md, flag it to the user and ask which is correct before proceeding.

---

## Version Control Rules (apply only if version control enabled)

Follow the specific policies agreed upon during the interview:
- Use the agreed branching strategy for all new work.
- Write commit messages following the format in CLAUDE.md Section 9 (e.g., `feat(BL-XXX): Short summary`).
- Only push to remote when the agreed push policy allows it.
- When merge conflicts arise, follow the agreed resolution approach (auto-resolve or flag for user review).
- Create PRs/MRs with descriptive titles, summaries, and linked backlog items if that workflow was enabled.
- Include documentation updates in the same commit as the code change.

### Version Control: Branch-per-Phase Strategy

- `mpf:execute` creates a feature branch: `feature/phase-{N}-{name}`
- Branch pushed to remote immediately after creation
- All tasks commit to the phase branch with atomic commits
- Commits pushed to remote after each task completion
- Branch merges to main only after `mpf:verify` passes
- Phase N branch must be merged before `mpf:execute` N+1 starts

---

## MPF Phase Execution Rules

- Phases execute in order (Phase 1 before Phase 2)
- Each phase follows: `mpf:plan-tasks` -> `mpf:execute` -> `mpf:verify`
- If `mpf:verify` fails, re-run `mpf:execute` to fix failed tasks
- Phase advancement requires explicit user action

## Agent Orchestration Rules

These rules apply when `mpf:execute` runs with team-based execution (the default for Standard and Full tier projects).

### Team-Based Execution
- The orchestrator creates a team (`mpf-execute-phase-{N}`) containing the planner and all executors for the phase.
- The planner is spawned in the background at team creation and remains available for the duration of execution.
- Executors are spawned on the same team, enabling direct communication via `send_message`.
- The team is dissolved after all waves complete (or execution is halted).

### Escalation Flow
- Executors encountering ambiguity check trigger conditions (missing file, ambiguous spec, scope creep, unspecified dependency) before stopping.
- On trigger match, the executor sends a structured escalation message to the planner.
- The planner responds with guidance (decision, rationale, file references).
- The executor incorporates guidance and continues. If the planner cannot resolve, the executor stops with an error report.
- All escalation events are logged in the executor's output for post-execution review.

### Cross-Wave State Injection
- After each wave completes, the orchestrator collects structured summaries from each executor (files changed, deviations, key decisions).
- These summaries are formatted as a "Prior Wave Context" block and injected into the next wave's executor prompts.
- Executors should read prior wave context to understand dependencies but should not modify files from prior waves unless explicitly listed in their task spec.
- Wave 1 has no prior context (skipped).

### Inline Verification
- If enabled, the orchestrator spawns `mpf-checker` after each wave to verify completed tasks.
- On failure, the user chooses: Continue, Stop, or Retry.
- Inline verification is a structural check, not a replacement for the comprehensive `mpf:verify` pass.
- Configuration is set during `mpf:init` Round 8 and stored in CLAUDE.md.

---

## Living Document Hook Rules

- PostToolUse hook on file_write/file_edit reminds Claude to check doc updates
- Priority order for doc updates: code-atlas -> tracker status -> traceability/backlog -> changelog -> decisions/spec -> PROJECT_STATUS
- Update `code-modules/` files when module internals change
- Update `architecture/` files when subsystem boundaries change

---

## Testing Rules (apply only if testing workflows enabled)

- If auto-generated tests are enabled, write tests alongside feature code in the same response.
- If Playwright MCP is enabled, generate Playwright test scaffolds for new UI features and capture screenshots as configured.
- Run linting/formatting checks before commits if CI/CD integration was specified.
- Never commit code that fails tests.

---

## Discovery Rules (apply only if Discovery phase enabled)

- Guide the user through structured requirement gathering before writing code.
- Produce user stories with acceptance criteria, technical specifications, and data model designs.
- Populate `docs/technical-specs/DATA_MODEL.md` with planned tables/objects during Discovery (status: `PLANNED`).
- Only transition to implementation when the user confirms Discovery is complete.

**If using in-repo tracking:**
- Use `docs/requirements/requirements.md` and `docs/technical-specs/TECHNICAL_SPEC.md` as the primary outputs of the Discovery phase.
- Create initial backlog items in `docs/BACKLOG.md` organized by phase as requirements are defined.

**If using external tracker + traceability matrix:**
- Use the PRD, `docs/technical-specs/TECHNICAL_SPEC.md`, and the external tracker as the primary outputs of the Discovery phase.
- Decompose product requirements into tracker tickets with acceptance criteria.
- Build `docs/traceability-matrix.md` as tickets are created, mapping each requirement to its ticket(s).
- Propose phase groupings (which tickets belong to which implementation phase) for user approval.
- After phases are defined, update the matrix's Phase column and create tracker milestones if the tool supports them.

---

## Migration Rules (apply only if migration/rebuild enabled)

- Keep `MIGRATION_REFERENCE.md` updated as modules, components, and data models are mapped and migrated.
- When implementing a feature that has an original equivalent, document the mapping in the Migration Reference before or during implementation.
- Note simplifications, removals, and new additions explicitly.

---

## Project Lifecycle & Traceability Rules (apply only if external tracker + traceability matrix enabled)

### Source of Truth Hierarchy
Each document has ONE job. When sources conflict, this priority order applies:
1. **PRD / Product Requirements** (what to build): authoritative for product decisions
2. **Tech Spec + Design Specs** (how to build): authoritative for architecture
3. **External Tracker** (status): authoritative for ticket status, acceptance criteria, assignments
4. **Traceability Matrix** (mapping): authoritative for requirement-to-ticket-to-phase mapping
5. **Code Atlas** (current state): authoritative for what exists in the codebase now

### Traceability Rules
- Every implementation task must trace to a product requirement AND a tracker ticket via `docs/traceability-matrix.md`.
- Never invent requirements not traceable to a PRD section or tracker ticket.
- Flag any product requirements with no corresponding tracker ticket (coverage gap).
- Flag any tracker tickets with no product requirement traceability (orphan ticket).
- Commit messages must include the tracker ticket identifier (e.g., `feat(RIH-150): ...`). Use the tracker's ticket ID format, not backlog item IDs.

### Decomposition & Phasing Rules
- During Discovery, populate the traceability matrix as requirements are decomposed into tracker tickets.
- Phase assignments are proposed by Claude but require user approval before being set.
- When tickets are created, split, or phases restructured, update the traceability matrix in the same response.
- Steps 3-5 of the lifecycle (decomposition, matrix, phase definition) happen once per project and are updated as scope changes.
- Steps 6-7 (implementation planning and implementation) repeat per phase.

### Agent Planning Protocol
When creating an implementation plan for a phase:
1. Read `docs/traceability-matrix.md` to identify the phase's tickets
2. Query the external tracker for each ticket's acceptance criteria and current status
3. Read the PRD sections referenced in the matrix for domain context
4. Read `docs/technical-specs/TECHNICAL_SPEC.md` and relevant design specs for architectural decisions
5. Read `docs/technical-specs/code-atlas.md` for current codebase state
6. Invoke `mpf:plan-tasks` to create the implementation plan
7. Execute via `mpf:execute`
8. Verify via `mpf:verify`

---

## Brownfield Project Flow

Use this flow when adding MPF to an existing codebase. The map-codebase step ensures init and discover have full context about existing code structure.

1. `mpf:map-codebase` - Analyze existing codebase structure
2. `mpf:init` - Initialize MPF scaffolding (will detect existing code and adapt)
3. `mpf:discover` - Create/update PRD from existing functionality
4. `mpf:plan-phases` - Break requirements into phases
5. `mpf:plan-tasks` - Break phases into executable tasks
6. `mpf:execute` - Execute tasks with atomic commits
7. `mpf:verify` - Verify phase completion

---

## Web App-Specific Rules (apply only if project type is web app)

### Frontend Development
- Use the **frontend-design skill** and **ui-ux-pro-max skill** for all UI work to ensure high-quality, production-grade design.
- **Tailwind CSS** is the required styling framework (per global rule `rules/ui-development.md`).
- Follow the chosen UI component library's conventions and patterns.
- Implement responsive design by default.
- Use the screenshot workflow (`screenshot.mjs` + `SCREENSHOT_WORKFLOW.md`) for visual verification of UI changes.

### Infrastructure
- If Docker is enabled, keep `Dockerfile` and `docker-compose.yml` up to date as dependencies change.
- If CI/CD is enabled, update GitHub Actions workflow when new test suites or deployment steps are added.
- Keep `.env.example` in sync with any new environment variables added.

### Testing
- Use Playwright for e2e testing of all user-facing features.
- Write unit tests for backend services and API endpoints.
- Run the full test suite before committing.
