# Task 06: Create core skills and references

**Requirement:** REQ-011
**Phase:** 4

## Context
Read these files before implementing:
- `skills/mpf/SKILL.md` -- main skill file (~420+ lines)
- `skills/mpf/references/document-templates.md` -- document templates (~660+ lines)
- `skills/mpf/references/workflow-rules.md` -- workflow rules (~181 lines)
- `skills/mpf/references/model-routing.md` -- model routing table (created in Phase 1)
- `skills/mpf/references/salesforce.md` -- Salesforce-specific reference
- `core/model-tiers.yaml` -- from task 4-01, for tier name references

## Files
- `core/skills/mpf/SKILL.md` (create)
- `core/skills/mpf/references/document-templates.md` (create)
- `core/skills/mpf/references/workflow-rules.md` (create)
- `core/skills/mpf/references/model-routing.md` (create)
- `core/skills/mpf/references/salesforce.md` (create)

## Action
Copy each skill and reference file into `core/skills/mpf/`, applying these transformations:

### Transformation rules:
1. **SKILL.md frontmatter:** Replace YAML frontmatter with comment-based metadata (same pattern as agents and commands).

2. **Tool references:** Replace any Claude Code tool names mentioned in skill content with abstract names. Most tool references in SKILL.md are in Round 8 (agent configuration) and the creation summary.

3. **Model references in Round 8:** Update Round 8's model routing bullet to reference abstract tiers (`reasoning`, `standard`, `fast`) instead of concrete models (`opus`, `sonnet`, `haiku`). Reference `core/model-tiers.yaml` for the mapping.

4. **Plugin paths:** Replace `~/.claude/plugins/mpf/` references with relative paths from core.

5. **Content preservation:** All interview logic, document templates, workflow rules, and reference content stays identical. These are the core intellectual property of MPF and are platform-neutral by nature.

6. **document-templates.md:** This file is almost entirely platform-neutral already (document structures are not platform-specific). The only changes are: remove any Claude Code-specific syntax examples, update task file template tool references if any exist.

7. **workflow-rules.md:** Replace tool names in any rule that references specific tools. The Agent Orchestration Rules section (added in Phase 2) references `TeamCreate`, `SendMessage`, `mpf-checker` spawn syntax -- convert to abstract equivalents.

8. **model-routing.md:** Already mostly abstract. Ensure the "Customization" section references abstract tiers. The provider-specific mappings are fine since this file documents the mapping.

9. **salesforce.md:** Copy as-is (domain reference content, no platform-specific syntax).

## Verify
```bash
test -f core/skills/mpf/SKILL.md && echo "SKILL.md exists"
test -f core/skills/mpf/references/document-templates.md && echo "templates exists"
test -f core/skills/mpf/references/workflow-rules.md && echo "workflow exists"
test -f core/skills/mpf/references/model-routing.md && echo "routing exists"
test -f core/skills/mpf/references/salesforce.md && echo "salesforce exists"
grep -l "model: opus\|model: sonnet\|model: haiku" core/skills/mpf/SKILL.md && echo "FAIL: concrete models" || echo "PASS"
```

## Done
- [ ] All 5 skill/reference files exist in `core/skills/mpf/`
- [ ] SKILL.md Round 8 uses abstract tier names
- [ ] workflow-rules.md uses abstract tool names in orchestration section
- [ ] document-templates.md content preserved
- [ ] No Claude Code-specific frontmatter syntax

## Dependencies
**Wave:** 2
**Depends On:** task-01
