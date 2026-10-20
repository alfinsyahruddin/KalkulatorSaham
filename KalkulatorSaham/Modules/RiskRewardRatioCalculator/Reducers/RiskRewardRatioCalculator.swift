//
//  RiskRewardRatioCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import Foundation
import ComposableArchitecture
import StockCalculator


@Reducer
struct RiskRewardRatioCalculator {
    @Dependency(\.stockCalculator) var stockCalculator

    @ObservableState
    struct State: Equatable {
        var buyPrice: Double = 0
        var targetPrice: Double = 0
        var stopLossPrice: Double = 0
        var errors: Validator.Errors = [:]

        var riskRewardRatio: RiskRewardRatio? = nil
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case validate
        case validateField(_ field: String)
        case calculateButtonTapped
        case calculate
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in

            // Validation Schema
            let validator = Validator.schema([
                ("buyPrice", state.buyPrice, rules: [RequiredRule([.notZero])]),
                ("targetPrice", state.targetPrice, rules: [RequiredRule([.notZero])]),
                ("stopLossPrice", state.stopLossPrice, rules: [RequiredRule([.notZero])])
            ], state.errors)

            switch action {
            case .validate:
                state.errors = validator.validate()
                return .none
            case let .validateField(field):
                state.errors = validator.validateField(field)
                return .none

            case .binding(\.buyPrice):
                return .send(.validateField("buyPrice"))
            case .binding(\.targetPrice):
                return .send(.validateField("targetPrice"))
            case .binding(\.stopLossPrice):
                return .send(.validateField("stopLossPrice"))

            case .calculateButtonTapped:
                return .concatenate(.send(.validate), .send(.calculate))
            case .calculate:
                guard state.errors.isEmpty else { return .none }

                state.riskRewardRatio = self.stockCalculator.calculateRiskRewardRatio(
                    buyPrice: state.buyPrice,
                    targetPrice: state.targetPrice,
                    stopLossPrice: state.stopLossPrice
                )

                return .none
            default:
                return .none
            }
        }
    }
}


