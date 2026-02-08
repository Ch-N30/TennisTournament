import Testing
@testable import TennisTournamentFeature

@MainActor
struct AuthViewModelTests {
    @Test("Rejects empty surname")
    func rejectsEmptySurname() {
        let viewModel = AuthViewModel()

        viewModel.surname = "   "

        #expect(viewModel.canSubmit == false)
    }

    @Test("Accepts non-empty surname and trims it")
    func acceptsAndTrimsSurname() {
        let viewModel = AuthViewModel()

        viewModel.surname = "  Federer  "

        #expect(viewModel.canSubmit == true)
        #expect(viewModel.trimmedSurname == "Federer")
    }
}
