# PRNDSwift Navigation Integration

## Context

The tournaments section needs one typed and testable SwiftUI navigation flow.
PRNDSwift `0.1.0-alpha.1` owns stack and modal state while the application keeps
route definitions, screen construction, deep-link parsing, Coordinator decisions,
MVVM state, and dependency injection.

## Scope

- Integrate only `PRNDSSwiftUI` at exact version `0.1.0-alpha.1`.
- Migrate the tournaments vertical slice:
  `Tournament list -> Details -> Profile -> Settings sheet`.
- Add an item-driven tournament editor sheet.
- Route supported custom URLs through `AppCoordinator`.
- Keep onboarding, authorization, Matches, and the standalone Profile tab unchanged.

## Acceptance Criteria

- `AppCoordinator` owns one `SwiftUINavigationStore<AppRoute, AppModalRoute>`.
- The tournaments `NavigationStack` binds to the PRNDS typed path.
- `AppRoute` supports tournament details and the current profile.
- `AppModalRoute` supports settings and tournament editor sheets.
- System Back and interactive sheet dismissal write state back through PRNDS bindings.
- Deep links replace the complete tournament path and reject missing tournament IDs.
- Valid deep links received before authorization are applied after authorization.
- The `tennistournament` URL scheme is present in the built application bundle.
- App build, unit tests, SwiftLint, and CI checks pass.

## Deep Links

- `tennistournament://tournaments/<UUID>`
- `tennistournament://tournaments/<UUID>/profile`
- `tennistournament://tournaments/<UUID>/edit`
- `tennistournament://settings`

The in-memory repository uses stable sample IDs ending in `0001` and `0002`, so
development deep links remain deterministic across launches.

## State and Ownership

- `AppCoordinator` owns selected tab, PRNDS store, modal presentation, and deep-link routing.
- `MainTabScreen` renders route-to-view mappings and binds SwiftUI containers to PRNDS.
- Feature screens receive closures and do not reference the coordinator or navigation store.
- `TournamentListViewModel` owns the current in-memory tournament list and editor updates.
- `UserProfile` has a persisted UUID used by the typed profile route. Legacy profiles without
  the UUID continue to decode and receive an identity on migration.

## Out of Scope

- Replacing onboarding or authorization navigation.
- Replacing navigation stacks in Matches or the standalone Profile tab.
- Tournament persistence; editor changes live only for the current app session.
- Universal links and Associated Domains.
- Custom transitions or multiple simultaneous modals.

## Tradeoffs

- PRNDSwift is an alpha dependency, so its public API can change before `1.0.0`.
- The existing `LoGGer` dependency remains branch-based and was not updated by this work.
- The editor remains in-memory until the persistence boundary is implemented.

## Test Plan

- Verify stack push and pop-to-root state through `AppCoordinator`.
- Verify settings/editor presentation and dismissal.
- Verify every supported and malformed URL shape.
- Verify deep-link path replacement, deferred authorization, and missing-ID rejection.
- Verify legacy profile decoding and tournament editing without identity changes.
