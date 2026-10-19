---
project: "[[logan-powers-website]]"
date: 2026-10-19
---

# logan-powers-website — repo setup

## What was done
- Opened the site in Chrome via a local server (`http://127.0.0.1:8080`).
- `git init -b main`, added `.gitignore` (excludes `.claude/settings.local.json`), initial commit.
- Created private repo https://github.com/Capadapp/logan-powers-website and pushed `main`.

## Key decisions
- Private by default. To use GitHub Pages on a free plan, flip it to public (`gh repo edit --visibility public --accept-visibility-change-consequences`), or deploy via Netlify/Vercel.
- Git identity set repo-locally to Capadapp / GitHub noreply email (no global git identity was configured on this machine).

## Problems + fixes
- Claude in Chrome refuses `file://` URLs → served the folder with `python -m http.server`.
- `git commit` failed: no author identity → set local `user.name`/`user.email`.

## Pick up next
- Fill in `<!-- EDIT -->` placeholders, add own photos, decide on hosting.
