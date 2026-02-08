# Project Architecture Bootstrap

## Context
Initial architecture bootstrap for the iOS app with MVVM plus Coordinator navigation.

## User stories
- As a developer, I can navigate from tournament list to creation and details placeholders.
- As a developer, I can implement domain rules in pure Swift without UI framework coupling.

## Acceptance criteria
- App starts with `AppRootView` powered by `AppCoordinator`.
- Navigation routes are centralized in coordinator.
- Tournament list uses `TournamentListViewModel` and repository abstraction.
- Domain standings calculator is pure Swift and unit-tested.

## Edge cases
- Tie in standings requires deterministic fallback ordering.
- Empty tournament list should still render safely.

## Data model impact
- Added `TournamentSummary` domain model.
- Added standings models: `ParticipantRecord` and `StandingsEntry`.

## UI screens
- `TournamentListScreen`
- `CreateTournamentScreen` (placeholder)
- `TournamentDetailsScreen` (placeholder)

## Test plan
- Unit tests for standings ordering and tie-break fallback.
- Unit test for list view model repository loading behavior.

## TODO
- Finalize tournament formats and tie-break policy in dedicated feature specs.
- Define persistence boundary after SwiftData/CoreData decision.
