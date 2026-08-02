---
project: jarvis-poc
phase: 5
date: 2026-08-02
tags: [jarvis-poc, speech, whisper, stt]
---

# jarvis-poc — Phase 5: local speech-to-text

## What was done
Built our own lightweight, fully-local **speech-to-text agent** — no cloud, no Wispr Flow.

- **Brain (`src/Jarvis.Brain/Speech/WhisperSpeechService.cs`)** — built on **Whisper.net**
  (the C#-native whisper.cpp; single-language stand-in for Python's faster-whisper). Loads a ggml
  model, transcribes 16 kHz mono WAV → text. Model is **downloaded once on first use** into
  `data/models/` (gitignored).
- **Endpoint** `POST /speech/transcribe` (authed, raw WAV body → `{text}`). `/health` now reports
  `speech {enabled, model}`. Config lives in `appsettings.json` → `Speech` (`base` model default).
- **Orb (`src/Jarvis.Orb/AudioRecorder.cs`)** — captures the mic via **NAudio** at 16 kHz mono into
  an in-memory WAV. **Ctrl+Alt+Space** is now real push-to-talk (**toggle**: press to start, press
  again to stop + send). Transcript flows through the shared `SendAsync` path (same as typing).

## Key decisions
- **Whisper.net over faster-whisper.** faster-whisper is Python-only; we chose a single-language C#
  stack, and the project CLAUDE.md already committed to whisper.net. Same Whisper weights, all C#.
- **STT engine lives in the brain, not the orb.** The mic + hotkey are client-side, but the model
  sits on the "server" side of the API seam — so a future phone client just uploads audio and stays
  thin. Matches the plan's "Speech in the Brain" architecture.
- **Toggle push-to-talk, not hold.** `RegisterHotKey` only delivers key-down, not key-up, so
  hold-to-talk would need a low-level keyboard hook. Toggle is robust with one global hotkey; a
  hold-style refinement can come later.
- **CPU by default.** `Whisper.net.Runtime` (CPU) always works and is light ("don't waste
  resources"). GPU is a one-line swap: add `Whisper.net.Runtime.Cuda` (NVIDIA) or `.Vulkan`.

## Problems + fixes
- Voice path set `Input.Text` to the transcript but the shared send cleared it — moved `Input.Clear()`
  into the *typed* path only, so voice keeps the transcript visible in the box while the reply shows.

## Verification (end-to-end, live)
- Started the brain, POSTed the classic **`jfk.wav`** (16 kHz mono) to `/speech/transcribe`.
- First call downloaded the base model + transcribed in ~28 s; returned exactly:
  *"And so my fellow Americans, ask not what your country can do for you, ask what you can do for
  your country."*
- Second call (cached model) transcribed in **1.5 s** on CPU. `/health` flipped to `speech.model:true`.
- **28/28** unit tests pass (added 3 speech-service tests that don't need the model).
- Committed `22bdaf9`, pushed to `Capadapp/jarvis-poc`.

## Pick up next
- **Logan to verify** the orb voice flow with a real mic (Ctrl+Alt+Space → speak → press again).
- **Phase 6** — full app UI + settings (rename assistant, accent, autostart). Also fold in orb polish.
- Optional later: **TTS** (Piper) for spoken replies; **hold-to-talk** via a low-level keyboard hook;
  bigger Whisper model / GPU runtime if accuracy needs it.
- Still pending from Phase 3: Gmail / Calendar / Outlook providers (need Logan's OAuth apps).
