---
repo: https://github.com/Capadapp/jarvis-poc
visibility: private
status: active
created: 2026-08-01
language: C# / .NET 10
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
- 2026-08-01 — Project created; Phase 1 first built in Python (FastAPI), verified working.
- 2026-08-01 — **Switched primary language to C# / .NET 10** (Logan's call; simpler single-language
  stack for brain + UI + future phone). Ported Phase 1 to ASP.NET Core: `src/Jarvis.Brain` with
  bearer-auth brain API (`/health`, `/chat`, `/ws`) on :8756, provider-agnostic `ModelRouter` over
  `ClaudeBackend` (thin Anthropic REST wrapper) + `OllamaBackend`. Tier config in `appsettings.json`.
  Verified: clean build, **8/8** xUnit classification tests, live `/chat` returns a `llama3` reply,
  cloud tiers fall back to local without a key. VS Code workspace + project `CLAUDE.md` added.
- 2026-08-01 — **Git/GitHub set up**: private repo `Capadapp/jarvis-poc`, initial commit pushed.
  Going forward: commit + push after each meaningful step (recorded in project + global CLAUDE.md).
  Next: Phase 2 Memory Manager (3 files + distillation).
