//
//  DividenYieldCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import Foundation
import ComposableArchitecture
import StockCalculator
import SwiftUI

struct DividenYieldCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator

    struct State: Equatable {
        @BindingState var price: Double = 0
        @BindingState var dividen: Double = 0
        var errors: Validator.Errors = [:]
        
        var dividenYield: Double? = nil
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case validate
        case validateField(_ field: String)
        case calculateButtonTapped
        case calculate
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            
            // Validation Schema
            let validator = Validator.schema([
                ("price", state.price, rules: [RequiredRule([.notZero])]),
                ("dividen", state.dividen, rules: [RequiredRule([.notZero])])
            ], state.errors)
            
            switch action {
            case .validate:
                state.errors = validator.validate()
                return .none
            case let .validateField(field):
                state.errors = validator.validateField(field)
                return .none

            case .binding(\.$price):
                return .send(.validateField("price"))
            case .binding(\.$dividen):
                return .send(.validateField("dividen"))
                
            case .calculateButtonTapped:
                return .merge(.send(.validate), .send(.calculate))
            case .calculate:
                guard state.errors.isEmpty else { return .none }
                
                state.dividenYield = self.stockCalculator.calculateDividenYield(
                    price: state.price,
                    dividen: state.dividen
                )
                return .none

            default:
                return .none
            }
        }
    }
}


