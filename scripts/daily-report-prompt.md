# Daily GEO Report — Sitefire → Resend pipeline

You are running in non-interactive mode (`claude --print`) inside the Rolling Square GEO project. Your job is to fetch today's Sitefire data, compare it to yesterday's snapshot, format an HTML email report, and send it via Resend. Do this end-to-end without asking confirmation.

## Working directory
`/Users/leonardodol/Documents/VisualSTudioCode/GEO/`

## Steps

### 1. Determine dates
- Today = local system date in `YYYY-MM-DD` format. Use `date '+%Y-%m-%d'` via Bash.
- Yesterday = today minus 1 day.

### 2. Fetch today's data via Sitefire MCP

Call these in order:
1. `mcp__sitefire__get_visibility_overview` with `days: 7` — overall account stats + top 5 competitors aggregati
2. `mcp__sitefire__get_source_performance` with `days: 7, limit: 30` — per-page citations
3. `mcp__sitefire__get_topic_positions` with `days: 7, limit: 30, view: "all"` — per-topic competitive landscape (winning/losing/competitive/untapped)

Save the combined result to `reports/{TODAY}.json` with this shape:

```json
{
  "snapshot_date": "{TODAY}",
  "snapshot_iso": "{ISO_TIMESTAMP}",
  "lookback_days": 7,
  "overview": { ... full overview response ... },
  "sources": [ ... full sources array ... ],
  "total_sources_tracked": <number>
}
```

### 3. Load yesterday's snapshot

If `reports/{YESTERDAY}.json` exists → load it as `prev`.
If it does NOT exist → set `prev = null` and the report will simply show today's snapshot without diffs (this happens on the very first run).

### 4. Compute diffs

For overall:
- `visibility_delta_24h = today.overview.visibility_score - prev.overview.visibility_score`
- `citation_delta_24h = today.overview.citation_score - prev.overview.citation_score`

For each source URL present in BOTH snapshots:
- `usage_delta = today.usage_percentage - prev.usage_percentage`
- `citation_delta = today.citation_rate - prev.citation_rate`
- `total_citations_delta = today.total_citations - prev.total_citations`

Identify:
- **Top 5 risers** by `citation_delta` (largest positive, then by `total_citations_delta`)
- **Top 5 fallers** by `citation_delta` (largest negative)
- **New sources** present today but not yesterday
- **Disappeared sources** present yesterday but not today (count = 0 today)

### 5. Generate per-page recommendations for FALLERS

For each top faller, emit 2-3 specific actionable recommendations chosen from this playbook (pick the most relevant 2-3, don't dump the whole list):

| Trigger | Recommendation |
|---|---|
| Page is a blog post AND fell sharply | Check `dateModified` schema is recent; if older than 7 days, bump it. Add 2 inline citations to authority sources. |
| Page is a product page AND fell sharply | Verify product description still has key feature claims. Check if a competitor product launched recently. Update product `meta_description` with the lost keyword cluster. |
| Citation rate dropped but usage stayed same | Content is being read but not cited. Add more extractable claims (specific numbers, comparisons, named entities). Add a FAQPage schema if missing. |
| Both usage AND citation dropped | Likely a fresh competitor article surfaced. Run `mcp__sitefire__get_topic_positions` to identify which topic is moving against us. |
| New page that just appeared | First detection — no action, monitor for 7 days. |
| Disappeared (0 today) | Verify URL is still HTTP 200 (run curl). Check robots.txt didn't accidentally block. Verify article isn't accidentally unpublished. |

### 6. Format HTML email

Use this structure (clean, brand-aligned, mobile-readable):

```html
<div style="font-family:-apple-system,BlinkMacSystemFont,Helvetica,sans-serif;max-width:680px;margin:auto;padding:24px;color:#1a1a1a">

  <h1 style="font-size:22px;font-weight:800;margin:0 0 4px;letter-spacing:-0.01em">Sitefire Daily Report</h1>
  <div style="color:#888;font-size:13px;margin-bottom:24px">{TODAY} · 7-day rolling window</div>

  <!-- OVERVIEW -->
  <div style="background:#fafbfc;border:1px solid #e0e0e0;border-radius:10px;padding:18px 20px;margin-bottom:20px">
    <div style="font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#888;font-size:11px;margin-bottom:8px">Overview (account-level, all topics)</div>
    <table style="width:100%;border-collapse:collapse;font-size:14px">
      <tr><td style="padding:4px 0">Visibility (% di risposte AI che menzionano rollingsquare.com)</td><td style="text-align:right"><strong>{VIS_SCORE}%</strong> <span style="color:{VIS_COLOR}">({VIS_DELTA_SIGN}{VIS_DELTA}pp 24h)</span></td></tr>
      <tr><td style="padding:4px 0">Citation rate (quando ci usano, ci citano)</td><td style="text-align:right"><strong>{CIT_SCORE}%</strong> <span style="color:{CIT_COLOR}">({CIT_DELTA_SIGN}{CIT_DELTA}pp 24h)</span></td></tr>
      <tr><td style="padding:4px 0">Topics tracked</td><td style="text-align:right"><strong>{TOPICS}</strong></td></tr>
      <tr><td style="padding:4px 0">Sources tracked</td><td style="text-align:right"><strong>{SOURCES}</strong></td></tr>
    </table>
  </div>

  <!-- TOP COMPETITORS (account-level) -->
  <h2 style="font-size:14px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#888;margin:28px 0 8px">🥊 Top 5 competitor — account-level (320 topic aggregati)</h2>
  <p style="font-size:12px;color:#666;margin:0 0 10px">Visibility share su tutti i topic monitorati. La tua posizione è {YOUR_RANK_OR_NOT_TOP_5}.</p>
  {COMPETITOR_TABLE_HTML — for each: rank, name (domain), visibility%, mention_count}

  <!-- PER-TOPIC COMPETITIVE LANDSCAPE -->
  <h2 style="font-size:14px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#888;margin:28px 0 8px">🎯 Posizione competitiva per topic (≥3 topic strategici)</h2>
  <p style="font-size:12px;color:#666;margin:0 0 10px">
    Da <code>get_topic_positions</code>. Mostra fino a 6 topic scelti così:<br>
    1. <strong>Top 3 LOSING</strong> by search volume (dove un competitor specifico ci batte) — sono priorità di outreach/content<br>
    2. <strong>Top 3 UNTAPPED</strong> by search volume (nessuno domina ancora — terreno conquistabile)<br>
    3. Se esistono <strong>WINNING</strong> o <strong>COMPETITIVE</strong>, mostra anche quelli (massimo 2 totali).
  </p>
  {PER_TOPIC_TABLE_HTML — table with columns: Topic | Search vol | Status (LOSING/UNTAPPED/COMPETITIVE/WINNING) | Your vis% | Top competitor + their vis% | Gap (Δpp)}
  <p style="font-size:11px;color:#888;margin:8px 0 0;line-height:1.4">
    <strong>Status:</strong>
    🔴 LOSING = un competitor ha visibility &gt; 5% e noi 0%.
    🟡 COMPETITIVE = noi e top competitor sotto soglia ma entrambi presenti.
    🟢 WINNING = la tua visibility supera quella del top competitor.
    ⚪ UNTAPPED = topic dove nessuno ha penetrazione forte (≤1% top vis) — opportunità di first-mover.
  </p>

  <!-- TOP RISERS -->
  <h2 style="font-size:14px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#0a8a3a;margin:28px 0 8px">▲ Top Risers (24h)</h2>
  {RISERS_HTML — for each: URL, citation_delta as +X.Xpp, today's citation_rate, today's total_citations}

  <!-- TOP FALLERS + RECOMMENDATIONS -->
  <h2 style="font-size:14px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#c0392b;margin:28px 0 8px">▼ Top Fallers (24h)</h2>
  {FALLERS_HTML — for each: URL, citation_delta as -X.Xpp, today's stats, then a nested div with 2-3 specific recommendations}

  <!-- NEW + DISAPPEARED -->
  {if any NEW sources: list them in a small section "🆕 First detected today"}
  {if any DISAPPEARED: list with warning style "⚠️ Vanished today (was cited yesterday)"}

  <!-- KPI LEGEND — ALWAYS INCLUDE -->
  <div style="background:#f0f7ff;border:1px solid #c4daff;border-radius:10px;padding:14px 18px;margin:24px 0;font-size:13px;line-height:1.55">
    <div style="font-weight:700;color:#1761ff;margin-bottom:8px">📖 Cosa significano questi numeri</div>
    <p style="margin:0 0 6px"><strong>Visibility %</strong> — è una metrica <em>per topic</em>: su tutte le risposte AI generate per un topic monitorato (es. "cable management"), la % che menziona <strong>rollingsquare.com</strong> in qualunque sua URL. 0% significa: gli LLM non ci tirano in ballo quando rispondono su quel topic. Non è la performance del singolo articolo.</p>
    <p style="margin:0 0 6px"><strong>Citation Rate %</strong> — è <em>per source/URL</em>: tra le risposte AI che usano quella specifica pagina come fonte, la % che la cita esplicitamente. Più alto = la pagina viene riconosciuta e citata, non solo letta.</p>
    <p style="margin:0 0 6px"><strong>Usage %</strong> — è anch'essa <em>per URL</em>: quanto spesso quella URL viene usata come fonte per costruire risposte AI (citata o no).</p>
    <p style="margin:0"><strong>Δ24h</strong> — variazione vs report di ieri (finestra 7-day rolling). Una pagina può avere 0% visibility a livello topic ma alto citation rate a livello pagina: significa che quando viene letta è spesso citata, ma il topic complessivo non ci è ancora ben penetrato.</p>
  </div>

  <!-- FULL TABLE -->
  <h2 style="font-size:14px;font-weight:700;text-transform:uppercase;letter-spacing:0.08em;color:#888;margin:28px 0 8px">Per-page breakdown (top 30)</h2>
  <table style="width:100%;border-collapse:collapse;font-size:12px;border:1px solid #e0e0e0">
    <thead>
      <tr style="background:#000;color:#fff">
        <th style="text-align:left;padding:8px 10px">URL</th>
        <th style="text-align:right;padding:8px 10px">Vis %</th>
        <th style="text-align:right;padding:8px 10px">Cit %</th>
        <th style="text-align:right;padding:8px 10px">Δ24h</th>
        <th style="text-align:right;padding:8px 10px">Total cits</th>
      </tr>
    </thead>
    <tbody>{ROWS}</tbody>
  </table>

  <p style="color:#888;font-size:11px;margin-top:24px;border-top:1px solid #e0e0e0;padding-top:14px">
    Generated by Claude Code routine · Sitefire MCP → Resend · Rolling Square GEO project<br>
    Comparison window: {YESTERDAY} → {TODAY} · Data freshness: 7-day rolling
  </p>
</div>
```

Color rules for delta values:
- Positive delta → `color:#0a8a3a` (green) and prefix with `+`
- Negative delta → `color:#c0392b` (red), no need to prefix with `-` (sign is already there)
- Zero or near-zero (|delta| < 0.05) → `color:#888` (grey), no sign

Decimal formatting:
- Visibility / citation rate: 2 decimal places (e.g., `2.42%`)
- Deltas: 2 decimal places with sign (e.g., `+0.12pp`, `-0.85pp`)

### 7. Send email via Resend

Read `.env.local` to get `RESEND_API_KEY`, `REPORT_FROM`, `REPORT_TO`.

POST to `https://api.resend.com/emails` with:
- `Authorization: Bearer {RESEND_API_KEY}`
- `Content-Type: application/json`
- `User-Agent: RollingSquare-GEO-Report/1.0` ← REQUIRED, otherwise Cloudflare blocks with error 1010
- Body: `{from, to, subject, html}`
- Subject: `Sitefire Daily Report — {TODAY}`

If the email API returns an error, log it to `/tmp/geo-daily-report-error.log` with timestamp and continue (do not throw).

### 8. Confirm completion

Print a one-line summary to stdout:
`✓ Report sent {TODAY}. Risers: {N}, Fallers: {N}. Email ID: {RESEND_ID}`

If anything failed, prefix with `✗` and describe the failure briefly.

## Important notes

- **Do not ask for confirmation** at any step. This runs unattended on cron.
- **Use the User-Agent header** when calling Resend, otherwise it fails with CF error 1010.
- **Save the JSON snapshot BEFORE sending the email** — that way if email fails, tomorrow's diff still works.
- **Encode URLs that contain `®` or other special characters** carefully when displayed in HTML (use `urllib.parse.unquote` to display the readable version, but keep the URL-encoded form in href).
- **Truncate long URLs in the email** to last path segment for display, but keep full URL in the `href`.
- **The first run** (no yesterday's JSON) should still send an email with the snapshot — just skip the diff/risers/fallers sections and add a banner at the top: "Baseline snapshot — diff will start tomorrow."
