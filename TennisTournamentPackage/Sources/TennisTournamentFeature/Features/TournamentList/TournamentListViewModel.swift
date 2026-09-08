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

    public func updateTournament(id: TournamentSummary.ID, name: String, format: String) {
        guard let index = tournaments.firstIndex(where: { $0.id == id }) else { return }
        tournaments[index] = TournamentSummary(id: id, name: name, format: format)
    }
}
