#!/usr/bin/env bash
# Build the MPF plugin for Claude Code from core/ specs.
# Edit core/ files, then run this script to regenerate agents/, commands/, skills/, hooks/.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$SCRIPT_DIR/adapters/claude-code/generate.sh"
echo ""
echo "Run /reload-plugins in your Claude session to pick up changes."
