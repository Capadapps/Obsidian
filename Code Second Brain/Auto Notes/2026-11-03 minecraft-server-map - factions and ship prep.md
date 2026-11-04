---
project: minecraft-server-map
date: 2026-11-03
---

# Factions and ship prep

## What was done
- Added factions: fixed colour from a separate 12-colour palette, uploaded logo as the mark on their territories, members with leader/officer/member roles, join requests, allied factions, faction land.
- Added smaller extras: Nether portal spot, distance from your base, links to a place, remembered map view, help guide, map data download, `npm run db:backup`.
- Chronicle now covers factions.
- Rewrote the README's deploy steps and added a "Making changes after that" section. Added a repo `CLAUDE.md`.

## Key decisions
- A player is in one faction at a time. Faction land has `faction_id` and no `owner_id`, so it stays when the person who drew it leaves.
- Logos are redrawn in the browser to 128×128 and stored in D1. The server accepts only PNG and WebP, checked by leading bytes. They have their own open route so the 15-second poll stays small.
- Disbanding can't be undone. Land stays as Server-owned in the faction's colour and name.
- Membership changes are logged as `update` history entries, because `history.action` has a CHECK constraint SQLite can't alter.

## Problems and fixes
- Promoting a successor before deleting a leader broke the one-leader index, so promotion now runs after the delete.
- `wrangler d1 export` has no `--persist-to`, so the data copy was rehearsed by running it from throwaway project folders.

## Verified
- 24/24 API tests. Browser pass on a test database as leader and as member, including logo upload, claim, exact colour match and phone-width layout.
- Pages Functions compile. Export, import and migrate rehearsed on copies: 1 player, 5 places and 1 document survived.
- Real local DB backed up to `backups/before-factions-2026-11-03`, then migrated.

## Not verified
- Nothing has been deployed, so the Cloudflare commands themselves haven't run against a real account.
- `npm run demo:phone` was never loaded from a real phone. The last re-check was blocked by the permission system.
- AI sentences only tested on Logan's PC, and the AI hasn't been re-run on faction data.

## Deployed later the same day
- Live at https://minecraft-server-map.pages.dev. Database `minecraft-map` on Logan's Cloudflare account. Secrets set by Logan.
- Changing `database_id` silently pointed local tools at a new empty database, so the first export was empty. Added `preview_database_id` with the old placeholder and exported data only, since the online tables already existed. README order fixed.
- Live checks passed for pages, tiles, the API and sign-in protection. Signing in and turning admin on online were not tested, because those need Logan's passwords.

## Pick up next
Open to new ideas; see Ideas in the project note.
