import ComposableArchitecture
import Foundation
import StockCalculator
import Testing
@testable import KalkulatorSaham

@MainActor
struct MainTests {
    private func makeStore(suite: String) -> TestStoreOf<Main> {
        TestStore(initialState: Main.State()) {
            Main()
        } withDependencies: {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        }
    }

    @Test func presentsAndDismissesShareSheet() async {
        let suite = "MainTests.\(UUID().uuidString)"
        defer { UserDefaults.standard.removePersistentDomain(forName: suite) }
        let store = makeStore(suite: suite)
        await store.send(.didTapShareButton) { $0.showShareSheet = true }
        await store.send(.binding(.set(\.showShareSheet, false))) { $0.showShareSheet = false }
    }

    @Test func settingsFeesReachTradingCalculator() async throws {
        let suite = "MainTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let store = makeStore(suite: suite)
        await store.send(.settings(.binding(.set(\.buyFee, 0.15)))) { $0.settings.buyFee = 0.15 }
        await store.send(.settings(.binding(.set(\.sellFee, 0.25)))) { $0.settings.sellFee = 0.25 }
        #expect(store.state.tradingReturnCalculator.brokerFee == BrokerFee(buy: 0.15, sell: 0.25))

        await store.send(.tradingReturnCalculator(.binding(.set(\.buyPrice, 1000)))) {
            $0.tradingReturnCalculator.buyPrice = 1000
        }
        await store.receive(\.tradingReturnCalculator.validateField)
        await store.send(.tradingReturnCalculator(.binding(.set(\.sellPrice, 1100)))) {
            $0.tradingReturnCalculator.sellPrice = 1100
        }
        await store.receive(\.tradingReturnCalculator.validateField)
        await store.send(.tradingReturnCalculator(.binding(.set(\.lot, 1)))) {
            $0.tradingReturnCalculator.lot = 1
        }
        await store.receive(\.tradingReturnCalculator.validateField)
        await store.send(.tradingReturnCalculator(.calculateButtonTapped))
        await store.receive(\.tradingReturnCalculator.validate)
        let expected = StockCalculator().calculateTradingReturn(
            buyPrice: 1000, sellPrice: 1100, lot: 1,
            brokerFee: BrokerFee(buy: 0.15, sell: 0.25)
        )
        await store.receive(\.tradingReturnCalculator.calculate) {
            $0.tradingReturnCalculator.tradingReturn = expected
        }
        let result = try #require(store.state.tradingReturnCalculator.tradingReturn)
        #expect(result.calculationResult.totalFee == 425)
        #expect(result.calculationResult.netTradingReturn == 9575)
        await store.finish()
    }

    @Test func riskRewardBindingRunsOnce() async {
        let suite = "MainTests.\(UUID().uuidString)"
        defer { UserDefaults.standard.removePersistentDomain(forName: suite) }
        let store = makeStore(suite: suite)
        await store.send(.riskRewardRatioCalculator(.binding(.set(\.buyPrice, 1000)))) {
            $0.riskRewardRatioCalculator.buyPrice = 1000
        }
        await store.receive(\.riskRewardRatioCalculator.validateField)
        // Exhaustive TestStore detects duplicate validation actions from duplicate scopes.
        await store.finish()
    }

    @Test func validationPreventsCalculationWithEmptyFields() async {
        let store = TestStore(initialState: PriceBookValueCalculator.State()) {
            PriceBookValueCalculator()
        }
        await store.send(.calculateButtonTapped)
        await store.receive(\.validate) {
            $0.errors = [
                "price": "this_field_is_required".tr(),
                "bookValue": "this_field_is_required".tr()
            ]
        }
        await store.receive(\.calculate)
        #expect(store.state.priceBookValue == nil)
        await store.finish()
    }
}
