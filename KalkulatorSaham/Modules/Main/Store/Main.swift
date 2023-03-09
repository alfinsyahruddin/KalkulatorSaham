//
//  Main.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import Foundation
import ComposableArchitecture


struct Main: ReducerProtocol {
    struct State: Equatable {
        var settings = Settings.State()
        var tradingReturnCalculator = TradingReturnCalculator.State()
    }
    
    enum Action: Equatable {
        case settings(Settings.Action)
        case tradingReturnCalculator(TradingReturnCalculator.Action)
        case didTapShareButton
    }
    
    var body: some ReducerProtocol<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .didTapShareButton:
                return .none
            default:
                return .none
            }
        }
   
        
        Scope(state: \.settings, action: /Action.settings) {
            Settings()
        }
        
        Scope(state: \.tradingReturnCalculator, action: /Action.tradingReturnCalculator) {
            TradingReturnCalculator()
        }
    }
}

