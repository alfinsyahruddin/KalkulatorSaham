//
//  AraArbCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import Foundation
import ComposableArchitecture
import StockCalculator


struct AraArbCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator

    struct State: Equatable {
        @BindingState var price: Double = 0
        @BindingState var type: Int = 0
        
        var autoRejectPrice: Double = 0
        var autoRejects: AutoRejects? = nil
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
                guard state.price > 0 else { return .none }
                
                var type: AutoRejectType
                switch state.type {
                case 0:
                    type = .symmetric
                case 1:
                    type = .asymmetric
                case 2:
                    type = .acceleration
                default:
                    type = .symmetric
                }

                state.autoRejectPrice = state.price
                state.autoRejects = self.stockCalculator.calculateAutoRejects(
                    price: state.price,
                    type: type,
                    limit: 5
                )
                state.autoRejects?.ara.reverse()
                return .none
            default:
                return .none
            }
        }
    }
}

