import SwiftUI

public struct TournamentsHomeScreen: View {
    @ObservedObject private var viewModel: TournamentListViewModel
    private let onSelectTournament: (TournamentSummary.ID) -> Void

    public init(
        viewModel: TournamentListViewModel,
        onSelectTournament: @escaping (TournamentSummary.ID) -> Void
    ) {
        self.viewModel = viewModel
        self.onSelectTournament = onSelectTournament
    }

    public var body: some View {
        List(viewModel.tournaments) { tournament in
            Button {
                onSelectTournament(tournament.id)
            } label: {
                VStack(alignment: .leading, spacing: 4) {
                    Text(tournament.name)
                        .font(.headline)
                    Text(tournament.format)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
        }
        .overlay {
            if viewModel.tournaments.isEmpty {
                ContentUnavailableView(
                    "No tournaments yet",
                    systemImage: "trophy",
                    description: Text("TODO: tournament creation flow will be added later.")
                )
            }
        }
        .navigationTitle("Tournaments")
    }
}
