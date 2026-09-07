import Foundation
import JustContainer
import LoGGer

public struct AppDependencyContainer {
    private var container: Container?
    public let tournamentRepository: any TournamentRepository
    public let standingsCalculator: any StandingsCalculating
    public let sessionStore: any AppSessionStoring
    public let logger: Logger

    @MainActor
    public static func makeLive() throws -> AppDependencyContainer {
        let container = Container()
        try container.register((any TournamentRepository).self) { _ -> any TournamentRepository in
            InMemoryTournamentRepository()
        }
        var dependencies = AppDependencyContainer(
            tournamentRepository: try container.resolve((any TournamentRepository).self)
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
