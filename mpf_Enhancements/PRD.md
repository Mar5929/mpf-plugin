# MPF v2: Intelligence, Orchestration, and Portability

## Product Vision

Transform MPF from a Claude Code-specific project management plugin into an intelligent, LLM-agnostic spec-driven development framework that routes work to the right model tier, enables agents to collaborate during execution, leverages live documentation sources, and can be adapted to run on any AI coding assistant.

## Problem Statement

MPF v1 works well as a Claude Code plugin but has three structural limitations:

1. **Uniform model usage.** All agents run on Sonnet regardless of task complexity. Planning and verification tasks that require deep reasoning use the same model as mechanical code execution, leaving quality on the table for high-stakes decisions.

2. **Isolated agent execution.** Executor agents operate in silos. When an executor encounters ambiguity, it either guesses or stops. There is no mechanism for executors to consult the planner, share state across tasks, or trigger inline verification between waves.

3. **No external knowledge integration.** Agents rely entirely on training data for library APIs, framework patterns, and tooling conventions. There is no mechanism to pull current documentation from Context7 or other sources before writing code.

4. **Platform lock-in.** The framework is structurally coupled to Claude Code's plugin system (`.claude-plugin/plugin.json`, agent frontmatter syntax, slash command routing, tool names). The core spec content is LLM-agnostic, but the delivery mechanism is not.

## Target Users

- **Primary:** Michael Rihm (sole developer and framework author) using MPF to manage personal and client projects across multiple AI coding tools
- **Future:** Developers who want a structured, spec-driven development workflow that works across Claude Code, Cursor, Copilot Workspace, Windsurf, or raw API calls

## User Stories

### US-001: Intelligent Model Routing

As a developer using MPF, I want planning and verification agents to use Opus-tier models while execution agents use Sonnet-tier models, so that high-stakes reasoning tasks get the best model and routine execution stays fast and cost-effective.

**Acceptance Criteria:**
1. Planner, verifier, and mapper-lead agents specify Opus as their model
2. Executor, mapper-specialist, and checker agents specify Sonnet (or lower) as their model
3. Model assignments are documented in a central model routing table that can be updated in one place
4. The routing table is referenced in SKILL.md and agent documentation so the rationale is clear

### US-002: Executor-to-Planner Escalation

As a developer, I want executor agents to be able to consult the planner when they encounter ambiguity in a task spec, so that they make informed decisions instead of guessing or stopping.

**Acceptance Criteria:**
1. Executor agents are on the same team as the planner agent during phase execution
2. When an executor encounters a defined set of escalation triggers (missing files, ambiguous specs, multiple valid approaches, scope beyond task), it sends a message to the planner
3. The planner responds with guidance and the executor continues
4. Escalation events are logged in the task file's output section
5. The execute command's orchestration logic supports team-based agent spawning

### US-003: Cross-Task State Sharing

As a developer, I want tasks in later waves to receive a summary of what earlier waves actually produced, so that dependent tasks have accurate context rather than only the original spec.

**Acceptance Criteria:**
1. After each wave completes, the orchestrator collects completion summaries from each executor (files created/modified, any deviations from spec)
2. These summaries are injected as additional context when spawning executors for the next wave
3. Summaries are concise (file paths + one-line description of changes, not full code)
4. The inject format is documented in the executor agent prompt

### US-004: Inline Verification Between Waves

As a developer, I want the checker agent to run between waves during execution, so that problems are caught early before later waves build on broken foundations.

**Acceptance Criteria:**
1. After each wave completes, the execute command optionally spawns a checker agent to verify completed tasks
2. If the checker finds failures, the orchestrator pauses and reports before proceeding to the next wave
3. This behavior is configurable (can be enabled/disabled in the MPF config from mpf:init Round 8)
4. Inline checking does not replace the full mpf:verify pass at phase end; it supplements it

### US-005: Context7 Integration for Executor Agents

As a developer, I want executor agents to pull current library documentation from Context7 before implementing tasks that reference specific frameworks or libraries, so that generated code uses current APIs rather than stale training data.

**Acceptance Criteria:**
1. Task files include a `Libraries` field listing the libraries/frameworks the task uses
2. The planner agent populates the Libraries field during task generation
3. The executor agent reads the Libraries field and calls Context7 to resolve library IDs and fetch relevant docs before implementing
4. Fetched docs are included in the executor's context for the duration of the task
5. Context7 is added to the executor agent's tool list
6. If Context7 is unavailable or returns no results, the executor proceeds without it (graceful degradation)

### US-006: Context7 Integration for Mapper Agents

As a developer, I want mapper agents to use Context7 when they encounter unfamiliar dependencies during codebase mapping, so that the generated technical documentation accurately describes how libraries are used.

**Acceptance Criteria:**
1. Mapper-specialist agents can call Context7 when they encounter dependencies they need to understand
2. Context7 is added to the mapper-specialist agent's tool list
3. Usage is optional and at the agent's discretion (not called for every dependency, only unfamiliar ones)

### US-007: Platform Abstraction Layer

As a developer, I want the core MPF specs (commands, agents, skills, references) to be defined in a platform-neutral format with thin adapters for each target platform, so that I can use MPF with Claude Code, Cursor, or other AI coding tools.

**Acceptance Criteria:**
1. MPF's core content (interview logic, workflow rules, document templates, agent behavior specs) is separated from platform-specific delivery (plugin manifests, frontmatter syntax, tool name mappings, slash command routing)
2. A platform adapter for Claude Code generates the current `.claude-plugin/`, `agents/`, `commands/`, and `skills/` structure from the core specs
3. The adapter pattern is documented so that new platform adapters can be written
4. The Claude Code adapter produces output identical (or functionally equivalent) to the current v1 structure
5. A design document describes the adapter interface and how new platforms would be supported

### US-008: Model Routing Abstraction

As a developer, I want model tier assignments (Opus/Sonnet/Haiku) to be expressed as abstract tiers (reasoning/standard/fast) so that the same specs work across providers with different model names.

**Acceptance Criteria:**
1. Agent definitions use abstract tier names (e.g., `tier: reasoning`, `tier: standard`, `tier: fast`) instead of provider-specific model names
2. The platform adapter maps abstract tiers to concrete model names (e.g., `reasoning` -> `opus` for Claude, `reasoning` -> `o3` for OpenAI)
3. The mapping is configurable per adapter and documented
4. The Claude Code adapter produces the same `model:` frontmatter values as the static routing from US-001

## Feature Requirements

| Feature | Priority | Requirement IDs | Description |
|---|---|---|---|
| Static model routing | P0 | REQ-001 | Assign Opus to planner/verifier/mapper-lead, Sonnet to executor/specialist/checker |
| Model routing table | P0 | REQ-002 | Central table documenting model assignments and rationale |
| Team-based execution | P0 | REQ-003 | Executor and planner agents on same team during phase execution |
| Executor escalation protocol | P0 | REQ-004 | Defined triggers and messaging for executor-to-planner escalation |
| Cross-wave state injection | P1 | REQ-005 | Orchestrator injects wave completion summaries into next-wave executor context |
| Inline verification | P1 | REQ-006 | Optional checker run between waves during execution |
| Task file Libraries field | P1 | REQ-007 | New field in task template for library/framework references |
| Planner populates Libraries | P1 | REQ-008 | Planner agent fills Libraries field during task generation |
| Executor Context7 lookup | P1 | REQ-009 | Executor calls Context7 before implementing tasks with library references |
| Mapper Context7 lookup | P2 | REQ-010 | Mapper-specialist can call Context7 for unfamiliar dependencies |
| Core/adapter separation | P2 | REQ-011 | Separate platform-neutral specs from platform-specific delivery |
| Claude Code adapter | P2 | REQ-012 | Adapter that generates current v1-compatible structure |
| Abstract model tiers | P2 | REQ-013 | Replace concrete model names with abstract tier names in core specs |
| Adapter interface design doc | P2 | REQ-014 | Documentation of the adapter pattern for new platforms |

## Non-Functional Requirements

| NFR-ID | Category | Requirement | Target |
|---|---|---|---|
| NFR-001 | Backward Compatibility | v2 must produce functionally equivalent output to v1 for Claude Code users | No breaking changes to existing MPF projects |
| NFR-002 | Cost Efficiency | Opus usage limited to planning/verification; execution stays on Sonnet | Opus calls < 20% of total agent calls per phase |
| NFR-003 | Graceful Degradation | Context7 unavailability must not block execution | Executor proceeds without docs if Context7 fails |
| NFR-004 | Portability | Core specs contain zero platform-specific syntax | No Claude Code frontmatter, tool names, or plugin paths in core |

## Out of Scope

- Dynamic model routing (runtime complexity-based model selection) — future consideration
- Adapters for Cursor, Copilot, or Windsurf — only the adapter *interface* and Claude Code adapter are in scope
- MCP server integration beyond Context7 (Postgres MCP, Playwright MCP, etc.)
- Changes to the interview flow, document templates, or workflow rules (content stays the same; only delivery changes)
- Multi-user or team collaboration features

## Open Questions

1. **Team messaging in Claude Code:** Does Claude Code's agent team system support the executor-to-planner messaging pattern described in US-002, or does the orchestrator need to mediate? Need to verify Claude Code's current team/agent capabilities.
2. **Context7 tool availability:** Can Context7 be added to agent tool lists via Claude Code's plugin system, or does it require a separate MCP server configuration? Need to verify integration path.
3. **Adapter build tooling:** Should the adapter be a simple shell script that copies/transforms files, a Node.js CLI, or a Python script? Depends on what's simplest to maintain for a single developer.
