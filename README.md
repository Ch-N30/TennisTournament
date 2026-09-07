# Tennis Tournament iOS App

## What this project is
This repository contains an iOS application for managing tennis tournaments with classic rules.

## Stack
- SwiftUI
- MVVM + Coordinator navigation
- PRNDSwift `0.1.0-alpha.1` for typed stack and modal navigation state
- Domain layer in pure Swift
- Standalone match persistence: versioned local JSON behind a repository protocol
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

## Current MVP scope
- Standalone singles/doubles setup, completed-game scoring and tie-break results
- Persistent match history, resume and undo, with JustContainer dependency assembly
- Tournaments postponed behind «Скоро будет»; existing domain code retained
- This feature uses build-only verification by explicit user request; behavior needs manual acceptance

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
- Independent PRNDS match flow: Match list -> Setup -> Scoring/result
- Tournament setup remains postponed; profile functionality remains available
- JustContainer currently uses an absolute local package path; see
  `docs/specs/justcontainer-integration.md` before building on another machine or CI

## Deep links

The application registers the `tennistournament` URL scheme.
During the standalone-match MVP:

- `tennistournament://tournaments/<UUID>` and its `/profile` and `/edit` variants are disabled.
- `tennistournament://settings` presents settings.

Unknown schemes and paths are ignored. Tournament source code is retained for a later version.

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
