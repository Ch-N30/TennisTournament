import Foundation
import LoGGer

public struct AppDependencyContainer {
    public let tournamentRepository: any TournamentRepository
    public let standingsCalculator: any StandingsCalculating
    public let sessionStore: any AppSessionStoring
    public let logger: Logger

    public static func makeDefaultLogger() -> Logger {
        Logger {
            ConsoleDestination()
                .withFormatter(PrettyFormatter(components: .full))
                .withFilter(LevelFilter(.debug))
        }
    }

    public init(
        tournamentRepository: any TournamentRepository = InMemoryTournamentRepository(),
        standingsCalculator: any StandingsCalculating = ClassicStandingsCalculator(),
        sessionStore: any AppSessionStoring = UserDefaultsAppSessionStore(),
        logger: Logger? = nil
    ) {
        self.tournamentRepository = tournamentRepository
        self.standingsCalculator = standingsCalculator
        self.sessionStore = sessionStore
        self.logger = logger ?? Self.makeDefaultLogger()
    }
}
