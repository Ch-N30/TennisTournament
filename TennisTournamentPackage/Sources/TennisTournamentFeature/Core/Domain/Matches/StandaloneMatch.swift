import Foundation

public enum MatchSide: Int, Codable, CaseIterable, Sendable {
    case first, second
}

public struct MatchPoints: Codable, Equatable, Sendable {
    var first = 0
    var second = 0

    var title: String { "\(first):\(second)" }

    mutating func add(to side: MatchSide) {
        if side == .first { first += 1 } else { second += 1 }
    }
}

struct CompletedMatchSet: Codable, Equatable, Sendable {
    let games: MatchPoints
    let tieBreak: MatchPoints?
    let winner: MatchSide
}

enum MatchEvent: Codable, Equatable, Sendable {
    case game(MatchSide)
    case tieBreak(MatchPoints)
}

public enum MatchAction: Sendable {
    case game(MatchSide)
    case tieBreak(MatchPoints)
    case undo
}

struct MatchScore: Codable, Equatable, Sendable {
    var games = MatchPoints()
    var sets: [CompletedMatchSet] = []
    var winner: MatchSide?

    var needsTieBreak: Bool { winner == nil && games == MatchPoints(first: 6, second: 6) }

    mutating func apply(_ event: MatchEvent, format: MatchFormat) throws {
        guard winner == nil else { throw MatchRuleError.finished }
        switch event {
        case .game(let side):
            guard !needsTieBreak else { throw MatchRuleError.tieBreakRequired }
            games.add(to: side)
            if max(games.first, games.second) >= 6 && abs(games.first - games.second) >= 2 {
                finishSet(winner: side, tieBreak: nil, format: format)
            }
        case .tieBreak(let points):
            let high = max(points.first, points.second)
            let low = min(points.first, points.second)
            // Subtract only after nonnegative validation; even malformed Int input cannot overflow.
            guard needsTieBreak, low >= 0,
                  (high == 7 && low <= 5) || (low >= 6 && high - low == 2) else {
                throw MatchRuleError.invalidTieBreak
            }
            let side: MatchSide = points.first > points.second ? .first : .second
            games.add(to: side)
            finishSet(winner: side, tieBreak: points, format: format)
        }
    }

    private mutating func finishSet(winner side: MatchSide, tieBreak: MatchPoints?, format: MatchFormat) {
        sets.append(CompletedMatchSet(games: games, tieBreak: tieBreak, winner: side))
        if sets.filter({ $0.winner == side }).count == format.setsToWin {
            winner = side
        } else {
            games = MatchPoints()
        }
    }
}

public struct StandaloneMatch: Codable, Equatable, Identifiable, Sendable {
    public let id: UUID
    let createdAt: Date
    private(set) var updatedAt: Date
    private(set) var completedAt: Date?
    let configuration: MatchConfiguration
    private(set) var revision: Int
    private(set) var history: [MatchEvent]
    private(set) var score: MatchScore

    var isFinished: Bool { score.winner != nil }

    init(id: UUID = UUID(), configuration: MatchConfiguration, date: Date = Date()) throws {
        try configuration.validate()
        self.id = id
        self.configuration = configuration
        createdAt = date
        updatedAt = date
        revision = 0
        history = []
        score = MatchScore()
    }

    func applying(_ action: MatchAction, at date: Date = Date()) throws -> Self {
        var next = self
        switch action {
        case .undo:
            guard !next.history.isEmpty else { throw MatchRuleError.nothingToUndo }
            next.history.removeLast()
            next.score = try Self.replay(next.history, format: configuration.format)
        case .game(let side):
            try next.score.apply(.game(side), format: configuration.format)
            next.history.append(.game(side))
        case .tieBreak(let points):
            try next.score.apply(.tieBreak(points), format: configuration.format)
            next.history.append(.tieBreak(points))
        }
        guard revision < Int.max else { throw MatchRuleError.invalidHistory }
        next.revision += 1
        next.updatedAt = max(date, updatedAt)
        next.completedAt = next.isFinished ? next.updatedAt : nil
        return next
    }

    func validateStoredState() throws {
        try configuration.validate()
        guard revision >= history.count, createdAt <= updatedAt,
              (completedAt != nil) == isFinished,
              completedAt == nil || completedAt == updatedAt,
              try Self.replay(history, format: configuration.format) == score else {
            throw MatchRuleError.invalidHistory
        }
    }

    private static func replay(_ events: [MatchEvent], format: MatchFormat) throws -> MatchScore {
        var score = MatchScore()
        for event in events { try score.apply(event, format: format) }
        return score
    }
}
