//
//  AraArbCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import Foundation
import ComposableArchitecture
import StockCalculator


@Reducer
struct AraArbCalculator {
    @Dependency(\.stockCalculator) var stockCalculator

    @ObservableState
    struct State: Equatable {
        var price: Double = 0
        var type: Int = 0
        var errors: Validator.Errors = [:]

        var autoRejectPrice: Double = 0
        var autoRejects: AutoRejects? = nil
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
                ("price", state.price, rules: [RequiredRule([.notZero])])
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

            case .calculateButtonTapped:
                return .concatenate(.send(.validate), .send(.calculate))
            case .calculate:
                guard state.errors.isEmpty else { return .none }

                var type: AutoRejectType
                switch state.type {
                case 0:
                    type = .symmetric
                case 1:
                    type = .asymmetric
                case 2:
                    type = .acceleration
                default:
                    type = .symmetric
                }

                state.autoRejectPrice = state.price
                state.autoRejects = self.stockCalculator.calculateAutoRejects(
                    price: state.price,
                    type: type,
                    limit: 5
                )
                state.autoRejects?.ara.reverse()
                return .none
            default:
                return .none
            }
        }
    }
}

