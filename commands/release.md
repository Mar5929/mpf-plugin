---
name: mpf:release
description: Coordinate a project release after all phases are verified. Updates CHANGELOG, creates git tag, closes Linear milestones, and updates PROJECT_ROADMAP.md. Run after all phases pass mpf:verify.
allowed-tools: Read, Write, Edit, Bash, mcp__claude_ai_Linear__*
---

# mpf:release

Coordinate a release after all planned phases are complete and verified.

## Usage

```
mpf:release [version]
```

Example: `mpf:release 1.0.0`

If no version is provided, suggest one based on the project state (check `docs/CHANGELOG.md` for prior versions, or default to `1.0.0` for initial release).

## Prerequisites

1. Read `docs/PROJECT_ROADMAP.md` Section 3 (Phase Roadmap).
2. Confirm all phases have status "Done" or "Verified". If any phase is incomplete, tell the user: "Phase {N} ({name}) is not yet verified. Run `mpf:verify {N}` first."
3. Read `CLAUDE.md` for version control and Linear configuration.
4. If version control is not enabled, skip git operations.

## Steps

### Step 1: Confirm Release

Present a release summary:

```
Release Summary: v{version}

Phases completed:
| Phase | Name | Verified |
|-------|------|----------|
| 1 | Foundation | Yes |
| 2 | Auth | Yes |
| 3 | Features | Yes |

Proceed with release?
```

Wait for user confirmation before proceeding.

### Step 2: Update CHANGELOG

If `docs/CHANGELOG.md` exists:

1. Read the existing changelog.
2. Add a new release entry at the top with today's date and the version.
3. Aggregate notable changes from all phases (read phase overview files for key outcomes).
4. Organize by: Added, Changed, Fixed (as applicable).

### Step 3: Git Tag (if version control enabled)

1. Confirm we're on the main branch. If not, warn the user.
2. Create an annotated tag: `git tag -a v{version} -m "Release v{version}"`
3. Ask the user if they want to push the tag: `git push origin v{version}`

### Step 4: Close Linear Milestones (if configured)

If Linear is configured:

1. Read phase overview files to find milestone IDs.
2. Add a completion comment to each milestone.
3. Close each milestone via `mcp__claude_ai_Linear__*`.

### Step 5: Update PROJECT_ROADMAP.md

1. Section 2 (Current Phase): Set to "Released: v{version}" or advance to next milestone if work continues.
2. Section 7 (Session Log): Add release entry.
3. Section 8 (Phase History): Mark all phases as released with the version tag.

### Step 6: Report

```
Release v{version} complete.

- CHANGELOG updated
- Git tag v{version} created {and pushed / (not pushed)}
- {N} Linear milestones closed
- PROJECT_ROADMAP.md updated
```
