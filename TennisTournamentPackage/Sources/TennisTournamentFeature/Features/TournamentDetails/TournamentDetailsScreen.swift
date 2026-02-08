import SwiftUI

public struct TournamentDetailsScreen: View {
    private let tournamentID: UUID

    public init(tournamentID: UUID) {
        self.tournamentID = tournamentID
    }

    public var body: some View {
        VStack(spacing: 12) {
            Text("Tournament Details")
                .font(.title2)
            Text(tournamentID.uuidString)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
        }
        .navigationTitle("Details")
    }
}
