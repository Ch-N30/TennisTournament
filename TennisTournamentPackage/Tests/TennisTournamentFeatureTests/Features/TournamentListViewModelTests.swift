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
}

private struct StubTournamentRepository: TournamentRepository {
    let items: [TournamentSummary]

    func loadTournamentSummaries() -> [TournamentSummary] {
        items
    }
}
