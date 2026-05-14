---
name: sitefire-discover
description: Analyze AI visibility data and find new topics worth creating actions for
---

# Discover New Topics for Sitefire Actions

Analyze your AI visibility data and find new topics worth creating actions for.

## Workflow

1. Call `get_visibility_overview` for a high-level performance summary
2. Present the overview: visibility score, trend, citation rate, competitor ranking
3. Call `get_topic_positions` with view=all to see the competitive landscape
4. Highlight key findings:
   - Topics where you're losing to specific competitors
   - Untapped topics with high search volume
   - Competitive (battleground) topics where you're close to winning
5. Call `get_topic_opportunities` for AI-recommended priorities
6. Present the prioritized list, noting which topics already have actions
7. Ask: "Would you like me to create actions for any of these topics?"
8. For selected topics, confirm the action type (or let Sitefire auto-diagnose) and call `create_action`
9. After creating actions, note that diagnosis takes 2-5 minutes and offer to check back later

## Tips
- Use `get_source_performance` if the user wants to understand which of their existing pages drive AI visibility
- Filter by AI model (chatgpt, gemini, perplexity, etc.) if the user wants model-specific insights
- Use 7-day lookback for recent trends, 90-day for strategic analysis
