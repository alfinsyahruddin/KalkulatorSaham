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
        
        var priceBookValue: Double? = nil
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case calculateButtonTapped
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .calculateButtonTapped:
                guard state.price > 0,
                      state.bookValue > 0
                else { return .none }
                
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


