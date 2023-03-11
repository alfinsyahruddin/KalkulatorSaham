//
//  ProfitPerTickCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI
import ComposableArchitecture
import StockCalculator

struct ProfitPerTickCalculator: ReducerProtocol {
    @Dependency(\.stockCalculator) var stockCalculator

    struct State: Equatable {
        @BindingState var price: Double = 0
        @BindingState var lot: Double = 0
        @BindingState var calculateBrokerFee: Bool = true

        var rows: [[String]] = []
        var colors: [[Color]] = []
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case calculateButtonTapped(brokerFee: BrokerFee)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .calculateButtonTapped(let brokerFee):
                guard state.price > 0 && state.lot > 0 else { return .none }
                
                let limit = 10
                let profitPerTicks = self.stockCalculator.calculateProfitPerTick(
                    price: state.price,
                    lot: state.lot,
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
