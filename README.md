# Tennis Tournament iOS App

## What this project is
This repository contains an iOS application for managing tennis tournaments with classic rules.

## Stack
- SwiftUI
- MVVM + Coordinator navigation
- PRNDSwift `0.1.0-alpha.1` for typed stack and modal navigation state
- Domain layer in pure Swift
- Persistence (later): SwiftData/CoreData
- Tests: Swift Testing and XCTest (UI)

## Getting started
1. Open `/Users/nikolaychunikhin/TennisTournament/TennisTournament.xcworkspace` in Xcode.
2. Read agent and engineering rules in `/Users/nikolaychunikhin/TennisTournament/AGENTS.md`.
3. Read contribution policy in `/Users/nikolaychunikhin/TennisTournament/CONTRIBUTING.md`.
4. Read product/domain baseline in `/Users/nikolaychunikhin/TennisTournament/docs/overview.md`.
5. Use command playbooks in `/Users/nikolaychunikhin/TennisTournament/commands/` and skills in `/Users/nikolaychunikhin/TennisTournament/skills/`.

## Lint
This project uses SwiftLint with shared rules from `Ch-N30/ios-code-style`.

Install SwiftLint:

```sh
brew install swiftlint
```

Run lint:

```sh
swiftlint lint --config .swiftlint.yml
```

Apply safe autocorrections:

```sh
swiftlint --fix --config .swiftlint.yml
```

## MVP scope (draft)
- Tournament setup for common formats (groups + playoff)
- Match score tracking
- Standings and progression
- Deterministic tie-break behavior covered by unit tests

## Current architecture baseline
- `TennisTournament/` - app shell target
- `TennisTournamentPackage/Sources/TennisTournamentFeature/App/` - app coordinator and root composition
- `TennisTournamentPackage/Sources/TennisTournamentFeature/Core/` - domain, data contracts, dependency container
- `TennisTournamentPackage/Sources/TennisTournamentFeature/Features/` - feature screens and view models
- `TennisTournamentPackage/Tests/TennisTournamentFeatureTests/` - domain and feature unit tests

## Initial app flow
- Onboarding screen
- Authorization screen (surname + gender, local persistence)
- Main tabs: Matches, Tournaments, Profile
- PRNDS flow: Tournament list -> Details -> Profile -> Settings sheet
- Match setup and tournament setup screens are intentionally postponed

## Deep links

The application registers the `tennistournament` URL scheme for the integrated
tournament flow:

- `tennistournament://tournaments/<UUID>` opens tournament details.
- `tennistournament://tournaments/<UUID>/profile` opens details and then the current profile.
- `tennistournament://tournaments/<UUID>/edit` opens details and presents the editor.
- `tennistournament://settings` presents settings.

The in-memory sample tournaments use stable UUIDs ending in `0001` and `0002`.
Unknown schemes, paths, and tournament identifiers are ignored.

## Repo structure
- `/Users/nikolaychunikhin/TennisTournament/README.md` - onboarding and scope
- `/Users/nikolaychunikhin/TennisTournament/CONTRIBUTING.md` - branch/PR/review rules
- `/Users/nikolaychunikhin/TennisTournament/AGENTS.md` - coding agent rules
- `/Users/nikolaychunikhin/TennisTournament/requirements.toml` - repository constraints for agents
- `/Users/nikolaychunikhin/TennisTournament/.codex/config.toml` - project Codex config
- `/Users/nikolaychunikhin/TennisTournament/docs/overview.md` - product/domain overview
- `/Users/nikolaychunikhin/TennisTournament/docs/specs/` - feature and architecture specs
- `/Users/nikolaychunikhin/TennisTournament/commands/` - command playbooks for typical tasks
- `/Users/nikolaychunikhin/TennisTournament/skills/` - reusable execution skills
- `/Users/nikolaychunikhin/TennisTournament/.github/workflows/ci.yml` - baseline CI
