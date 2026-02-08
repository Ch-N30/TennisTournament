import SwiftUI

public struct AppRootView: View {
    @StateObject private var coordinator: AppCoordinator

    public init(coordinator: AppCoordinator = AppCoordinator()) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            TournamentListScreen(
                viewModel: coordinator.tournamentListViewModel,
                onAddTournament: coordinator.showCreateTournament,
                onTournamentSelected: { tournament in
                    coordinator.showTournamentDetails(id: tournament.id)
                }
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .createTournament:
                    CreateTournamentScreen()
                case let .tournamentDetails(id):
                    TournamentDetailsScreen(tournamentID: id)
                }
            }
        }
    }
}
