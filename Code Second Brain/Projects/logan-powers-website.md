---
repo: https://github.com/Capadapp/logan-powers-website
visibility: private
status: active
created: 2026-10-19
---

# logan-powers-website

## What it is
Personal portfolio site: static HTML/CSS/JS with GSAP + ScrollTrigger + Lenis motion (CDN). Dark cinematic hero, warm-paper body, gold accents. Local path: `D:\Code Projects\Personal website\logan-powers-website`.

## Goals
- Publish (GitHub Pages / Netlify) and link from LinkedIn + college applications
- Fill in `<!-- EDIT -->` flags in `index.html` (school name, courses)
- Swap Unsplash photos for own images (headshot for hero)

## Decisions & lessons
- Repo created private; GitHub Pages on a free account needs it public (or use Netlify/Vercel).
- `.claude/settings.local.json` is gitignored.
- Preview locally with `python -m http.server 8080` (Claude in Chrome can't open `file://` URLs).

## Log
- 2026-10-19 — Git initialized, pushed to new private repo Capadapp/logan-powers-website.
- 2026-10-19 — Removed 0→100 preloader; page now fades in on window load (`is-loading` class on `<html>`, 3.5–4s safety nets).
