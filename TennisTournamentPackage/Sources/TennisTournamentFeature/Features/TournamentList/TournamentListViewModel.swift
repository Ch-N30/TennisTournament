import Combine
import Foundation

public final class TournamentListViewModel: ObservableObject {
    @Published public private(set) var tournaments: [TournamentSummary] = []

    private let repository: any TournamentRepository

    public init(repository: any TournamentRepository) {
        self.repository = repository
        loadTournaments()
    }

    public func loadTournaments() {
        tournaments = repository.loadTournamentSummaries()
    }

    public func tournament(id: TournamentSummary.ID) -> TournamentSummary? {
        tournaments.first { $0.id == id }
    }
}
