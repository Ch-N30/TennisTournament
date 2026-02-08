# Tennis Tournament iOS App

## What this project is
This repository is the engineering base for an iOS app that manages tennis tournaments using classic tournament rules.

## Planned tech stack
- SwiftUI for UI
- Domain layer in pure Swift
- Persistence (later): SwiftData or CoreData
- Unit tests for rules and scoring logic

## Getting started
This repo is intentionally prepared before Xcode project scaffolding.

1. Clone and open this repository in your editor.
2. Read engineering rules in `AGENTS.md`.
3. Read contribution process in `CONTRIBUTING.md`.
4. Read product and domain baseline in `docs/overview.md`.
5. Use skills from `skills/` for feature specs, PR review, and bug triage.

## MVP scope (draft)
- Tournament setup for common formats (groups plus playoff bracket)
- Match score tracking
- Standings and bracket progression
- Deterministic tie-break handling (covered by tests)

## Repo structure
- `README.md` - project overview and onboarding
- `CONTRIBUTING.md` - branch, PR, and review rules
- `AGENTS.md` - rules for Codex and engineering agents
- `requirements.toml` - operational constraints for agents
- `.codex/config.toml` - project-level Codex config stub
- `docs/overview.md` - domain and MVP overview
- `docs/specs/` - feature specs produced by `feature-spec` skill
- `skills/feature-spec/` - feature specification skill
- `skills/pr-review/` - PR review skill
- `skills/bug-triage/` - bug triage skill
- `.github/workflows/ci.yml` - baseline CI checks
