# Project Roadmap

## Phase Summary

| Phase | Name | Status | Requirements | Estimated Scope |
|---|---|---|---|---|
| 1 | Intelligent Model Routing | Not Started | REQ-001, REQ-002 | 4 tasks, 2 waves |
| 2 | Agent Orchestration Upgrades | Not Started | REQ-003, REQ-004, REQ-005, REQ-006 | 8-10 tasks, 3 waves |
| 3 | Context7 Integration | Not Started | REQ-007, REQ-008, REQ-009, REQ-010 | 6-8 tasks, 3 waves |
| 4 | Platform Abstraction Layer | Not Started | REQ-011, REQ-012, REQ-013, REQ-014 | 10-14 tasks, 4 waves |

---

## Phase Details

### Phase 1: Intelligent Model Routing

**Goal:** Assign the right model tier to each agent based on task complexity. Planning, verification, and architectural reasoning use Opus. Execution and mechanical checks use Sonnet. Document the routing rationale so future changes are informed.

**Requirements Covered:** REQ-001, REQ-002

**Success Criteria:**
1. `mpf-planner.md`, `mpf-verifier.md`, and `mpf-mapper-lead.md` specify `model: opus` in frontmatter
2. `mpf-executor.md`, `mpf-mapper-specialist.md`, and `mpf-checker.md` specify `model: sonnet` in frontmatter
3. A model routing table exists in `skills/mpf/references/model-routing.md` documenting each agent's model assignment, the reasoning, and when to reconsider
4. SKILL.md references the routing table in its agent configuration section

**Dependencies:** None. This phase has no prerequisites.

**Estimated Scope:** 4 tasks across 2 waves

---

### Phase 2: Agent Orchestration Upgrades

**Goal:** Transform agent execution from isolated parallel runs into a collaborative team-based model. Executors can escalate to the planner when blocked. The orchestrator shares completed-wave state with subsequent waves. An optional inline checker catches problems between waves instead of only at phase end.

**Requirements Covered:** REQ-003, REQ-004, REQ-005, REQ-006

**Success Criteria:**
1. The `mpf:execute` command spawns executors and the planner on the same team
2. The executor agent prompt includes escalation triggers and a messaging protocol to consult the planner
3. After each wave, the orchestrator collects executor output summaries and injects them as context for the next wave's executors
4. The execute command supports an optional `--inline-check` flag (or config-driven setting) that runs the checker between waves
5. MPF init Round 8 includes the inline verification option
6. All orchestration changes are reflected in the execute command, executor agent, and planner agent docs

**Dependencies:** Phase 1 (model routing must be set so the planner on the team runs on Opus, executors on Sonnet)

**Estimated Scope:** 8-10 tasks across 3 waves

---

### Phase 3: Context7 Integration

**Goal:** Give agents access to current library and framework documentation during planning and execution. The planner annotates tasks with library references. The executor fetches docs from Context7 before implementing. Mapper specialists can optionally look up unfamiliar dependencies.

**Requirements Covered:** REQ-007, REQ-008, REQ-009, REQ-010

**Success Criteria:**
1. The task file template includes a `Libraries:` field listing relevant libraries with optional version constraints
2. The planner agent populates the Libraries field by analyzing the requirements and tech stack
3. The executor agent's context loading step includes a Context7 resolution step for each listed library
4. Context7 is listed in the executor and mapper-specialist agent tool lists
5. If Context7 fails or returns no results, agents proceed without blocking (logged as a warning)
6. The document-templates.md task file template is updated with the new field

**Dependencies:** Phase 1 (model routing). Phase 2 is not strictly required but recommended (team-based execution makes Context7 results shareable across the team).

**Estimated Scope:** 6-8 tasks across 3 waves

---

### Phase 4: Platform Abstraction Layer

**Goal:** Separate MPF's core spec content from Claude Code's plugin delivery format. Define a platform-neutral representation of commands, agents, skills, and references. Build a Claude Code adapter that transforms the neutral format into the current v1 structure. Document the adapter interface for future platform support.

**Requirements Covered:** REQ-011, REQ-012, REQ-013, REQ-014

**Success Criteria:**
1. A `core/` directory contains platform-neutral spec files for all commands, agents, skills, and references
2. Core specs use abstract model tiers (`reasoning`, `standard`, `fast`) instead of provider-specific names
3. Core specs use abstract tool names (e.g., `file_read`, `file_write`, `shell`, `search`) instead of Claude Code-specific names (`Read`, `Write`, `Bash`, `Grep`)
4. An `adapters/claude-code/` directory contains an adapter script that generates the current `.claude-plugin/`, `agents/`, `commands/`, `skills/`, and `hooks/` structure from core specs
5. Running the Claude Code adapter produces output functionally equivalent to the v1 structure (with v2 upgrades from Phases 1-3 applied)
6. An `adapters/ADAPTER_GUIDE.md` documents the adapter interface: what inputs it receives, what outputs it must produce, and how to map abstract concepts to a new platform
7. The README is updated to reflect the new architecture

**Dependencies:** Phases 1-3 (all content upgrades should be finalized before abstracting the delivery layer)

**Estimated Scope:** 10-14 tasks across 4 waves
