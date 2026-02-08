import Foundation

public struct ParticipantRecord: Hashable, Sendable {
    public let participantID: String
    public let wins: Int
    public let setsWon: Int
    public let setsLost: Int
    public let gamesWon: Int
    public let gamesLost: Int

    public init(
        participantID: String,
        wins: Int,
        setsWon: Int,
        setsLost: Int,
        gamesWon: Int,
        gamesLost: Int
    ) {
        self.participantID = participantID
        self.wins = wins
        self.setsWon = setsWon
        self.setsLost = setsLost
        self.gamesWon = gamesWon
        self.gamesLost = gamesLost
    }

    public var setDifference: Int { setsWon - setsLost }
    public var gameDifference: Int { gamesWon - gamesLost }
}

public struct StandingsEntry: Hashable, Sendable {
    public let participantID: String
    public let wins: Int
    public let setDifference: Int
    public let gameDifference: Int

    public init(participantID: String, wins: Int, setDifference: Int, gameDifference: Int) {
        self.participantID = participantID
        self.wins = wins
        self.setDifference = setDifference
        self.gameDifference = gameDifference
    }
}

public protocol StandingsCalculating {
    func makeStandings(from records: [ParticipantRecord]) -> [StandingsEntry]
}

public struct ClassicStandingsCalculator: StandingsCalculating {
    public init() {}

    public func makeStandings(from records: [ParticipantRecord]) -> [StandingsEntry] {
        records
            .sorted { lhs, rhs in
                if lhs.wins != rhs.wins {
                    return lhs.wins > rhs.wins
                }

                if lhs.setDifference != rhs.setDifference {
                    return lhs.setDifference > rhs.setDifference
                }

                if lhs.gameDifference != rhs.gameDifference {
                    return lhs.gameDifference > rhs.gameDifference
                }

                return lhs.participantID < rhs.participantID
            }
            .map {
                StandingsEntry(
                    participantID: $0.participantID,
                    wins: $0.wins,
                    setDifference: $0.setDifference,
                    gameDifference: $0.gameDifference
                )
            }
    }
}
