//
//  Main.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import Foundation
import ComposableArchitecture
import StockCalculator


@Reducer
struct Main {
    @ObservableState
    struct State: Equatable {
        var showShareSheet: Bool = false

        var settings = Settings.State()
        var araArbCalculator = AraArbCalculator.State()
        var _tradingReturnCalculator = TradingReturnCalculator.State()
        var tradingReturnCalculator: TradingReturnCalculator.State {
            get {
                var state = self._tradingReturnCalculator
                state.brokerFee = BrokerFee(buy: self.settings.buyFee, sell: self.settings.sellFee)
                return state
            } set {
                self._tradingReturnCalculator = newValue
                self.settings.buyFee = newValue.brokerFee.buy
                self.settings.sellFee = newValue.brokerFee.sell
            }
        }
        var profitPerTickCalculator = ProfitPerTickCalculator.State()
        var averagePriceCalculator = AveragePriceCalculator.State()
        var riskRewardRatioCalculator = RiskRewardRatioCalculator.State()
        var priceBookValueCalculator = PriceBookValueCalculator.State()
        var dividenYieldCalculator = DividenYieldCalculator.State()
        var stockSplitCalculator = StockSplitCalculator.State()
        var rightIssueCalculator = RightIssueCalculator.State()
        var lotCalculator = LotCalculator.State()
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)

        case settings(Settings.Action)
        case didTapShareButton

        case tradingReturnCalculator(TradingReturnCalculator.Action)
        case araArbCalculator(AraArbCalculator.Action)
        case profitPerTickCalculator(ProfitPerTickCalculator.Action)
        case averagePriceCalculator(AveragePriceCalculator.Action)
        case riskRewardRatioCalculator(RiskRewardRatioCalculator.Action)
        case priceBookValueCalculator(PriceBookValueCalculator.Action)
        case dividenYieldCalculator(DividenYieldCalculator.Action)
        case stockSplitCalculator(StockSplitCalculator.Action)
        case rightIssueCalculator(RightIssueCalculator.Action)
        case lotCalculator(LotCalculator.Action)
    }

    var body: some ReducerOf<Self> {

        // MARK: Binding Reducer
        BindingReducer()

        // MARK: Main Reducer
        Reduce { state, action in
            switch action {
            case .didTapShareButton:
                state.showShareSheet = true
                return .none
            default:
                return .none
            }
        }

        // MARK: Scopes
        Scope(state: \.settings, action: \.settings) {
            Settings()
        }

        Scope(state: \.araArbCalculator, action: \.araArbCalculator) {
            AraArbCalculator()
        }

        Scope(state: \.tradingReturnCalculator, action: \.tradingReturnCalculator) {
            TradingReturnCalculator()
        }

        Scope(state: \.profitPerTickCalculator, action: \.profitPerTickCalculator) {
            ProfitPerTickCalculator()
        }

        Scope(state: \.averagePriceCalculator, action: \.averagePriceCalculator) {
            AveragePriceCalculator()
        }

        Scope(state: \.riskRewardRatioCalculator, action: \.riskRewardRatioCalculator) {
            RiskRewardRatioCalculator()
        }

        Scope(state: \.priceBookValueCalculator, action: \.priceBookValueCalculator) {
            PriceBookValueCalculator()
        }


        Scope(state: \.dividenYieldCalculator, action: \.dividenYieldCalculator) {
            DividenYieldCalculator()
        }

        Scope(state: \.stockSplitCalculator, action: \.stockSplitCalculator) {
            StockSplitCalculator()
        }

        Scope(state: \.rightIssueCalculator, action: \.rightIssueCalculator) {
            RightIssueCalculator()
        }

        Scope(state: \.lotCalculator, action: \.lotCalculator) {
            LotCalculator()
        }

    }
}

