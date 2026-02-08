# App Entry Flow with Tabs

## Context
Initial user journey for the app startup and access gates.

## User stories
- As a first-time user, I must see onboarding before entering the app.
- As a user, I must provide surname and gender once to access the app.
- As an authorized user, I must access the app through three tabs: Matches, Tournaments, Profile.

## Acceptance criteria
- Startup flow is `Onboarding -> Authorization -> App Tabs`.
- Authorization stores `surname` and `gender` locally.
- Tabs are visible only after authorization completes.
- Tabs include exactly: Matches, Tournaments, Profile.
- Tournaments tab may show list/placeholder without tournament setup flow.

## Edge cases
- Empty or whitespace-only surname cannot be submitted.
- Onboarding can be completed only once per installation state.
- If profile is removed, app returns to authorization flow.

## Data model impact
- Added `UserProfile` and `UserGender` models.
- Added app session storage contract and `UserDefaults` implementation.

## UI screens
- `OnboardingScreen`
- `AuthScreen`
- `MatchesHomeScreen`
- `TournamentsHomeScreen`
- `ProfileScreen`

## Test plan
- Coordinator flow unit tests for first launch, post-onboarding, and ready session.
- Auth input validation unit tests for surname trimming and empty handling.

## TODO
- Define localization policy for profile field labels.
- Replace local profile storage with secured persistence if requirements change.
