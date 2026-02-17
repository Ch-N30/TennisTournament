import Combine
import Foundation

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

    public init(dependencies: AppDependencyContainer = AppDependencyContainer()) {
        self.dependencies = dependencies
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
    }

    public func completeOnboarding() {
        dependencies.sessionStore.setHasCompletedOnboarding(true)
        flow = dependencies.sessionStore.loadUserProfile() == nil ? .authorization : .appTabs
        if flow == .appTabs {
            userProfile = dependencies.sessionStore.loadUserProfile()
        }
    }

    public func completeAuthorization(name: String, surname: String, gender: UserGender) {
        let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedSurname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedName.isEmpty, !normalizedSurname.isEmpty else {
            return
        }

        let profile = UserProfile(name: normalizedName, surname: normalizedSurname, gender: gender)
        dependencies.sessionStore.saveUserProfile(profile)
        userProfile = profile
        flow = .appTabs
    }

    public func updateProfile(name: String, surname: String, gender: UserGender) {
        let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedSurname = surname.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedName.isEmpty, !normalizedSurname.isEmpty else {
            return
        }

        let profile = UserProfile(name: normalizedName, surname: normalizedSurname, gender: gender)
        dependencies.sessionStore.saveUserProfile(profile)
        userProfile = profile
    }

    public func resetAuthorization() {
        dependencies.sessionStore.clearUserProfile()
        userProfile = nil
        flow = .authorization
    }
}
