//
//  DividenYieldCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import Foundation
import ComposableArchitecture
import StockCalculator


struct DividenYieldCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator
    
    struct State: Equatable {
        @BindingState var price: Double = 0
        @BindingState var dividen: Double = 0
        
        var dividenYield: Double? = nil
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
                      state.dividen > 0
                else { return .none }
                
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


