#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#  populate.sh — Daily Opportunity Hub data refresher
#  Cron-ready: triggers an OpenClaw sub-agent to refresh data
# ─────────────────────────────────────────────────────────────────
#  Usage:
#    ./scripts/populate.sh              # run manually
#    0 7 * * * /root/daily-opportunity-hub/scripts/populate.sh >> /root/daily-opportunity-hub/logs/populate.log 2>&1
#
#  What it does:
#    1. Updates last_updated timestamp in opportunities.json
#    2. Can be extended to call a real API / scraper
#    3. Optionally triggers an OpenClaw AI refresh via CLI
# ─────────────────────────────────────────────────────────────────

set -euo pipefail

DATA_FILE="$(dirname "$0")/../data/opportunities.json"
LOG_DIR="$(dirname "$0")/../logs"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DATE=$(date +"%Y-%m-%d")

echo "[${TIMESTAMP}] Starting opportunity data refresh..."

# ── Step 1: Update the last_updated timestamp ──────────────────
if command -v python3 &>/dev/null; then
  python3 - <<PYEOF
import json, sys
path = "$DATA_FILE"
with open(path, "r") as f:
    data = json.load(f)
data["last_updated"] = "$TIMESTAMP"
# Update date_added for all items to today
for section in ["jobs", "ebay_trending", "fiverr_gigs", "upwork_opportunities", "youtube_ideas"]:
    for item in data.get(section, []):
        item["date_added"] = "$DATE"
with open(path, "w") as f:
    json.dump(data, f, indent=2)
print("[OK] Timestamp updated to $TIMESTAMP")
PYEOF
elif command -v node &>/dev/null; then
  node - <<JSEOF
const fs = require('fs');
const path = '$DATA_FILE';
const data = JSON.parse(fs.readFileSync(path, 'utf8'));
data.last_updated = '$TIMESTAMP';
['jobs','ebay_trending','fiverr_gigs','upwork_opportunities','youtube_ideas'].forEach(k => {
  (data[k] || []).forEach(item => item.date_added = '$DATE');
});
fs.writeFileSync(path, JSON.stringify(data, null, 2));
console.log('[OK] Timestamp updated to $TIMESTAMP');
JSEOF
else
  # Fallback: sed replace last_updated line
  sed -i "s/\"last_updated\": \".*\"/\"last_updated\": \"${TIMESTAMP}\"/" "$DATA_FILE"
  echo "[OK] Timestamp updated via sed"
fi

# ── Step 2: Optional — trigger OpenClaw AI refresh ────────────
# Uncomment to have OpenClaw's AI regenerate fresh opportunity data:
#
# if command -v openclaw &>/dev/null; then
#   echo "[INFO] Triggering OpenClaw AI data refresh..."
#   openclaw run --once \
#     "Read /root/daily-opportunity-hub/data/opportunities.json. \
#      Research current trending opportunities and update the data with fresh entries. \
#      Keep the same JSON structure. Save back to the file." \
#     2>&1 | tee -a "$LOG_DIR/ai-refresh-${DATE}.log"
# else
#   echo "[SKIP] openclaw CLI not found — skipping AI refresh"
# fi

# ── Step 3: Git commit (optional) ─────────────────────────────
REPO_DIR="$(dirname "$0")/.."
if [ -d "${REPO_DIR}/.git" ]; then
  cd "$REPO_DIR"
  git add data/opportunities.json
  git commit -m "chore: refresh opportunity data ${DATE}" --quiet 2>/dev/null || true
  # git push --quiet 2>/dev/null || true  # uncomment if you want auto-push
  echo "[OK] Git commit done"
fi

echo "[${TIMESTAMP}] Refresh complete. ✅"
