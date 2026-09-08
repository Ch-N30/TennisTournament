import Foundation
import LoGGer
import Testing
@testable import TennisTournamentFeature

@MainActor
struct AppCoordinatorTests {
    @Test("Starts with onboarding when app is launched first time")
    func startsWithOnboardingForFirstLaunch() {
        let store = InMemoryAppSessionStore(onboardingCompleted: false, profile: nil)
        let dependencies = AppDependencyContainer(sessionStore: store, logger: Logger {})

        let coordinator = AppCoordinator(dependencies: dependencies)

        #expect(coordinator.flow == .onboarding)
    }

    @Test("Moves to authorization after onboarding when profile is missing")
    func movesToAuthorizationAfterOnboarding() {
        let store = InMemoryAppSessionStore(onboardingCompleted: false, profile: nil)
        let dependencies = AppDependencyContainer(sessionStore: store, logger: Logger {})

        let coordinator = AppCoordinator(dependencies: dependencies)
        coordinator.completeOnboarding()

        #expect(coordinator.flow == .authorization)
        #expect(store.onboardingCompleted == true)
    }

    @Test("Stores profile and opens app tabs after authorization")
    func storesProfileAndOpensTabsAfterAuthorization() {
        let store = InMemoryAppSessionStore(onboardingCompleted: true, profile: nil)
        let dependencies = AppDependencyContainer(sessionStore: store, logger: Logger {})

        let coordinator = AppCoordinator(dependencies: dependencies)
        coordinator.completeAuthorization(name: " Novak ", surname: " Djokovic ", gender: .male)

        #expect(coordinator.flow == .appTabs)
        #expect(coordinator.userProfile?.name == "Novak")
        #expect(coordinator.userProfile?.surname == "Djokovic")
        #expect(coordinator.userProfile?.gender == .male)
        #expect(store.profile == coordinator.userProfile)
    }

    @Test("Starts directly in tabs when onboarding and profile exist")
    func startsDirectlyInTabsWhenSessionIsReady() {
        let profile = UserProfile(name: "Rafael", surname: "Nadal", gender: .male)
        let store = InMemoryAppSessionStore(onboardingCompleted: true, profile: profile)
        let dependencies = AppDependencyContainer(sessionStore: store, logger: Logger {})

        let coordinator = AppCoordinator(dependencies: dependencies)

        #expect(coordinator.flow == .appTabs)
        #expect(coordinator.userProfile == profile)
    }

    @Test("Updates profile without leaving app tabs")
    func updatesProfileWithoutAuthorizationFlow() {
        let initialProfile = UserProfile(name: "Rafael", surname: "Nadal", gender: .male)
        let store = InMemoryAppSessionStore(onboardingCompleted: true, profile: initialProfile)
        let dependencies = AppDependencyContainer(sessionStore: store)

        let coordinator = AppCoordinator(dependencies: dependencies)
        coordinator.updateProfile(name: " Carlos ", surname: " Alcaraz ", gender: .male)

        #expect(coordinator.flow == .appTabs)
        #expect(coordinator.userProfile?.id == initialProfile.id)
        #expect(coordinator.userProfile?.name == "Carlos")
        #expect(coordinator.userProfile?.surname == "Alcaraz")
        #expect(coordinator.userProfile?.gender == .male)
        #expect(store.profile == coordinator.userProfile)
    }

    @Test("Builds the tournament stack with typed PRNDS routes")
    func buildsTournamentStack() throws {
        let coordinator = makeReadyCoordinator()
        let tournamentID = try #require(coordinator.tournamentListViewModel.tournaments.first?.id)
        let userID = try #require(coordinator.userProfile?.id)

        coordinator.showTournamentDetails(id: tournamentID)
        coordinator.showCurrentProfile()

        #expect(coordinator.selectedTab == .tournaments)
        #expect(coordinator.navigationStore.path == [
            .details(id: tournamentID),
            .profile(userID: userID)
        ])

        coordinator.popToTournamentList()
        #expect(coordinator.navigationStore.path.isEmpty)
    }

    @Test("Presents and dismisses typed modal routes")
    func presentsAndDismissesModals() throws {
        let coordinator = makeReadyCoordinator()
        let tournamentID = try #require(coordinator.tournamentListViewModel.tournaments.first?.id)

        coordinator.showSettings()
        #expect(coordinator.navigationStore.presentedModal == .settings)

        coordinator.showTournamentEditor(id: tournamentID)
        #expect(coordinator.navigationStore.presentedModal == .editor(itemID: tournamentID))

        coordinator.dismissModal()
        #expect(coordinator.navigationStore.presentedModal == nil)
    }

    @Test("Deep link replaces the complete tournament path")
    func opensTournamentProfileDeepLink() throws {
        let coordinator = makeReadyCoordinator()
        let tournamentID = try #require(coordinator.tournamentListViewModel.tournaments.first?.id)
        let userID = try #require(coordinator.userProfile?.id)
        coordinator.navigationStore.setPath([.details(id: UUID())])
        let url = try #require(URL(string: "tennistournament://tournaments/\(tournamentID)/profile"))

        let handled = coordinator.handleDeepLink(url)

        #expect(handled)
        #expect(coordinator.selectedTab == .tournaments)
        #expect(coordinator.navigationStore.path == [
            .details(id: tournamentID),
            .profile(userID: userID)
        ])
    }

    @Test("Defers a valid deep link until authorization completes")
    func defersDeepLinkUntilAuthorization() throws {
        let tournament = TournamentSummary(
            id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
            name: "Test Open",
            format: "Groups + Playoff"
        )
        let store = InMemoryAppSessionStore(onboardingCompleted: false, profile: nil)
        let dependencies = AppDependencyContainer(
            tournamentRepository: StubTournamentRepository(items: [tournament]),
            sessionStore: store,
            logger: Logger {}
        )
        let coordinator = AppCoordinator(dependencies: dependencies)
        let url = try #require(URL(string: "tennistournament://tournaments/\(tournament.id)"))

        #expect(coordinator.handleDeepLink(url))
        #expect(coordinator.navigationStore.path.isEmpty)

        coordinator.completeOnboarding()
        #expect(coordinator.navigationStore.path.isEmpty)

        coordinator.completeAuthorization(name: "Novak", surname: "Djokovic", gender: .male)
        #expect(coordinator.navigationStore.path == [.details(id: tournament.id)])
    }

    @Test("Rejects deep links to missing tournaments without changing navigation")
    func rejectsMissingTournamentDeepLink() throws {
        let coordinator = makeReadyCoordinator()
        let url = try #require(URL(string: "tennistournament://tournaments/\(UUID())"))

        #expect(coordinator.handleDeepLink(url) == false)
        #expect(coordinator.navigationStore.path.isEmpty)
        #expect(coordinator.navigationStore.presentedModal == nil)
    }

    @Test("Opens settings from a deep link")
    func opensSettingsDeepLink() throws {
        let coordinator = makeReadyCoordinator()
        let url = try #require(URL(string: "tennistournament://settings"))

        #expect(coordinator.handleDeepLink(url))
        #expect(coordinator.navigationStore.presentedModal == .settings)
    }
}

@MainActor
private func makeReadyCoordinator() -> AppCoordinator {
    let profile = UserProfile(name: "Rafael", surname: "Nadal", gender: .male)
    let store = InMemoryAppSessionStore(onboardingCompleted: true, profile: profile)
    let dependencies = AppDependencyContainer(sessionStore: store, logger: Logger {})
    return AppCoordinator(dependencies: dependencies)
}

private final class InMemoryAppSessionStore: AppSessionStoring {
    var onboardingCompleted: Bool
    var profile: UserProfile?

    init(onboardingCompleted: Bool, profile: UserProfile?) {
        self.onboardingCompleted = onboardingCompleted
        self.profile = profile
    }

    func hasCompletedOnboarding() -> Bool {
        onboardingCompleted
    }

    func setHasCompletedOnboarding(_ value: Bool) {
        onboardingCompleted = value
    }

    func loadUserProfile() -> UserProfile? {
        profile
    }

    func saveUserProfile(_ profile: UserProfile) {
        self.profile = profile
    }

    func clearUserProfile() {
        profile = nil
    }
}

private struct StubTournamentRepository: TournamentRepository {
    let items: [TournamentSummary]

    func loadTournamentSummaries() -> [TournamentSummary] {
        items
    }
}
