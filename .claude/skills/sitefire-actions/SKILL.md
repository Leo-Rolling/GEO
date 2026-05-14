---
name: sitefire-actions
description: Check & execute ready Sitefire actions — review briefings and help the user act on them
---

# Check & Execute Sitefire Actions

Review your existing Sitefire actions and help execute the ones that are ready.

## Workflow

1. Call `list_actions` to get all actions
2. Identify actions with completed briefings — group by action type
3. For ready actions, call `get_briefing` to read what each one recommends
4. Present a summary organized by type:
   - **Ready to write** — CREATE_CONTENT actions with completed briefings but no article yet
   - **Ready to improve** — IMPROVE_CONTENT actions with completed briefings
   - **Ready to execute** — EDITORIAL_COVERAGE and ENGAGE_UGC actions with completed briefings
   - **In progress** — actions still being diagnosed or with briefings generating
5. Ask the user which actions they want to work on
6. Execute based on action type:

### CREATE_CONTENT execution
- Ask: "Should Sitefire write the article, or do you want to write it yourself based on the briefing?"
- If Sitefire writes: ask for any custom writing instructions, then call `write_article`
- If user writes: share the full briefing content for them to work from

### IMPROVE_CONTENT execution
- Help locate the existing content (ask the user where it lives)
- Walk through the briefing's recommendations step by step
- Apply improvements to the document

### EDITORIAL_COVERAGE execution
- Share the pre-written outreach emails from the briefing
- Help the user send them — compose in email tools if available
- Help gather supporting materials (PR docs, media kits) if the user has local access

### ENGAGE_UGC execution
- Share the pre-written posts from the briefing
- Guide the user to the target platforms (subreddit, forum, Q&A site)
- Help prepare or post the content
