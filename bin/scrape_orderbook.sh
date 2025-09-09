#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail -o errtrace

# Arguments:
#   $1 - URL to fetch (e.g., http://127.0.0.1:62601/orderbook.json)
#   $2 - Output root dir (e.g., /mnt/volume_sfo3_01/orderbook-jsons)

ORDERBOOK_URL="${1:?Missing URL argument}"
OUTDIR_ROOT="${2:?Missing output directory prefix}"
DISCORD_WEBHOOK="https://discord.com/api/webhooks/1374466136158240898/epu9BTfIL9um8n4KJuvm7wJPv-DHZ63i1Vj_b_DOHjiVNu4o3abrPdRdGHqUnKdIfCc_"

notify_discord() {
  local msg="$1"
  curl -sS -H 'Content-Type: application/json' \
       -X POST \
       -d "{\"content\": \"${msg//\"/\\\"}\"}" \
       "$DISCORD_WEBHOOK" >/dev/null
}

trap 'notify_discord "❌ Orderbook scrape failed at $(date -u +"%Y-%m-%dT%H:%M:%SZ") for URL: $ORDERBOOK_URL"' ERR

main() {
  local date time dir file
  date=$(date -u +%F)           # YYYY-MM-DD
  time=$(date -u +%H-%M)        # HH-MM
  dir="${OUTDIR_ROOT}/${date}"
  file="${dir}/orderbook_${time}.json"

  mkdir -p "$dir"
  curl -fsSL --max-time 15 "$ORDERBOOK_URL" -o "$file"

  # Rotate old uncompressed JSONs after 1 day
  find "$OUTDIR_ROOT" -type f -name '*.json' -mtime +1 -exec gzip -9 {} \;
  find "$OUTDIR_ROOT" -type f -name '*.gz' -mtime +90 -delete
}

main
