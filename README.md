# ⚡ Kylan's Daily Opportunity Hub

A personal daily dashboard that surfaces job leads, eBay trends, Fiverr gig ideas, Upwork opportunities, and YouTube content ideas — all tailored to Kylan's skills.

## 📁 Structure

```
daily-opportunity-hub/
├── index.html                  # Main dashboard (open in browser)
├── data/
│   └── opportunities.json      # All opportunity data (edit this!)
├── scripts/
│   └── populate.sh             # Cron-ready data refresh script
├── logs/                       # Auto-created by populate.sh
└── README.md
```

## 🚀 Quick Start

### Option 1: Direct file open
Just open `index.html` in your browser. Works via `file://` if CORS isn't an issue.

### Option 2: Local server (recommended)
```bash
# With Node.js
npx serve /root/daily-opportunity-hub

# With Python
python3 -m http.server 8080 --directory /root/daily-opportunity-hub

# Then visit: http://localhost:8080
```

## 📊 Dashboard Sections

| Tab | What's in it |
|-----|-------------|
| 💼 Jobs | Remote jobs in-field + accessible, with salary & platform |
| 📦 eBay Trends | Trending UK products, competition level, sourcing tips |
| 🎯 Fiverr Gigs | Gigs to launch based on your skills, with pricing tiers |
| 💻 Upwork | Freelance contracts with skill tags and budget ranges |
| 🎬 YouTube Ideas | One recording session → 2-3 videos for @prompttocide |

## 🔄 Updating Data

### Manual
Edit `data/opportunities.json` directly. The dashboard reloads data on every page open.

### Automated (cron)
The populate script updates the `last_updated` timestamp and `date_added` fields:

```bash
chmod +x scripts/populate.sh
./scripts/populate.sh
```

**Add to cron (runs at 7am daily):**
```bash
crontab -e
# Add this line:
0 7 * * * /root/daily-opportunity-hub/scripts/populate.sh >> /root/daily-opportunity-hub/logs/populate.log 2>&1
```

### AI-powered refresh (OpenClaw)
Uncomment the OpenClaw section in `scripts/populate.sh` to have the AI regenerate fresh opportunity data each morning.

## 🎨 Customisation

The `data/opportunities.json` file is the single source of truth. Edit any section:

- **jobs** — Add/remove job listings
- **ebay_trending** — Update with latest eBay trends
- **fiverr_gigs** — Add new gig ideas
- **upwork_opportunities** — Add contract types
- **youtube_ideas** — Add video concepts for @prompttocide

## 🛠 Skills This Dashboard Is Built Around

- WordPress management
- eBay selling / listing optimisation
- Customer service (retail background)
- AI tools (Claude, ChatGPT, OpenClaw)
- Computer repair basics
- Technical setup & configuration

## 📝 Notes

- No build tools needed — pure HTML + vanilla JS
- All CSS/JS is inline for portability
- Data loaded via `fetch()` from `data/opportunities.json`
- Fully mobile-friendly (responsive grid)
- Dark theme matches expense-tracker & codecraft-dashboard
