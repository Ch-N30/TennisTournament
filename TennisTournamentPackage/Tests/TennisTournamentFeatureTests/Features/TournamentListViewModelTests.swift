import Foundation
import Testing
@testable import TennisTournamentFeature

struct TournamentListViewModelTests {
    @Test("Loads tournaments from repository on init")
    func loadsTournamentsOnInit() {
        let expected = [
            TournamentSummary(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, name: "Test Open", format: "Groups + Playoff"),
            TournamentSummary(id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!, name: "Local Cup", format: "Single Elimination")
        ]

        let viewModel = TournamentListViewModel(repository: StubTournamentRepository(items: expected))

        #expect(viewModel.tournaments == expected)
    }

    @Test("Updates an existing tournament without changing its identity")
    func updatesTournament() {
        let id = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        let viewModel = TournamentListViewModel(
            repository: StubTournamentRepository(
                items: [TournamentSummary(id: id, name: "Old name", format: "Old format")]
            )
        )

        viewModel.updateTournament(id: id, name: "New name", format: "Groups + Playoff")

        #expect(viewModel.tournaments == [
            TournamentSummary(id: id, name: "New name", format: "Groups + Playoff")
        ])
    }
}

private struct StubTournamentRepository: TournamentRepository {
    let items: [TournamentSummary]

    func loadTournamentSummaries() -> [TournamentSummary] {
        items
    }
}
