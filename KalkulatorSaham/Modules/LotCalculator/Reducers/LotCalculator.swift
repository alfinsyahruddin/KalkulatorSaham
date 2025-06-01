//
//  LotCalculator.swift
//  KalkulatorSaham
//
//  Created by M Alfin Syahruddin on 01/06/25.
//

import Foundation
import ComposableArchitecture
import StockCalculator


struct LotCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator
    
    struct State: Equatable {
        @BindingState var price: Double = 0
        @BindingState var maxBuy: Double = 0
        var errors: Validator.Errors = [:]

        var lotResult: LotResult? = nil
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
                ("maxBuy", state.maxBuy, rules: [RequiredRule([.notZero])]),
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
            case .binding(\.$maxBuy):
                return .send(.validateField("maxBuy"))
                
            case .calculateButtonTapped:
                return .merge(.send(.validate), .send(.calculate))
            case .calculate:
                guard state.errors.isEmpty else { return .none }
                
                state.lotResult = self.stockCalculator.calculateLot(
                    price: state.price,
                    maxBuy: state.maxBuy
                )
                
                return .none
            default:
                return .none
            }
        }
    }
}


