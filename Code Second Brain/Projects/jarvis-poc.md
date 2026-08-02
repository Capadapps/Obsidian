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
- 2026-08-01 — **Phase 2 done: Memory Manager** (`src/Jarvis.Brain/Memory/`). Three small markdown
  files: `recent-dialogue.md` (rolling last-10 buffer, oldest evicted), `long-term.md` (tiny
  summary→file-path pointer index with keyword search), `working-memory.md` (durable notes, pruned
  when large). `LlmMemoryCurator` distills durable facts from evicted messages + prunes, all on the
  **local model** (no API key). `/memory/*` endpoints added. Verified: **20/20** tests; live run held
  a 10-message window, persisted+searched a pointer, distilled "prefers VS Code" into working memory.
  API-key decision: sticking with an API key (subscription can't back a raw-API app; local model
  keeps the meter near zero) — Logan will add the key later.
- 2026-08-01 — **Phase 4 done: the orb** (`src/Jarvis.Orb`, WPF, `net10.0-windows`). Frameless
  transparent always-on-top glowing orb + type panel, global hotkeys (Ctrl+Alt+J), system tray,
  talks to the brain over HTTP, records to memory. Chose WPF over Avalonia for Windows-native
  transparency/tray/global-hotkeys; phone stays a separate future client. Screenshot-verified a full
  click→type→reply through the brain (see Phase 4 auto note).
- 2026-08-01 — **Phase 3 (part 1): local file search** (`src/Jarvis.Brain/Integrations/`). `IIntegration`
  interface + `LocalFileSearch` (searches Documents by default: filename + text content, prunes
  node_modules/.git, survives access-denied). `/integrations/files/search` endpoint; `/health` now
  reports integration availability. 25/25 tests; live search of Documents found the project's own
  vault notes. **Remaining Phase 3 (needs Logan's OAuth apps):** Gmail + Google Calendar (Google
  Cloud OAuth), Outlook mail (Microsoft Entra / Graph). That's the next build once the apps exist.
- 2026-08-02 — **Phase 5 done: local speech-to-text** (`src/Jarvis.Brain/Speech/`, `src/Jarvis.Orb/`).
  Our own Whisper agent on **Whisper.net** (C#-native whisper.cpp): brain hosts `POST /speech/transcribe`
  (WAV → text, model auto-downloaded to gitignored `data/models/`); orb captures the mic via **NAudio**
  and **Ctrl+Alt+Space** is real push-to-talk (toggle). Engine sits in the brain so a future phone client
  stays thin. Verified live: transcribed `jfk.wav` correctly (28 s first call incl. model download, 1.5 s
  cached, CPU base model). 28/28 tests. GPU = one-line runtime swap. Commit `22bdaf9`. See Phase 5 auto note.
- 2026-08-02 — **Phase 6 done: full app + settings** (`src/Jarvis.Orb/MainWindow.*`, `UserSettings`,
  `StartupManager`). Second surface on the same brain: dark chat UI (nav, message bubbles + model/tier
  badge, mic, live health dot) opened from tray/right-click-orb; hides to tray on close. Settings screen
  (name, accent + live preview, orb size, hotkeys, brain URL, launch-on-startup, desktop shortcut) saved
  to `%APPDATA%\Jarvis\settings.json` and **applied live** everywhere; the brain reads the same file for
  its persona name. Orb polish folded in (click-outside-dismiss, right-click-to-open, live re-accent).
  Clean build, 28/28 tests, app renders + reports `connected` (screenshot in Phase 6 auto note). Deferred:
  streaming replies. Commit `1b85727`.
- 2026-08-02 — **One-click launcher** (`Jarvis.cmd` + `run.ps1`): starts the brain, polls `/health` until
  it answers, then opens the app with `JARVIS_OPEN_APP=1` and stops the brain when the app exits. Also
  fixed the orb loading `appsettings.Local.json` (copied to output). Commit `24acaa5`.
