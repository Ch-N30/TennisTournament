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
        #expect(coordinator.userProfile == UserProfile(name: "Novak", surname: "Djokovic", gender: .male))
        #expect(store.profile == UserProfile(name: "Novak", surname: "Djokovic", gender: .male))
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

        let expected = UserProfile(name: "Carlos", surname: "Alcaraz", gender: .male)
        #expect(coordinator.flow == .appTabs)
        #expect(coordinator.userProfile == expected)
        #expect(store.profile == expected)
    }
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
