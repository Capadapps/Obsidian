---
project: "[[northlight-site]]"
date: 2026-10-25
---

# northlight-site: site framework and business plan

## What was done
- Researched the most profitable B2B AI SaaS niches. Picked **AI intake for law firms** (high value per client, documented missed-call pain, ethics moat). Runner-up: med spas.
- Built a static, Apple-inspired marketing site: home (animated phone-call hero, stats, bento, scroll story, ROI calculator, practice areas, guardrails, pricing, founding-firm program, FAQ), pricing, solutions, security, demo form, free calculator page, blog + template post, legal placeholders, 404.
- SEO/AEO: JSON-LD, sitemap, robots, `llms.txt`. Cloudflare/Netlify `_headers`.
- Wrote `README.md` (how to edit) and `docs/BUSINESS-PLAN.md` (research, pricing, unit economics, GTM, deployment, compliance, 90-day roadmap).
- Created private repo **Capadapp/northlight-site** and pushed.

## Key decisions
- No framework or build step. `config.js` is the single source of business data.
- Pricing $297 / $697 / $1,497 a month, flat with conversation caps, $0.90 overage.
- Honest social proof only (founding-firm program, cited stats).

## Problems + fixes
- `ol[class]` reset out-specified `.story` padding → wrapped the reset in `:where()`.
- Mobile menu was squashed by the header's `backdrop-filter` (it becomes the containing block for fixed children) → moved the menu outside `<header>`.
- The pricing table made the page 578px wide on phones because `.sr-only` cells escaped the scroller → `position:relative` on `.compare__scroll`.
- No global git identity → set it per-repo.

## Pick up next
- Trademark/domain → deploy on Cloudflare Pages → replace `example.com` → connect Formspree + Plausible.
- Verify the homepage stats against their primary sources. Make an OG image.
- Start building the MVP voice agent (Retell/Vapi + Claude + Twilio) for personal injury.
