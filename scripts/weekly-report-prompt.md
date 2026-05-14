# Weekly GEO Report — Monday digest

You run on Mondays at 09:00 Europe/Rome (cron: every Monday). This is the **weekly summary**, longer and more strategic than the daily reports.

## Working directory
`/Users/leonardodol/Documents/VisualSTudioCode/GEO/`

## Goal
Produce a weekly digest comparing **last 7 days vs previous 7 days**, identifying:
- Pages that gained/lost the most over the week (not just day-over-day)
- Topics where competitive position shifted
- New opportunities Sitefire detected
- Pending Sitefire actions (briefings ready, content to write)
- Recommendations focused on the WEEK ahead, not just yesterday

## Steps

### 1. Determine dates
- Today (Monday) — use `date '+%Y-%m-%d'`
- Last week's Monday — `date -v-7d '+%Y-%m-%d'`
- 14 days ago — `date -v-14d '+%Y-%m-%d'`

### 2. Fetch data via Sitefire MCP

Call all of these:
1. `mcp__sitefire__get_visibility_overview` with `days: 7` → current week stats
2. `mcp__sitefire__get_visibility_overview` with `days: 30` → context (longer-window trend)
3. `mcp__sitefire__get_source_performance` with `days: 7, limit: 30` → current week per-page
4. `mcp__sitefire__get_topic_positions` with `days: 7, limit: 30, view: "all"` → per-topic landscape
5. `mcp__sitefire__get_topic_opportunities` with `limit: 10` → AI-recommended priorities for the week
6. `mcp__sitefire__list_actions` with default args → all Sitefire actions across statuses
7. `mcp__sitefire__fetch_timeseries` with `series: ["visibility", "citation_rate"]`, `filters: {date_from: "<14 days ago>", date_to: "<today>", granularity: "day"}` → visibility/citation curve over the past 2 weeks

### 3. Load reports/{LAST_MONDAY}.json (the previous weekly snapshot, if exists)

If file exists → load as `prev_week_snapshot` for week-over-week comparison.
If missing → first weekly report, skip diffs and add banner: "First weekly snapshot — week-over-week diff starts next Monday."

Save today's data to `reports/weekly-{TODAY}.json` for next week's comparison.

### 4. Compute weekly aggregates

For each source URL present in BOTH this week and previous week:
- `weekly_citation_delta = today.total_citations - prev_week.total_citations`
- `weekly_usage_delta = today.usage_percentage - prev_week.usage_percentage`

Identify:
- **Top 5 weekly winners** (largest positive `weekly_citation_delta`)
- **Top 5 weekly losers** (largest negative `weekly_citation_delta`)
- **New URLs** detected this week
- **Vanished URLs** present last week, gone this week

For overall:
- Visibility score change (week-over-week)
- Citation rate change (week-over-week)

### 5. Generate per-page strategic recommendations for losers

Use the same playbook as daily but with weekly-tier framing — these are issues that have persisted for 7 days, so prescriptions should be more aggressive:

| Trigger | Weekly recommendation |
|---|---|
| Page lost > 30% of citations week-over-week | Treat as urgent. Inspect content for stale claims, broken links, missing schema. Push outreach to 2 publications featuring competitor content for the same topic. |
| Page lost ≥ 1.0pp citation rate | Run a competitor audit on Sitefire actions board. Consider creating an EDITORIAL_COVERAGE action. |
| Page disappeared entirely (was cited last week) | Verify HTTP 200, check robots.txt, review recent commits to the article body. |
| New URL detected this week | Validate it's the canonical version (not a duplicate from a sale/test slug). Boost via the homepage `featured-blog` section if relevant. |

### 6. Format HTML email — WEEKLY layout

This is the longer, weekly version. Structure:

```html
<div style="font-family:-apple-system,BlinkMacSystemFont,Helvetica,sans-serif;max-width:800px;margin:auto;padding:24px;color:#1a1a1a;background:#fff">

  <!-- HERO -->
  <div style="background:linear-gradient(135deg,#1761ff 0%,#000 100%);color:#fff;padding:28px 32px;border-radius:14px;margin-bottom:24px">
    <div style="font-size:11px;letter-spacing:0.14em;text-transform:uppercase;opacity:0.7;margin-bottom:6px">Weekly GEO Digest</div>
    <h1 style="font-size:30px;font-weight:800;margin:0 0 6px;letter-spacing:-0.02em">Week of {THIS_WEEK_DATE}</h1>
    <div style="opacity:0.85;font-size:14px">Confronto: {THIS_WEEK_RANGE} vs {PREV_WEEK_RANGE}</div>
  </div>

  <!-- KPI LEGEND (always include) -->
  <div style="background:#f0f7ff;border:1px solid #c4daff;border-radius:10px;padding:16px 20px;margin-bottom:24px;font-size:13px;line-height:1.55">
    <div style="font-weight:800;color:#1761ff;margin-bottom:8px;font-size:13px">📖 Cosa significano questi numeri</div>
    <p style="margin:0 0 6px"><strong>Visibility %</strong> — per topic. % di risposte AI che menzionano rollingsquare.com (qualunque URL) per quel topic. 0% = AI non ci tirano in ballo per quel topic, NON significa che la pagina è rotta.</p>
    <p style="margin:0 0 6px"><strong>Citation Rate %</strong> — per source/URL. Tra le risposte che usano la pagina come fonte, % che la cita esplicitamente.</p>
    <p style="margin:0"><strong>ΔW/W</strong> — variazione settimana vs settimana precedente. Per la prima volta capture anche delle metriche topic-level.</p>
  </div>

  <!-- WEEKLY OVERVIEW -->
  <div style="background:#fafbfc;border:1px solid #e0e0e0;border-radius:10px;padding:20px 24px;margin-bottom:24px">
    <div style="font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#888;font-size:11px;margin-bottom:12px">Account performance — week vs week</div>
    <table style="width:100%;border-collapse:collapse;font-size:14px">
      {OVERVIEW_ROWS — visibility this week + delta vs prev week, citation rate this week + delta, total evaluations, sources tracked, topics tracked}
    </table>
  </div>

  <!-- 14-DAY VISIBILITY/CITATION CHART (use a horizontal bar chart with HTML/CSS — text-based, no image) -->
  <h2 style="font-size:14px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#888;margin:28px 0 12px">📈 Visibility & Citation rate — last 14 days</h2>
  <div style="border:1px solid #e0e0e0;border-radius:10px;padding:16px;margin-bottom:24px">
    {DAILY_BARS_HTML — each day shows two horizontal bars: one for visibility%, one for citation_rate%. Color: visibility=#1761ff, citation_rate=#17e260. Width proportional to value (max ~80% of container).}
  </div>

  <!-- TOP 5 WEEKLY WINNERS -->
  <h2 style="font-size:15px;font-weight:700;color:#0a8a3a;margin:32px 0 10px">🏆 Top 5 winners — this week</h2>
  {WINNERS_HTML — large cards with: URL, total citations gained week-over-week, today's vs last week's usage%/citation%, what likely caused the gain (heuristic: blog post just published? cross-linked from new article?)}

  <!-- TOP 5 WEEKLY LOSERS + RECOMMENDATIONS -->
  <h2 style="font-size:15px;font-weight:700;color:#c0392b;margin:32px 0 10px">📉 Top 5 losers — this week</h2>
  {LOSERS_HTML — for each: URL, citations lost, status (still cited / vanished / dropped sharply), 2-3 weekly recommendations from the playbook above}

  <!-- COMPETITIVE LANDSCAPE PER TOPIC -->
  <h2 style="font-size:14px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#888;margin:32px 0 10px">🎯 Posizione competitiva per topic</h2>
  <p style="font-size:12px;color:#666;margin:0 0 10px">Top 3 LOSING + Top 3 UNTAPPED per search volume. Eventuali WINNING/COMPETITIVE in fondo.</p>
  {TOPIC_POSITIONS_TABLE_HTML — Topic | Volume | Status | Your vis% | Top competitor + their vis% | Gap}

  <!-- AI-RECOMMENDED OPPORTUNITIES -->
  <h2 style="font-size:14px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#888;margin:32px 0 10px">💡 Sitefire opportunities — top 5 questa settimana</h2>
  <p style="font-size:12px;color:#666;margin:0 0 10px">Topic AI-raccomandati da Sitefire come priorità (combina topic dove perdi + untapped). Quelli marcati ❤️ hanno già un'azione, quelli senza no.</p>
  {OPPORTUNITIES_LIST — for each: topic, search volume, current position (losing/untapped), recommended action_type (CREATE_CONTENT / IMPROVE_CONTENT / EDITORIAL_COVERAGE / ENGAGE_UGC), action exists yes/no}

  <!-- ACTION PORTFOLIO STATUS -->
  <h2 style="font-size:14px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#888;margin:32px 0 10px">📋 Action portfolio</h2>
  {ACTIONS_SUMMARY — count by status: ready (briefing complete, executable now) / in_progress (diagnosis or generation running) / completed / failed. List ready actions with topic + action_type + briefing summary if available}

  <!-- WEEK AHEAD: PRIORITY 3 -->
  <h2 style="font-size:14px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#888;margin:32px 0 10px">🎯 Top 3 azioni per la settimana che inizia</h2>
  {NEXT_WEEK_PRIORITIES — 3 concrete actions ranked: e.g., "Esegui CREATE_CONTENT su X (briefing già pronto)", "Re-pitch TechRadar su Supertiny (PR-Kit pronto)", "Fix dateModified su pagine declined > 30%"}

  <!-- FOOTER -->
  <p style="color:#888;font-size:11px;margin-top:32px;border-top:1px solid #e0e0e0;padding-top:14px;line-height:1.5">
    Generated by Claude Code routine via Sitefire MCP &middot; Sent through Resend on rollingsquare.com<br>
    Schedule: launchd <code>com.rollingsquare.geo-weekly</code> &middot; every Monday at 09:00 local time<br>
    Daily reports continue Tuesday-Sunday at 09:00.
  </p>
</div>
```

### 7. Send via Resend

Same approach as daily report. Subject: `Sitefire Weekly Digest — Week of {TODAY}`.

Read `RESEND_API_KEY`, `REPORT_FROM`, `REPORT_TO` from `.env.local`.

POST headers MUST include `User-Agent: RollingSquare-GEO-Report/1.0` (Cloudflare WAF blocks otherwise).

### 8. Confirm completion

Print one-line summary:
`✓ Weekly report sent {TODAY}. Winners: {N}, Losers: {N}, Opportunities: {N}, Ready actions: {N}. Email ID: {RESEND_ID}`

## Important notes

- **Save the JSON snapshot BEFORE sending the email** — if email fails, next week's diff still works.
- **Use the User-Agent header** when calling Resend.
- **For the 14-day chart**: use proportional CSS bars, not actual `<svg>` — keep email-client compatibility maximal.
- **Handle missing data gracefully**: if a section has no data (e.g., no losers this week, or no opportunities), show a positive empty state ("No declines this week 🎉") rather than empty divs.
- **First Monday run**: skip week-over-week diffs and show a banner explaining diffs start next Monday.
