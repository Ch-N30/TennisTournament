import SwiftUI

public struct AuthScreen: View {
    @StateObject private var viewModel: AuthViewModel

    private let onSubmit: (String, UserGender) -> Void

    public init(
        viewModel: AuthViewModel = AuthViewModel(),
        onSubmit: @escaping (String, UserGender) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSubmit = onSubmit
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Surname", text: $viewModel.surname)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()

                    Picker("Gender", selection: $viewModel.gender) {
                        ForEach(UserGender.allCases) { gender in
                            Text(gender.title).tag(gender)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    Button("Save and continue") {
                        onSubmit(viewModel.trimmedSurname, viewModel.gender)
                    }
                    .disabled(!viewModel.canSubmit)
                }
            }
            .navigationTitle("Authorization")
        }
    }
}
