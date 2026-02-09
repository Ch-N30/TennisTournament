import SwiftUI

public struct MatchesHomeScreen: View {
    public init() {}

    public var body: some View {
        ContentUnavailableView(
            "Matches",
            systemImage: "sportscourt",
            description: Text("TODO: match setup and scoring screens will be added in next iterations.")
        )
        .navigationTitle("Matches")
    }
}
