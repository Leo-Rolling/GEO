# Sitefire — AI Visibility Analytics

Sitefire is the System of Record for AI visibility. It monitors how AI models (ChatGPT, Gemini, Perplexity, DeepSeek, Google AI) mention and cite your brand across tracked topics, and provides actionable intelligence to improve your presence.

This plugin connects your AI agent to your Sitefire account via MCP. You can analyze your AI visibility, manage actions, and execute content workflows directly from your terminal.

## Domain Model

- **Topic** — a keyword being monitored across AI models. Each topic tracks your visibility score, citation rate, and competitive positioning.
- **Action** — a package of work to improve AI visibility for a topic. Created manually or from recommendations. Sitefire's AI agents diagnose the topic and produce a briefing.
- **Briefing** — the actionable plan attached to an action after diagnosis completes. Contains specific instructions, pre-written content, outreach templates, or improvement recommendations depending on the action type.
- **Article** — generated content for CREATE_CONTENT actions. Sitefire's writing agents produce this from the briefing.

## Action Types

| Type | What it does | Briefing contains |
|------|-------------|-------------------|
| CREATE_CONTENT | Write a new article from scratch | Content structure, target keywords, outline, sources to cite |
| IMPROVE_CONTENT | Optimize an existing page | Specific changes to make, sections to add/rewrite, SEO improvements |
| EDITORIAL_COVERAGE | Get mentioned by editors and publishers | Pre-written outreach emails, target publications, pitch angles |
| ENGAGE_UGC | Engage in forums, Reddit, Q&A sites | Pre-written posts, target threads/subreddits, discussion points |

## Action Lifecycle

1. **Action created** for a topic (with a preset type, or auto-diagnosed by Sitefire)
2. **Diagnosis runs** (2-5 min) — Sitefire's AI analyzes the competitive landscape and determines the best approach
3. **Briefing generated** (1-3 min) — the action becomes executable
4. **For CREATE_CONTENT only**: article generation can be triggered (5-15 min)

## Two Operating Modes

### Analytics / Discovery
When exploring data or finding new topics. Use: `get_visibility_overview`, `get_topic_positions`, `get_topic_opportunities`, `get_source_performance`. Interpret the data and help the user decide what to tackle.

### Action / Execution
When working on existing actions. Use: `list_actions`, `get_action`, `get_briefing`, `get_article`, `write_article`. Actions are already-analyzed work products — present them and help execute.

**Key rule**: When the user asks "what can we write?" or "what should we work on?" — check existing actions FIRST (`list_actions`), then offer to discover new topics if needed.

## Terminology

Always use user-facing terms:
- Say "action", never "project"
- Say "topic", never "keyword"
- Never mention internal concepts like prompt_set, project_members, keyword_id
