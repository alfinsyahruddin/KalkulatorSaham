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
        var araArbCalculator = AraArbCalculator.State()
        var profitPerTickCalculator = ProfitPerTickCalculator.State()
    }
    
    enum Action: Equatable {
        case settings(Settings.Action)
        case tradingReturnCalculator(TradingReturnCalculator.Action)
        case araArbCalculator(AraArbCalculator.Action)
        case profitPerTickCalculator(ProfitPerTickCalculator.Action)
        case didTapShareButton
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.settings, action: /Action.settings) {
            Settings()
        }
        
        Scope(state: \.araArbCalculator, action: /Action.araArbCalculator) {
            AraArbCalculator()
        }
        
        Scope(state: \.tradingReturnCalculator, action: /Action.tradingReturnCalculator) {
            TradingReturnCalculator()
        }
        
        Scope(state: \.profitPerTickCalculator, action: /Action.profitPerTickCalculator) {
            ProfitPerTickCalculator()
        }
        
        
        Reduce { state, action in
            switch action {
            case .didTapShareButton:
                return .none
            default:
                return .none
            }
        }
   
      
    }
}

