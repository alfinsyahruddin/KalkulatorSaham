import Foundation
import ComposableArchitecture

/// Stores only the suite name so dependency values can safely cross isolation boundaries.
struct UserDefaultsClient: Sendable {
    var suiteName: String? = nil

    private var defaults: UserDefaults {
        suiteName.flatMap(UserDefaults.init(suiteName:)) ?? .standard
    }

    func string(forKey key: String) -> String? {
        defaults.string(forKey: key)
    }

    func double(forKey key: String) -> Double {
        defaults.double(forKey: key)
    }

    func set(_ value: String, forKey key: String) {
        defaults.set(value, forKey: key)
    }

    func set(_ value: Double, forKey key: String) {
        defaults.set(value, forKey: key)
    }
}

private enum UserDefaultsDependencyKey: DependencyKey {
    static let liveValue = UserDefaultsClient()
}

extension DependencyValues {
    var userDefaults: UserDefaultsClient {
        get { self[UserDefaultsDependencyKey.self] }
        set { self[UserDefaultsDependencyKey.self] = newValue }
    }
}
