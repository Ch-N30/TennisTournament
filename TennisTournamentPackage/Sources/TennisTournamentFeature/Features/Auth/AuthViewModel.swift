import Combine
import Foundation

@MainActor
public final class AuthViewModel: ObservableObject {
    @Published public var name: String = ""
    @Published public var surname: String = ""
    @Published public var gender: UserGender = .male

    public init() {}

    public var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var trimmedSurname: String {
        surname.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var canSubmit: Bool {
        !trimmedName.isEmpty && !trimmedSurname.isEmpty
    }
}
