import SwiftUI

public struct OnboardingScreen: View {
    private let onContinue: () -> Void

    public init(onContinue: @escaping () -> Void) {
        self.onContinue = onContinue
    }

    public var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "tennis.racket")
                .font(.system(size: 56))
                .foregroundStyle(.green)

            Text("Welcome to Tennis Tournament")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)

            Text("Manage classic tournaments, matches, and standings in one app.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer()

            Button("Continue") {
                onContinue()
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
    }
}
