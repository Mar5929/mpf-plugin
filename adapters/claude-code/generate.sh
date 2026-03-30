#!/usr/bin/env bash
# generate.sh - Transform core/ platform-agnostic specs into Claude Code plugin format.
# Reads core/ agents, commands, skills, and hooks, applies tool-name and tier-to-model
# mappings, and writes the result to dist/claude-code/.
#
# Designed to minimize subprocess spawns for MSYS2/Git Bash compatibility on Windows.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CORE_DIR="$REPO_ROOT/core"
TOOL_MAP="$SCRIPT_DIR/tool-map.yaml"
OUTPUT_DIR="$REPO_ROOT"

# ==============================================================================
# Associative arrays for mappings
# ==============================================================================

declare -A TOOL_NAMES
declare -A TIER_MODELS

# Precompiled sed script files (built once, applied many times).
SED_SCRIPT_FILE=""       # Tool substitutions only
SED_SCRIPT_FILE_FULL=""  # Tool + tier substitutions

# ==============================================================================
# parse_tool_map - populate TOOL_NAMES and TIER_MODELS from tool-map.yaml
# ==============================================================================

parse_tool_map() {
  local in_mappings=0
  local in_tiers=0

  while IFS= read -r line; do
    if [[ "$line" =~ ^mappings: ]]; then
      in_mappings=1; in_tiers=0; continue
    fi
    if [[ "$line" =~ ^tier_to_model: ]]; then
      in_tiers=1; in_mappings=0; continue
    fi
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line// /}" ]] && continue

    if (( in_mappings )); then
      if [[ "$line" =~ ^[[:space:]]*([a-z0-9_]+):[[:space:]]*\"?([^\"]+)\"?[[:space:]]*$ ]]; then
        TOOL_NAMES["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
      fi
    fi

    if (( in_tiers )); then
      if [[ "$line" =~ ^[[:space:]]*([a-z]+):[[:space:]]*(.*) ]]; then
        TIER_MODELS["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}"
      fi
    fi
  done < "$TOOL_MAP"

  echo "[parse_tool_map] Loaded ${#TOOL_NAMES[@]} tool mappings, ${#TIER_MODELS[@]} tier mappings."
}

# ==============================================================================
# build_sed_script - precompile a single sed script for tool name substitutions
# ==============================================================================

build_sed_script() {
  SED_SCRIPT_FILE="$SCRIPT_DIR/.sed_script.tmp"

  # Sort tool keys longest-first to avoid partial-match collisions.
  local keys=()
  for k in "${!TOOL_NAMES[@]}"; do
    keys+=("$k")
  done

  # Insertion sort by length descending (no subprocess)
  local i j tmp
  for (( i=1; i<${#keys[@]}; i++ )); do
    tmp="${keys[$i]}"
    j=$i
    while (( j > 0 )) && (( ${#keys[$((j-1))]} < ${#tmp} )); do
      keys[$j]="${keys[$((j-1))]}"
      ((j--))
    done
    keys[$j]="$tmp"
  done

  # Write sed script
  > "$SED_SCRIPT_FILE"
  for key in "${keys[@]}"; do
    local val="${TOOL_NAMES[$key]}"
    local val_escaped="${val//\//\\/}"
    echo 's/`'"$key"'`/`'"$val_escaped"'`/g' >> "$SED_SCRIPT_FILE"
    echo 's/'"$key"'(/'"$val_escaped"'(/g' >> "$SED_SCRIPT_FILE"
    echo 's/\([^a-zA-Z0-9_]\)'"$key"'\([^a-zA-Z0-9_]\)/\1'"$val_escaped"'\2/g' >> "$SED_SCRIPT_FILE"
  done

  # NOTE: No tier-to-model body substitutions. Tier mapping only applies to
  # agent frontmatter (model: field), not body text. Applying it to body text
  # corrupts prose (e.g., "Deep reasoning needed" becomes "Deep opus needed").
  SED_SCRIPT_FILE_FULL="$SED_SCRIPT_FILE"

  echo "[build_sed_script] Precompiled sed script (${#keys[@]} tool mappings)."
}

# ==============================================================================
# resolve_tool_inline - map abstract tool name to Claude Code name (no subshell)
# ==============================================================================

_RESOLVED=""
resolve_tool_inline() {
  local abstract="$1"
  abstract="${abstract#"${abstract%%[![:space:]]*}"}"
  abstract="${abstract%"${abstract##*[![:space:]]}"}"
  _RESOLVED="${TOOL_NAMES[$abstract]:-$abstract}"
}

# ==============================================================================
# transform_agents - core/agents/*.md -> dist/claude-code/agents/*.md
# ==============================================================================

transform_agents() {
  local agent_dir="$CORE_DIR/agents"
  local out_dir="$OUTPUT_DIR/agents"
  mkdir -p "$out_dir"

  local count=0
  for src in "$agent_dir"/*.md; do
    [[ -f "$src" ]] || continue
    local filename="${src##*/}"

    # Extract metadata using bash read loop (no subprocess per field)
    local agent_name="" tier="" tools_raw=""
    while IFS= read -r line; do
      if [[ "$line" =~ ^#\ Agent:\ (.*) ]]; then
        agent_name="${BASH_REMATCH[1]}"
      elif [[ "$line" =~ ^#\ Tier:\ (.*) ]]; then
        tier="${BASH_REMATCH[1]}"
      elif [[ "$line" =~ ^#\ Tools:\ \[(.*)\] ]]; then
        tools_raw="${BASH_REMATCH[1]}"
      elif [[ -z "$line" ]]; then
        break
      fi
    done < "$src"

    local model="${TIER_MODELS[$tier]:-$tier}"

    # Build tools YAML list
    local tools_yaml=""
    IFS=',' read -ra tool_arr <<< "$tools_raw"
    for t in "${tool_arr[@]}"; do
      resolve_tool_inline "$t"
      tools_yaml="${tools_yaml}  - ${_RESOLVED}"$'\n'
    done

    # Build output: frontmatter + transformed body (single pipeline)
    {
      echo "---"
      echo "name: ${agent_name}"
      echo "model: ${model}"
      echo "tools:"
      printf "%s" "$tools_yaml"
      echo "---"
      sed '/^# Agent:/d; /^# Tier:/d; /^# Tools:/d' "$src" | sed -f "$SED_SCRIPT_FILE"
    } > "$out_dir/$filename"

    count=$((count + 1))
  done

  echo "[transform_agents] Generated $count agent file(s)."
}

# ==============================================================================
# transform_commands - core/commands/mpf/*.md -> dist/claude-code/commands/mpf/*.md
# ==============================================================================

transform_commands() {
  local cmd_dir="$CORE_DIR/commands/mpf"
  local out_dir="$OUTPUT_DIR/commands"
  mkdir -p "$out_dir"

  local count=0
  for src in "$cmd_dir"/*.md; do
    [[ -f "$src" ]] || continue
    local filename="${src##*/}"

    # Extract metadata
    local cmd_name="" description="" tools_raw=""
    while IFS= read -r line; do
      if [[ "$line" =~ ^#\ Command:\ (.*) ]]; then
        cmd_name="${BASH_REMATCH[1]}"
      elif [[ "$line" =~ ^#\ Description:\ (.*) ]]; then
        description="${BASH_REMATCH[1]}"
      elif [[ "$line" =~ ^#\ Tools:\ \[(.*)\] ]]; then
        tools_raw="${BASH_REMATCH[1]}"
      elif [[ -z "$line" ]]; then
        break
      fi
    done < "$src"

    # Resolve tools to comma-separated Claude Code names
    local tools_csv=""
    IFS=',' read -ra tool_arr <<< "$tools_raw"
    for t in "${tool_arr[@]}"; do
      resolve_tool_inline "$t"
      if [[ -z "$tools_csv" ]]; then
        tools_csv="$_RESOLVED"
      else
        tools_csv="${tools_csv}, ${_RESOLVED}"
      fi
    done

    # Build output: frontmatter + transformed body
    {
      echo "---"
      echo "name: ${cmd_name}"
      echo "description: ${description}"
      echo "allowed-tools: ${tools_csv}"
      echo "---"
      sed '/^# Command:/d; /^# Description:/d; /^# Tools:/d' "$src" | sed -f "$SED_SCRIPT_FILE"
    } > "$out_dir/$filename"

    count=$((count + 1))
  done

  echo "[transform_commands] Generated $count command file(s)."
}

# ==============================================================================
# transform_skills - core/skills/mpf/ -> dist/claude-code/skills/mpf/
# ==============================================================================

transform_skills() {
  local skill_dir="$CORE_DIR/skills/mpf"
  local out_dir="$OUTPUT_DIR/skills/mpf"
  mkdir -p "$out_dir"

  # --- SKILL.md ---
  local src="$skill_dir/SKILL.md"
  if [[ -f "$src" ]]; then
    local skill_name="" description=""
    while IFS= read -r line; do
      if [[ "$line" =~ ^#\ Skill:\ (.*) ]]; then
        skill_name="${BASH_REMATCH[1]}"
      elif [[ "$line" =~ ^#\ Description:\ (.*) ]]; then
        description="${BASH_REMATCH[1]}"
      elif [[ -z "$line" ]]; then
        break
      fi
    done < "$src"

    {
      echo "---"
      echo "name: ${skill_name}"
      echo "description: ${description}"
      echo "---"
      sed '/^# Skill:/d; /^# Description:/d' "$src" | sed -f "$SED_SCRIPT_FILE_FULL"
    } > "$out_dir/SKILL.md"

    echo "[transform_skills] Generated SKILL.md."
  fi

  # --- Reference files ---
  local ref_dir="$skill_dir/references"
  local ref_out="$out_dir/references"
  if [[ -d "$ref_dir" ]]; then
    mkdir -p "$ref_out"
    local ref_count=0
    for ref in "$ref_dir"/*.md; do
      [[ -f "$ref" ]] || continue
      local ref_name="${ref##*/}"
      sed -f "$SED_SCRIPT_FILE_FULL" "$ref" > "$ref_out/$ref_name"
      ref_count=$((ref_count + 1))
    done
    echo "[transform_skills] Copied $ref_count reference file(s)."
  fi
}

# ==============================================================================
# generate_plugin_json - write .claude-plugin/plugin.json
# ==============================================================================

generate_plugin_json() {
  local plugin_dir="$OUTPUT_DIR/.claude-plugin"
  mkdir -p "$plugin_dir"

  cat > "$plugin_dir/plugin.json" <<'PLUGIN_EOF'
{
  "name": "mpf",
  "description": "Mike Project Framework - lean project management pipeline with phased execution, state tracking, and atomic commits. Commands: mpf:init, mpf:map-codebase, mpf:discover, mpf:plan-phases, mpf:plan-tasks, mpf:execute, mpf:verify, mpf:status, mpf:sync-linear.",
  "version": "0.1.0",
  "author": {
    "name": "Michael Rihm"
  }
}
PLUGIN_EOF

  echo "[generate_plugin_json] Written plugin.json."
}

# ==============================================================================
# generate_hook - produce the PostToolUse hook script from core/hooks spec
# ==============================================================================

generate_hook() {
  local hook_dir="$OUTPUT_DIR/hooks"
  mkdir -p "$hook_dir"

  cat > "$hook_dir/doc-update-hook.sh" <<'HOOK_EOF'
#!/usr/bin/env bash
# MPF PostToolUse hook for Write/Edit tools.
# Generated by adapters/claude-code/generate.sh from core/hooks/doc-update-hook.md

INPUT="$1"

FILE_PATH=$(echo "$INPUT" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -1)

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

case "$FILE_PATH" in
  */docs/*|*/.claude/*|*/archive/*|*.md|*.json|*.yml|*.yaml|*.toml|*.lock|*.env*)
    exit 0
    ;;
esac

echo "[MPF] Source file modified: $FILE_PATH"
echo "[MPF] Check if docs/technical-specs/code-atlas.md, code-modules/, or PROJECT_STATUS.md need updating."
HOOK_EOF

  chmod +x "$hook_dir/doc-update-hook.sh"
  echo "[generate_hook] Written doc-update-hook.sh."
}

# ==============================================================================
# validate - count outputs and print summary
# ==============================================================================

validate() {
  echo ""
  echo "=============================="
  echo "  MPF Claude Code Plugin Build"
  echo "=============================="

  local total=0
  local c

  c=$(ls "$OUTPUT_DIR/agents/"*.md 2>/dev/null | wc -l)
  echo "  Agents:     $c"
  total=$((total + c))

  c=$(ls "$OUTPUT_DIR/commands/"*.md 2>/dev/null | wc -l)
  echo "  Commands:   $c"
  total=$((total + c))

  c=$(ls "$OUTPUT_DIR/skills/mpf/"*.md "$OUTPUT_DIR/skills/mpf/references/"*.md 2>/dev/null | wc -l)
  echo "  Skills:     $c"
  total=$((total + c))

  if [[ -f "$OUTPUT_DIR/hooks/doc-update-hook.sh" ]]; then
    echo "  Hooks:      1"
    total=$((total + 1))
  fi

  echo "------------------------------"
  echo "  Total files: $total"
  echo "  Output dir:  $OUTPUT_DIR"
  echo "=============================="
}

# ==============================================================================
# Main
# ==============================================================================

main() {
  echo "MPF generate.sh - building Claude Code plugin from core/ specs"
  echo ""

  # Clean previous generated output (safe: only removes known generated dirs)
  rm -rf "$OUTPUT_DIR/agents" "$OUTPUT_DIR/commands" "$OUTPUT_DIR/skills" "$OUTPUT_DIR/hooks"
  mkdir -p "$OUTPUT_DIR"

  parse_tool_map
  build_sed_script
  transform_agents
  transform_commands
  transform_skills
  generate_hook

  # Clean up temp sed script
  rm -f "$SED_SCRIPT_FILE" "$SED_SCRIPT_FILE_FULL" 2>/dev/null

  validate
}

main "$@"
