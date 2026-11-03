---
repo: https://github.com/Capadapp/minecraft-server-map
visibility: private
status: active
created: 2026-11-01
---

# minecraft-server-map

## What it is
"Server Atlas": a shared web map for a Bedrock server with friends (seed 5954060426765304508). Biome map from the seed, predicted villages, and shared editing of territories, houses, points of interest and villages, with coordinates and undo. Player accounts, admin, factions and a World History section. Leaflet front end, Cloudflare Pages + D1 back end.

Local folder: `C:\Users\logan\Desktop\minecraft-server-map`

## Goals
- Friends can add and update places themselves, with exact coordinates.
- Map matches the real world as closely as a seed calculation can.

## Decisions & lessons
- cubiomes is a Java generator, but Overworld biomes are shared with Bedrock since 1.18. Structure placement isn't, so villages use Bedrock's own algorithm.
- cubiomes predates dappled forest (Bedrock 26.50). `tools/seedgen.c` splits it out of plains by climate values.
- Checked against mcseeder.com: 401/401 villages identical, 332/332 biome samples. Not yet checked against a real world.
- Leaflet renders tooltip strings as HTML, so user text must be passed as DOM nodes.

## Ideas
Logan wants to keep adding to this. Not started:
- Faction wars or claim disputes, with an overlap list for the admin.
- Nether and End maps.
- Server events calendar on the map.
- Discord link: post map changes to a channel.
- Screenshots on places (needs Cloudflare R2).

## Log
- 2026-11-01 — Built and tested locally, pushed to private repo. Not deployed yet: needs Logan's Cloudflare account. See [[2026-11-01 minecraft-server-map - initial build]].
- 2026-11-02 — Added player accounts, admin, ownership, allies, automatic colours, World History and a browser AI chronicle. Still local only. See [[2026-11-02 minecraft-server-map - accounts and history]].
- 2026-11-03 — Added factions with logos, plus smaller extras and full deploy steps. Ready for Logan to deploy. See [[2026-11-03 minecraft-server-map - factions and ship prep]].
