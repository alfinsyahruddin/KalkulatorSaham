//
//  RiskRewardRatioCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import Foundation
import ComposableArchitecture
import StockCalculator


struct RiskRewardRatioCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator
    
    struct State: Equatable {
        @BindingState var buyPrice: Double = 0
        @BindingState var targetPrice: Double = 0
        @BindingState var stopLossPrice: Double = 0
        
        var riskRewardRatio: RiskRewardRatio? = nil
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
                guard state.buyPrice > 0,
                      state.targetPrice > 0,
                      state.stopLossPrice > 0
                else { return .none }
               
                state.riskRewardRatio = self.stockCalculator.calculateRiskRewardRatio(
                    buyPrice: state.buyPrice,
                    targetPrice: state.targetPrice,
                    stopLossPrice: state.stopLossPrice
                )
                
                return .none
            default:
                return .none
            }
        }
    }
}


