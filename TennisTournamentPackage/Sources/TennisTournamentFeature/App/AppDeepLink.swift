import Foundation

public enum AppDeepLink: Equatable {
    case tournamentDetails(id: TournamentSummary.ID)
    case tournamentProfile(id: TournamentSummary.ID)
    case tournamentEditor(id: TournamentSummary.ID)
    case settings
}

public struct AppDeepLinkParser {
    public init() {}

    public func parse(_ url: URL) -> AppDeepLink? {
        guard url.scheme?.lowercased() == "tennistournament" else { return nil }

        let path = url.pathComponents.filter { $0 != "/" }
        switch url.host?.lowercased() {
        case "settings" where path.isEmpty:
            return .settings
        case "tournaments":
            return parseTournamentPath(path)
        default:
            return nil
        }
    }

    private func parseTournamentPath(_ path: [String]) -> AppDeepLink? {
        guard let rawID = path.first, let id = UUID(uuidString: rawID) else { return nil }

        switch Array(path.dropFirst()) {
        case []:
            return .tournamentDetails(id: id)
        case ["profile"]:
            return .tournamentProfile(id: id)
        case ["edit"]:
            return .tournamentEditor(id: id)
        default:
            return nil
        }
    }
}
