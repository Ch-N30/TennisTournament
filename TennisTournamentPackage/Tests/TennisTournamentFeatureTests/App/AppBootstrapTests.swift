import Testing
@testable import TennisTournamentFeature

@MainActor
struct AppBootstrapTests {
    @Test("Live container assembles the tournament scenario")
    func assemblesLiveGraph() throws {
        let dependencies = try AppDependencyContainer.makeLive()
        let coordinator = AppCoordinator(dependencies: dependencies)

        #expect(coordinator.tournamentListViewModel.tournaments == dependencies.tournamentRepository.loadTournamentSummaries())
        #expect(coordinator.tournamentListViewModel.tournaments.count == 2)
    }

    @Test("Assembly failure remains visible at the application boundary")
    func reportsAssemblyFailure() {
        let bootstrap = AppBootstrap { throw AssemblyFailure.expected }

        #expect(bootstrap.coordinator == nil)
        #expect(bootstrap.error as? AssemblyFailure == .expected)
    }

    private enum AssemblyFailure: Error {
        case expected
    }
}
