import Foundation

public protocol TournamentRepository {
    func loadTournamentSummaries() -> [TournamentSummary]
}

public struct InMemoryTournamentRepository: TournamentRepository {
    public init() {}

    public func loadTournamentSummaries() -> [TournamentSummary] {
        [
            TournamentSummary(name: "City Open", format: "Groups + Playoff"),
            TournamentSummary(name: "Weekend Cup", format: "Single Elimination")
        ]
    }
}
