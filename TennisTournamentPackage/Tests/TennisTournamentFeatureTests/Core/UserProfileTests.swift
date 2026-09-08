import Foundation
import Testing
@testable import TennisTournamentFeature

struct UserProfileTests {
    @Test("Decodes profiles persisted before navigation identity was added")
    func decodesLegacyProfileWithoutID() throws {
        let data = try #require(#"{"name":"Serena","surname":"Williams","gender":"female"}"#.data(using: .utf8))

        let profile = try JSONDecoder().decode(UserProfile.self, from: data)

        #expect(profile.name == "Serena")
        #expect(profile.surname == "Williams")
        #expect(profile.gender == .female)
    }

    @Test("Persists the generated identity when loading a legacy profile")
    func persistsMigratedProfileID() throws {
        let suiteName = "UserProfileTests.\(UUID())"
        let userDefaults = try #require(UserDefaults(suiteName: suiteName))
        defer { userDefaults.removePersistentDomain(forName: suiteName) }
        let data = try #require(#"{"name":"Serena","surname":"Williams","gender":"female"}"#.data(using: .utf8))
        userDefaults.set(data, forKey: "app.user.profile")
        let store = UserDefaultsAppSessionStore(userDefaults: userDefaults)

        let firstLoad = try #require(store.loadUserProfile())
        let secondLoad = try #require(store.loadUserProfile())

        #expect(firstLoad.id == secondLoad.id)
    }
}
