import Combine
import Foundation
import LoGGer
import PRNDSSwiftUI

public enum AppFlow: Equatable {
    case onboarding
    case authorization
    case appTabs
}

@MainActor
public final class AppCoordinator: ObservableObject {
    @Published public private(set) var flow: AppFlow
    @Published public private(set) var userProfile: UserProfile?
    @Published public var selectedTab: AppTab = .matches

    public let tournamentListViewModel: TournamentListViewModel
    public let navigationStore: SwiftUINavigationStore<AppRoute, AppModalRoute>

    private let dependencies: AppDependencyContainer
    private let appLogger: ScopedLogger

    public init(dependencies: AppDependencyContainer = AppDependencyContainer()) {
        self.dependencies = dependencies
        self.appLogger = dependencies.logger.scoped(to: "App")
        self.tournamentListViewModel = TournamentListViewModel(repository: dependencies.tournamentRepository)
        self.navigationStore = SwiftUINavigationStore()
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

        let profile = UserProfile(
            id: userProfile?.id ?? UUID(),
            name: normalizedName,
            surname: normalizedSurname,
            gender: gender
        )
        dependencies.sessionStore.saveUserProfile(profile)
        userProfile = profile
    }

    public func resetAuthorization() {
        dependencies.sessionStore.clearUserProfile()
        userProfile = nil
        flow = .authorization
    }

    public func showTournamentDetails(id: TournamentSummary.ID) {
        selectedTab = .tournaments
        navigationStore.push(.details(id: id))
    }

    public func showCurrentProfile() {
        guard let userProfile else { return }
        navigationStore.push(.profile(userID: userProfile.id))
    }

    public func popToTournamentList() {
        navigationStore.popToRoot()
    }

    public func showSettings() {
        navigationStore.present(.settings)
    }

    public func showTournamentEditor(id: TournamentSummary.ID) {
        navigationStore.present(.editor(itemID: id))
    }

    public func dismissModal() {
        navigationStore.dismissModal()
    }
}
