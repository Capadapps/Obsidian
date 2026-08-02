---
project: jarvis-poc
date: 2026-08-02
tags: [jarvis-poc, wpf, hotkeys, ux, persistence]
---

# jarvis-poc — talk hotkey, live rename, saved chats

Three papercuts from Logan's first real use of the app, fixed in one pass.

## What was done

**1. Push-to-talk moved to `Ctrl+Alt+V`** (was `Ctrl+Alt+Space`). Claude's desktop app registers that
combo first and Windows gives a hotkey to whoever asked first, so ours silently never fired.
`AppConfig.Load` migrates anyone still holding the old combo in `settings.json` and rewrites the file.
Also: `RegisterHotKey` returning false was being ignored, so a stolen combo looked identical to a
working one — `App.RegisterHotkeys` now collects failures and `MainWindow.ReportHotkeyFailures` shows
them in Settings ("another app already owns it").

**2. The assistant's name is read live.** The brain read `%APPDATA%\Jarvis\settings.json` once at
startup, so renaming it to **NoA** in the app did nothing until the next restart. New
`UserSettingsFile` (brain side) re-reads the file whenever its timestamp/size changes and keeps the
last good value if it catches a mid-write; `AssistantOptions.ResolvedName` / `PersonaResolved` go
through it, and `/health` reports it.

**3. Saved chats.** `ChatStore` (orb/app side) keeps one JSON file per conversation in
`%APPDATA%\Jarvis\chats\`. The app grew a sidebar: **+ New chat**, a list of saved chats (title +
"N messages · when"), click to reopen, right-click → delete, and a click-to-rename title above the
transcript. Chats auto-title from their first message. Each send carries that chat's **last 20 turns**
to `/chat`, so reopening a chat resumes its thread instead of starting cold.

## Key decisions
- **Chats live on the client, not in the brain.** A chat is a UI artifact — a transcript you scroll.
  The brain's three memory files stay the distilled long-term layer they were designed as; mixing
  archives into them would undo Phase 2's point.
- **History is capped at 20 turns per request** — enough to hold a thread, bounded so an old chat
  doesn't grow the prompt forever. Note this pushes longer chats over the router's
  `LargeContextChars` (6000) into the heavy tier, which is arguably right but worth watching.
- **A chat only hits disk once it has a message** — no litter of empty "New chat" files.
- **The orb's quick panel stays single-shot** and unsaved; it's the "ask and go" surface. Folding it
  into the active chat is a possible follow-up.
- Corrupt chat files are skipped rather than taking down the whole list.

## Verification
- Clean build (0 warnings), **34/34** tests (was 28 — 6 new around live rename, including
  malformed-file and fallback cases).
- Live: restarted the brain → `/health` reported **NoA**. Renamed the settings file underneath the
  *running* brain → `/health` immediately reported the new name, then restored (this is the actual fix).
- Launched the app → it migrated `hotkeyTalk` to `Ctrl+Alt+V` in `settings.json` on startup and stayed
  running (so the new XAML parses and the sidebar builds).
- `ChatStore` exercised through a throwaway harness against a temp dir: 13/13 — empty chat not
  written, auto-title, truncation, reload keeps transcript + model badge, rename persists, ordering,
  corrupt file skipped, delete.
- **Not verified by clicking**: the app isn't Start-menu registered, so computer-use couldn't be
  granted access to screenshot it. The UI itself needs Logan's eyes.
- Commits `dd9ae71`, `2fb3492`, pushed.

## Pick up next
- **Logan to click through**: new chat → send → reopen it later; rename; delete; and confirm
  Ctrl+Alt+V talks.
- Still open from the research pass: **llama3 hallucinating** mail/calendar data it has no integration
  for (invented "12 unread emails"), the **`heavy` tier pointing at `claude-opus-4-8`** (current is
  `claude-opus-5`), and **no API key** so every cloud tier falls back to local.
- Phase 3 remainder (Gmail / Calendar / Outlook) and Phase 7 autonomy still need the OAuth apps.
