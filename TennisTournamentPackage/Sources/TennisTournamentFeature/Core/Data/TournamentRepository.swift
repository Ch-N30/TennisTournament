import Foundation

public protocol TournamentRepository {
    func loadTournamentSummaries() -> [TournamentSummary]
}

public struct InMemoryTournamentRepository: TournamentRepository {
    public init() {}

    public func loadTournamentSummaries() -> [TournamentSummary] {
        [
            TournamentSummary(
                id: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)),
                name: "City Open",
                format: "Groups + Playoff"
            ),
            TournamentSummary(
                id: UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2)),
                name: "Weekend Cup",
                format: "Single Elimination"
            )
        ]
    }
}
