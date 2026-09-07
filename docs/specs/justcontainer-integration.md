# JustContainer MVP integration

The live composition root uses JustContainer to resolve `any TournamentRepository`
and inject it into the existing AppCoordinator -> TournamentListViewModel ->
TournamentsHomeScreen flow. Existing initializer injection remains available for mocks.

AppBootstrap assembles dependencies once per root lifetime. AppDependencyContainer
retains the container. The stateless repository uses transient scope; no singleton
is needed. Factories perform synchronous construction only. Coordinator and UI are
created separately on MainActor. Assembly errors produce a startup error screen and
remain available in AppBootstrap for diagnostics; no fallback graph is constructed.

## Package reproducibility

The remote repository at revision `1a5de566f7a574349665c21af0baf3d73e87a5bf`
has its manifest under JustContainer/, not at the Git root. SwiftPM remote package
dependencies cannot select this subdirectory. This MVP therefore uses the existing
local package at `/Users/nikolaychunikhin/Desktop/swift/JustDoIt/JustContainer`.
No library source files are copied or modified. Local dependencies have no lock-file
revision; this path must exist on the machine building the app.

For GitHub/CI reproducibility, publish a root-manifest package, pin its verified
commit in the application manifest, and provide CI read access to the private repo.
The current absolute local path is not portable and will not work on hosted CI.
Existing private PRNDS access also remains a separate CI prerequisite.

Swift 6.1+ is required; the local compiler is 6.3.3. The application's iOS 18.2
deployment target and package's iOS 18 target are unchanged.

## Verification

- Xcode workspace build and 23 unit tests passed on iPhone 17 Pro / iOS 26.5.
- Tests include live graph assembly and propagation of an assembly failure.
- SwiftLint strict: zero violations; no new concurrency diagnostics in the final build.
- Maestro launch -> Tournaments -> City Open details passed with the new build.
- Hosted CI was not run: the local dependency requires the preparation above.
