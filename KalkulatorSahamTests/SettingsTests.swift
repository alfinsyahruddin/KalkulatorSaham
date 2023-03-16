//
//  SettingsTests.swift
//  KalkulatorSahamTests
//
//  Created by Alfin on 16/03/23.
//

import XCTest
import ComposableArchitecture
@testable import KalkulatorSaham


final class SettingsTests: XCTestCase {
    private var store: TestStore<Settings.State, Settings.Action, Settings.State, Settings.Action, ()>!
    private var userDefaults: UserDefaults!

    override func setUpWithError() throws {
        store = TestStore(initialState: Settings.State(), reducer: Settings()) {
            userDefaults = UserDefaults(suiteName: #file)
            userDefaults.removePersistentDomain(forName: #file)
            $0.userDefaults = userDefaults
        }
    }
    
    override func tearDownWithError() throws {
        store = nil
    }
    
    func test_setTheme() async throws {
        await store.send(.setTheme(.dark)) {
            $0.theme = .dark
        }
    }
    
    func test_setLanguage() async throws {
        await store.send(.setLanguage(.indonesia)) {
            $0.language = .indonesia
        }
    }
    
    func test_setBrokerFee() async throws {
        await store.send(.binding(.set(\.buyFee, 0.15))) {
            $0.buyFee = 0.15
        }
        
        await store.send(.binding(.set(\.sellFee, 0.25))) {
            $0.sellFee = 0.25
        }
    }
}
