import SwiftUI

public struct TournamentListScreen: View {
    @ObservedObject private var viewModel: TournamentListViewModel

    private let onAddTournament: () -> Void
    private let onTournamentSelected: (TournamentSummary) -> Void

    public init(
        viewModel: TournamentListViewModel,
        onAddTournament: @escaping () -> Void,
        onTournamentSelected: @escaping (TournamentSummary) -> Void
    ) {
        self.viewModel = viewModel
        self.onAddTournament = onAddTournament
        self.onTournamentSelected = onTournamentSelected
    }

    public var body: some View {
        List(viewModel.tournaments) { tournament in
            Button {
                onTournamentSelected(tournament)
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
        }
        .navigationTitle("Tournaments")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New", action: onAddTournament)
            }
        }
    }
}
