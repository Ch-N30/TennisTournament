import Foundation

public struct AppDependencyContainer {
    public let tournamentRepository: any TournamentRepository
    public let standingsCalculator: any StandingsCalculating

    public init(
        tournamentRepository: any TournamentRepository = InMemoryTournamentRepository(),
        standingsCalculator: any StandingsCalculating = ClassicStandingsCalculator()
    ) {
        self.tournamentRepository = tournamentRepository
        self.standingsCalculator = standingsCalculator
    }
}
