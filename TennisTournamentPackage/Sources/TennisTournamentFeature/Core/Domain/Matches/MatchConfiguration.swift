import Foundation

enum MatchKind: String, Codable, CaseIterable, Sendable {
    case singles, doubles

    var title: String { self == .singles ? "Одиночный · 1 на 1" : "Парный · 2 на 2" }
    var playersPerSide: Int { self == .singles ? 1 : 2 }
}

enum MatchCategory: String, Codable, CaseIterable, Sendable {
    case men, women, mixed

    var title: String {
        switch self {
        case .men: "Мужская"
        case .women: "Женская"
        case .mixed: "Микст"
        }
    }

    func gender(at position: Int) -> UserGender {
        self == .women || (self == .mixed && position == 1) ? .female : .male
    }
}

enum MatchFormat: String, Codable, CaseIterable, Sendable {
    case oneSet, bestOfThree, bestOfFive

    var title: String {
        switch self {
        case .oneSet: "Один сет"
        case .bestOfThree: "До двух выигранных сетов"
        case .bestOfFive: "До трёх выигранных сетов"
        }
    }

    var setsToWin: Int {
        switch self {
        case .oneSet: 1
        case .bestOfThree: 2
        case .bestOfFive: 3
        }
    }

    var maximumSets: Int { setsToWin * 2 - 1 }
    var setsCountTitle: String { self == .oneSet ? "1 сет" : "До \(maximumSets) сетов" }
}

struct MatchPlayer: Codable, Equatable, Identifiable, Sendable {
    let id: UUID
    let profileID: UUID?
    let name: String
    let surname: String
    let gender: UserGender

    var fullName: String { "\(name) \(surname)" }
}

struct MatchConfiguration: Codable, Equatable, Sendable {
    let kind: MatchKind
    let category: MatchCategory
    let format: MatchFormat
    let sides: [[MatchPlayer]]

    func validate() throws {
        guard sides.count == 2, sides.allSatisfy({ $0.count == kind.playersPerSide }),
              kind == .doubles || category != .mixed else {
            throw MatchRuleError.invalidParticipants
        }
        let players = sides.flatMap { $0 }
        let profiles = players.compactMap(\.profileID)
        guard Set(players.map(\.id)).count == players.count,
              Set(profiles).count == profiles.count else { throw MatchRuleError.duplicatePlayer }
        for side in sides {
            for (position, player) in side.enumerated() {
                guard !player.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                      !player.surname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                      player.gender == category.gender(at: position) else {
                    throw MatchRuleError.invalidParticipants
                }
            }
        }
    }
}

enum MatchRuleError: LocalizedError {
    case invalidParticipants, duplicatePlayer, finished, tieBreakRequired
    case invalidTieBreak, nothingToUndo, invalidHistory

    var errorDescription: String? {
        switch self {
        case .invalidParticipants: "Заполните имя и фамилию каждого игрока и проверьте состав выбранной категории."
        case .duplicatePlayer: "Один игрок не может участвовать в матче дважды."
        case .finished: "Матч завершён. Чтобы исправить счёт, отмените последнее действие."
        case .tieBreakRequired: "При 6:6 введите итоговый счёт тай-брейка."
        case .invalidTieBreak: "Нужен итог тай-брейка: 7:0–7:5 либо разница ровно 2 после 6:6 (например, 8:6)."
        case .nothingToUndo: "Пока нечего отменять."
        case .invalidHistory: "Сохранённая история матча повреждена. Данные не изменены."
        }
    }
}
