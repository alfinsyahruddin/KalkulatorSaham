//
//  ProfitLossCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import Foundation
import ComposableArchitecture

struct ProfitLossCalculator: ReducerProtocol {
    struct State: Equatable {
        var price: Int = 0
    }
    
    enum Action: Equatable {
        case setPrice(price: Int)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .setPrice(let price):
                state.price = price
                return .none
            }
        }
    }
}

