---
project: jarvis-poc
date: 2026-08-01
topic: Phase 2 — three-file Memory Manager + distillation
---

# jarvis-poc — Phase 2: Memory Manager

## What was done
- Built the three-file memory system in `src/Jarvis.Brain/Memory/` (C#/.NET 10):
  - **`RollingDialogueBuffer`** (`recent-dialogue.md`) — keeps only the last N (default 10)
    messages; the oldest is evicted on overflow and returned so it can be distilled first.
    Stored as readable markdown with HTML-comment delimiters carrying role + timestamp.
  - **`LongTermIndex`** (`long-term.md`) — a tiny pointer index (`summary :: path`) with keyword
    search. This is what "have I done this before?" searches; the real files stay on disk.
  - **`WorkingMemory`** (`working-memory.md`) — durable notes; condensed when it grows too big.
  - **`IMemoryCurator`** / `LlmMemoryCurator` — distills a durable fact from each evicted message
    and prunes working memory, using the **local model tier** (Ollama) so no API key is needed.
    `NoOpMemoryCurator` keeps the mechanical layer deterministic for tests.
  - **`MemoryManager`** — serialized orchestrator; `/memory/message|recent|working|longterm|search`
    endpoints on the brain (all bearer-auth'd, since it's personal data).

## Key decisions
- Raw dialogue is disposable (rolling 10); only distilled notes persist. Resolves the
  "store everything" vs "delete after 10" tension exactly as planned.
- Distillation/pruning run on the **local** model on purpose — private, free, offline.
- Memory files live in `data/memory/` (gitignored), resolved against the app content root.

## Problems + fixes
- Local model sometimes returns `NONE.` (trailing punctuation), which slipped past an exact-match
  `== "NONE"` check and wrote a junk note. Fixed with `IsEmptyOrSentinel` (letters-only compare);
  added 6 theory test cases for it.
- A shell-escaping mistake (backslashes in a Windows path) produced invalid JSON on the pointer
  POST during manual testing — not a code bug; clean paths persist + search fine.

## Verification
- `dotnet test`: **20/20** (8 router + 6 memory + 6 sentinel).
- Live: recorded 12 messages → exactly the last 10 survived (msgs 3–12); added + searched a
  long-term pointer; a durable message ("building Jarvis in C#, prefers VS Code") was distilled
  into `working-memory.md` after being pushed out of the window.

## Pick up next
- Phase 3 (integrations) needs Google + Microsoft OAuth apps → I'll walk Logan through those.
- OR jump to the orb UI (Avalonia) which is more visible/fun and needs no accounts.
- Cloud tiers still dark until Logan adds `ANTHROPIC_API_KEY` (local model works now).
