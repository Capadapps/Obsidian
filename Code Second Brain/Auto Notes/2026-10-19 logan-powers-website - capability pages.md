---
project: "[[logan-powers-website]]"
date: 2026-10-19
---

# logan-powers-website — capability pages, cursor, imagery

## What was done
- Removed the custom gold cursor (HTML, CSS, JS).
- Capabilities section: rows are now links; floating hover images removed.
- New pages `capabilities/{web-development,digital-marketing,client-operations,flight-training}.html` — image header, Overview / What I do / Toolkit blocks with EDIT banners, an all-capabilities index and prev/next pager.
- `js/capabilities.js` holds the one list that builds the nav "Capabilities" dropdown (all pages) and the index on each capability page.
- Flight Log: pinned sideways scroll removed → 2-column grid; each card links to the matching capability page.
- New hero photo: jet silhouette at golden hour (Unsplash, pz7vx75iMx0). Capability photos: iMac in dark room, high-rise desk at dusk, gold fountain pen nib, A330 cockpit at dawn. Credit links in README.

## Key decisions
- Interpreted "home row" as both the nav bar (dropdown) and the Flight Log cards.
- Images hotlinked from images.unsplash.com (all verified "Free to use under the Unsplash License", no Unsplash+).
- Nav drops `mix-blend-mode` and turns solid while the dropdown is open (uses `:has()`).

## Problems + fixes
- PowerShell 5.1 `Get-Content -Raw | Set-Content` re-encoded index.html and garbled UTF-8 (═, —). Restored from git; use the Edit tool for text edits, never PS round-trips.
- Claude in Chrome tab IDs don't carry across turns — call tabs_context_mcp again.

## Pick up next
- Flight Log card images are still bright stock (team meeting, code, clouds, city) — swap for darker matches.
- Hero refinement plan (smaller type, gold as accent only, slower fade) still pending.
- Fill in real details / EDIT flags on each capability page.
