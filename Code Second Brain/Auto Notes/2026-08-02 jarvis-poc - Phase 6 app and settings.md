---
project: jarvis-poc
phase: 6
date: 2026-08-02
tags: [jarvis-poc, wpf, ui, settings]
---

# jarvis-poc — Phase 6: full app window + settings

![[jarvis-app-2026-08-02.png]]

## What was done
A second surface on the same brain — a proper **chat + settings app** alongside the orb.

- **`MainWindow` (WPF)** — clean dark UI: left nav (**Chat** / **Settings**), chat as message bubbles
  with a per-reply `backend/model · tier` badge, mic + input + Send, and a live **health dot**
  (`● connected` / `● brain offline`). Opens from the **tray** ("Open Jarvis") or by **right-clicking
  the orb**. Closing **hides to tray**; the app only quits from the tray's Quit.
- **Voice works in the app too** — its own `AudioRecorder`, toggle mic button, same transcribe path.
- **Settings screen** (live-applied + persisted): assistant **name**, **accent** colour (swatches +
  live preview across the whole UI), **orb size** (slider), **type/talk hotkeys**, **brain URL**,
  **launch-on-startup**, and a **Create desktop shortcut** button.

## Key decisions
- **One app, two surfaces** (orb + full window) sharing one `BrainClient` — the plan's model. The app
  is just another client of the brain API, same as the orb.
- **Settings persistence = `%APPDATA%\Jarvis\settings.json`** (`UserSettings`), overlaying the shipped
  `appsettings.json`. **Secrets never go there** — the auth token stays in `appsettings.Local.json` /
  `BRAIN_AUTH_TOKEN`. The **brain reads the same file** so its persona uses the chosen name (takes
  effect on the brain's next restart; the client UI updates instantly).
- **Live apply on Save**: accent (via a `DynamicResource` swap), name, orb size, re-registered hotkeys
  (`GlobalHotkeys.Clear()` + re-register), re-pointed `BrainClient.Configure(url, token)`, tray
  icon/text, and the HKCU **Run** key. No restart needed for the client side.
- **Startup + shortcut** in `StartupManager`: HKCU `...\Run` entry, and a desktop `.lnk` created via the
  Windows Script Host COM object (late-bound, no COM reference).
- **Orb polish folded in**: click-outside-to-dismiss (Deactivated collapses the panel), right-click to
  open the app, live `ApplyConfig`.
- **Deferred**: streaming replies (needs SSE/WS streaming through the router + backends) — noted, not
  built. TTS still optional/deferred from Phase 5.

## Problems + fixes
- WPF/WinForms type collisions again (`Brush`, `Cursors`, `HorizontalAlignment`) — fixed with explicit
  `using` aliases, same pattern as the orb.
- Couldn't script a chat *through the UI* for a screenshot: Windows foreground-lock kept the browser on
  top, so synthetic clicks/keys landed in Chrome, not the app. Not an app bug — the Send path is the
  same verified `BrainClient.ChatAsync`. Verified render + `connected` instead (screenshot above).

## Verification
- Clean build (**0 warnings**), **28/28** tests.
- App launches, renders the dark chat UI, and reports **● connected** to the brain (health OK).
- A dev convenience: set `JARVIS_OPEN_APP=1` to auto-open the window on launch.
- Commit `1b85727`, pushed to `Capadapp/jarvis-poc`.

## Pick up next
- **Logan to verify** the app live: tray → Open Jarvis; type/voice a message; open **Settings**, rename
  it + change the accent + Save (watch it apply live); toggle launch-on-startup; make a desktop shortcut.
- **Phase 7** — draft-and-notify autonomy (email reply drafting with approval) — needs the mail
  integrations, which need the OAuth apps.
- Still pending from **Phase 3**: Gmail / Calendar / Outlook providers (need Logan's OAuth apps).
- Optional polish: **streaming replies**, hold-to-talk, TTS.
