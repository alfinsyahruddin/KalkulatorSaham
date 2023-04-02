//
//  StockSplitCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//



import Foundation
import ComposableArchitecture
import StockCalculator


struct StockSplitCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator
    
    struct State: Equatable {
        @BindingState var price: Double = 0
        @BindingState var oldRatio: Double = 0
        @BindingState var newRatio: Double = 0
        
        var stockSplit: Double? = nil
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
                      state.oldRatio > 0,
                      state.newRatio > 0
                else { return .none }
                
                state.stockSplit = self.stockCalculator.calculateStockSplit(
                    price: state.price,
                    oldRatio: state.oldRatio,
                    newRatio: state.newRatio
                )
                
                return .none
            default:
                return .none
            }
        }
    }
}


