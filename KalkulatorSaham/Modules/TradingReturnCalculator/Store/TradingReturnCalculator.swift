//
//  TradingReturnCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import Foundation
import ComposableArchitecture

struct TradingReturnCalculator: ReducerProtocol {
    struct State: Equatable {
        @BindingState var buyPrice = ""
        @BindingState var sellPrice = ""
        @BindingState var lot = ""
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
//            case .binding(\.$buyPrice):
//                print("buyPrice: \(state.buyPrice)")
//                return .none
            default:
                return .none
            }
        }
    }
}

