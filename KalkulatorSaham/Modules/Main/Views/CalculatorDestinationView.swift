import SwiftUI
import ComposableArchitecture

struct CalculatorDestinationView: View {
    let screen: CalculatorScreen
    let store: StoreOf<Main>

    var body: some View {
        switch screen {
        case .araArb:
            AraArbCalculatorView(
                store: store.scope(
                    state: \.araArbCalculator,
                    action: \.araArbCalculator
                )
            )
        case .tradingReturn:
            TradingReturnCalculatorView(
                store: store.scope(
                    state: \.tradingReturnCalculator,
                    action: \.tradingReturnCalculator
                ),
                settingsStore: store.scope(
                    state: \.settings,
                    action: \.settings
                )
            )
        case .profitPerTick:
            ProfitPerTickCalculatorView(
                store: store.scope(
                    state: \.profitPerTickCalculator,
                    action: \.profitPerTickCalculator
                ),
                settingsStore: store.scope(
                    state: \.settings,
                    action: \.settings
                )
            )
        case .averagePrice:
            AveragePriceCalculatorView(
                store: store.scope(
                    state: \.averagePriceCalculator,
                    action: \.averagePriceCalculator
                )
            )
        case .riskRewardRatio:
            RiskRewardRatioCalculatorView(
                store: store.scope(
                    state: \.riskRewardRatioCalculator,
                    action: \.riskRewardRatioCalculator
                )
            )
        case .priceBookValue:
            PriceBookValueCalculatorView(
                store: store.scope(
                    state: \.priceBookValueCalculator,
                    action: \.priceBookValueCalculator
                )
            )
        case .dividenYield:
            DividenYieldCalculatorView(
                store: store.scope(
                    state: \.dividenYieldCalculator,
                    action: \.dividenYieldCalculator
                )
            )
        case .stockSplit:
            StockSplitCalculatorView(
                store: store.scope(
                    state: \.stockSplitCalculator,
                    action: \.stockSplitCalculator
                )
            )
        case .rightIssue:
            RightIssueCalculatorView(
                store: store.scope(
                    state: \.rightIssueCalculator,
                    action: \.rightIssueCalculator
                )
            )
        case .lot:
            LotCalculatorView(
                store: store.scope(
                    state: \.lotCalculator,
                    action: \.lotCalculator
                ),
                settingsStore: store.scope(
                    state: \.settings,
                    action: \.settings
                )
            )
        case .settings:
            SettingsView(store: store.scope(state: \.settings, action: \.settings))
        }
    }
}
