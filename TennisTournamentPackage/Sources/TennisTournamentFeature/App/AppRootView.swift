import SwiftUI

public struct AppRootView: View {
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
                        tournamentListViewModel: coordinator.tournamentListViewModel,
                        userProfile: profile,
                        selectedTab: $coordinator.selectedTab,
                        navigationStore: coordinator.navigationStore,
                        onUpdateProfile: { name, surname, gender in
                            coordinator.updateProfile(name: name, surname: surname, gender: gender)
                        },
                        onSelectTournament: coordinator.showTournamentDetails,
                        onShowProfile: coordinator.showCurrentProfile,
                        onPopToTournamentList: coordinator.popToTournamentList
                    )
                } else {
                    ProgressView("Loading profile...")
                }
            }
        }
    }
}
