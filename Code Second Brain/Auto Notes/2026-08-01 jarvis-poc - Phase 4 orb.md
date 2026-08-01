---
project: jarvis-poc
date: 2026-08-01
topic: Phase 4 — WPF desktop orb
---

# jarvis-poc — Phase 4: the orb

![[jarvis-orb-2026-08-01.png]]

## What was done
- Built the floating desktop orb as a **WPF** app (`src/Jarvis.Orb`, `net10.0-windows`) — a pure
  HTTP client of the brain (no project reference; talks over the API, which is the phone/cloud seam).
  - `OrbWindow` — frameless, transparent, always-on-top, no taskbar entry; a glowing radial-gradient
    orb (accent-colored) that's draggable, with a collapsible dark type/reply panel. Click the orb
    (or the global hotkey) to summon the type box; Enter sends; the reply shows with a
    `backend/model · tier` status line.
  - `App` — system-tray icon (summon / show-hide / quit) + global hotkeys via Win32 `RegisterHotKey`
    (`Ctrl+Alt+J` = type, `Ctrl+Alt+Space` reserved for voice in Phase 5).
  - `BrainClient` — calls `/chat` and records both turns to `/memory/message`.
  - `AppConfig` — appsettings.json + appsettings.Local.json (token) + `BRAIN_AUTH_TOKEN` env override.

## Why WPF (not Avalonia)
- WPF is the least-friction path on Windows for the orb's needs: transparency, always-on-top,
  tray, and *global* hotkeys. Avalonia's global-hotkey story is much more P/Invoke-heavy.
- The brain stays cross-platform (`net10.0`); only the orb is Windows. The future **phone** is its
  own separate client of the same brain API, so WPF here doesn't block cross-platform later.

## Problems + fixes
- WPF + WinForms (needed for the tray `NotifyIcon`) both in scope → `CS0104` name clashes
  (`Application`, `Color`, `ColorConverter`, `KeyEventArgs`). Fixed with explicit `using` aliases
  to the `System.Windows.*` types.

## Verification
- Full solution builds clean (3 projects). Orb launched without crashing (process alive, XAML parsed).
- **Screenshot-verified**: the orb renders bottom-right; a scripted interaction (click → type
  "Say hi in exactly five words" → Enter) returned **"Hello, I'm Jarvis, your assistant."** routed
  through the brain, status `ollama/llama3:latest · cheap` (cheap tier classified, cloud absent →
  fell back to local), rendered in the panel. See image above.

## Pick up next
- Phase 3 integrations: **local file search** is account-free and complements the long-term index
  ("have I done this before?" → actually find the file). Gmail/Calendar/Outlook need OAuth apps
  (Logan's ~15-min setup) — walk him through Google Cloud + Microsoft Entra.
- Orb polish for later (settings phase): autostart, desktop shortcut, in-app settings, streaming
  replies, click-outside-to-dismiss.
