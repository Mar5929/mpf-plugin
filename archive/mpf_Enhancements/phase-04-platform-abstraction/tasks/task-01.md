# Task 01: Create core/model-tiers.yaml

**Requirement:** REQ-013
**Phase:** 4

## Context
Read these files before implementing:
- `skills/mpf/references/model-routing.md` -- contains the current agent-to-model mapping with Abstract Tier column (reasoning, standard, fast)
- `mpf_Enhancements/phase-04-platform-abstraction/overview.md` -- success criterion 4: model-tiers.yaml maps abstract tiers to provider-specific models

## Files
- `core/model-tiers.yaml` (create) -- abstract tier definitions with provider mappings

## Action
Create the `core/` directory and `core/model-tiers.yaml` with the following content:

```yaml
# Model Tier Definitions
# Maps abstract performance tiers to provider-specific model identifiers.
# Platform adapters read this file to resolve tier names in agent specs.

tiers:
  reasoning:
    description: "Complex planning, architecture synthesis, verification, and judgment calls"
    providers:
      claude: opus
      openai: o3
      google: gemini-2.5-pro
    default_for:
      - planner
      - verifier
      - mapper-lead

  standard:
    description: "Code execution, following well-defined specs, structured exploration"
    providers:
      claude: sonnet
      openai: gpt-4.1
      google: gemini-2.5-flash
    default_for:
      - executor
      - mapper-specialist

  fast:
    description: "Mechanical checks, simple lookups, structural validation"
    providers:
      claude: haiku
      openai: gpt-4.1-mini
      google: gemini-2.5-flash-lite
    default_for:
      - checker

# Cost guidance (from NFR-002):
# Reasoning-tier usage should stay below 20% of total agent calls per phase.
# See skills/mpf/references/model-routing.md for detailed cost analysis.
```

## Verify
```bash
test -f core/model-tiers.yaml && echo "File exists"
grep "reasoning:" core/model-tiers.yaml
grep "standard:" core/model-tiers.yaml
grep "fast:" core/model-tiers.yaml
grep "claude:" core/model-tiers.yaml
grep "openai:" core/model-tiers.yaml
```

## Done
- [ ] `core/model-tiers.yaml` exists
- [ ] Defines three tiers: reasoning, standard, fast
- [ ] Each tier has a description, provider mappings (claude, openai, google), and default_for list
- [ ] Includes cost guidance reference

## Dependencies
**Wave:** 1
**Depends On:** none
