---
repo: https://github.com/Capadapp/northlight-site
visibility: private
status: active
created: 2026-10-25
---

# northlight-site

## What it is
Marketing website + business plan for **Northlight** (working name), an AI intake/receptionist SaaS for small–mid law firms: answers calls/texts/web chat 24/7, qualifies cases, books consults. Static HTML/CSS/JS, no build step, Apple-inspired design with an indigo→teal "aurora" identity. Local path: `C:\Users\logan\Desktop\northlight-site`.

## Goals
- Deploy to Cloudflare Pages + buy a domain (trademark-check the name first)
- Sign 25 "founding firms" by hand, then build the inbound engine (calculator, SEO/AEO blog, agency partners)
- Build the actual product: Retell/Vapi + Claude + Twilio + Stripe

## Decisions & lessons
- Niche chosen: **law firms** over home services, which is crowded (Avoca $1B, Jobber bundling at ~$29/mo).
- Pricing: Solo $297 / Growth $697 / Firm $1,497 per month; annual = 2 months free.
- All business data (prices, phone, email, nav, form endpoints) lives in `assets/js/config.js`; header/footer are custom elements in `components.js`; `<body data-root>` fixes relative links in sub-folders.
- No fake testimonials: the founding-firm program is the social proof instead.
- Gotchas: a `backdrop-filter` on the header breaks `position:fixed` children (the mobile menu moved outside the header); `.sr-only` inside an `overflow:auto` table needs `position:relative` on the scroller, or the page scrolls sideways on mobile.
- Git identity set per-repo: `Logan <140434863+Capadapp@users.noreply.github.com>` (no global identity on this PC).

## Log
- 2026-10-25 — Researched niches, built the full site framework (11 pages) + docs/BUSINESS-PLAN.md, verified in browser, pushed to new private repo Capadapp/northlight-site.
