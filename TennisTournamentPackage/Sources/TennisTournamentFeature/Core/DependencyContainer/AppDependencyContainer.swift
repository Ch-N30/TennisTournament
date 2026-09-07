import Foundation
import JustContainer
import LoGGer

public struct AppDependencyContainer {
    private var container: Container?
    public let tournamentRepository: any TournamentRepository
    public let matchRepository: any MatchRepository
    public let standingsCalculator: any StandingsCalculating
    public let sessionStore: any AppSessionStoring
    public let logger: Logger

    @MainActor
    public static func makeLive() throws -> AppDependencyContainer {
        let container = Container()
        try container.register((any TournamentRepository).self) { _ -> any TournamentRepository in
            InMemoryTournamentRepository()
        }
        try container.register((any MatchRepository).self, scope: .singleton) { _ -> any MatchRepository in
            LocalMatchRepository()
        }
        var dependencies = AppDependencyContainer(
            tournamentRepository: try container.resolve((any TournamentRepository).self),
            matchRepository: try container.resolve((any MatchRepository).self)
        )
        dependencies.container = container
        return dependencies
    }

    public static func makeDefaultLogger() -> Logger {
        Logger {
            ConsoleDestination()
                .withFormatter(PrettyFormatter(components: .full))
                .withFilter(LevelFilter(.debug))
        }
    }

    public init(
        tournamentRepository: any TournamentRepository = InMemoryTournamentRepository(),
        matchRepository: any MatchRepository = LocalMatchRepository(),
        standingsCalculator: any StandingsCalculating = ClassicStandingsCalculator(),
        sessionStore: any AppSessionStoring = UserDefaultsAppSessionStore(),
        logger: Logger? = nil
    ) {
        self.tournamentRepository = tournamentRepository
        self.matchRepository = matchRepository
        self.standingsCalculator = standingsCalculator
        self.sessionStore = sessionStore
        self.logger = logger ?? Self.makeDefaultLogger()
    }
}
