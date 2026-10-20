//
//  StockSplitCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import Foundation
import ComposableArchitecture
import StockCalculator


@Reducer
struct StockSplitCalculator {
    @Dependency(\.stockCalculator) var stockCalculator

    @ObservableState
    struct State: Equatable {
        var price: Double = 0
        var oldRatio: Double = 0
        var newRatio: Double = 0
        var errors: Validator.Errors = [:]

        var stockSplit: Double? = nil
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
                ("price", state.price, rules: [RequiredRule([.notZero])]),
                ("oldRatio", state.oldRatio, rules: [RequiredRule([.notZero])]),
                ("newRatio", state.newRatio, rules: [RequiredRule([.notZero])])
            ], state.errors)

            switch action {
            case .validate:
                state.errors = validator.validate()
                return .none
            case let .validateField(field):
                state.errors = validator.validateField(field)
                return .none

            case .binding(\.price):
                return .send(.validateField("price"))
            case .binding(\.oldRatio):
                return .send(.validateField("oldRatio"))
            case .binding(\.newRatio):
                return .send(.validateField("newRatio"))

            case .calculateButtonTapped:
                return .concatenate(.send(.validate), .send(.calculate))
            case .calculate:
                guard state.errors.isEmpty else { return .none }

                calculateResult(state: &state)
                return .none
            default:
                return .none
            }
        }
    }

    /// Shared by live submissions and session restoration.
    func calculateResult(state: inout State) {
        state.stockSplit = self.stockCalculator.calculateStockSplit(
            price: state.price,
            oldRatio: state.oldRatio,
            newRatio: state.newRatio
        )
    }

}


