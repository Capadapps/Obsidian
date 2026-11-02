# 2026-11-02 minecraft-server-map - accounts and history

Project: [[minecraft-server-map]]

## What was done
- Replaced the single shared password with player accounts, an admin password, ownership and co-owners, enforced on the server.
- Colours now come from ownership: one village green, each player's unique colour, and own colours only for Server places.
- Added a Players tab with a colour key and allies, My base, Move corners, Add expansion, Add place here, overlap warnings and coordinate pasting.
- Added World History: official and player documents, plus a chronicle generator.
- Migrated Logan's local database and kept all 5 of his places. Backup is in `backups/before-accounts-2026-11-02`.

## Key decisions
- Whole-history AI failed testing: SmolLM2 ignored the facts, and Qwen2.5-0.5B invented a player and misplaced a landmark. So code writes all facts, and AI writes one validated flavour sentence per place.
- AI runs on CPU (WASM), not WebGPU, because WebGPU only echoed the prompt on this machine. COOP/COEP headers enable threads, and a worker stops the page freezing.
- Tests run on their own database (`npm run dev:test`, port 8799), so they can't touch real data.

## Problems + fixes
- `_headers` is only read at Wrangler startup, so restart after changing it.

## Where to pick up next
1. Deploy to Cloudflare, then copy the local database across, because the online one starts empty.
2. Find out why Logan's recorded World Spawn (-782, -647) is about 900 blocks from the calculated (64, -192).
3. Run `/locate structure village` in game to test more predictions. Confirmed Village 1 is 34 blocks from its prediction, a good first sign.
