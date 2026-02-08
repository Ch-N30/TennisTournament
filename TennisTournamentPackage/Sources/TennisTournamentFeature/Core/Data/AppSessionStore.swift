import Foundation

public protocol AppSessionStoring {
    func hasCompletedOnboarding() -> Bool
    func setHasCompletedOnboarding(_ value: Bool)
    func loadUserProfile() -> UserProfile?
    func saveUserProfile(_ profile: UserProfile)
    func clearUserProfile()
}

public final class UserDefaultsAppSessionStore: AppSessionStoring {
    private enum Keys {
        static let onboardingCompleted = "app.onboarding.completed"
        static let userProfile = "app.user.profile"
    }

    private let userDefaults: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(
        userDefaults: UserDefaults = .standard,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
    }

    public func hasCompletedOnboarding() -> Bool {
        userDefaults.bool(forKey: Keys.onboardingCompleted)
    }

    public func setHasCompletedOnboarding(_ value: Bool) {
        userDefaults.set(value, forKey: Keys.onboardingCompleted)
    }

    public func loadUserProfile() -> UserProfile? {
        guard let data = userDefaults.data(forKey: Keys.userProfile) else {
            return nil
        }
        return try? decoder.decode(UserProfile.self, from: data)
    }

    public func saveUserProfile(_ profile: UserProfile) {
        guard let data = try? encoder.encode(profile) else {
            return
        }
        userDefaults.set(data, forKey: Keys.userProfile)
    }

    public func clearUserProfile() {
        userDefaults.removeObject(forKey: Keys.userProfile)
    }
}
