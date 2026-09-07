import PRNDSSwiftUI
import SwiftUI

public struct MainTabScreen: View {
    @Binding private var selectedTab: AppTab
    @ObservedObject private var navigationStore: SwiftUINavigationStore<AppRoute, AppModalRoute>
    @ObservedObject private var tournamentListViewModel: TournamentListViewModel
    private let matchesCoordinator: MatchesCoordinator

    private let userProfile: UserProfile
    private let onUpdateProfile: (String, String, UserGender) -> Void
    private let onSelectTournament: (TournamentSummary.ID) -> Void
    private let onShowProfile: () -> Void
    private let onPopToTournamentList: () -> Void
    private let onShowSettings: () -> Void
    private let onShowTournamentEditor: (TournamentSummary.ID) -> Void
    private let onDismissModal: () -> Void

    public init(
        matchesCoordinator: MatchesCoordinator,
        tournamentListViewModel: TournamentListViewModel,
        userProfile: UserProfile,
        selectedTab: Binding<AppTab>,
        navigationStore: SwiftUINavigationStore<AppRoute, AppModalRoute>,
        onUpdateProfile: @escaping (String, String, UserGender) -> Void,
        onSelectTournament: @escaping (TournamentSummary.ID) -> Void,
        onShowProfile: @escaping () -> Void,
        onPopToTournamentList: @escaping () -> Void,
        onShowSettings: @escaping () -> Void,
        onShowTournamentEditor: @escaping (TournamentSummary.ID) -> Void,
        onDismissModal: @escaping () -> Void
    ) {
        self.matchesCoordinator = matchesCoordinator
        self.tournamentListViewModel = tournamentListViewModel
        self.userProfile = userProfile
        _selectedTab = selectedTab
        self.navigationStore = navigationStore
        self.onUpdateProfile = onUpdateProfile
        self.onSelectTournament = onSelectTournament
        self.onShowProfile = onShowProfile
        self.onPopToTournamentList = onPopToTournamentList
        self.onShowSettings = onShowSettings
        self.onShowTournamentEditor = onShowTournamentEditor
        self.onDismissModal = onDismissModal
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            MatchesFlowView(
                coordinator: matchesCoordinator,
                navigationStore: matchesCoordinator.navigationStore,
                profile: userProfile
            )
            .tabItem {
                Label("Матчи", systemImage: "sportscourt")
            }
            .tag(AppTab.matches)

            NavigationStack {
                ContentUnavailableView(
                    "Скоро будет",
                    systemImage: "trophy",
                    description: Text("Турниры появятся в следующей версии. Пока можно вести отдельные матчи.")
                )
                .navigationTitle("Турниры")
            }
            .tabItem {
                Label("Турниры", systemImage: "list.bullet.rectangle")
            }
            .tag(AppTab.tournaments)

            NavigationStack {
                ProfileScreen(profile: userProfile, onUpdateProfile: onUpdateProfile)
            }
            .tabItem {
                Label("Профиль", systemImage: "person.crop.circle")
            }
            .tag(AppTab.profile)
        }
        .sheet(item: navigationStore.presentedModalBinding) { route in
            modalDestination(for: route)
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
                    onEditTournament: { onShowTournamentEditor(id) },
                    onPopToTournaments: onPopToTournamentList
                )
            } else {
                ContentUnavailableView("Tournament not found", systemImage: "exclamationmark.triangle")
            }
        case .profile(let userID):
            if userID == userProfile.id {
                ProfileScreen(
                    profile: userProfile,
                    onUpdateProfile: onUpdateProfile,
                    onShowSettings: onShowSettings
                )
            } else {
                ContentUnavailableView("Profile not found", systemImage: "person.crop.circle.badge.questionmark")
            }
        }
    }

    @ViewBuilder
    private func modalDestination(for route: AppModalRoute) -> some View {
        switch route {
        case .settings:
            SettingsScreen(onDismiss: onDismissModal)
        case .editor(let itemID):
            if let tournament = tournamentListViewModel.tournament(id: itemID) {
                TournamentEditorScreen(
                    tournament: tournament,
                    onSave: { name, format in
                        tournamentListViewModel.updateTournament(id: itemID, name: name, format: format)
                        onDismissModal()
                    },
                    onCancel: onDismissModal
                )
            } else {
                NavigationStack {
                    ContentUnavailableView("Tournament not found", systemImage: "exclamationmark.triangle")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close", action: onDismissModal)
                            }
                        }
                }
            }
        }
    }
}
