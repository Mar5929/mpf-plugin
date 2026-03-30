# MPF Adapter Interface Guide

## 1. Overview

An MPF adapter transforms the platform-neutral specs in `core/` into a platform-specific plugin or extension structure. The adapter reads abstract agent definitions, command specs, skills, and hooks, then produces output that the target platform can load and execute.

Each adapter is responsible for:
- Resolving abstract model tiers to provider-specific model names
- Resolving abstract tool names to platform-specific tool identifiers
- Converting the comment-based metadata format to the platform's configuration format
- Implementing hook behavior in the platform's native mechanism
- Generating any required manifest or registration files

## 2. Input: The core/ directory

The adapter receives the `core/` directory as input. Its structure:

| Path | Contents |
|------|----------|
| `core/agents/*.md` | Agent behavior specs with `# Agent:`, `# Tier:`, `# Tools:` comment headers followed by markdown body |
| `core/commands/mpf/*.md` | Command orchestration specs with `# Command:`, `# Description:`, `# Tools:` comment headers |
| `core/skills/mpf/SKILL.md` | Main skill definition with `# Skill:`, `# Description:` comment headers |
| `core/skills/mpf/references/*.md` | Reference documents (templates, rules, routing tables) |
| `core/hooks/*.md` | Hook behavior specs describing trigger conditions, skip rules, and actions |
| `core/model-tiers.yaml` | Maps abstract tiers (reasoning, standard, fast) to provider-specific model names |
| `core/tool-mappings.yaml` | Maps abstract tool names to descriptions and known platform implementations |

### Comment-based metadata format

Agent files use this header format:
```
# Agent: mpf-planner
# Tier: reasoning
# Tools: [file_read, file_write, shell, text_search, file_search]
```

Command files use:
```
# Command: mpf:execute
# Description: Execute all tasks in a phase...
# Tools: [file_read, file_write, file_edit, shell, text_search, file_search, agent_spawn]
```

The header ends at the first blank line. Everything after the blank line is the behavioral body content.

## 3. Output requirements

The adapter must produce a complete, loadable plugin structure for its target platform. At minimum:

| Component | What to produce |
|-----------|----------------|
| Agent definitions | One file or config entry per agent, with the platform's model assignment and tool access list |
| Command routing | Registration of all 9 `mpf:*` commands so users can invoke them |
| Skill content | The skill definition and all reference files, accessible to commands and agents |
| Hook implementation | A working implementation of each hook's behavior (or a documented workaround) |
| Plugin manifest | Whatever registration file the platform needs to discover and load the plugin |

## 4. Mapping: Abstract tiers to models

Read `core/model-tiers.yaml` to resolve tier names. The file defines three tiers:

| Tier | Claude | OpenAI | Google |
|------|--------|--------|--------|
| reasoning | opus | o3 | gemini-2.5-pro |
| standard | sonnet | gpt-4.1 | gemini-2.5-flash |
| fast | haiku | gpt-4.1-mini | gemini-2.5-flash-lite |

Each agent spec contains `# Tier: <tier_name>`. The adapter resolves this to the appropriate model for its provider.

**Fallback strategy:** If the target provider is not listed in `model-tiers.yaml`, the adapter should:
1. Check if the provider has a model at the equivalent capability level
2. Map to the closest available model
3. Document the mapping in the adapter's configuration file

## 5. Mapping: Abstract tools to platform tools

Read `core/tool-mappings.yaml` for the canonical list of 13 abstract tool names. Each agent and command spec references tools by abstract name.

The adapter must:
1. Replace abstract tool names in the metadata header with platform-specific names
2. Replace abstract tool names in the body text (in backticks, function-call syntax, and standalone references)
3. Handle tools the platform does not support

**Missing tool strategies:**
- **Skip:** Remove the tool from the agent's tool list and strip references from the body. Acceptable for optional tools (e.g., `context7_resolve` if Context7 is not available).
- **Substitute:** Map to an equivalent tool on the platform (e.g., `file_search` might map to a different glob implementation).
- **Error:** Fail the build if a required tool has no mapping. Required tools: `file_read`, `file_write`, `file_edit`, `shell`, `text_search`, `file_search`.

## 6. Mapping: Command routing

MPF commands follow the naming pattern `mpf:<action>` (e.g., `mpf:execute`, `mpf:verify`). The adapter must route these to the platform's invocation mechanism:

| Platform pattern | Example |
|-----------------|---------|
| Slash commands | `/mpf:execute` (Claude Code) |
| CLI subcommands | `mpf execute` (terminal CLI) |
| Keybindings | Ctrl+Shift+E bound to execute |
| Menu items | File > MPF > Execute |
| API endpoints | `POST /mpf/execute` |

The command spec body contains the orchestration logic. The adapter may need to wrap this in the platform's command registration format.

## 7. Mapping: Platform-specific features

### Agent spawning

Core specs use `agent_spawn(agent: "mpf-executor", ...)` to launch subagents. Platforms handle this differently:

- **Claude Code:** `Agent(subagent_type: "mpf-executor")` with inline prompt
- **API-based:** HTTP request to spawn a new agent instance
- **Single-threaded:** Sequential execution within the same context

### Teams and messaging

Core specs use `team_create(name: ...)` and `send_message(to: ...)` for inter-agent coordination. Platforms without native team support can:

- Use shared files or a message queue for coordination
- Implement a mediator pattern where the orchestrator relays messages
- Skip team features and run agents sequentially with state passed between calls

### Hooks

Core hook specs (`core/hooks/*.md`) define behavior as trigger conditions + skip rules + actions. Platform implementations vary:

- **Claude Code:** `PostToolUse` events in `settings.json` with shell script commands
- **IDE extensions:** File watcher events or editor hooks
- **CI/CD:** Post-step actions in pipeline definitions
- **No equivalent:** Inject the reminder text directly into agent prompts

### Frontmatter and configuration

Core specs use comment-based metadata headers. Each platform has its own configuration format:

- **Claude Code:** YAML frontmatter with `---` delimiters
- **JSON config:** Separate `.json` files per agent/command
- **Programmatic:** Registration calls in code (e.g., `registerAgent({name, model, tools})`)
- **Environment variables:** Tool mappings via env vars

## 8. Reference implementation

The Claude Code adapter at `adapters/claude-code/` demonstrates all required mappings:

| File | Purpose |
|------|---------|
| `tool-map.yaml` | Maps all 13 abstract tools to Claude Code names, plus tier-to-model mappings |
| `generate.sh` | Reads `core/`, applies mappings, writes to `dist/claude-code/` |
| `README.md` | Usage and customization docs |

Key implementation patterns in `generate.sh`:
- Metadata extraction via bash regex on comment headers
- Tool name substitution via precompiled sed script (longest-first to avoid partial matches)
- Frontmatter generation by prepending YAML blocks to transformed bodies
- Hook generation by emitting a shell script from the behavioral spec

## 9. Adapter checklist

Use this checklist to verify a new adapter is complete:

- [ ] All 6 agents generated with correct model names and tool lists
- [ ] All 9 commands routed and accessible via the platform's invocation mechanism
- [ ] SKILL.md and all 4 reference files delivered and accessible to agents
- [ ] Hook behavior implemented or documented as not applicable
- [ ] Plugin manifest or configuration file generated
- [ ] Abstract tool names fully resolved (none remain in output)
- [ ] Abstract tier names fully resolved (none remain in output)
- [ ] Output tested against the platform (commands load, agents can be spawned)
- [ ] Adapter README documents usage, output structure, and customization
