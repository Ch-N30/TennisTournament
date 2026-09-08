import Foundation

public enum AppTab: Hashable {
    case matches
    case tournaments
    case profile
}

public enum AppRoute: Hashable {
    case details(id: TournamentSummary.ID)
    case profile(userID: UserProfile.ID)
}

public enum AppModalRoute: Hashable, Identifiable {
    case settings
    case editor(itemID: TournamentSummary.ID)

    public var id: Self { self }
}
