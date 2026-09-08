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

public struct UserProfile: Codable, Hashable, Identifiable, Sendable {
    public let id: UUID
    public let name: String
    public let surname: String
    public let gender: UserGender

    public init(id: UUID = UUID(), name: String, surname: String, gender: UserGender) {
        self.id = id
        self.name = name
        self.surname = surname
        self.gender = gender
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case surname
        case gender
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        surname = try container.decode(String.self, forKey: .surname)
        gender = try container.decode(UserGender.self, forKey: .gender)
    }
}
