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
            let snapshot = $0
            $0.session.capture(.tradingReturn, from: snapshot)
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

@MainActor
struct CalculationPersistenceTests {
    @Test func restoresAllSubmittedCalculatorsAfterRelaunch() async throws {
        let suite = "CalculationPersistenceTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        var initial = withDependencies {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        } operation: { Main.State() }
        initial.settings.buyFee = 0.15
        initial.settings.sellFee = 0.25
        initial.araArbCalculator.price = 1000
        initial.araArbCalculator.type = 4
        initial.araArbCalculator.araPercentage = 12
        initial.araArbCalculator.arbPercentage = 8
        initial.tradingReturnCalculator.buyPrice = 1000
        initial.tradingReturnCalculator.sellPrice = 1100
        initial.tradingReturnCalculator.lot = 2
        initial.profitPerTickCalculator.price = 1000
        initial.profitPerTickCalculator.lot = 2
        initial.averagePriceCalculator.price = 1000
        initial.averagePriceCalculator.lot = 2
        initial.averagePriceCalculator.value = 200000
        initial.riskRewardRatioCalculator.buyPrice = 1000
        initial.riskRewardRatioCalculator.targetPrice = 1200
        initial.riskRewardRatioCalculator.stopLossPrice = 900
        initial.priceBookValueCalculator.price = 1000
        initial.priceBookValueCalculator.bookValue = 500
        initial.dividenYieldCalculator.price = 1000
        initial.dividenYieldCalculator.dividen = 50
        initial.stockSplitCalculator.price = 1000
        initial.stockSplitCalculator.oldRatio = 1
        initial.stockSplitCalculator.newRatio = 5
        initial.rightIssueCalculator.ticker = "TEST"
        initial.rightIssueCalculator.cumDatePrice = 1000
        initial.rightIssueCalculator.lot = 2
        initial.rightIssueCalculator.exercisePrice = 500
        initial.rightIssueCalculator.oldRatio = 2
        initial.rightIssueCalculator.newRatio = 1
        initial.lotCalculator.price = 1000
        initial.lotCalculator.maxBuy = 1000000
        let store = TestStore(initialState: initial) { Main() } withDependencies: {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        }
        store.exhaustivity = .off
        // Use fees different from settings to verify the exact submitted fees are saved.
        let fee = BrokerFee(buy: 0.35, sell: 0.45)
        let actions: [Main.Action] = [
            .araArbCalculator(.calculateButtonTapped),
            .tradingReturnCalculator(.calculateButtonTapped),
            .profitPerTickCalculator(.calculateButtonTapped(brokerFee: fee)),
            .averagePriceCalculator(.buyButtonTapped),
            .riskRewardRatioCalculator(.calculateButtonTapped),
            .priceBookValueCalculator(.calculateButtonTapped),
            .dividenYieldCalculator(.calculateButtonTapped),
            .stockSplitCalculator(.calculateButtonTapped),
            .rightIssueCalculator(.calculateButtonTapped),
            .lotCalculator(.calculateButtonTapped(brokerFee: fee))
        ]
        for action in actions {
            await store.send(action).finish()
        }
        await store.send(.rightIssueCalculator(.binding(.set(\.currentPrice, 950)))).finish()
        await store.send(.binding(.set(\.path, [.rightIssue])))
        let data = try #require(defaults.data(forKey: CalculationSession.storageKey))
        let saved = try JSONDecoder().decode(CalculationSession.self, from: data)
        #expect(saved.forms.count == 10)
        let restored = withDependencies {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        } operation: { Main.State.restored() }
        #expect(restored.path == [.rightIssue])
        #expect(restored.araArbCalculator == store.state.araArbCalculator)
        #expect(restored.tradingReturnCalculator.tradingReturn == store.state.tradingReturnCalculator.tradingReturn)
        #expect(restored.tradingReturnCalculator.buyPrice == 1000)
        #expect(restored.profitPerTickCalculator == store.state.profitPerTickCalculator)
        #expect(restored.averagePriceCalculator == store.state.averagePriceCalculator)
        #expect(restored.riskRewardRatioCalculator == store.state.riskRewardRatioCalculator)
        #expect(restored.priceBookValueCalculator == store.state.priceBookValueCalculator)
        #expect(restored.dividenYieldCalculator == store.state.dividenYieldCalculator)
        #expect(restored.stockSplitCalculator == store.state.stockSplitCalculator)
        #expect(restored.rightIssueCalculator == store.state.rightIssueCalculator)
        #expect(restored.lotCalculator == store.state.lotCalculator)

        // Drafts and failed submissions must leave the previous successful form intact.
        await store.send(.priceBookValueCalculator(.binding(.set(\.price, 0)))).finish()
        await store.send(.priceBookValueCalculator(.calculateButtonTapped)).finish()
        let afterFailure = try #require(defaults.data(forKey: CalculationSession.storageKey))
        #expect(afterFailure == data)
        await store.send(.averagePriceCalculator(.deleteButtonTapped(index: 0)))
        let afterDeletion = withDependencies {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        } operation: { Main.State.restored() }
        #expect(afterDeletion.averagePriceCalculator == store.state.averagePriceCalculator)
        await store.finish()
    }

    @Test func missingCorruptAndUnsupportedSessionsUseFreshState() throws {
        let suite = "CalculationPersistenceTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        try withDependencies {
            $0.userDefaults = UserDefaultsClient(suiteName: suite)
        } operation: {
            #expect(Main.State.restored().path.isEmpty)
            defaults.set(Data("invalid json".utf8), forKey: CalculationSession.storageKey)
            #expect(Main.State.restored().session.forms.isEmpty)
            var unsupported = CalculationSession()
            unsupported.version = 999
            unsupported.path = [.lot]
            defaults.set(try JSONEncoder().encode(unsupported), forKey: CalculationSession.storageKey)
            #expect(Main.State.restored().path.isEmpty)
        }
    }
}

struct NumericInputFormattingTests {
    @Test(arguments: [
        ("2000000", "2.000.000"),
        ("1234,50", "1.234,50"),
        ("0,", "0,"),
        (",5", "0,5"),
        ("0001234", "1.234"),
        ("-2000000,25", "-2.000.000,25"),
        ("2.000.000,50", "2.000.000,50"),
        ("0.15", "0,15"),
        ("", ""),
        ("-", "-")
    ])
    func formatsEditableNumbers(example: (String, String)) {
        #expect(NumericInputFormatter.format(example.0) == example.1)
    }

    @Test func groupsEveryKeystrokeAndPreservesTheNumericValue() {
        var text = ""
        for digit in "2000000" {
            text = NumericInputFormatter.format(text + String(digit), previous: text)
        }
        #expect(text == "2.000.000")
        #expect(NumericInputFormatter.value(of: text) == 2000000)
        text = NumericInputFormatter.format(text + ",", previous: text)
        #expect(text == "2.000.000,")
        text = NumericInputFormatter.format(text + "5", previous: text)
        #expect(text == "2.000.000,5")
        #expect(NumericInputFormatter.value(of: text) == 2000000.5)
    }

    @Test func acceptsDecimalKeyboardPeriodAndBackspace() {
        #expect(NumericInputFormatter.format("1.000.", previous: "1.000") == "1.000,")
        #expect(NumericInputFormatter.format("1.00", previous: "1.000") == "100")
        #expect(NumericInputFormatter.format("1234", previous: "1.234") == "234")
        #expect(NumericInputFormatter.display(2000000.125) == "2.000.000,125")
        #expect(NumericInputFormatter.value(of: "") == 0)
        #expect(NumericInputFormatter.value(of: "1.234,50") == 1234.5)
        #expect(NumericInputFormatter.value(of: String(repeating: "9", count: 400)) == nil)
    }
}
