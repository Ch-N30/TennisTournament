import SwiftUI

public struct TournamentDetailsScreen: View {
    private let tournament: TournamentSummary
    private let onShowProfile: () -> Void
    private let onPopToTournaments: () -> Void

    public init(
        tournament: TournamentSummary,
        onShowProfile: @escaping () -> Void,
        onPopToTournaments: @escaping () -> Void
    ) {
        self.tournament = tournament
        self.onShowProfile = onShowProfile
        self.onPopToTournaments = onPopToTournaments
    }

    public var body: some View {
        List {
            Section("Tournament") {
                LabeledContent("Name", value: tournament.name)
                LabeledContent("Format", value: tournament.format)
            }

            Section("Navigation") {
                Button("Open profile", systemImage: "person.crop.circle", action: onShowProfile)
                Button("Back to tournaments", systemImage: "arrow.uturn.backward", action: onPopToTournaments)
            }
        }
        .navigationTitle("Details")
    }
}
