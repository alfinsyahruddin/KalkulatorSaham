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
        var value: Double = 0
        var errors: Validator.Errors = [:]

        var portfolio: Portfolio? = nil
        var transactions: [Transaction] = []
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case validate
        case validateField(_ field: String)
        case buyButtonTapped
        case buy
        case deleteButtonTapped(index: Int)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        
        Reduce { state, action in
            
            // Validation Schema
            let validator = Validator.schema([
                ("price", state.price, rules: [RequiredRule([.notZero])]),
                ("lot", state.lot, rules: [RequiredRule([.notZero])])
            ], state.errors)
            
            switch action {
            case .validate:
                state.errors = validator.validate()
                return .none
            case let .validateField(field):
                state.errors = validator.validateField(field)
                return .none
                
            case .binding(\.$price):
                state.value = state.price * (state.lot * self.stockCalculator.sharesPerLot)
                return .send(.validateField("price"))
            case .binding(\.$lot):
                state.value = state.price * (state.lot * self.stockCalculator.sharesPerLot)
                return .send(.validateField("lot"))
                
            case .buyButtonTapped:
                return .merge(.send(.validate), .send(.buy))
            case .buy:
                guard state.errors.isEmpty else { return .none }
                
                state.transactions.insert(
                    Transaction(
                        price: state.price,
                        lot: state.lot,
                        value: state.value
                    ),
                    at: 0
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
            default:
                return .none
            }
        }
    }
}

