---
name: sitefire-write-all
description: Trigger article generation for all CREATE_CONTENT actions with ready briefings
---

# Write All Ready Articles

Find all CREATE_CONTENT actions with completed briefings but no article yet, and trigger article generation for each.

## Workflow

1. Call `list_actions` to get all actions
2. Filter for CREATE_CONTENT actions where:
   - Briefing status is "completed"
   - No article exists yet (or article status is not "completed" or "drafting")
3. If none found: tell the user "No actions are ready for article writing. You may need to create new actions or wait for existing diagnoses to complete."
4. If found: present the list with topic names and briefing summaries
5. Ask: "Should I trigger article generation for all of these, or would you like to pick specific ones?"
6. Ask if the user wants to add any custom writing instructions that apply to all articles
7. For each selected action:
   - Call `get_action` to get the briefing ID
   - Call `write_article` with the briefing ID (and writing instructions if provided)
   - Report: "Started article generation for [topic]. This takes about 5-15 minutes."
8. After triggering all: "Article generation is running for [N] topics. You can check progress anytime by asking about your actions."
