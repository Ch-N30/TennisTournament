import SwiftUI

public struct AuthScreen: View {
    @StateObject private var viewModel: AuthViewModel

    private let onSubmit: (String, String, UserGender) -> Void

    public init(
        viewModel: AuthViewModel = AuthViewModel(),
        onSubmit: @escaping (String, String, UserGender) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSubmit = onSubmit
    }

    public var body: some View {
		NavigationStack {
			Form {
				Section {
					TextField("Name", text: $viewModel.name)
						.textInputAutocapitalization(.words)
						.autocorrectionDisabled()
					
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
				
				Button("Save and continue") {
					onSubmit(viewModel.trimmedName, viewModel.trimmedSurname, viewModel.gender)
				}
				.disabled(!viewModel.canSubmit)
				.tint(.green)
			}
			.navigationTitle("Authorization")
			.scrollDisabled(true)
		}
    }
}

#Preview {
	AuthScreen(viewModel: AuthViewModel()) { _, _, _ in
		
	}
}
