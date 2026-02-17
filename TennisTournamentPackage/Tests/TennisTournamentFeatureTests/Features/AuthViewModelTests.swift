import Testing
@testable import TennisTournamentFeature

@MainActor
struct AuthViewModelTests {
    @Test("Rejects when name or surname is empty")
    func rejectsEmptyNameOrSurname() {
        let viewModel = AuthViewModel()

        viewModel.name = "Roger"
        viewModel.surname = "   "
        #expect(viewModel.canSubmit == false)

        viewModel.name = "   "
        viewModel.surname = "Federer"
        #expect(viewModel.canSubmit == false)
    }

    @Test("Accepts non-empty name and surname and trims them")
    func acceptsAndTrimsNameAndSurname() {
        let viewModel = AuthViewModel()

        viewModel.name = "  Roger  "
        viewModel.surname = "  Federer  "

        #expect(viewModel.canSubmit == true)
        #expect(viewModel.trimmedName == "Roger")
        #expect(viewModel.trimmedSurname == "Federer")
    }
}
