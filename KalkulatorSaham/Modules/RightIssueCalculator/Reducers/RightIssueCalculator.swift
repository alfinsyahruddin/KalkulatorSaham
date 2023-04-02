//
//  RightIssueCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import Foundation
import ComposableArchitecture
import StockCalculator


struct RightIssueCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator
    
    struct State: Equatable {
        @BindingState var ticker: String = "BBHI"
        @BindingState var cumDatePrice: Double = 800
        @BindingState var lot: Double = 1000
        @BindingState var exercisePrice: Double = 250
        @BindingState var oldRatio: Double = 1000
        @BindingState var newRatio: Double = 300
        @BindingState var theoreticalPrice: Double = 0
        @BindingState var currentPrice: Double = 0
        
        var rightIssue: RightIssue? = nil
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
                guard state.ticker.count > 0,
                      state.cumDatePrice > 0,
                      state.lot > 0,
                      state.exercisePrice > 0,
                      state.oldRatio > 0,
                      state.newRatio > 0
                else { return .none }
                
                state.rightIssue = self.stockCalculator.calculateRightIssue(
                    ticker: state.ticker,
                    cumDatePrice: state.cumDatePrice,
                    lot: state.lot,
                    exercisePrice: state.exercisePrice,
                    oldRatio: state.oldRatio,
                    newRatio: state.newRatio
                )
                state.theoreticalPrice = state.rightIssue!.theoreticalPrice
                state.currentPrice = state.rightIssue!.theoreticalPrice

                return .none
                
            case .binding(\.$currentPrice):
                state.rightIssue = self.stockCalculator.calculateRightIssue(
                    ticker: state.ticker,
                    cumDatePrice: state.cumDatePrice,
                    lot: state.lot,
                    exercisePrice: state.exercisePrice,
                    oldRatio: state.oldRatio,
                    newRatio: state.newRatio,
                    currentPrice: state.currentPrice
                )
                state.theoreticalPrice = state.rightIssue!.theoreticalPrice
                
                return .none
                
            default:
                return .none
            }
        }
    }
}


