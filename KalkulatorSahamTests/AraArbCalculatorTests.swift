import ComposableArchitecture
import Foundation
import StockCalculator
import Testing
@testable import KalkulatorSaham

@MainActor
struct AraArbCalculatorTests {
    @Test func defaultStateUsesIdxPreset() async throws {
        let state = AraArbCalculator.State()
        #expect(state.type == 0)
        #expect(!state.usesCustomPercentages)

        var expected = StockCalculator().calculateAutoRejects(price: 11, type: .idx, limit: 5)
        expected.ara.reverse()

        var calculatedState = AraArbCalculator.State()
        calculatedState.price = 11
        AraArbCalculator().calculateResult(state: &calculatedState)
        #expect(calculatedState.autoRejects == expected)
    }

    @Test func customPercentagesReachBothPriceLadders() async throws {
        var state = AraArbCalculator.State()
        state.price = 1000
        state.type = 4
        let store = TestStore(initialState: state) { AraArbCalculator() }
        await store.send(.binding(.set(\.araPercentage, 12.5))) { $0.araPercentage = 12.5 }
        await store.receive(\.validateField)
        await store.send(.binding(.set(\.arbPercentage, 7.5))) { $0.arbPercentage = 7.5 }
        await store.receive(\.validateField)
        await store.send(.calculateButtonTapped)
        await store.receive(\.validate)
        var expected = StockCalculator().calculateAutoRejects(
            price: 1000, type: .idx, limit: 5,
            araPercentage: 12.5, arbPercentage: 7.5
        )
        expected.ara.reverse()
        await store.receive(\.calculate) {
            $0.autoRejectPrice = 1000
            $0.autoRejects = expected
        }
        let result = try #require(store.state.autoRejects)
        #expect(result.ara.last?.price == 1125)
        #expect(result.arb.first?.price == 925)
        #expect(result.ara.count == 5)
        #expect(result.arb.count == 5)
        await store.finish()
    }

    @Test(arguments: [-1.0, 100.01, Double.infinity, -Double.infinity, Double.nan])
    func invalidPercentagesPreventCalculation(percentage: Double) async {
        var state = AraArbCalculator.State()
        state.price = 1000
        state.type = 4
        state.araPercentage = percentage
        state.arbPercentage = percentage
        let reducer = AraArbCalculator()
        _ = reducer.reduce(into: &state, action: .calculate)
        #expect(state.errors == [
            "araPercentage": "percentage_must_be_between_0_and_100".tr(),
            "arbPercentage": "percentage_must_be_between_0_and_100".tr()
        ])
        #expect(state.autoRejects == nil)
    }

    @Test(arguments: [0.0, 100.0])
    func acceptsPercentageBoundaries(percentage: Double) async throws {
        var state = AraArbCalculator.State()
        state.price = 100
        state.type = 4
        state.araPercentage = percentage
        state.arbPercentage = percentage
        let store = TestStore(initialState: state) { AraArbCalculator() }
        var expected = StockCalculator().calculateAutoRejects(
            price: 100, type: .idx, limit: 5,
            araPercentage: percentage, arbPercentage: percentage
        )
        expected.ara.reverse()
        await store.send(.calculateButtonTapped)
        await store.receive(\.validate)
        await store.receive(\.calculate) {
            $0.autoRejectPrice = 100
            $0.autoRejects = expected
        }
        let result = try #require(store.state.autoRejects)
        if percentage == 0 {
            #expect(result.ara.isEmpty)
            #expect(result.arb.isEmpty)
        }
        await store.finish()
    }

    @Test(arguments: [0, 1, 2, 3])
    func switchingToPresetClearsCustomErrorsAndUsesPreset(type: Int) async {
        var state = AraArbCalculator.State()
        state.price = 1000
        state.type = 4
        state.araPercentage = -1
        state.arbPercentage = 101
        state.errors = [
            "araPercentage": "percentage_must_be_between_0_and_100".tr(),
            "arbPercentage": "percentage_must_be_between_0_and_100".tr()
        ]
        let store = TestStore(initialState: state) { AraArbCalculator() }
        await store.send(.binding(.set(\.type, type))) {
            $0.type = type
            $0.errors = [:]
        }
        let preset: AutoRejectType
        switch type {
        case 0: preset = .idx
        case 1: preset = .symmetric
        case 2: preset = .asymmetric
        default: preset = .acceleration
        }
        var expected = StockCalculator().calculateAutoRejects(price: 1000, type: preset)
        expected.ara.reverse()
        await store.send(.calculateButtonTapped)
        await store.receive(\.validate)
        await store.receive(\.calculate) {
            $0.autoRejectPrice = 1000
            $0.autoRejects = expected
        }
        await store.send(.binding(.set(\.type, 4))) { $0.type = 4 }
        await store.receive(\.validateField) {
            $0.errors["araPercentage"] = "percentage_must_be_between_0_and_100".tr()
        }
        await store.receive(\.validateField) {
            $0.errors["arbPercentage"] = "percentage_must_be_between_0_and_100".tr()
        }
        await store.finish()
    }
}
