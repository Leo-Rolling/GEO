# GitHub Copilot / AI agent instructions

Purpose
- Help AI coding agents be immediately productive in this repository: a small static site with article HTML files and supporting assets.

Big picture (what to know quickly)
- This repo is organized as a static content site: primary content lives in the `blog/` directory (HTML files and `assets/`).
- Supplementary content and editorial material appear in `Briefing/` and images in `Images/`.
- There are paired language variants for many posts (English and Spanish). When updating content, look for matching slugs in both languages.
- Default branch: `main` (repository metadata).

Key files and examples
- Entrypoint: `blog/index.html` — site index and navigation.
- Language-pair example: `blog/how-to-find-lost-device-complete-guide.html` and `blog/como-encontrar-dispositivo-perdido-guia-completa.html`.
- Assets: `blog/assets/` contains CSS/JS/static resources referenced by the HTML pages.

Patterns & conventions
- Content is plain static HTML (not Markdown). Preserve the existing HTML structure and relative paths when editing.
- When changing an article, check for an equivalent translation and update both versions consistently.
- Keep file slugs and filenames stable — they appear to be used as canonical URLs.
- Add images to `Images/` and follow the path style already used by pages (inspect existing `img` tags to match relative linking).

Local preview & developer workflows
- There is no build system detected in the repo. To preview locally, serve the repository root with a simple HTTP server, for example:

  python -m http.server 8000

- Then open `http://localhost:8000/blog/` to view pages.
- Use plain `git` workflows: edit files on a branch, open a PR against `main`.

Guidance for AI edits
- Make minimal, targeted edits unless asked to refactor many files.
- For content changes: update both language variants when present and keep translations consistent (copy and mark translation TODOs if you cannot fully translate).
- For asset edits: preserve relative references inside `blog/` and ensure paths to `blog/assets/*` are intact.
- When adding new pages, follow the existing filename slug pattern and add any new assets under `blog/assets/` or `Images/` as appropriate.

What not to assume
- No JS build (Node/npm) or CI configurations were found; do not add build tool assumptions without confirming.
- Deployment mechanism (GitHub Pages or external host) is not present in repo files — verify with maintainers before changing deployment-related files.

Questions for maintainers (if you need clarification)
- Should content edits always be mirrored in both languages or sometimes only one?
- Is there a preferred image path structure (absolute vs relative) for newly added images?

If something is unclear, leave a short inline TODO comment in the edited HTML and open a PR describing the ambiguity.

---
Keep edits compact and reversible; prefer separate PRs for content vs structural changes.
