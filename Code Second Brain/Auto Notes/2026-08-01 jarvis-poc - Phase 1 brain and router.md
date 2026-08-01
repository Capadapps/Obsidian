---
project: jarvis-poc
date: 2026-08-01
topic: Phase 1 — brain service + model router
---

# jarvis-poc — Phase 1: brain service + model router

## What was done
- Planned the whole assistant (see the approved plan at
  `C:\Users\logan\.claude\plans\hello-claude-can-you-compiled-naur.md`) and scaffolded the project
  at `C:\Users\logan\Projects\jarvis-poc`.
- Built and **verified** Phase 1:
  - `brain/config.py` — loads `config.toml` + `.env`.
  - `brain/models/` — provider-agnostic `ModelBackend` interface, `ClaudeBackend` (Anthropic SDK),
    `OllamaBackend` (local), and a `Router` that classifies a request into a tier
    (local/cheap/default/heavy) and dispatches to the right backend+model.
  - `brain/app.py` — FastAPI service with `/health`, `/chat`, `/ws`, bearer-token auth.
  - `scripts/smoke_test.py` — classification + live-generation check.

## Key decisions
- Everything tunable lives in `config.toml`; secrets in `.env`. Tier→model mapping is config-driven
  so behavior is tuned without touching code.
- The localhost API requires an auth token even now, so the future phone/cloud "over the network"
  case is already handled — that API boundary is the seam.
- Router **falls back to the local model** if a cloud tier is picked but no key/network.

## Problems + fixes
- Guessed local model `llama3.1:8b` in config → Ollama 404 (server up, model not pulled). Found
  `llama3:latest` + `noa:latest` installed; pointed config at `llama3:latest`.
- Smoke test crashed on that 404 → wrapped live generation in try/except so one backend failing
  doesn't abort the run.

## Verification
- `python -m scripts.smoke_test`: **classification 7/7**; local `llama3:latest` generated a reply
  via Ollama ("Hello! I'm here to assist."); cloud tier correctly skipped (no `ANTHROPIC_API_KEY`).
- All source files compile on Python 3.14; deps installed in `.venv`.

## Pick up next
- **User action needed:** add `ANTHROPIC_API_KEY` + a `BRAIN_AUTH_TOKEN` to `.env` to light up
  cloud tiers; later, create Google + Microsoft OAuth apps for integrations.
- **Phase 2 (no external deps):** Memory Manager — `recent-dialogue.md` rolling last-10 buffer,
  `working-memory.md`, `long-term.md` pointer index, and the distillation step. Wire it into `/chat`.
