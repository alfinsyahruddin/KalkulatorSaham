//
//  PriceBookValueCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import Foundation
import ComposableArchitecture
import StockCalculator


struct PriceBookValueCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator
    
    struct State: Equatable {
        @BindingState var price: Double = 0
        @BindingState var bookValue: Double = 0
        var errors: Validator.Errors = [:]

        var priceBookValue: Double? = nil
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
                ("bookValue", state.bookValue, rules: [RequiredRule([.notZero])])
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
            case .binding(\.$bookValue):
                return .send(.validateField("bookValue"))
                
            case .calculateButtonTapped:
                return .merge(.send(.validate), .send(.calculate))
            case .calculate:
                guard state.errors.isEmpty else { return .none }
                
                state.priceBookValue = self.stockCalculator.calculatePriceBookValue(
                    price: state.price,
                    bookValue: state.bookValue
                )
                
                return .none
            default:
                return .none
            }
        }
    }
}


