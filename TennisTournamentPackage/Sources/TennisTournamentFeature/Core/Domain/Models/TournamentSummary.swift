import Foundation

public struct TournamentSummary: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let name: String
    public let format: String

    public init(id: UUID = UUID(), name: String, format: String) {
        self.id = id
        self.name = name
        self.format = format
    }
}
