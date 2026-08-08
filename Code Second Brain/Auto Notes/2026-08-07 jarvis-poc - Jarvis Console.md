---
project: jarvis-poc
date: 2026-08-07
tags: [jarvis-poc, wpf, ui, design-handoff, rendering]
---

# jarvis-poc — the Jarvis Console

Built the full-screen console from `design_handoff_jarvis_console/` — a dot-cloud orb with twelve
summonable panels — as a third WPF surface on the same brain.

## What was done
- **Shell** (`Console/ConsoleWindow.xaml`): 52px header (health dot, name, build tag, brain/tier/clock),
  three-column main with scrolling rails either side of the orb, footer with twelve dock chips and a
  mic + command field. Opens from the tray ("Open console"); Esc hides it.
- **The orb** (`OrbRenderer` + `OrbView`): halo, 620-point Fibonacci dot sphere with amplitude-driven
  surface displacement, 90 orbiting motes, shock ring, and the orbit sweep — all the constants from the
  handoff's draw loop.
- **Twelve panels** as `DataTemplate`s keyed `PanelTemplate.<key>` in one resource dictionary, resolved
  by a `DataTemplateSelector`, all sharing a `PanelCard` shell that rises in on open.
- **Wiring**: mic → real `/speech/transcribe`, commands → real `/chat`, tier badge from the reply,
  health dot from `/health`, name + accent + brain URL from `AppConfig`.

## Key decisions
- **Split the orb across CPU and GPU.** Dots are rasterized by hand into a premultiplied BGRA buffer
  (WPF has no cheap primitive for ~740 anti-aliased sub-pixel sprites). The halo started out in the same
  loop and cost **a third of a core on its own** — it is one smooth full-canvas gradient, so it moved to
  a WPF `RadialGradientBrush`. Steady state went 33% → 18% of a core, visually identical.
- **Everything stops when hidden.** Render loop and both timers unhook on `IsVisible=false` — measured
  at exactly 0% CPU with the console constructed but not shown.
- **Twelve DataTemplates, not twelve UserControls.** Keeps the shared visual language in one file next
  to the tokens.
- **`TrackedText`** exists because WPF has no `letter-spacing`, and the design leans on it for every
  uppercase label. Per-character TextBlocks with a fixed margin — exact and font-independent, unlike
  padding with thin/hair spaces whose widths drift across the fallback chain.
- **Panel data stays placeholder**, as the handoff specifies. Live: transcript, orb mode, clock, tier,
  health, name, STT, replies.
- **Intent routing stays client-side** for now; the handoff wants it in the `/chat` response so every
  surface routes identically.

## Problems + fixes
- **A bug in the design's own regex table.** Intents are bare substrings, so `rain` matches inside
  "b**rain**" — "Open the brain log.", which is both a listed intent *and* one of the prototype's seven
  demo utterances, routed to **Weather**. Anchored every alternative to a word start (`\b`), which also
  kills `ram` matching "prog**ram**"/"f**ram**ework". Leading boundary only, so `temp` still matches
  "temperature".
- **WPF rejects a negative `BeginTime`** (CSS allows negative `animation-delay`). The mic bars' −0.4s /
  0s / −0.7s stagger became the equivalent positive phase inside the 0.7s cycle.
- **`CornerRadius="999"` is not `border-radius: 999px`.** CSS clamps to a pill; WPF took it literally and
  bulged the dock chips into ovals. Set to half the chip height.
- Rail views were null while the default-open panels were being set in the collection initializer —
  moved the opening to after the `CollectionViewSource`s exist.
- The usual WPF/WinForms type collisions (`Control`, `Size`, `Point`, `Color`, `Button`, `Orientation`,
  `Application`), fixed with aliases like the other windows.

## Verification
- Clean build, 0 warnings; **34/34** tests still pass.
- **Built a render harness** (scratchpad) that loads the window off-screen, renders it to PNG, and
  installs a listener on `PresentationTraceSources.DataBindingSource`. This solved the standing problem
  that the app isn't Start-menu registered so computer-use can't screenshot it — the console was
  inspected visually at 1600×900 in default, all-panels/listening, and remaining-panels/speaking states.
  **No binding errors** in any state.
- Intent table checked against 15 cases including the two traps: **15/15**.
- CPU measured on the real app: **18%** of one core visible, **0%** hidden.
- Commit `f5deebd`, pushed.

## Pick up next
- **Logan to eyeball it**: tray → Open console. Try "what's the weather", "open the brain log",
  Ctrl+Alt+V to talk.
- Deliberate deviations to accept or revisit: no `backdrop-filter` blur on cards (WPF has no equivalent;
  the translucent fill reads nearly the same), and **IBM Plex is not installed** — the font chains fall
  back to Segoe UI / Cascadia Mono. Installing IBM Plex Sans + Mono upgrades it with no code change.
- Wiring real panel data still needs the integrations blocked on the OAuth apps.
- Still open from before: llama3 hallucinating, `heavy` tier on `claude-opus-4-8`, no API key.
