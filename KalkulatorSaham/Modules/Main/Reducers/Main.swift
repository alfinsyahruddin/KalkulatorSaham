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
    @Dependency(\.userDefaults) var userDefaults
    @ObservableState
    struct State: Equatable {
        var showShareSheet: Bool = false
        var path: [CalculatorScreen] = []
        var selectedScreen: CalculatorScreen? {
            get { path.last }
            set { path = newValue.map { [$0] } ?? [] }
        }
        var session = CalculationSession()

        static func restored() -> Self {
            @Dependency(\.userDefaults) var userDefaults
            guard let data = userDefaults.data(forKey: CalculationSession.storageKey),
                  let session = try? JSONDecoder().decode(CalculationSession.self, from: data),
                  session.version == 1 else { return Self() }
            var state = Self()
            session.restore(into: &state)
            return state
        }

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

        // Run after child reducers so only completed, valid submissions are saved.
        Reduce { state, action in
            let screen: CalculatorScreen?
            switch action {
            case .araArbCalculator(.calculate) where state.araArbCalculator.errors.isEmpty: screen = .araArb
            case .tradingReturnCalculator(.calculate) where state.tradingReturnCalculator.errors.isEmpty: screen = .tradingReturn
            case .profitPerTickCalculator(.calculate) where state.profitPerTickCalculator.errors.isEmpty: screen = .profitPerTick
            case .averagePriceCalculator(.buy) where state.averagePriceCalculator.errors.isEmpty: screen = .averagePrice
            case .averagePriceCalculator(.deleteButtonTapped): screen = .averagePrice
            case .riskRewardRatioCalculator(.calculate) where state.riskRewardRatioCalculator.errors.isEmpty: screen = .riskRewardRatio
            case .priceBookValueCalculator(.calculate) where state.priceBookValueCalculator.errors.isEmpty: screen = .priceBookValue
            case .dividenYieldCalculator(.calculate) where state.dividenYieldCalculator.errors.isEmpty: screen = .dividenYield
            case .stockSplitCalculator(.calculate) where state.stockSplitCalculator.errors.isEmpty: screen = .stockSplit
            case .rightIssueCalculator(.calculate) where state.rightIssueCalculator.errors.isEmpty: screen = .rightIssue
            case .rightIssueCalculator(.binding(\.currentPrice)) where state.rightIssueCalculator.rightIssue != nil: screen = .rightIssue
            case .lotCalculator(.calculateProfitPerTick) where state.lotCalculator.errors.isEmpty: screen = .lot
            case .binding(\.path), .binding(\.selectedScreen): screen = nil
            default: return .none
            }
            if let screen {
                let brokerFee: BrokerFee?
                switch action {
                case let .profitPerTickCalculator(.calculate(fee)),
                     let .lotCalculator(.calculateProfitPerTick(fee)):
                    brokerFee = fee
                default:
                    brokerFee = nil
                }
                let snapshot = state
                state.session.capture(screen, from: snapshot, brokerFee: brokerFee)
            }
            state.session.path = state.path
            if let data = try? JSONEncoder().encode(state.session) {
                userDefaults.set(data, forKey: CalculationSession.storageKey)
            }
            return .none
        }

    }
}

