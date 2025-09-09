#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail -o errtrace

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Uninstalling OrderBook Scraper cron job..."

# Remove cron job
if crontab -l 2>/dev/null | grep -F "$SCRIPT_DIR/bin/run_scraper.sh" > /dev/null; then
    crontab -l | grep -v "$SCRIPT_DIR/bin/run_scraper.sh" | crontab -
    echo "Cron job removed successfully!"
else
    echo "No cron job found for this scraper."
fi

echo "Uninstall complete!"
echo "Note: Data and log files have been preserved."
echo "To completely remove, delete the entire directory: $SCRIPT_DIR"