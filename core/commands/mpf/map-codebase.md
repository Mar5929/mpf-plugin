# Command: mpf:map-codebase
# Description: Analyze an existing codebase and generate technical-specs/ documentation for brownfield projects. Spawns the mpf-mapper-lead agent to discover subsystems, orchestrate parallel specialist agents, and produce high-level-architecture.md, code-atlas.md, architecture/ and code-modules/ files. Run before mpf:init for brownfield projects.
# Tools: [file_read, shell, text_search, file_search, agent_spawn]

# mpf:map-codebase

Analyze an existing codebase and generate technical documentation so MPF has full context for planning and execution.

## Usage

```
mpf:map-codebase
```

No arguments. Runs against the current working directory.

## When to Use

- **Brownfield projects:** Run this before `mpf:init` so the init interview has codebase context.
- **After major changes:** Re-run to update technical-specs/ after large refactors or new subsystem additions.
- **Onboarding:** Generate docs for a project that has none.

## Prerequisites

1. Confirm the current directory is a project root (has source code, package files, or a recognizable project structure).
2. If the directory appears empty or is not a project, tell the user: "This doesn't look like a project root. Navigate to your project directory and try again."

## Steps

### Step 1: Pre-flight Check

1. Run `ls` on the current directory to confirm it's a project.
2. Check if `docs/technical-specs/` already exists:
   - **Exists:** Tell the user: "Existing technical-specs/ found. The mapper will read existing docs and fill gaps without overwriting." Set `existing_docs=true`.
   - **Does not exist:** Set `existing_docs=false`.
3. Check if `docs/` exists. If not, create it: `mkdir -p docs/technical-specs/architecture docs/technical-specs/code-modules`

### Step 2: Spawn Mapper Lead

Spawn the mpf-mapper-lead agent:

```
agent_spawn(
  subagent_type: "mpf-mapper-lead",
  prompt: "Map this codebase. Project root: {absolute_path_to_cwd}. Existing docs: {existing_docs}.",
  mode: "bypassPermissions"
)
```

The lead handles all team creation, specialist spawning, and synthesis internally. This command does not create teams directly.

### Step 3: Report Results

After the lead completes, report its summary to the user.

Then recommend the next step:

- If `mpf:init` has not been run yet (no `docs/PROJECT.md`): "Codebase mapped. Run `mpf:init` to set up the project."
- If `mpf:init` was already run (has `docs/PROJECT.md`): "Technical specs updated. The docs are ready for `mpf:discover` or `mpf:plan-phases`."
