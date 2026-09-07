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
    public let matchesCoordinator: MatchesCoordinator
    public let navigationStore: SwiftUINavigationStore<AppRoute, AppModalRoute>

    private let dependencies: AppDependencyContainer
    private let appLogger: ScopedLogger
    private let deepLinkParser: AppDeepLinkParser
    private var pendingDeepLink: AppDeepLink?

    public init(
        dependencies: AppDependencyContainer = AppDependencyContainer(),
        deepLinkParser: AppDeepLinkParser = AppDeepLinkParser()
    ) {
        self.dependencies = dependencies
        self.appLogger = dependencies.logger.scoped(to: "App")
        self.deepLinkParser = deepLinkParser
        self.tournamentListViewModel = TournamentListViewModel(repository: dependencies.tournamentRepository)
        self.matchesCoordinator = MatchesCoordinator(repository: dependencies.matchRepository)
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
            openPendingDeepLinkIfPossible()
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
        openPendingDeepLinkIfPossible()
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
        navigationStore.popToRoot()
        navigationStore.dismissModal()
        matchesCoordinator.reset()
        userProfile = nil
        flow = .authorization
    }

    public func showTournamentDetails(id: TournamentSummary.ID) {
        selectedTab = .tournaments
        // Tournament entry points are paused for the standalone-match MVP.
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
        // Retained for the postponed tournament flow; no presentation in this MVP.
    }

    public func dismissModal() {
        navigationStore.dismissModal()
    }

    @discardableResult
    public func handleDeepLink(_ url: URL) -> Bool {
        guard let deepLink = deepLinkParser.parse(url) else { return false }
        guard case .settings = deepLink else { return false }

        guard flow == .appTabs else {
            pendingDeepLink = deepLink
            return true
        }

        return open(deepLink)
    }

    private func openPendingDeepLinkIfPossible() {
        guard let pendingDeepLink else { return }
        self.pendingDeepLink = nil
        _ = open(pendingDeepLink)
    }

    private func open(_ deepLink: AppDeepLink) -> Bool {
        switch deepLink {
        case .settings:
            navigationStore.present(.settings)
            return true
        case .tournamentDetails(let id):
            return openTournament(id: id, pathSuffix: [])
        case .tournamentProfile(let id):
            guard let userProfile else { return false }
            return openTournament(id: id, pathSuffix: [.profile(userID: userProfile.id)])
        case .tournamentEditor(let id):
            guard openTournament(id: id, pathSuffix: []) else { return false }
            navigationStore.present(.editor(itemID: id))
            return true
        }
    }

    private func openTournament(id: TournamentSummary.ID, pathSuffix: [AppRoute]) -> Bool {
        guard tournamentListViewModel.tournament(id: id) != nil else { return false }
        selectedTab = .tournaments
        navigationStore.dismissModal()
        navigationStore.setPath([.details(id: id)] + pathSuffix)
        return true
    }
}
