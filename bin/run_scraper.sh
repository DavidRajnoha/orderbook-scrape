#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail -o errtrace

# Load configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/config/config.env"

# Create log directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

# Run the scraper with logging
echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") - Starting orderbook scrape" >> "$LOG_FILE"
"$SCRIPT_DIR/bin/scrape_orderbook.sh" "$ORDERBOOK_URL" "$OUTDIR_ROOT" >> "$LOG_FILE" 2>&1
echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ") - Orderbook scrape completed" >> "$LOG_FILE"