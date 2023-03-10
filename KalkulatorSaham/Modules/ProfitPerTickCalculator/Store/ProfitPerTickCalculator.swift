//
//  ProfitPerTickCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import Foundation
import ComposableArchitecture

struct ProfitPerTickCalculator: ReducerProtocol {
    struct State: Equatable {
        @BindingState var price = ""
        @BindingState var lot = ""
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
