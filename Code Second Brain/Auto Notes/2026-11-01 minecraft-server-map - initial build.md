# 2026-11-01 minecraft-server-map - initial build

Project: [[minecraft-server-map]]

## What was done
- Generated a biome and terrain map from Bedrock seed 5954060426765304508, covering X/Z from -10,240 to 10,240.
- Predicted 401 villages using Bedrock's placement algorithm plus a biome check.
- Built the site: territories, houses, points of interest, village confirmation, coordinate grid and readout, search, edit history with restore, phone layout, shared password.
- 7 API tests pass, and the main flows were tested in the browser against a local server.

## Key decisions
- Cloudflare Pages + D1 for free hosting with shared data.
- One shared password for both viewing and editing, because the map shows where people's bases are.
- Villages stay "predicted" until someone confirms them in game.

## Problems + fixes
- 3 villages disagreed with Seeder. Cause: cubiomes doesn't know dappled forest (Bedrock 26.50). Added a climate rule, and the village lists then matched exactly.
- Stored XSS from Leaflet tooltips rendering names as HTML. Names now go in as DOM nodes.
- Predicted villages inside a territory couldn't be clicked. Moved them to a pane above territories.
- Added a `minecraft-map` entry to `Desktop\.claude\launch.json`, because previews read that file.

## Where to pick up next
1. Logan deploys: `wrangler login`, then the steps in the README.
2. Run `/locate structure village` in game near spawn and compare with the map. This is the first check against the real world.
3. Confirm the server runs Bedrock 26.50 or later. Older versions have no dappled forest, so a few villages and biomes would differ.

## Noticed
- The vault's git remote URL has a GitHub token stored in plain text. Worth rotating and moving to a credential helper.
