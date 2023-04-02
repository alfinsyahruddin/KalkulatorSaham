//
//  MainTests.swift
//  KalkulatorSahamTests
//
//  Created by Alfin on 16/03/23.
//

import XCTest
import ComposableArchitecture
@testable import KalkulatorSaham

final class MainTests: XCTestCase {
    private var store: TestStore<Main.State, Main.Action, Main.State, Main.Action, ()>!
    
    override func setUpWithError() throws {
        store = TestStore(initialState: Main.State(), reducer: Main()) {
            let userDefaults = UserDefaults(suiteName: #file)!
            userDefaults.removePersistentDomain(forName: #file)
            $0.userDefaults = userDefaults
        }
    }
    
    func test_didTapShareButton() async throws {
        await store.send(.didTapShareButton) {
            $0.showShareSheet = true
        }
    }
}
