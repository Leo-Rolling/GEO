#!/bin/bash
# Daily GEO Report — runs at 09:00 via launchd
# Triggers Claude Code in non-interactive mode to fetch Sitefire data,
# compute day-over-day deltas, format HTML, and send via Resend.

set -e

PROJECT_DIR="/Users/leonardodol/Documents/VisualSTudioCode/GEO"
LOG_FILE="/tmp/geo-daily-report.log"
PROMPT_FILE="${PROJECT_DIR}/scripts/daily-report-prompt.md"

cd "$PROJECT_DIR"

# Make sure PATH includes /opt/homebrew/bin (where claude CLI lives) — launchd has minimal PATH
export PATH="/Users/leonardodol/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Load env
set -a
source "${PROJECT_DIR}/.env.local"
set +a

echo "=== Daily report run: $(date '+%Y-%m-%d %H:%M:%S %Z') ===" >> "$LOG_FILE"

# Run claude in non-interactive print mode
# --dangerously-skip-permissions allows MCP + Bash + Write tools without prompts
# --print outputs final answer and exits
PROMPT_CONTENT="$(cat "$PROMPT_FILE")"

claude --print --dangerously-skip-permissions "$PROMPT_CONTENT" >> "$LOG_FILE" 2>&1

EXIT_CODE=$?
echo "=== Exit code: $EXIT_CODE ===" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

exit $EXIT_CODE
