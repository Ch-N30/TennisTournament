import PRNDSSwiftUI
import SwiftUI

public struct MainTabScreen: View {
    @Binding private var selectedTab: AppTab
    @ObservedObject private var navigationStore: SwiftUINavigationStore<AppRoute, AppModalRoute>

    private let tournamentListViewModel: TournamentListViewModel
    private let userProfile: UserProfile
    private let onUpdateProfile: (String, String, UserGender) -> Void
    private let onSelectTournament: (TournamentSummary.ID) -> Void
    private let onShowProfile: () -> Void
    private let onPopToTournamentList: () -> Void

    public init(
        tournamentListViewModel: TournamentListViewModel,
        userProfile: UserProfile,
        selectedTab: Binding<AppTab>,
        navigationStore: SwiftUINavigationStore<AppRoute, AppModalRoute>,
        onUpdateProfile: @escaping (String, String, UserGender) -> Void,
        onSelectTournament: @escaping (TournamentSummary.ID) -> Void,
        onShowProfile: @escaping () -> Void,
        onPopToTournamentList: @escaping () -> Void
    ) {
        self.tournamentListViewModel = tournamentListViewModel
        self.userProfile = userProfile
        _selectedTab = selectedTab
        self.navigationStore = navigationStore
        self.onUpdateProfile = onUpdateProfile
        self.onSelectTournament = onSelectTournament
        self.onShowProfile = onShowProfile
        self.onPopToTournamentList = onPopToTournamentList
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

            NavigationStack(path: navigationStore.pathBinding) {
                TournamentsHomeScreen(
                    viewModel: tournamentListViewModel,
                    onSelectTournament: onSelectTournament
                )
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
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

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .details(let id):
            if let tournament = tournamentListViewModel.tournament(id: id) {
                TournamentDetailsScreen(
                    tournament: tournament,
                    onShowProfile: onShowProfile,
                    onPopToTournaments: onPopToTournamentList
                )
            } else {
                ContentUnavailableView("Tournament not found", systemImage: "exclamationmark.triangle")
            }
        case .profile(let userID):
            if userID == userProfile.id {
                ProfileScreen(profile: userProfile, onUpdateProfile: onUpdateProfile)
            } else {
                ContentUnavailableView("Profile not found", systemImage: "person.crop.circle.badge.questionmark")
            }
        }
    }
}
