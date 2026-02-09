import Foundation

public enum UserGender: String, Codable, CaseIterable, Hashable, Sendable, Identifiable {
    case male
    case female

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .male: "Male"
        case .female: "Female"
        }
    }
}

public struct UserProfile: Codable, Hashable, Sendable {
    public let surname: String
    public let gender: UserGender

    public init(surname: String, gender: UserGender) {
        self.surname = surname
        self.gender = gender
    }
}
