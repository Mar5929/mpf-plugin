# MPF v2 Enhancement Task Index

## Status Legend
- [ ] Not started
- [~] In progress
- [x] Complete

## Summary

| Phase | Name | Tasks | Waves | Status |
|-------|------|-------|-------|--------|
| 1 | Intelligent Model Routing | 3 | 2 | Complete |
| 2 | Agent Orchestration Upgrades | 7 | 4 | Complete |
| 3 | Context7 Integration | 7 | 3 | Complete |
| 4 | Platform Abstraction Layer | 12 | 4 | Complete |
| **Total** | | **29** | | |

## Requirement Coverage

| REQ | Description | Tasks |
|-----|-------------|-------|
| REQ-001 | Static model routing | 1-01 |
| REQ-002 | Model routing table | 1-02, 1-03 |
| REQ-003 | Team-based execution | 2-03 |
| REQ-004 | Executor escalation protocol | 2-01, 2-02, 2-05 |
| REQ-005 | Cross-wave state injection | 2-03 |
| REQ-006 | Inline verification | 2-04, 2-06 |
| REQ-007 | Task file Libraries field | 3-01 |
| REQ-008 | Planner populates Libraries | 3-04 |
| REQ-009 | Executor Context7 lookup | 3-02, 3-05, 3-07 |
| REQ-010 | Mapper Context7 lookup | 3-03, 3-06, 3-07 |
| REQ-011 | Core/adapter separation | 4-02, 4-03, 4-04, 4-05, 4-06, 4-07 |
| REQ-012 | Claude Code adapter | 4-08, 4-09, 4-10 |
| REQ-013 | Abstract model tiers | 4-01, 4-03, 4-04 |
| REQ-014 | Adapter interface design doc | 4-11, 4-12 |

---

## Phase 1: Intelligent Model Routing

| Task | Title | Wave | Depends On | Primary File | Status |
|------|-------|------|------------|-------------|--------|
| 1-01 | Update verifier model to opus | 1 | none | `agents/mpf-verifier.md` | [x] |
| 1-02 | Create model routing reference table | 1 | none | `skills/mpf/references/model-routing.md` | [x] |
| 1-03 | Add routing reference to SKILL.md Round 8 | 2 | 1-02 | `skills/mpf/SKILL.md` | [x] |

---

## Phase 2: Agent Orchestration Upgrades

| Task | Title | Wave | Depends On | Primary File | Status |
|------|-------|------|------------|-------------|--------|
| 2-01 | Add escalation protocol and team tools to executor | 1 | none | `agents/mpf-executor.md` | [x] |
| 2-02 | Add consultation support to planner | 1 | none | `agents/mpf-planner.md` | [x] |
| 2-03 | Refactor execute command for team-based spawning with state injection | 2 | 2-01, 2-02 | `commands/mpf/execute.md` | [x] |
| 2-04 | Add inline verification step to execute command | 3 | 2-03 | `commands/mpf/execute.md` | [x] |
| 2-05 | Add escalation logging to executor output section | 3 | 2-03 | `agents/mpf-executor.md` | [x] |
| 2-06 | Add inline verification config to SKILL.md Round 8 | 4 | 2-04 | `skills/mpf/SKILL.md` | [x] |
| 2-07 | Update workflow-rules.md with orchestration patterns | 4 | 2-03, 2-04 | `skills/mpf/references/workflow-rules.md` | [x] |

---

## Phase 3: Context7 Integration

| Task | Title | Wave | Depends On | Primary File | Status |
|------|-------|------|------------|-------------|--------|
| 3-01 | Add Libraries field to task file template | 1 | none | `skills/mpf/references/document-templates.md` | [x] |
| 3-02 | Add Context7 tools to executor frontmatter | 1 | none | `agents/mpf-executor.md` | [x] |
| 3-03 | Add Context7 tools to mapper-specialist frontmatter | 1 | none | `agents/mpf-mapper-specialist.md` | [x] |
| 3-04 | Add Libraries population step to planner | 2 | 3-01 | `agents/mpf-planner.md` | [x] |
| 3-05 | Add Context7 resolution step to executor | 2 | 3-02 | `agents/mpf-executor.md` | [x] |
| 3-06 | Add Context7 lookup guidance to mapper-specialist | 2 | 3-03 | `agents/mpf-mapper-specialist.md` | [x] |
| 3-07 | Update model-routing.md with Context7 tool additions | 3 | 3-05, 3-06 | `skills/mpf/references/model-routing.md` | [x] |

---

## Phase 4: Platform Abstraction Layer

| Task | Title | Wave | Depends On | Primary File(s) | Status |
|------|-------|------|------------|-----------------|--------|
| 4-01 | Create core/model-tiers.yaml | 1 | none | `core/model-tiers.yaml` | [x] |
| 4-02 | Create core/tool-mappings.yaml | 1 | none | `core/tool-mappings.yaml` | [x] |
| 4-03 | Create core agent specs (reasoning tier) | 2 | 4-01, 4-02 | `core/agents/mpf-planner.md`, `mpf-verifier.md`, `mpf-mapper-lead.md` | [x] |
| 4-04 | Create core agent specs (standard/fast tier) | 2 | 4-01, 4-02 | `core/agents/mpf-executor.md`, `mpf-checker.md`, `mpf-mapper-specialist.md` | [x] |
| 4-05 | Create core command specs | 2 | 4-02 | `core/commands/mpf/*.md` | [x] |
| 4-06 | Create core skills and references | 2 | 4-01 | `core/skills/mpf/SKILL.md`, `references/*.md` | [x] |
| 4-07 | Create core hooks spec | 2 | 4-02 | `core/hooks/doc-update-hook.md` | [x] |
| 4-08 | Create Claude Code adapter tool-map.yaml | 3 | 4-02 | `adapters/claude-code/tool-map.yaml` | [x] |
| 4-09 | Create Claude Code adapter generate script | 3 | 4-03 to 4-07 | `adapters/claude-code/generate.sh` | [x] |
| 4-10 | Create Claude Code adapter README | 3 | 4-09 | `adapters/claude-code/README.md` | [x] |
| 4-11 | Create adapter interface design document | 4 | 4-08, 4-09 | `adapters/ADAPTER_GUIDE.md` | [x] |
| 4-12 | Update repo README with new architecture | 4 | 4-11 | `README.md` | [x] |
