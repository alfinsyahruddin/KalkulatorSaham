//
//  AveragePriceCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import Foundation
import ComposableArchitecture
import StockCalculator


struct AveragePriceCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator
    
    struct State: Equatable {
        @BindingState var price: Double = 0
        @BindingState var lot: Double = 0
        @BindingState var value: Double = 0

        var portfolio: Portfolio? = nil
        var transactions: [Transaction] = []
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case buyButtonTapped
        case deleteButtonTapped(index: Int)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .buyButtonTapped:
                guard state.price > 0,
                      state.lot > 0
                else { return .none }
           
                state.transactions.append(
                    Transaction(
                        price: state.price,
                        lot: state.lot,
                        value: state.value
                    )
                )
                state.portfolio = self.stockCalculator.calculateAveragePrice(
                    transactions: state.transactions
                )
                return .none
            case let .deleteButtonTapped(index):
                state.transactions.remove(at: index)
                state.portfolio = self.stockCalculator.calculateAveragePrice(
                    transactions: state.transactions
                )
                return .none
            case .binding(\.$price):
                state.value = state.price * (state.lot * self.stockCalculator.sharesPerLot)
                return .none
            case .binding(\.$lot):
                state.value = state.price * (state.lot * self.stockCalculator.sharesPerLot)
                return .none
            default:
                return .none
            }
        }
    }
}

