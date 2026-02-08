import Combine
import Foundation

public enum AppRoute: Hashable {
    case tournamentDetails(UUID)
    case createTournament
}

public final class AppCoordinator: ObservableObject {
    @Published public var path: [AppRoute] = []

    private let dependencies: AppDependencyContainer

    public lazy var tournamentListViewModel: TournamentListViewModel = {
        TournamentListViewModel(repository: dependencies.tournamentRepository)
    }()

    public init(dependencies: AppDependencyContainer = AppDependencyContainer()) {
        self.dependencies = dependencies
    }

    public func showCreateTournament() {
        path.append(.createTournament)
    }

    public func showTournamentDetails(id: UUID) {
        path.append(.tournamentDetails(id))
    }
}
