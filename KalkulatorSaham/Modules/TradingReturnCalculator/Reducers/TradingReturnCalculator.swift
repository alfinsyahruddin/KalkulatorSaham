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
        var errors: Validator.Errors = [:]

        var tradingReturn: TradingReturn? = nil
        var brokerFee: BrokerFee = BrokerFee(buy: 0, sell: 0)
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
                ("buyPrice", state.buyPrice, rules: [RequiredRule([.notZero])]),
                ("sellPrice", state.sellPrice, rules: [RequiredRule([.notZero])]),
                ("lot", state.lot, rules: [RequiredRule([.notZero])])
            ], state.errors)
            
            switch action {
            case .validate:
                state.errors = validator.validate()
                return .none
            case let .validateField(field):
                state.errors = validator.validateField(field)
                return .none
                
            case .binding(\.$buyPrice):
                return .send(.validateField("buyPrice"))
            case .binding(\.$sellPrice):
                return .send(.validateField("sellPrice"))
            case .binding(\.$lot):
                return .send(.validateField("lot"))
                
            case .calculateButtonTapped:
                return .merge(.send(.validate), .send(.calculate))
            case .calculate:
                guard state.errors.isEmpty else { return .none }

                print("BROKER FEE: \(state.brokerFee)")
                state.tradingReturn = self.stockCalculator.calculateTradingReturn(
                    buyPrice: state.buyPrice,
                    sellPrice: state.sellPrice,
                    lot: state.lot,
                    brokerFee: state.calculateBrokerFee
                        ? state.brokerFee
                        : BrokerFee(buy: 0, sell: 0)
                )
                return .none
            default:
                return .none
            }
        }
        
        
        
    }
}

