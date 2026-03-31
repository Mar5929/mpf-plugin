---
name: mpf:help
description: Show a compact reference of all MPF commands, their purpose, and common flags. Run at any time for quick orientation.
allowed-tools: Read
---

# mpf:help

Print the MPF command quick reference. No file reads needed; output the table directly.

## Output

Print this table:

```
MPF Command Reference
=====================

SETUP & DISCOVERY
  mpf:init                Initialize or upgrade project scaffolding
  mpf:discover            Create PRD through structured interview
  mpf:discover --extend   Add new scope to existing PRD
  mpf:map-codebase        Analyze codebase, generate architecture docs

BROWNFIELD ONBOARDING
  mpf:import              Import requirements from external sources
  mpf:audit               Assess which requirements are already built
  mpf:audit --requirements REQ-45-51   Spot-check specific requirements
  mpf:reconcile           Align existing docs with MPF structure
  mpf:sync-linear         Check tracker alignment, fix discrepancies

PLANNING
  mpf:plan-phases              Break PRD into implementation phases
  mpf:plan-phases --new-only   Add phases for new requirements only
  mpf:plan-tasks <N>           Break phase N into executable tasks
  mpf:decompose                Quick TODO breakdown (no PRD needed)

EXECUTION & VERIFICATION
  mpf:execute <N>         Implement phase N tasks with wave parallelization
  mpf:verify <N>          Verify phase N against acceptance criteria
  mpf:verify --manual <N> Verify without prior execution (manual work)

MONITORING
  mpf:status              Show project dashboard and current state
  mpf:next                Auto-detect and suggest next workflow step
  mpf:help                This reference

WORKFLOW SEQUENCES
  Greenfield:  init > discover > plan-phases > plan-tasks > execute > verify
  Brownfield:  map-codebase > init > import > audit > reconcile > sync-linear > plan-phases > ...
  Ad-hoc:      decompose > execute > verify
```

If `CLAUDE.md` exists, also print: "Current project: {project name from CLAUDE.md Section 1}. Run `mpf:status` for full dashboard."
