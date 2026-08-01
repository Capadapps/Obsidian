---
repo: (local only for now — C:\Users\logan\Projects\jarvis-poc)
visibility: local
status: active
created: 2026-08-01
---

# jarvis-poc

## What it is
A local-first personal AI assistant (a "Jarvis"): a floating desktop **orb** + a full **app**,
driven by voice or text, powered by Claude with smart routing between a **local model** (Ollama)
and **cloud Claude** models. Reads personal Outlook/Gmail/Calendar + local files, keeps small
durable memory notes, and acts semi-autonomously (draft & notify).

Built local-only for now, but on hard seams so a **cloud backend** and a **phone client** bolt on
later without a rewrite. Full design: `C:\Users\logan\.claude\plans\hello-claude-can-you-compiled-naur.md`.

## Goals
- Daily/weekly task+mail summaries across personal accounts.
- "Have I done this before?" — search local files via a tiny pointer index.
- Voice (push-to-talk) + text, floating orb + full app, custom assistant name.
- Model router: cheap local for trivial/offline, cloud Claude (Haiku→Sonnet→Opus/Fable) for hard.

## Decisions & lessons
- **Three-tier architecture** with a localhost HTTP/WS brain API = the future network boundary.
- **Memory = 3 small files**: rolling last-10 dialogue buffer + `working-memory.md` + `long-term.md`
  (an index of pointers to real files, not copies). Raw chat disposable; distilled notes persist.
- **Autonomy = draft & notify** by default.
- A non-Claude local model does **not** share Claude's knowledge — only the *memory/context* is
  shared across models. Tiering is about cost/complexity, not a shared brain.
- No school accounts / Teams for now (avoids Microsoft admin-consent hurdles).

## Log
- 2026-08-01 — Project created. Phase 1 built + verified: FastAPI brain service (localhost,
  bearer-auth), provider-agnostic model router with Claude + Ollama backends. Router
  classification 7/7 on smoke test; local `llama3:latest` generates via Ollama; cloud tier
  falls back gracefully when no API key. Next: Phase 2 Memory Manager (3 files + distillation).
