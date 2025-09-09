#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail -o errtrace

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up OrderBook Scraper..."

# Create necessary directories
echo "Creating directory structure..."
mkdir -p "$SCRIPT_DIR"/{bin,logs,data,config}

# Make scripts executable
echo "Making scripts executable..."
chmod +x "$SCRIPT_DIR/bin/scrape_orderbook.sh"
chmod +x "$SCRIPT_DIR/bin/run_scraper.sh"

# Update config with actual paths
echo "Updating configuration with current paths..."
cat > "$SCRIPT_DIR/config/config.env" << EOF
# Configuration for orderbook scraper
ORDERBOOK_URL="http://127.0.0.1:62601/orderbook.json"
OUTDIR_ROOT="$SCRIPT_DIR/data"
SCRIPT_DIR="$SCRIPT_DIR"
LOG_FILE="$SCRIPT_DIR/logs/scraper.log"
EOF

# Add cron job
echo "Setting up cron job to run every minute..."
CRON_JOB="* * * * * $SCRIPT_DIR/bin/run_scraper.sh"

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -F "$SCRIPT_DIR/bin/run_scraper.sh" > /dev/null; then
    echo "Cron job already exists, skipping..."
else
    # Add the cron job
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Cron job added successfully!"
fi

echo "Setup complete!"
echo ""
echo "Directory structure:"
echo "├── bin/             # Executable scripts"
echo "├── config/          # Configuration files"
echo "├── data/            # Output data directory"
echo "├── logs/            # Log files"
echo "└── setup.sh         # This setup script"
echo ""
echo "The scraper will run every minute and save data to: $SCRIPT_DIR/data"
echo "Logs will be written to: $SCRIPT_DIR/logs/scraper.log"
echo ""
echo "To remove the cron job later, run:"
echo "crontab -l | grep -v '$SCRIPT_DIR/bin/run_scraper.sh' | crontab -"