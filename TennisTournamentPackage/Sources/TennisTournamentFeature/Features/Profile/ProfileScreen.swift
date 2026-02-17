import SwiftUI

public struct ProfileScreen: View {
    private let profile: UserProfile
    private let onUpdateProfile: (String, String, UserGender) -> Void

    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var gender: UserGender = .male

    public init(
        profile: UserProfile,
        onUpdateProfile: @escaping (String, String, UserGender) -> Void
    ) {
        self.profile = profile
        self.onUpdateProfile = onUpdateProfile
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedSurname: String {
        surname.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var hasChanges: Bool {
        trimmedName != profile.name || trimmedSurname != profile.surname || gender != profile.gender
    }

    public var body: some View {
        Form {
            Section() {
                TextField("Name", text: $name)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()

                TextField("Surname", text: $surname)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()

                Picker("Gender", selection: $gender) {
                    ForEach(UserGender.allCases) { g in
                        Text(g.title).tag(g)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("Profile")
        .onAppear { syncFromProfile() }
        .onChange(of: profile) { _, newProfile in syncFromProfile(newProfile) }
        .onChange(of: name) { _, _ in persistIfNeeded() }
        .onChange(of: surname) { _, _ in persistIfNeeded() }
        .onChange(of: gender) { _, _ in persistIfNeeded() }
    }

    private func syncFromProfile(_ p: UserProfile? = nil) {
        let source = p ?? profile
        name = source.name
        surname = source.surname
        gender = source.gender
    }

    private func persistIfNeeded() {
        guard !trimmedName.isEmpty, !trimmedSurname.isEmpty, hasChanges else {
            return
        }

        onUpdateProfile(trimmedName, trimmedSurname, gender)
    }
}

#Preview {
    ProfileScreen(
        profile: UserProfile(
            name: "Вася",
            surname: "Пупкин",
            gender: .male
        ),
        onUpdateProfile: { _, _, _ in }
    )
}
