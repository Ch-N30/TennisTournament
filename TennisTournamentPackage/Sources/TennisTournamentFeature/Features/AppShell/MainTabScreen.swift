import SwiftUI

public struct MainTabScreen: View {
    @State private var selectedTab: AppTab = .matches

    private let tournamentListViewModel: TournamentListViewModel
    private let userProfile: UserProfile
    private let onUpdateProfile: (String, String, UserGender) -> Void

    public init(
        tournamentListViewModel: TournamentListViewModel,
        userProfile: UserProfile,
        onUpdateProfile: @escaping (String, String, UserGender) -> Void
    ) {
        self.tournamentListViewModel = tournamentListViewModel
        self.userProfile = userProfile
        self.onUpdateProfile = onUpdateProfile
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MatchesHomeScreen()
            }
            .tabItem {
                Label("Matches", systemImage: "sportscourt")
            }
            .tag(AppTab.matches)

            NavigationStack {
                TournamentsHomeScreen(viewModel: tournamentListViewModel)
            }
            .tabItem {
                Label("Tournaments", systemImage: "list.bullet.rectangle")
            }
            .tag(AppTab.tournaments)

            NavigationStack {
                ProfileScreen(profile: userProfile, onUpdateProfile: onUpdateProfile)
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
            .tag(AppTab.profile)
        }
    }
}

private enum AppTab: Hashable {
    case matches
    case tournaments
    case profile
}
