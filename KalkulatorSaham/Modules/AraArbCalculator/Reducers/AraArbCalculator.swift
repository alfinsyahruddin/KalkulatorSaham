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
        var araPercentage: Double = 25
        var arbPercentage: Double = 15

        var usesCustomPercentages: Bool { type == 3 }
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

            let usesCustomPercentages = state.usesCustomPercentages

            // Validation Schema
            let validator = Validator.schema([
                ("price", state.price, rules: [RequiredRule([.notZero])]),
                ("araPercentage", state.araPercentage, rules: [
                    CustomRule("percentage_must_be_between_0_and_100".tr()) { value in
                        guard usesCustomPercentages else { return true }
                        guard let percentage = Double(value) else { return false }
                        return percentage.isFinite && (0...100).contains(percentage)
                    }
                ]),
                ("arbPercentage", state.arbPercentage, rules: [
                    CustomRule("percentage_must_be_between_0_and_100".tr()) { value in
                        guard usesCustomPercentages else { return true }
                        guard let percentage = Double(value) else { return false }
                        return percentage.isFinite && (0...100).contains(percentage)
                    }
                ])
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

            case .binding(\.araPercentage):
                return .send(.validateField("araPercentage"))
            case .binding(\.arbPercentage):
                return .send(.validateField("arbPercentage"))
            case .binding(\.type):
                if !state.usesCustomPercentages {
                    state.errors.removeValue(forKey: "araPercentage")
                    state.errors.removeValue(forKey: "arbPercentage")
                    return .none
                }
                return .concatenate(
                    .send(.validateField("araPercentage")),
                    .send(.validateField("arbPercentage"))
                )

            case .calculateButtonTapped:
                return .concatenate(.send(.validate), .send(.calculate))
            case .calculate:
                state.errors = validator.validate()
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
                    limit: 5,
                    araPercentage: state.usesCustomPercentages ? state.araPercentage : nil,
                    arbPercentage: state.usesCustomPercentages ? state.arbPercentage : nil
                )
                state.autoRejects?.ara.reverse()
                return .none
            default:
                return .none
            }
        }
    }
}

