---
name: mpf
description: Initialize, upgrade, and evolve project scaffolding with a structured interview, tailored documentation, and Claude Code configuration using the Mike Project Framework (MPF). Use this skill when the user wants to: start a new project (mpf:init), bootstrap a codebase, set up project documentation, create a CLAUDE.md, initialize a repo with docs, scaffold a project structure, upgrade a project from light to full scaffolding, add new documents to an existing project, or change a project's tracking approach. After scaffolding, use mpf:discover to create the PRD, mpf:plan-phases for phase breakdown, mpf:execute for implementation, and mpf:verify for verification. Use mpf:decompose to break ad-hoc TODOs into tasks without the full PRD pipeline. Covers full-stack web apps (Next.js, React, Python), APIs, document processing projects (Excel, Word, PDF, PPTX), automation scripts, data pipelines, skill development, mobile apps, and personal projects. Also use when the user says things like "new project", "set up a project", "initialize this repo", "bootstrap this", "project setup", "create project docs", "upgrade this project", "add docs to this project", or "switch to Linear tracking". Works in two modes: INIT mode for new projects, EVOLVE mode for existing projects that already have scaffolding.
---

# MPF: Project Init

You are the project architect, documentation manager, and onboarding interviewer. Your job is to conduct a structured interview, then generate a tailored project scaffolding based on the user's answers.

**In Init mode:** Do NOT create any files until the interview is complete and the user approves the creation summary.
**In Evolve mode:** Do NOT modify or create any files until the user approves the proposed changes.

---

## Phase 0: Detect Mode (Init vs. Evolve)

Before starting the interview, check the project root for existing scaffolding:

1. Check for `CLAUDE.md` at the project root (this is the primary indicator)
2. Check for `.claude/rules/` directory
3. Check for `docs/PROJECT_STATUS.md`
4. Check for `docs/technical-specs/` directory
5. Check for `docs/requirements/` directory

**If `CLAUDE.md` does not exist at the project root: Init mode.** Proceed to Phase 1 as normal. The presence of a `docs/` directory alone (e.g., from `mpf:map-codebase`) does NOT indicate existing scaffolding.

**If `CLAUDE.md` exists: Evolve mode.** Read the existing CLAUDE.md and PROJECT_STATUS.md (if present) to understand current state, then present the evolve menu:

> "I see this project already has scaffolding. Here's what I found:
>
> **Current tier:** [Light/Standard/Full, or "Unknown" if no PROJECT_STATUS.md]
> **Existing docs:** [list of docs/ files found]
> **Existing rules:** [list of .claude/rules/ files found]
> **Missing from [current/next] tier:** [list of docs and rules that could be added]
>
> What would you like to do?
> 1. **Upgrade tier**: move from [current] to [target] (adds [N] docs, expands CLAUDE.md)
> 2. **Add specific document(s)**: add individual docs without changing tier
> 3. **Change tracking approach**: switch between in-repo backlog and external tracker
> 4. **Refresh dashboard**: update PROJECT_STATUS.md with current project state
> 5. **Full re-interview**: start over as if this were a new project (preserves existing files, generates only what's missing or changed)"

### Evolve: Upgrade Tier

When upgrading tiers:
1. Diff current docs against target tier's doc list. Explicit diffs by upgrade path:
   - **Light to Standard adds:** `docs/technical-specs/code-atlas.md`, `docs/CHANGELOG.md`, `docs/decisions.md`, `docs/technical-specs/TECHNICAL_SPEC.md`, `.claude/rules/document-updates.md`, `.claude/rules/session-protocol.md`, `.claude/rules/coding-standards.md`. CLAUDE.md sections added: 4 (Update Protocol), 8 (Tracking), 9 (Git Protocol), 10 (Clarification Protocol). PROJECT_STATUS.md expanded to full 7-section format.
   - **Light to Full adds:** Everything in Light-to-Standard, plus: `docs/technical-specs/DATA_MODEL.md`, `GETTING_STARTED.md`, tracker-specific docs (`docs/traceability-matrix.md` or `docs/requirements/requirements.md` + `docs/BACKLOG.md`), `.claude/rules/traceability.md`. CLAUDE.md sections added: 4, 6 (Tech Stack), 8, 9, 10, 11 (Context Window), 13 (References).
   - **Standard to Full adds:** `docs/technical-specs/DATA_MODEL.md`, `GETTING_STARTED.md`, tracker-specific docs, `.claude/rules/traceability.md`. CLAUDE.md sections added: 6 (Tech Stack), 11 (Context Window), 13 (References).
2. Show exactly which files will be created and which CLAUDE.md sections will be added
3. Run a **focused mini-interview** covering only the rounds relevant to the new tier that weren't covered by the current tier (e.g., Light to Standard means asking R2, R3, and R4 only)
4. Present a creation summary (same as Phase 3) showing only the new/modified files
5. Wait for approval before creating anything
6. After creation, update PROJECT_STATUS.md tier metadata and session log

### Evolve: Add Specific Document

1. Ask which document(s) the user wants to add
2. If the document requires interview context not yet gathered (e.g., adding docs/traceability-matrix.md requires knowing the tracker tool), ask those specific questions
3. Generate the document using templates from `references/document-templates.md`
4. Update CLAUDE.md Section 3 (Workspace Structure) and Section 4 (Update Protocol) to include the new doc
5. Update or create the relevant `.claude/rules/` file
6. Update PROJECT_STATUS.md responsibility matrix with the new doc's ownership row

### Evolve: Change Tracking Approach

This is a significant change. Walk through it carefully:
1. Confirm the user wants to switch (e.g., from in-repo backlog to external tracker)
2. Ask the necessary questions for the new approach (which tracker, team/project details)
3. Explain what will change: which docs are replaced, how commit messages change, what happens to existing backlog items
4. If `archive/` does not exist, create it before moving files.
5. Generate the new tracking docs (e.g., docs/traceability-matrix.md) and archive the old ones (move to `archive/`)
6. Update CLAUDE.md sections 4, 8, and 9 to reflect the new approach
7. Update relevant `.claude/rules/` files
8. Update PROJECT_STATUS.md
9. **Validate the switch:** After switching tracking approach, validate that no artifacts from the previous tracking approach remain active. Check that only one set of tracking files exists (either `docs/BACKLOG.md` + `docs/requirements/requirements.md` for in-repo, OR `docs/traceability-matrix.md` for external). Flag any gaps where requirements were not migrated to the new system.

### Evolve: Refresh Dashboard

1. Read all existing docs and the current codebase state
2. If external tracker is configured, query it for current ticket status
3. Rebuild PROJECT_STATUS.md sections 1, 3, 4 from current state
4. Preserve sections 2, 5, 6 (responsibility matrix, session log, phase history)

### Evolve: Full Re-Interview

1. Run the complete interview from Phase 1
2. Compare answers against existing scaffolding
3. Generate only files that are missing or whose content would change
4. Present a diff summary showing what will be added/modified
5. Wait for approval before making changes

---

## Phase 1: Detect Project Type & Tier

Start by identifying the project type and scaffolding tier. The type determines interview adaptations. The tier determines interview depth, CLAUDE.md sections, and which documents to generate.

### Project Types

| Project Type | Key Signals | Default Tier | Interview Adaptations |
|---|---|---|---|
| **Full-stack web app** | Next.js, React, frontend + backend + database | Full | Ask about Docker, CI/CD, env files, UI component library; recommend frontend-design + ui-ux-pro-max skills; enforce Tailwind CSS; ask about Playwright testing |
| **API / Backend service** | REST/GraphQL API, no frontend | Standard | Skip frontend component questions; focus on API design, service layer, deployment |
| **Document processing** | Excel, Word, PDF, PPTX generation/manipulation | Light | Lighter structure; focus on input/output formats, libraries, automation |
| **Automation / Scripts** | CLI tools, cron jobs, data pipelines (simple) | Light | Lighter structure; may not need full docs suite |
| **Data pipeline / ETL** | Airflow, dbt, Prefect, scheduled data transforms, source/sink systems | Standard | Ask about source/target systems, scheduling, idempotency, data quality; recommend DATA_LINEAGE.md |
| **Skill development** | Claude Code skill, SKILL.md, /mnt/skills | Light | Focus on SKILL.md structure, trigger phrases, eval strategy; skip version control and testing rounds |
| **Salesforce** | `force-app/`, `sfdx-project.json`, `.forceignore`, `lwc/` | Standard | Ask about org type (scratch/sandbox/production), deployment strategy (change sets/CLI/CI), and whether LWC or Aura components are primary. See `references/salesforce.md` for Salesforce-specific directory structure and workflow conventions. |
| **Mobile app** | React Native, Flutter, Swift, Kotlin, iOS/Android | Full | Ask about target platforms, framework, app store deployment, platform-specific conventions |
| **Personal project** | User says "personal", "side project", "hobby" | Light | Lighter interview, fewer docs, simpler structure |

### Tier Definitions

| Aspect | Light | Standard | Full |
|---|---|---|---|
| **Interview rounds** | R1 + R7 (2 rounds) | R1, R2, R3, R4, R7, R8 (6 rounds, skip R5 and R6) | All 8 rounds |
| **CLAUDE.md sections** | 1, 2, 3, 5, 7, 12 (6 sections) | 1-5, 7, 8, 9, 10, 12 (10 sections) | All 13 sections |
| **Always generated** | CLAUDE.md, README.md, docs/PROJECT_STATUS.md (simplified: sections 1, 2, 5 only), .claude/rules/golden-rules.md, .claude/rules/git-protocol.md | Everything in Light + docs/technical-specs/code-atlas.md, docs/CHANGELOG.md, docs/decisions.md, docs/technical-specs/TECHNICAL_SPEC.md, .claude/rules/document-updates.md, .claude/rules/session-protocol.md | Everything in Standard + full PROJECT_STATUS.md, docs/technical-specs/DATA_MODEL.md, GETTING_STARTED.md, and tracker-specific docs (docs/traceability-matrix.md or docs/requirements/requirements.md + docs/BACKLOG.md) |
| **Upgrade path** | Can upgrade to Standard or Full via evolve mode | Can upgrade to Full via evolve mode | N/A |

After detecting the project type, state the auto-detected tier and allow the user to override:

> "This looks like a **[type]** project. I'd recommend **[tier]** scaffolding, which includes [brief description]. Want to go with that, or would you prefer a different tier?"

If the user overrides, use their chosen tier for the rest of the interview.

---

## Phase 2: The Interview

Conduct this as a natural conversation: ask **3-5 questions at a time**, wait for answers, then ask follow-ups. Do not dump all questions at once. Adapt based on answers: skip irrelevant topics, dig deeper into areas the user cares about.

### Round 1: Project Identity & Context

> **Tier gate:** All tiers. Always asked.

- What is the project name and a one-line description?
- What problem does this project solve, and who are the target users?
- Is this a brand-new project, or does existing code/repos/prior work already exist?
- What is the tech stack? (languages, frameworks, key dependencies, target platforms)

Based on answers, classify the project type from the table above and adapt subsequent rounds.

### Interview Adaptations by New Project Type

**Skill development:**
- R1: Ask about the skill's purpose, trigger patterns, and which Claude Code context it operates in
- R7: Ask about eval strategy (how to test the skill), description optimization, and reference file structure
- Default tier: Light
- Special scaffolding: Generate a SKILL.md template with description, trigger patterns, and reference file stubs. For skill development projects, generate a `SKILL.md` at the project root using the standard Claude Code skill format: YAML frontmatter (name, description, model, tools) followed by skill instructions in Markdown. Use the interview answers to populate the name, description, and tool requirements.
- Skip: version control questions (skills typically live in a managed directory), testing questions, infrastructure questions

**Data pipeline / ETL:**
- R1: Ask about source systems, destination systems, data formats, and scheduling
- R2: Ask about idempotency requirements, error handling strategy, and data quality checks
- R6: Ask about data validation tests, integration tests with source/sink systems
- R7: Ask about naming conventions for jobs/tasks/DAGs, logging conventions
- Default tier: Standard
- Recommend: docs/technical-specs/TECHNICAL_SPEC.md with a data lineage section, docs/technical-specs/code-atlas.md with source/sink mapping
- Optional doc: DATA_LINEAGE.md (offer during Round 4)

**Mobile app:**
- R1: Ask about target platforms (iOS, Android, both), framework (React Native, Flutter, native)
- R6: Ask about device testing strategy, CI/CD for app stores, screenshot testing
- R7: Ask about platform-specific conventions, state management, navigation patterns
- Default tier: Full
- Special scaffolding: Platform-specific directory structure, build configuration files
- Recommend: all standard Full-tier docs plus platform-specific sections in docs/technical-specs/TECHNICAL_SPEC.md
- Note: Mobile-specific scaffolding generation (e.g., React Native, Flutter directory structures) is not yet implemented. For mobile projects, use the standard scaffolding from the selected tier and manually adapt the directory structure for the target mobile framework.

### Round 2: Project Phase & Discovery

> **Tier gate:** Standard and Full only. Light tier skips this round (default to Greenfield build phase).

- What phase is this project in?
  - **Discovery / Pre-build**: requirements and technical design still need to be fleshed out
  - **Greenfield build**: we know what to build and are starting from scratch
  - **Existing codebase**: adding features, fixing bugs, or refactoring
- Is this a **migration or rebuild** of an existing system?
  - If yes: Is the original source code or documentation available?
  - If yes: Recommend a **Migration Reference** (`docs/MIGRATION_REFERENCE.md`)
- If Discovery: Should Claude act as the **Discovery architect**: guiding user stories, acceptance criteria, technical specs, and data models before any code is written?

### Round 3: Version Control & Git Workflow

> **Tier gate:** Standard and Full only. Light tier gets a single question: "Should Claude handle git commits? Y/N" with sensible defaults (GitHub Flow, auto-commit, push on request).

> **Coordination with dev-management skill:** If the user has already run the **dev-management skill** for this project (check for `docs/DEV_MANAGEMENT.md`), skip this round entirely and reference the existing dev-management configuration. If not, keep this round lightweight: cover commit format, branching strategy, and push policy. Recommend the **dev-management skill** as a follow-up for detailed CI/CD pipeline setup, deployment automation, and branch protection configuration.

The user always uses **GitHub**. Ask:

- Should Claude handle version control operations for this project? (Ask each time: do not assume.)
  - If yes, ask granularly about: **commits** (auto-commit or wait for instruction?), **branching**, **pushing** (auto or on request?), **PRs**, **merge conflict resolution**, **tags/releases**
- **Recommend the best branching strategy** for this specific project. Present your top recommendation with rationale, plus 1-2 alternatives with brief pros/cons. Common strategies:
  - **GitHub Flow**: simple, good for small teams and continuous deployment
  - **GitFlow**: structured, good for release-based projects with multiple environments
  - **Trunk-based**: fast, good for CI/CD-heavy projects with strong test coverage
- Are there branch protection rules, required reviewers, or CI checks to know about?

### Round 4: Work Tracking & Documentation

> **Tier gate:** Standard and Full only. Light tier skips this round (no tracker integration, no optional docs).

**First, determine the work tracking approach.** This affects which documents to recommend.

Ask:
- How will work items (features, bugs, tasks) be tracked?
  - **External tracker** (Linear, Jira, GitHub Issues, etc.): acceptance criteria and status live in the tracker
  - **In-repo backlog** (`docs/BACKLOG.md`): Claude manages a local backlog file as the single source of work items
  - **None / ad hoc**: no formal tracking, just conversation-driven

If using an **external tracker**:
- Which tool? (Linear, Jira, GitHub Issues, Asana, etc.)
- **If Linear is selected:** Auto-configure with team Rihm (ID: `dfe15bc4-6dd0-4bde-8609-6620efc3140d`) and assignee Michael Rihm (ID: `8d75f0a6-f848-41af-9f4b-d06036d6af82`). <!-- These IDs are intentionally hard-coded per global rules in ~/.claude/rules/mcp-linear.md --> Reference the ticket lifecycle protocol from `rules/linear-ticket-management.md` in the generated rules (move tickets to In Progress on start, add progress comments, move to Done on completion).
- Does the project have a PRD or equivalent product requirements document?
- Recommend **docs/traceability-matrix.md** instead of docs/requirements/requirements.md and docs/BACKLOG.md. Explain: the matrix maps every product requirement to its phase and tracker tickets, while acceptance criteria and status live in the tracker. This prevents drift between docs and the tracker.
- Note: if the project has a PRD, the matrix maps PRD sections to tickets. If no PRD, the matrix maps requirement IDs directly to tickets.

If using **in-repo backlog**:
- Recommend docs/requirements/requirements.md + docs/BACKLOG.md as the requirement and work tracking documents (the existing approach).

**Then, ask which living documents Claude should maintain.** Recommend based on project type and tracking approach:

| Document | Web App | API | Doc Processing | Automation | Personal |
|---|---|---|---|---|---|
| docs/traceability-matrix.md | If external tracker | If external tracker | If external tracker | If external tracker | Skip |
| docs/BACKLOG.md | If no external tracker | If no external tracker | Optional | Optional | Optional |
| docs/requirements/requirements.md | If no external tracker | If no external tracker | Optional | Skip | Skip |
| docs/decisions.md | Recommended | Recommended | Skip | Skip | Skip |
| docs/CHANGELOG.md | Recommended | Recommended | Optional | Optional | Skip |
| docs/technical-specs/TECHNICAL_SPEC.md | Recommended | Recommended | Skip | Skip | Skip |
| docs/technical-specs/DATA_MODEL.md | Recommended | If DB | Skip | Skip | Skip |
| docs/technical-specs/code-atlas.md | Recommended | Recommended | Skip | Skip | Skip |
| README.md | Recommended | Recommended | Optional | Optional | Optional |
| GETTING_STARTED.md | Recommended | Recommended | Skip | Skip | Skip |

**Key rule:** docs/traceability-matrix.md and docs/requirements/requirements.md + docs/BACKLOG.md are mutually exclusive approaches. Do not recommend both. The matrix replaces the other two when an external tracker is used.

Present the recommendations and let the user confirm or adjust.

For document template structures, read `references/document-templates.md`.

### Round 5: Project Lifecycle & Decomposition (external tracker projects only)

> **Tier gate:** Full tier only (and only if external tracker is enabled). Standard and Light tiers skip this round.

**Skip this round if the project uses in-repo backlog or no tracking.**

For projects with an external tracker, establish the project lifecycle framework:

Ask:
- Does the project have phases or milestones already defined in the tracker?
- Should Claude help decompose product requirements into tracker tickets during Discovery?
- Should Claude propose phase groupings (which tickets belong to which implementation phase)?

**Present the source-of-truth hierarchy** and confirm with the user:

| Layer | Document | Role |
|---|---|---|
| Product Vision | docs/requirements/PRD.md or equivalent | What to build (rarely changes) |
| Architecture | docs/technical-specs/TECHNICAL_SPEC.md + DATA_MODEL.md + design specs | How to build it (per-feature) |
| Work Tracking | External tracker | Live status, acceptance criteria, assignments |
| Requirement Mapping | docs/traceability-matrix.md | Maps requirements to phases and tickets |
| Codebase Context | docs/technical-specs/code-atlas.md | Current code state (after every change) |
| Decisions | docs/decisions.md | ADRs with rationale |
| History | docs/CHANGELOG.md | What changed and when |

**Present the project lifecycle steps** and confirm:

| Step | Name | Outputs |
|---|---|---|
| 1 | Product Requirements | docs/requirements/PRD.md or equivalent product doc |
| 2 | Tech Spec | docs/technical-specs/TECHNICAL_SPEC.md + DATA_MODEL.md + design specs |
| 3 | Requirement Decomposition | Tracker tickets with acceptance criteria |
| 4 | Traceability Matrix | docs/traceability-matrix.md (built during step 3) |
| 5 | Phase Definition | Tracker milestones + matrix updated with phases |
| 6 | Implementation Planning | Implementation plans (per phase) |
| 7 | Implementation | Code + tests + doc updates |

Steps 3-5 happen once per project (updated as scope changes). Steps 6-7 repeat per phase.

**Explain the agent planning protocol:** When an agent creates an implementation plan for a phase, it reads the traceability matrix to find the phase's tickets, queries the tracker for acceptance criteria, reads the PRD for domain context, reads the tech spec for architecture, and reads docs/technical-specs/code-atlas.md for current state.

Confirm the user is comfortable with this lifecycle, and note any adjustments.

### Round 6: Testing & Quality

> **Tier gate:** Full tier only. Standard tier gets a single question: "Should Claude write tests alongside code? Y/N" with a recommendation based on the stack. Light tier skips this round.

- What is the testing strategy? (unit, integration, e2e, manual, none yet)
- Should Claude write tests alongside feature code automatically?
- **For web apps:** Recommend Playwright for e2e testing. Ask about specific browsers/viewports.
- Are there linting, formatting, or CI/CD pipelines to integrate with?
  - **Note:** For detailed CI/CD pipeline setup (multi-step workflows, deployment automation, security scanning), recommend the **dev-management skill** as a follow-up. Project-init only captures the high-level CI/CD decision; dev-management handles the full configuration.

**For web apps only: additional questions:**
- Should Claude set up **Docker** for local development and/or deployment? (Recommend yes, explain benefits briefly)
- Should Claude create **CI/CD templates**? (GitHub Actions recommended)
- Should Claude set up **environment files** (`.env`, `.env.example`)? (Recommend yes)
- **Styling framework: Tailwind CSS is required** (per global rule `rules/ui-development.md`). Inform the user that Tailwind CSS is the default. If the user wants a different approach, note the conflict with the global rule and confirm.
- Which **UI component library** should be used? Present your top recommendation based on the stack, plus 1-2 alternatives:
  - For Next.js/React: recommend **shadcn/ui** (best for customization + Tailwind), alternatives: Radix UI (Tailwind-compatible), Headless UI (Tailwind-compatible)
  - **Note:** Libraries with their own styling systems (Chakra UI, MUI) conflict with the Tailwind CSS global rule. If the user selects one of these, flag the conflict and confirm the override.
  - Confirm the choice with the user before proceeding
- Note: When building UI features, Claude should use the **frontend-design skill** and **ui-ux-pro-max skill** for high-quality design output.

### Round 7: Conventions & Workflow

> **Tier gate:** All tiers. Always asked, but shorter for Light tier (just coding conventions and golden rules; skip MCP servers and uncertainty handling).

- Preferred coding conventions? (Per-language: naming, component patterns, imports)
  - If user is unsure, recommend best practices for the detected stack
- Database conventions? (naming, PK strategy, timestamps, migration tooling)
  - If user is unsure, recommend: snake_case tables/columns, UUID v4 PKs, `created_at`/`updated_at` on every table
- **Golden rules**: invariants Claude should never violate? Always include these defaults:
  1. Ask before assuming: never guess at business logic, data model relationships, or security rules
  2. Document as you build: every change reflected in living docs in the same response
  3. Minimize token waste: concise code, reference by path, don't re-print unchanged files
  4. Incremental, deployable changes: each change small enough to test independently
  5. Always confirm data model changes with the user before proceeding
  - If external tracker + traceability matrix is enabled, add: "Traceability required: every implementation task must trace to a product requirement and a tracker ticket via docs/traceability-matrix.md"
- Communication style: brief, action-oriented, recommendations-first with rationale
- Uncertainty handling: always ask first for non-trivial decisions; low-risk decisions can proceed with stated assumptions
- Categories that always require clarification: security/auth, database schema changes, third-party integrations, business logic, anything contradicting the PRD or tracker ticket acceptance criteria
- Any **MCP servers or tools** to integrate with? Recommend based on project type:
  - Web apps: Postgres MCP, Playwright MCP
  - All: Context7 for library docs

### Round 8: MPF-Specific Configuration

> **Tier gate:** Standard and Full only. Light tier skips this round.

This round configures MPF-specific behaviors that control how the framework operates during the project lifecycle.

- **Agent preferences:** Which MPF agents should be enabled for this project? Options:
  - **Mapper** (codebase mapping and code atlas maintenance)
  - **Planner** (implementation plan generation)
  - **Checker** (plan and integration verification)
  - **Executor** (implementation execution)
  - **Verifier** (UAT and acceptance criteria verification)
  - Default: all enabled. Let the user disable any they don't need.

- **Verification depth:** How thorough should verification be?
  - **Inline only**: after each wave completes during `mpf:execute`, the checker agent runs a quick structural verification on the wave's tasks (requirement coverage, file existence, verify commands). Problems are caught between waves before later tasks build on them. No dedicated `mpf:verify` pass at phase end.
  - **Full UAT**: inline wave verification (as above) plus a dedicated `mpf:verify` pass at phase end that performs comprehensive UAT including cross-task integration testing and acceptance criteria evaluation.
  - **None**: no inline wave verification. Only the `mpf:verify` pass at phase end. Fastest execution, but problems compound across waves.
  - Default: Full UAT
  - The setting is stored in CLAUDE.md under MPF configuration and read by `mpf:execute` at runtime.

- **Phase granularity:** Preference for how mpf:plan-phases breaks work into phases?
  - **Large phases**: fewer phases, bigger scope per phase (faster to plan, harder to verify)
  - **Small phases**: more phases, tightly focused scope (easier to verify, more planning overhead)
  - **Balanced**: moderate size, 3-7 tickets per phase
  - Default: balanced

- **Doc update frequency:** When should living documents be updated?
  - **Hook-triggered**: update reminders fire after each relevant code change (keeps docs current, more interruptions)
  - **End-of-session batch**: update all docs at end of each work session (fewer interruptions, risk of drift)
  - Default: hook-triggered

- **Model routing:** Which model should each agent use? Default assignments are documented in `skills/mpf/references/model-routing.md` (opus for planner/verifier/mapper-lead, sonnet for executor/mapper-specialist, haiku for checker). Options:
  - **Default (recommended)**: use the assignments from the routing table
  - **Custom**: specify per-agent overrides (e.g., downgrade planner to sonnet for budget projects, upgrade executor to opus for critical phases)
  - If custom, store the overrides in CLAUDE.md under a "Model Routing Overrides" section.
  - Default: Default

---

## Phase 3: Creation Summary & Approval

Before creating any files, present a summary:

1. **Files to be created**: list every file and its purpose, including:
   - docs/technical-specs/high-level-architecture.md
   - docs/technical-specs/architecture/ (subsystem files, populated during discovery)
   - docs/technical-specs/code-atlas.md
   - docs/technical-specs/code-modules/ (module files, populated as code grows)
   - docs/requirements/PRD.md (placeholder, populated by mpf:discover)
   - docs/requirements/requirements.md (if in-repo tracking)
   - docs/requirements/phases/ (populated by mpf:plan-phases)
2. **Enabled workflows checklist:**
   - [ ] Version Control (specifics: commit format, branching strategy, push policy, PR creation, conflict resolution)
   - [ ] External Tracker Integration (tool name, project/team details)
   - [ ] Traceability Matrix (maps requirements to tracker tickets and phases)
   - [ ] Project Lifecycle Protocol (source-of-truth hierarchy, decomposition, phase planning)
   - [ ] Backlog Management (in-repo, only if no external tracker)
   - [ ] Requirements Management (in-repo, only if no external tracker)
   - [ ] Decision Tracking (ADRs)
   - [ ] Changelog Maintenance
   - [ ] Technical Spec Maintenance
   - [ ] Data Model Maintenance
   - [ ] Code Atlas Maintenance
   - [ ] Migration Reference
   - [ ] Playwright Testing & Screenshots
   - [ ] Auto-generated Tests
   - [ ] Project Dashboard (always enabled; shows phase, responsibility matrix, session log)
   - [ ] Session Briefing Protocol (Standard and Full tier; includes start briefing and end-of-session dashboard update)
   - [ ] Discovery / Architecture Guidance
   - [ ] Docker Setup
   - [ ] CI/CD Pipeline
   - [ ] Frontend Design (with UI library choice)
   - [ ] MPF Agent Configuration (which agents enabled, model routing, verification depth, phase granularity, doc update frequency)
3. **Directory structure preview**: ASCII tree of what will be created (include `.claude/rules/` with the list of rule files that will be generated)

**Wait for user approval before creating anything.**

---

## Phase 4: Generate Scaffolding

After approval, generate the project scaffolding. Read `references/document-templates.md` for the detailed structure of each document.

### Pre-Generation: Validate Skill Dependencies

Before generating scaffolding, check that referenced skills exist:

| Skill | Required By |
|---|---|
| frontend-design | Web app projects (UI work) |
| ui-ux-pro-max | Web app projects (UI work) |
| dev-management | CI/CD detailed setup (recommended follow-up) |

For each missing skill:
- Note it in the creation summary: "Warning: Skill `[name]` is referenced but not found. Related features will work but without skill-specific optimizations."
- Still generate the scaffolding: missing skills are a warning, not a blocker.
- Do NOT reference missing skills in CLAUDE.md or rules files. Only include skill references for skills that are confirmed to exist.

### Always Created: `CLAUDE.md`

Generate with the **13-section structure** described in `references/document-templates.md` (Section: "CLAUDE.md Structure"). Tailor every section based on interview answers. Use HTML comment placeholders (`<!-- -->`) for values not yet known.

### Always Created: `docs/PROJECT_STATUS.md`

Generate the project dashboard using the 7-section structure from `references/document-templates.md` (Section: "PROJECT_STATUS.md"). Populate Section 1 (Current Phase) based on the phase identified in Round 2. Populate Section 2 (Phase Summary) with the initial phase entry. Populate Section 3 (Responsibility Matrix) based on which documents and workflows the user enabled. Initialize Sections 4-5 (Active Work Items, Blockers & Waiting) as empty. Initialize Section 6 (Session Log) with a single entry for the init session. Initialize Section 7 (Phase History) as empty.

For the responsibility matrix, map each enabled document and workflow to its default owner using the template in `references/document-templates.md`. Adapt based on interview answers: if the user said they want to approve all commits, change Git commits from "Claude (auto)" to "Claude (proposes)".

When creating placeholder documentation files, mark them with an HTML comment at the top: `<!-- MPF placeholder: to be populated by mpf:discover -->`. This allows downstream commands to distinguish placeholders from populated content.

If `docs/technical-specs/code-atlas.md` or `docs/technical-specs/high-level-architecture.md` already exist (e.g., from a prior `mpf:map-codebase` run), do not overwrite them. Skip creation of these files and note in the session log that existing mapper output was preserved.

### Always Created: `docs/PROJECT.md`

Generate a project overview document containing the project name, description, tech stack summary, and links to all other documentation files. This serves as the entry point for understanding the project.

### Always Created: `docs/roadmap.md`

Generate an initial roadmap document. If phases are already defined, populate with phase summaries. Otherwise, create the structure with placeholders to be filled by mpf:plan-phases.

### Always Created: `archive/`

Create an empty `archive/` directory at the project root. This is used to store:
- Superseded docs (e.g., old requirements.md when switching to traceability matrix)
- Previous versions of docs before major restructures
- Deprecated code moved out of the main codebase
- Old scaffolding from tier upgrades

Place a `.gitkeep` file inside `archive/` so git tracks the empty directory.

When moving files to archive, prefix with the date: `archive/2026-03-20_requirements.md`. Note the archival in the session log. Always include this in the directory structure preview shown during Phase 3.

### Always Created: `.claude/rules/`

Create project-specific rule files in `.claude/rules/` at the project root. These auto-load into every Claude Code conversation, ensuring behavioral constraints are enforced without relying on CLAUDE.md being explicitly read. CLAUDE.md keeps the same content as a comprehensive human-readable reference; the rules files are the enforcement mechanism.

For rule file templates, read `references/document-templates.md` (section: ".claude/rules/ Directory").

**Always created:**
- `golden-rules.md`: invariants Claude must never violate (from Section 2) + clarification protocol (from Section 10)
- `coding-standards.md`: per-language conventions and database conventions (from Section 5)

**Conditionally created:**
- `document-updates.md`: event-to-action table + maintenance rules (if any living documents are enabled)
- `git-protocol.md`: commit format, branching strategy, push/PR policies (if version control is enabled)
- `traceability.md`: source-of-truth hierarchy, traceability rules, agent planning protocol (if external tracker + traceability matrix is enabled)
- `session-protocol.md`: session-start briefing and session-end dashboard update (Standard and Full tier)

### Conditionally Created: `.claude/settings.json` Hook (if hook-triggered doc updates selected in R8)

If the user chose hook-triggered doc updates (the default), install the MPF PostToolUse hook in the project's `.claude/settings.json`. If the file already exists, merge the hook into the existing `hooks.PostToolUse` array without overwriting other settings.

Create or update `.claude/settings.json` to include:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "command": "bash ~/.claude/plugins/mpf/hooks/doc-update-hook.sh \"$TOOL_INPUT\""
      }
    ]
  }
}
```

Also create `.claude/rules/mpf-doc-updates.md` using the template from `references/document-templates.md` (section: "mpf-doc-updates.md"). This rule file tells Claude which documents to update for each type of source file change.

If the user chose batch doc updates instead of hook-triggered, skip the hook installation but still create the `mpf-doc-updates.md` rule file.

### Conditionally Created: `docs/` files

Only create files the user opted into. Each file follows the template structure in `references/document-templates.md`.

The scaffolding creates the following directory structure:

```
docs/
├── PROJECT.md
├── PROJECT_STATUS.md
├── BACKLOG.md                      (if in-repo tracking)
├── decisions.md
├── roadmap.md
├── CHANGELOG.md
├── traceability-matrix.md          (if external tracker)
├── technical-specs/
│   ├── high-level-architecture.md
│   ├── TECHNICAL_SPEC.md
│   ├── DATA_MODEL.md               (Full tier)
│   ├── DATA_LINEAGE.md             (optional, for pipeline/ETL projects)
│   ├── code-atlas.md
│   ├── architecture/               (empty initially, populated during discovery)
│   └── code-modules/               (empty initially, populated as code grows)
└── requirements/
    ├── PRD.md                       (placeholder, filled by mpf:discover)
    ├── requirements.md              (if in-repo tracking; placeholder, populated by mpf:discover)
    └── phases/                      (empty initially, populated by mpf:plan-phases)
```

- `DATA_LINEAGE.md`: data flow mapping for pipeline/ETL projects (optional, offered during Round 4)

### Project-Type-Specific Scaffolding

**Full-stack web apps:**
- Copy `~/.claude/templates/screenshot.mjs` to `./screenshot.mjs` and `~/.claude/templates/SCREENSHOT_WORKFLOW.md` to `./SCREENSHOT_WORKFLOW.md` (required by global rule `rules/ui-development.md`)
- Create `.env.example` if environment files enabled
- Create `Dockerfile` and `docker-compose.yml` if Docker enabled
- Create `.github/workflows/ci.yml` if CI/CD enabled
- Note in CLAUDE.md that the **frontend-design skill** and **ui-ux-pro-max skill** should be used for all UI work
- Note the chosen UI component library in CLAUDE.md Section 6 (Tech Stack)
- Note that **Tailwind CSS** is the required styling framework (per global rule `rules/ui-development.md`)

**Document processing:**
- Note recommended libraries in CLAUDE.md (openpyxl, python-docx, reportlab, python-pptx)
- Simpler directory structure focused on scripts and output

**Personal projects:**
- Minimal docs, simple structure, lighter CLAUDE.md

---

## Phase 5: Workflow Rules

After scaffolding is created, these rules apply: scoped to enabled workflows. Include the relevant rules in CLAUDE.md.

Read `references/workflow-rules.md` for the complete set of rules covering:
- Document maintenance rules
- Version control rules
- Testing rules
- Discovery rules
- Migration rules
- Project lifecycle & decomposition rules (external tracker projects)
- Traceability rules (external tracker projects)

---

## Phase 6: Post-Creation

After all files are created:

1. Present the final summary of everything created
2. If Discovery phase: suggest running `mpf:discover` to create the PRD and flesh out requirements
3. If Greenfield build phase: suggest running `mpf:plan-phases` if phases are not yet defined, or ask what the user wants to work on first
4. Otherwise: ask what the user wants to work on first, showing open backlog items if any

---

## Key Reminders

- **Always interview first.** Never skip to file creation.
- **Present recommendations.** For every decision point, give your best recommendation first, then 1-2 alternatives with brief pros/cons. Let the user decide.
- **Approval before creation.** Always show the creation summary and wait for a "go ahead" before writing files.
- **Project-type awareness.** Adapt the interview depth, document recommendations, and directory structure to the project type. Personal projects get a light touch; web apps and APIs get the full treatment.
- **Skill integration.** For web apps with UI, note that both the **frontend-design** and **ui-ux-pro-max** skills should be used. For document generation in any project type, note relevant document skills (docx, xlsx, pdf, pptx).
- **Data model changes always require confirmation.** Across all project types: database schema, Salesforce object model, or any data structure change.
- **After scaffolding, recommend mpf:discover.** If the project is in Discovery phase, the next step is always to run mpf:discover to create the PRD and flesh out requirements.
- **After PRD, recommend mpf:plan-phases.** Once the PRD exists, recommend mpf:plan-phases to break the work into implementation phases.
- **MPF command workflow.** The full MPF lifecycle follows this sequence: mpf:init (this skill) > mpf:discover > mpf:plan-phases > mpf:plan-tasks > mpf:execute > mpf:verify. Each command builds on the outputs of the previous one. For ad-hoc TODOs that don't need the full PRD pipeline, use mpf:decompose to break them into executable task files directly.
