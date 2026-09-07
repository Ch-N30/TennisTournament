# Product and Domain Overview

## Goal
Deliver an iOS app to run tennis tournaments with classic rules, predictable scoring, and transparent progression.

## Current MVP: standalone matches
- First tab: match history, unfinished matches first; creation with the top-right plus button.
- Singles and doubles; men's, women's and mixed doubles categories.
- Setup → game-by-game scoring → saved result, with persistent undo and resume.
- One set or best-of-three; a standard tie-break at 6:6 in every set.
- Local, device-wide storage; no cloud sync or account-specific match history yet.
- Tournaments tab shows «Скоро будет». Existing tournament code remains, but
  tournament entry points and deep links are disabled. Settings links remain active.
- See `specs/standalone-match.md` for rules, storage guarantees and manual acceptance.

## Later: tournament formats
- Group stage followed by playoff bracket.
- Basic elimination progression and deterministic standings.

## Match scoring boundaries
- Record completed games, not individual 15–30–40 points.
- Sets end at 6:0–6:4, 7:5 or 7:6 after a final tie-break score.
- No super tie-break, custom formats or tournament standings in this flow.

## Core entities
- `Tournament`: metadata, format, status, schedule boundaries
- `Participant`: player/team identity and eligibility
- `Match`: participants, score state, result, round/group linkage
- `Ruleset`: scoring and ranking rules (including tie-break behavior)

## Notes
- Match and tournament dependency assembly uses JustContainer in the composition root; see
  `specs/justcontainer-integration.md` for local-package and CI constraints.
- Standalone matches use an actor-owned, versioned JSON file in Application Support.
  Every action is persisted atomically before the ViewModel publishes the new score.
  Tournament persistence remains postponed.
- The match flow owns a separate PRNDS store and keeps the existing MVVM/Coordinator layout.
- This feature explicitly excludes test authoring and execution at the user's request.
  A successful simulator build establishes compilation only, not behavioral acceptance.
- Detailed feature requirements belong in `docs/specs/*.md`.
