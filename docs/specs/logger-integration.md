# Logger Integration

## Context
The app needs a lightweight application logger for development diagnostics. The logger should be available through dependency injection and must not leak into tournament rules/domain code.

## Scope
- Add `LoGGer` as a Swift Package dependency for `TennisTournamentFeature`.
- Inject `LoGGer.Logger` through `AppDependencyContainer`.
- Enable console logging for focused development diagnostics.
- Add a startup diagnostic log point without logging personal user values.

## Acceptance Criteria
- App code can create a default `LoGGer.Logger` from `AppDependencyContainer`.
- Tests can inject `Logger {}` when they need silent logging.
- Domain rules remain independent from logging.
- Coordinator emits a startup diagnostic with the selected app flow and profile presence.
- Routine user actions such as tab selection, onboarding completion, authorization, and profile reset do not emit logs.

## Out of Scope
- Remote log transport.
- Persistent log files.
- Runtime log-level UI.
- Logging inside scoring, standings, or tie-break rules.

## Tradeoffs
The dependency is currently pinned to the `main` branch because the logger repository has no release tag yet. This is acceptable for testing the integration, but production should move to a version tag once one exists.
