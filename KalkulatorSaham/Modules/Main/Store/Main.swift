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
        var profitLossCalculator = ProfitLossCalculator.State()
    }
    
    enum Action: Equatable {
        case profitLossCalculator(ProfitLossCalculator.Action)
        case didTapShareButton
        case didTapSettingsButton
    }
    
    var body: some ReducerProtocol<State, Action> {
        
        Reduce { state, action in
            switch action {
            case .didTapShareButton:
                return .none
            case .didTapSettingsButton:
                return .none
            default:
                return .none
            }
        }
        
        Scope(state: \.profitLossCalculator, action: /Action.profitLossCalculator) {
            ProfitLossCalculator()
        }
    }
}

