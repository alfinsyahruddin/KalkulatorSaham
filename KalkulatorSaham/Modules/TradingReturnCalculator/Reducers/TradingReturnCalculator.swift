//
//  TradingReturnCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import Foundation
import ComposableArchitecture
import StockCalculator


struct TradingReturnCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator

    
    struct State: Equatable {
        @BindingState var buyPrice: Double = 0
        @BindingState var sellPrice: Double = 0
        @BindingState var lot: Double = 0
        @BindingState var calculateBrokerFee: Bool = true

        var tradingReturn: TradingReturn? = nil
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case calculateButtonTapped(brokerFee: BrokerFee)
    }
    
    var body: some ReducerProtocol<State, Action> {
        
        BindingReducer()
        
        
        Reduce { state, action in
            switch action {
            case .calculateButtonTapped(let brokerFee):
                state.tradingReturn = self.stockCalculator.calculateTradingReturn(
                    buyPrice: state.buyPrice,
                    sellPrice: state.sellPrice,
                    lot: state.lot,
                    brokerFee: state.calculateBrokerFee
                        ? brokerFee
                        : BrokerFee(buy: 0, sell: 0)
                )
                return .none
            default:
                return .none
            }
        }
        
        
        
    }
}

