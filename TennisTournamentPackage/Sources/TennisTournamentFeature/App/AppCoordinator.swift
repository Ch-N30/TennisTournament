import Combine
import Foundation
import LoGGer

public enum AppFlow: Equatable {
    case onboarding
    case authorization
    case appTabs
}

@MainActor
public final class AppCoordinator: ObservableObject {
    @Published public private(set) var flow: AppFlow
    @Published public private(set) var userProfile: UserProfile?

    public let tournamentListViewModel: TournamentListViewModel

    private let dependencies: AppDependencyContainer
    private let appLogger: ScopedLogger

    public init(dependencies: AppDependencyContainer = AppDependencyContainer()) {
        self.dependencies = dependencies
        self.appLogger = dependencies.logger.scoped(to: "App")
        self.tournamentListViewModel = TournamentListViewModel(repository: dependencies.tournamentRepository)
        let profile = dependencies.sessionStore.loadUserProfile()
        self.userProfile = profile

        if !dependencies.sessionStore.hasCompletedOnboarding() {
            self.flow = .onboarding
        } else if profile == nil {
            self.flow = .authorization
        } else {
            self.flow = .appTabs
        }

        appLogger.debug(
            "App coordinator initialized",
            metadata: [
                "flow": String(describing: flow),
                "hasProfile": profile != nil
            ]
        )
    }

    public func completeOnboarding() {
        dependencies.sessionStore.setHasCompletedOnboarding(true)
        flow = dependencies.sessionStore.loadUserProfile() == nil ? .authorization : .appTabs
        if flow == .appTabs {
            userProfile = dependencies.sessionStore.loadUserProfile()
        }
    }

    public func completeAuthorization(surname: String, gender: UserGender) {
        let normalizedSurname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedSurname.isEmpty else {
            return
        }

        let profile = UserProfile(surname: normalizedSurname, gender: gender)
        dependencies.sessionStore.saveUserProfile(profile)
        userProfile = profile
        flow = .appTabs
    }

    public func resetAuthorization() {
        dependencies.sessionStore.clearUserProfile()
        userProfile = nil
        flow = .authorization
    }
}
