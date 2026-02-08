import Testing
@testable import TennisTournamentFeature

struct ClassicStandingsCalculatorTests {
    @Test("Sorts standings by wins, set difference, game difference")
    func sortsByClassicTieBreakOrder() {
        let calculator = ClassicStandingsCalculator()

        let standings = calculator.makeStandings(from: [
            ParticipantRecord(participantID: "Bravo", wins: 2, setsWon: 5, setsLost: 3, gamesWon: 40, gamesLost: 32),
            ParticipantRecord(participantID: "Alpha", wins: 3, setsWon: 6, setsLost: 2, gamesWon: 41, gamesLost: 29),
            ParticipantRecord(participantID: "Charlie", wins: 2, setsWon: 5, setsLost: 4, gamesWon: 39, gamesLost: 36)
        ])

        #expect(standings.map(\.participantID) == ["Alpha", "Bravo", "Charlie"])
    }

    @Test("Uses stable participant identifier as final fallback")
    func sortsByIdentifierWhenAllMetricsEqual() {
        let calculator = ClassicStandingsCalculator()

        let standings = calculator.makeStandings(from: [
            ParticipantRecord(participantID: "Zeta", wins: 2, setsWon: 4, setsLost: 2, gamesWon: 30, gamesLost: 20),
            ParticipantRecord(participantID: "Alpha", wins: 2, setsWon: 4, setsLost: 2, gamesWon: 30, gamesLost: 20)
        ])

        #expect(standings.map(\.participantID) == ["Alpha", "Zeta"])
    }
}
