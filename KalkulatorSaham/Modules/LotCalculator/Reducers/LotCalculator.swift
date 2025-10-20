//
//  LotCalculator.swift
//  KalkulatorSaham
//
//  Created by M Alfin Syahruddin on 01/06/25.
//

import SwiftUI
import ComposableArchitecture
import StockCalculator


struct LotCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator
    
    struct State: Equatable {
        @BindingState var price: Double = 0
        @BindingState var maxBuy: Double = 0
        @BindingState var calculateBrokerFee: Bool = true
        var errors: Validator.Errors = [:]

        var lotResult: LotResult? = nil
        var rows: [[String]] = []
        var colors: [[Color]] = []
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case validate
        case validateField(_ field: String)
        case calculateButtonTapped(brokerFee: BrokerFee)
        case calculate(brokerFee: BrokerFee)
        case calculateProfitPerTick(brokerFee: BrokerFee)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            
            // Validation Schema
            let validator = Validator.schema([
                ("price", state.price, rules: [RequiredRule([.notZero])]),
                ("maxBuy", state.maxBuy, rules: [RequiredRule([.notZero])]),
            ], state.errors)
            
            switch action {
            case .validate:
                state.errors = validator.validate()
                return .none
            case let .validateField(field):
                state.errors = validator.validateField(field)
                return .none
                
            case .binding(\.$price):
                return .send(.validateField("price"))
            case .binding(\.$maxBuy):
                return .send(.validateField("maxBuy"))
                
            case let .calculateButtonTapped(brokerFee):
                return .merge(.send(.validate), .send(.calculate(brokerFee: brokerFee)))
            case let .calculate(brokerFee):
                guard state.errors.isEmpty else { return .none }
                
                state.lotResult = self.stockCalculator.calculateLot(
                    price: state.price,
                    maxBuy: state.maxBuy
                )
                
                return .send(.calculateProfitPerTick(brokerFee: brokerFee))
                
            case let .calculateProfitPerTick(brokerFee):
                guard state.errors.isEmpty else { return .none }
                                
                let limit = 10
                let profitPerTicks = self.stockCalculator.calculateProfitPerTick(
                    price: state.price,
                    lot: state.lotResult?.lot ?? 0,
                    brokerFee: state.calculateBrokerFee
                        ? brokerFee
                        : BrokerFee(buy: 0, sell: 0),
                    limit: limit
                )
                
                
                var rows: [[String]] = []
                var colors: [[Color]] = []
                let down = profitPerTicks.filter { $0.price <= state.price }.sorted { $0.price > $1.price }
                let up = profitPerTicks.filter { $0.price > state.price }
                
                for index in 0..<limit+1 {
                    rows.append([
                        down[safe: index]?.value.f() ?? "",
                        down[safe: index]?.percentage.f().percentage() ?? "",
                        down[safe: index]?.price.f() ?? "",
                        up[safe: index]?.price.f() ?? "",
                        up[safe: index]?.percentage.f().percentage() ?? "",
                        up[safe: index]?.value.f() ?? ""
                    ])
                    
                    colors.append([
                        (down[safe: index]?.value ?? 0).getColor(),
                        (down[safe: index]?.percentage ?? 0).getColor(),
                        (down[safe: index]?.price ?? 0).getColor(state.price),
                        (up[safe: index]?.price ?? 0).getColor(state.price),
                        (up[safe: index]?.percentage ?? 0).getColor(),
                        (up[safe: index]?.value ?? 0).getColor()
                    ])
                }
                
                state.rows = rows
                state.colors = colors
                
                return .none
            default:
                return .none
            }
        }
    }
}


