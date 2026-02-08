# Product and Domain Overview

## Goal
Deliver an iOS app to run tennis tournaments with classic rules, predictable scoring, and transparent progression.

## MVP tournament formats
- Group stage followed by playoff bracket
- Basic elimination progression from qualified participants
- Deterministic standings and tie resolution rules

## What "classic" means (MVP interpretation)
- Standard match score tracking by sets and games
- Tie-break support as configured by ruleset
- Standings based on wins/losses and tie-break criteria
- No custom/non-standard experimental formats in MVP

## Core entities
- `Tournament`: metadata, format, status, schedule boundaries
- `Participant`: player/team identity and eligibility
- `Match`: participants, score state, result, round/group linkage
- `Ruleset`: scoring and ranking rules (including tie-break behavior)

## Notes
- Persistence implementation is postponed until architecture and domain contracts stabilize.
- Detailed feature requirements belong in `docs/specs/*.md`.
