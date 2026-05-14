# Sitefire Agent Plugin

Connect your AI coding agent to your [Sitefire](https://sitefire.ai) account for AI visibility analytics, action management, and content workflows — directly from your terminal or IDE.

Works with **Claude Code**, **Codex**, **Cursor**, **Gemini CLI**, and any agent that supports the [Agent Skills](https://github.com/anthropics/skills) spec or remote MCP servers.

## What's included

| Component | Purpose |
|-----------|---------|
| **MCP Server** | Auto-connects your agent to Sitefire's API (OAuth, no setup needed) |
| **Product Knowledge** | Your agent understands Sitefire's domain model, workflows, and terminology |
| **`/sitefire-actions`** | Check existing actions and execute ready briefings |
| **`/sitefire-discover`** | Analyze visibility data and find new topics to work on |
| **`/sitefire-write-all`** | Trigger article generation for all ready briefings at once |

## Installation

```bash
npx skills add sitefire-ai/skills
```

On first use, a browser window opens where you sign in to your Sitefire account and approve access.

For alternative setup methods (Claude.ai, Claude Desktop, manual MCP config), see the [full documentation](https://docs.sitefire.ai/docs/mcp).

## Usage

Once installed, your agent automatically has access to your Sitefire data. Just ask:

- "How is our AI visibility?" — runs analytics overview
- "What actions do we have?" — lists existing actions with briefing status
- "What articles can we write?" — finds ready CREATE_CONTENT actions
- "What topics should we tackle next?" — discovers new opportunities

Or use the slash commands:

```
/sitefire-actions     # Review and execute ready actions
/sitefire-discover    # Analyze data and find new topics
/sitefire-write-all   # Batch-trigger article generation
```

## How it works

Sitefire monitors your brand's visibility across AI models (ChatGPT, Gemini, Perplexity, DeepSeek, Google AI). When you create an **action** for a topic, Sitefire's AI agents diagnose the competitive landscape and produce a **briefing** — an actionable plan with specific recommendations. For content actions, Sitefire can also generate the article.

This plugin gives your agent the context to navigate these workflows fluently: it knows when to check existing actions vs. discover new topics, how to read briefings, and how to help you execute each action type.

## Requirements

- A Sitefire account at [app.sitefire.ai](https://app.sitefire.ai)
- An AI coding agent that supports [Agent Skills](https://github.com/anthropics/skills) or remote MCP servers
