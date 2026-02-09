import SwiftUI

public struct TournamentsHomeScreen: View {
    @ObservedObject private var viewModel: TournamentListViewModel

    public init(viewModel: TournamentListViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        List(viewModel.tournaments) { tournament in
            VStack(alignment: .leading, spacing: 4) {
                Text(tournament.name)
                    .font(.headline)
                Text(tournament.format)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
