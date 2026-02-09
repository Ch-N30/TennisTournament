import Foundation

public struct AppDependencyContainer {
    public let tournamentRepository: any TournamentRepository
    public let standingsCalculator: any StandingsCalculating
    public let sessionStore: any AppSessionStoring

    public init(
        tournamentRepository: any TournamentRepository = InMemoryTournamentRepository(),
        standingsCalculator: any StandingsCalculating = ClassicStandingsCalculator(),
        sessionStore: any AppSessionStoring = UserDefaultsAppSessionStore()
    ) {
        self.tournamentRepository = tournamentRepository
        self.standingsCalculator = standingsCalculator
        self.sessionStore = sessionStore
    }
}
