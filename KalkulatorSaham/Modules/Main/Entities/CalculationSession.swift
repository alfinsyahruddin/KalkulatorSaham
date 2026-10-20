import ComposableArchitecture
import Foundation
import StockCalculator

/// Each entry is the last submitted form, including the fees used for its result.
/// Results are rebuilt with the shared calculation methods, keeping presentation details
/// such as localized table values and colors out of the disk format.
struct CalculationSession: Codable, Equatable {
    static let storageKey = "calculationSession.v1"
    var version = 1
    var path: [CalculatorScreen] = []
    var forms: [String: SubmittedForm] = [:]

    mutating func capture(_ screen: CalculatorScreen, from state: Main.State, brokerFee: BrokerFee? = nil) {
        var form = SubmittedForm()
        form.buyFee = brokerFee?.buy ?? state.settings.buyFee
        form.sellFee = brokerFee?.sell ?? state.settings.sellFee
        switch screen {
        case .araArb:
            let value = state.araArbCalculator
            form.numbers = ["price": value.price, "type": Double(value.type), "araPercentage": value.araPercentage, "arbPercentage": value.arbPercentage]
        case .tradingReturn:
            let value = state.tradingReturnCalculator
            form.numbers = ["buyPrice": value.buyPrice, "sellPrice": value.sellPrice, "lot": value.lot]
            form.flags = ["calculateBrokerFee": value.calculateBrokerFee]
        case .profitPerTick:
            let value = state.profitPerTickCalculator
            form.numbers = ["price": value.price, "lot": value.lot]
            form.flags = ["calculateBrokerFee": value.calculateBrokerFee]
        case .averagePrice:
            let value = state.averagePriceCalculator
            form.numbers = ["price": value.price, "lot": value.lot, "value": value.value]
            form.transactions = value.transactions.map { .init(price: $0.price, lot: $0.lot, value: $0.value) }
        case .riskRewardRatio:
            let value = state.riskRewardRatioCalculator
            form.numbers = ["buyPrice": value.buyPrice, "targetPrice": value.targetPrice, "stopLossPrice": value.stopLossPrice]
        case .priceBookValue:
            let value = state.priceBookValueCalculator
            form.numbers = ["price": value.price, "bookValue": value.bookValue]
        case .dividenYield:
            let value = state.dividenYieldCalculator
            form.numbers = ["price": value.price, "dividen": value.dividen]
        case .stockSplit:
            let value = state.stockSplitCalculator
            form.numbers = ["price": value.price, "oldRatio": value.oldRatio, "newRatio": value.newRatio]
        case .rightIssue:
            let value = state.rightIssueCalculator
            form.numbers = ["cumDatePrice": value.cumDatePrice, "lot": value.lot, "exercisePrice": value.exercisePrice, "oldRatio": value.oldRatio, "newRatio": value.newRatio, "currentPrice": value.currentPrice]
            form.ticker = value.ticker
        case .lot:
            let value = state.lotCalculator
            form.numbers = ["price": value.price, "maxBuy": value.maxBuy]
            form.flags = ["calculateBrokerFee": value.calculateBrokerFee]
        case .settings: return
        }
        forms[screen.rawValue] = form
    }

    func restore(into state: inout Main.State) {
        state.path = path
        state.session = self
        for screen in CalculatorScreen.allCases {
            guard let form = forms[screen.rawValue] else { continue }
            let brokerFee = BrokerFee(buy: form.buyFee, sell: form.sellFee)
            switch screen {
            case .araArb:
                var value = AraArbCalculator.State()
                value.price = form.numbers["price"] ?? 0
                value.type = (0...3).first { Double($0) == form.numbers["type"] } ?? 0
                value.araPercentage = form.numbers["araPercentage"] ?? 0
                value.arbPercentage = form.numbers["arbPercentage"] ?? 0
                AraArbCalculator().calculateResult(state: &value)
                state.araArbCalculator = value
            case .tradingReturn:
                var value = TradingReturnCalculator.State()
                value.buyPrice = form.numbers["buyPrice"] ?? 0
                value.sellPrice = form.numbers["sellPrice"] ?? 0
                value.lot = form.numbers["lot"] ?? 0
                value.calculateBrokerFee = form.flags["calculateBrokerFee"] ?? true
                value.brokerFee = brokerFee
                TradingReturnCalculator().calculateResult(state: &value)
                state._tradingReturnCalculator = value
            case .profitPerTick:
                var value = ProfitPerTickCalculator.State()
                value.price = form.numbers["price"] ?? 0
                value.lot = form.numbers["lot"] ?? 0
                value.calculateBrokerFee = form.flags["calculateBrokerFee"] ?? true
                ProfitPerTickCalculator().calculateResult(state: &value, brokerFee: brokerFee)
                state.profitPerTickCalculator = value
            case .averagePrice:
                var value = AveragePriceCalculator.State()
                value.price = form.numbers["price"] ?? 0
                value.lot = form.numbers["lot"] ?? 0
                value.value = form.numbers["value"] ?? 0
                value.transactions = form.transactions.map { Transaction(price: $0.price, lot: $0.lot, value: $0.value) }
                @Dependency(\.stockCalculator) var calculator
                value.portfolio = calculator.calculateAveragePrice(transactions: value.transactions)
                state.averagePriceCalculator = value
            case .riskRewardRatio:
                var value = RiskRewardRatioCalculator.State()
                value.buyPrice = form.numbers["buyPrice"] ?? 0
                value.targetPrice = form.numbers["targetPrice"] ?? 0
                value.stopLossPrice = form.numbers["stopLossPrice"] ?? 0
                RiskRewardRatioCalculator().calculateResult(state: &value)
                state.riskRewardRatioCalculator = value
            case .priceBookValue:
                var value = PriceBookValueCalculator.State()
                value.price = form.numbers["price"] ?? 0
                value.bookValue = form.numbers["bookValue"] ?? 0
                PriceBookValueCalculator().calculateResult(state: &value)
                state.priceBookValueCalculator = value
            case .dividenYield:
                var value = DividenYieldCalculator.State()
                value.price = form.numbers["price"] ?? 0
                value.dividen = form.numbers["dividen"] ?? 0
                DividenYieldCalculator().calculateResult(state: &value)
                state.dividenYieldCalculator = value
            case .stockSplit:
                var value = StockSplitCalculator.State()
                value.price = form.numbers["price"] ?? 0
                value.oldRatio = form.numbers["oldRatio"] ?? 0
                value.newRatio = form.numbers["newRatio"] ?? 0
                StockSplitCalculator().calculateResult(state: &value)
                state.stockSplitCalculator = value
            case .rightIssue:
                var value = RightIssueCalculator.State()
                value.cumDatePrice = form.numbers["cumDatePrice"] ?? 0
                value.lot = form.numbers["lot"] ?? 0
                value.exercisePrice = form.numbers["exercisePrice"] ?? 0
                value.oldRatio = form.numbers["oldRatio"] ?? 0
                value.newRatio = form.numbers["newRatio"] ?? 0
                value.currentPrice = form.numbers["currentPrice"] ?? 0
                value.ticker = form.ticker
                RightIssueCalculator().calculateResult(state: &value)
                value.currentPrice = form.numbers["currentPrice"] ?? value.currentPrice
                RightIssueCalculator().updateCurrentPriceResult(state: &value)
                state.rightIssueCalculator = value
            case .lot:
                var value = LotCalculator.State()
                value.price = form.numbers["price"] ?? 0
                value.maxBuy = form.numbers["maxBuy"] ?? 0
                value.calculateBrokerFee = form.flags["calculateBrokerFee"] ?? true
                LotCalculator().calculateResult(state: &value)
                LotCalculator().calculateProfitPerTickResult(state: &value, brokerFee: brokerFee)
                state.lotCalculator = value
            case .settings: break
            }
        }
    }
}
