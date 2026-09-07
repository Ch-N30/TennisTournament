import SwiftUI

public struct AppRootView: View {
    @StateObject private var bootstrap: AppBootstrap

    public init() {
        _bootstrap = StateObject(wrappedValue: AppBootstrap())
    }

    public init(coordinator: AppCoordinator) {
        _bootstrap = StateObject(wrappedValue: AppBootstrap(coordinator: coordinator))
    }

    public var body: some View {
        if let coordinator = bootstrap.coordinator {
            AppFlowView(coordinator: coordinator)
        } else {
            ContentUnavailableView(
                "Unable to start",
                systemImage: "exclamationmark.triangle",
                description: Text("Application setup failed. Please restart the app.")
            )
        }
    }
}

private struct AppFlowView: View {
    @StateObject private var coordinator: AppCoordinator

    public init(coordinator: AppCoordinator = AppCoordinator()) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    public var body: some View {
        Group {
            switch coordinator.flow {
            case .onboarding:
                OnboardingScreen {
                    coordinator.completeOnboarding()
                }
            case .authorization:
                AuthScreen { name, surname, gender in
                    coordinator.completeAuthorization(name: name, surname: surname, gender: gender)
                }
            case .appTabs:
                if let profile = coordinator.userProfile {
                    MainTabScreen(
                        matchesCoordinator: coordinator.matchesCoordinator,
                        tournamentListViewModel: coordinator.tournamentListViewModel,
                        userProfile: profile,
                        selectedTab: $coordinator.selectedTab,
                        navigationStore: coordinator.navigationStore,
                        onUpdateProfile: { name, surname, gender in
                            coordinator.updateProfile(name: name, surname: surname, gender: gender)
                        },
                        onSelectTournament: coordinator.showTournamentDetails,
                        onShowProfile: coordinator.showCurrentProfile,
                        onPopToTournamentList: coordinator.popToTournamentList,
                        onShowSettings: coordinator.showSettings,
                        onShowTournamentEditor: coordinator.showTournamentEditor,
                        onDismissModal: coordinator.dismissModal
                    )
                } else {
                    ProgressView("Loading profile...")
                }
            }
        }
        .onOpenURL { url in
            coordinator.handleDeepLink(url)
        }
    }
}
