import ComposableArchitecture
import Foundation
import Testing
@testable import KalkulatorSaham

@MainActor
struct SettingsTests {
    @Test func persistsThemeAndLanguage() async throws {
        let suite = "SettingsTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let store = TestStore(initialState: Settings.State()) {
            Settings()
        } withDependencies: {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        }

        await store.send(.setTheme(.dark)) { $0.theme = .dark }
        #expect(defaults.string(forKey: UserDefaultsKey.theme) == "dark")
        await store.send(.setLanguage(.indonesia)) { $0.language = .indonesia }
        #expect(defaults.string(forKey: UserDefaultsKey.language) == "indonesia")
    }

    @Test func persistsBrokerFeeBindings() async throws {
        let suite = "SettingsTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let store = TestStore(initialState: Settings.State()) {
            Settings()
        } withDependencies: {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        }

        await store.send(.binding(.set(\.buyFee, 0.15))) { $0.buyFee = 0.15 }
        await store.send(.binding(.set(\.sellFee, 0.25))) { $0.sellFee = 0.25 }
        #expect(defaults.double(forKey: UserDefaultsKey.buyFee) == 0.15)
        #expect(defaults.double(forKey: UserDefaultsKey.sellFee) == 0.25)

        let reloaded = withDependencies {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        } operation: {
            Settings.State()
        }
        #expect(reloaded.buyFee == 0.15)
        #expect(reloaded.sellFee == 0.25)
    }

    @Test func persistsStampDutyBindingsAndDefaults() async throws {
        let suite = "SettingsTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let store = TestStore(initialState: Settings.State()) {
            Settings()
        } withDependencies: {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        }

        #expect(store.state.stampDutyFee == 10000)
        #expect(store.state.stampDutyThreshold == 10000000)

        await store.send(.binding(.set(\.stampDutyFee, 15000))) { $0.stampDutyFee = 15000 }
        await store.send(.binding(.set(\.stampDutyThreshold, 20000000))) { $0.stampDutyThreshold = 20000000 }
        #expect(defaults.double(forKey: UserDefaultsKey.stampDutyFee) == 15000)
        #expect(defaults.double(forKey: UserDefaultsKey.stampDutyThreshold) == 20000000)

        let reloaded = withDependencies {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        } operation: {
            Settings.State()
        }
        #expect(reloaded.stampDutyFee == 15000)
        #expect(reloaded.stampDutyThreshold == 20000000)
    }

    @Test func invalidSavedPreferencesFallBackToSystem() async throws {
        let suite = "SettingsTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set("unknown", forKey: UserDefaultsKey.theme)
        defaults.set("unknown", forKey: UserDefaultsKey.language)
        let store = TestStore(initialState: Settings.State()) {
            Settings()
        } withDependencies: {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        }
        #expect(store.state.theme == .system)
        #expect(store.state.language == .system)
    }
}
