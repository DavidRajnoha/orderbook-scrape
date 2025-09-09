# OrderBook Scraper

A script that periodically scrapes and archives JoinMarket orderbook data.

## Prerequisites

### 1. Install and Configure JoinMarket

Follow the installation instructions in the [JoinMarket README](https://github.com/JoinMarket-Org/joinmarket-clientserver).

**Important:** Use Python 3.11 as recommended. Later Python versions may fail due to dependency issues.

### 2. Configure Bitcoin Core

Bitcoin Core must be configured as described in the [JoinMarket usage guide](https://github.com/JoinMarket-Org/joinmarket-clientserver/blob/master/docs/USAGE.md#configure). Ensure your `bitcoin.conf` includes the necessary RPC settings for JoinMarket to connect.

### 3. Configure Tor

Tor must be running on your system with the following configuration in `/etc/tor/torrc`:

```
SocksPort 9050
ControlPort 9051
CookieAuthentication 1
```

Start/restart tor after configuration:
```bash
sudo systemctl restart tor
```

### 4. Configure JoinMarket

In your JoinMarket configuration, replace the default directory nodes with these onion addresses:

```
3kxw6lf5vf6y26emzwgibzhrzhmhqiw6ekrek3nqfjjmhwznb2moonad.onion:5222,bqlpq6ak24mwvuixixitift4yu42nxchlilrcqwk2ugn45tdclg42qid.onion:5222,coinjointovy3eq5fjygdwpkbcdx63d7vd4g32mw7y553uj3kjjzkiqd.onion:5222,jmarketxf5wc4aldf3slm5u6726zsky52bqnfv6qyxe5hnafgly6yuyd.onion:5222,odpwaf67rs5226uabcamvypg3y4bngzmfk7255flcdodesqhsvkptaid.onion:5222,satoshi2vcg5e2ept7tjkzlkpomkobqmgtsjzegg6wipnoajadissead.onion:5222,shssats5ucnwdpticbb4dxvh2z364ykjfmvsoze6tkfjceq35ededagjpdmpxm6yd.onion:5222,ylegp63psfqh3zk2huckf2xth6dxvh2z364ykjfmvsoze6tkfjceq7qd.onion:5222
```

See [PR #1789](https://github.com/JoinMarket-Org/joinmarket-clientserver/pull/1789/files) for details.

### 5. Install Cron (Arch Linux)

```bash
sudo pacman -S cronie
sudo systemctl enable --now cronie
```

## Installation

1. Clone this repository
2. Run the setup script:
   ```bash
   ./setup.sh
   ```

## Usage

### Starting the OrderBook Watcher

First, start the JoinMarket orderbook watcher:
```bash
cd /path/to/joinmarket-clientserver
python scripts/obwatch/ob-watcher.py
```

This will serve the orderbook data at `http://127.0.0.1:62601/orderbook.json`

### Automatic Scraping

The setup script configures a cron job that runs every minute to scrape and archive the orderbook data.

Data will be saved to:
- `data/YYYY-MM-DD/orderbook_HH-MM.json` (uncompressed for current day)
- Older files are automatically gzipped after 1 day
- Files older than 90 days are automatically deleted

Logs are written to `logs/scraper.log`

## Configuration

Edit `config/config.env` to customize:
- `ORDERBOOK_URL` - URL of the orderbook endpoint
- `OUTDIR_ROOT` - Directory where data is stored
- `LOG_FILE` - Log file location

## Uninstallation

To remove the cron job:
```bash
./uninstall.sh
```

To completely remove all data:
```bash
rm -rf /path/to/OrderBookScrape
```

## Directory Structure

```
├── bin/             # Executable scripts
│   ├── scrape_orderbook.sh    # Main scraper script
│   └── run_scraper.sh         # Wrapper with logging
├── config/          # Configuration files
│   └── config.env            # Environment variables
├── data/            # Scraped orderbook data (organized by date)
├── logs/            # Log files
├── setup.sh         # Installation script
├── uninstall.sh     # Removal script
└── README.md        # This file
```