import PRNDSSwiftUI
import SwiftUI

struct MatchesFlowView: View {
    @ObservedObject var coordinator: MatchesCoordinator
    @ObservedObject var navigationStore: SwiftUINavigationStore<MatchRoute, MatchModalRoute>
    let profile: UserProfile

    var body: some View {
        NavigationStack(path: navigationStore.pathBinding) {
            MatchesHomeScreen(
                viewModel: coordinator.listViewModel,
                onCreate: coordinator.showSetup,
                onSelect: coordinator.showMatch
            )
            .navigationDestination(for: MatchRoute.self) { route in
                switch route {
                case .setup:
                    if let viewModel = coordinator.setupViewModel {
                        MatchSetupScreen(viewModel: viewModel, profile: profile)
                    }
                case .match(let id):
                    if let viewModel = coordinator.matchViewModel, viewModel.match.id == id {
                        MatchScreen(viewModel: viewModel)
                    } else {
                        ContentUnavailableView("Матч не найден", systemImage: "exclamationmark.triangle")
                    }
                }
            }
        }
    }
}
