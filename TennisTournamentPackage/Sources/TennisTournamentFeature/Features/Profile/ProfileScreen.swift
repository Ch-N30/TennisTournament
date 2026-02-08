import SwiftUI

public struct ProfileScreen: View {
    private let profile: UserProfile
    private let onResetProfile: () -> Void

    public init(profile: UserProfile, onResetProfile: @escaping () -> Void) {
        self.profile = profile
        self.onResetProfile = onResetProfile
    }

    public var body: some View {
        Form {
            Section("User") {
                LabeledContent("Surname", value: profile.surname)
                LabeledContent("Gender", value: profile.gender.title)
            }

            Section {
                Button("Change profile") {
                    onResetProfile()
                }
                .foregroundStyle(.red)
            }
        }
        .navigationTitle("Profile")
    }
}
