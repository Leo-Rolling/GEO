#!/bin/bash
# Weekly GEO Digest — runs every Monday at 09:00 via launchd
# Uses Claude Code in non-interactive mode with Sitefire MCP + Resend.

set -e

PROJECT_DIR="/Users/leonardodol/Documents/VisualSTudioCode/GEO"
LOG_FILE="/tmp/geo-weekly-report.log"
PROMPT_FILE="${PROJECT_DIR}/scripts/weekly-report-prompt.md"

cd "$PROJECT_DIR"

export PATH="/Users/leonardodol/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

set -a
source "${PROJECT_DIR}/.env.local"
set +a

echo "=== Weekly report run: $(date '+%Y-%m-%d %H:%M:%S %Z') ===" >> "$LOG_FILE"

PROMPT_CONTENT="$(cat "$PROMPT_FILE")"

claude --print --dangerously-skip-permissions "$PROMPT_CONTENT" >> "$LOG_FILE" 2>&1

EXIT_CODE=$?
echo "=== Exit code: $EXIT_CODE ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

exit $EXIT_CODE
