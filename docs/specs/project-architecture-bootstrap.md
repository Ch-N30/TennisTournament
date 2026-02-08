# Project Architecture Bootstrap

## Context
Architecture bootstrap for the first runnable app flow using MVVM and Coordinator.

## User stories
- As a first-time user, I see onboarding before entering the app.
- As a user, I provide surname and gender once and enter the app.
- As a user, I can access three core sections: Matches, Tournaments, Profile.
- As a developer, I can keep domain logic independent from UI frameworks.

## Acceptance criteria
- App starts with `AppRootView` and flow is controlled by `AppCoordinator`.
- Launch sequence is `Onboarding -> Authorization -> Tabs`.
- Authorization persists surname and gender locally.
- Tabs include exactly `Matches`, `Tournaments`, and `Profile`.
- Tournament setup and match setup screens are out of scope for this iteration.

## Edge cases
- Empty/whitespace surname cannot be submitted.
- If profile is cleared, app returns to authorization.
- Existing profile with completed onboarding opens tabs directly.

## Data model impact
- Added `UserProfile` and `UserGender`.
- Added `AppSessionStoring` with `UserDefaults` implementation.
- Preserved `TournamentSummary` and standings domain models.

## UI screens
- `OnboardingScreen`
- `AuthScreen`
- `MatchesHomeScreen`
- `TournamentsHomeScreen`
- `ProfileScreen`

## Test plan
- Unit tests for coordinator flow transitions.
- Unit tests for authorization input validation.
- Existing unit tests for standings ordering and tournament list loading remain active.

## TODO
- Define localization policy for onboarding/auth/profile copy.
- Define next specs for match setup and tournament setup flows.
