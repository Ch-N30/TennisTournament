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
                AuthScreen { surname, gender in
                    coordinator.completeAuthorization(surname: surname, gender: gender)
                }
            case .appTabs:
                if let profile = coordinator.userProfile {
                    MainTabScreen(
                        tournamentListViewModel: coordinator.tournamentListViewModel,
                        userProfile: profile,
                        onResetProfile: {
                            coordinator.resetAuthorization()
                        }
                    )
                } else {
                    ProgressView("Loading profile...")
                }
            }
        }
    }
}
