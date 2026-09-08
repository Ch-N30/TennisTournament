import Foundation

extension StandaloneMatch {
    func sideName(_ side: MatchSide) -> String {
        configuration.sides[side.rawValue].map(\.fullName).joined(separator: " / ")
    }

    var statusTitle: String { isFinished ? "Завершён" : "Идёт" }
    var categoryTitle: String { "\(configuration.kind.title) · \(configuration.category.title)" }
    var scoreTitle: String {
        var values = score.sets.map { set in
            set.games.title + (set.tieBreak.map { " (тай-брейк \($0.title))" } ?? "")
        }
        if !isFinished { values.append(score.games.title) }
        return values.joined(separator: "  ·  ")
    }
}
