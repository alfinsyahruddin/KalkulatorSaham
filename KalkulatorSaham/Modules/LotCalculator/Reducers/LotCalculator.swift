//
//  LotCalculator.swift
//  KalkulatorSaham
//
//  Created by M Alfin Syahruddin on 01/06/25.
//

import SwiftUI
import ComposableArchitecture
import StockCalculator

public struct LotCalculationResult: Equatable, Sendable {
    public var lot: Double
    public var buyValue: Double
    public var buyFee: Double
    public var stampDuty: Double
    public var totalPaid: Double

    public init(
        lot: Double = 0,
        buyValue: Double = 0,
        buyFee: Double = 0,
        stampDuty: Double = 0,
        totalPaid: Double = 0
    ) {
        self.lot = lot
        self.buyValue = buyValue
        self.buyFee = buyFee
        self.stampDuty = stampDuty
        self.totalPaid = totalPaid
    }

    public var value: Double { totalPaid }
}

@Reducer
struct LotCalculator {
    @Dependency(\.stockCalculator) var stockCalculator

    @ObservableState
    struct State: Equatable {
        var price: Double = 0
        var maxBuy: Double = 0
        var calculateBrokerFee: Bool = true
        var calculateStampDuty: Bool = true
        var errors: Validator.Errors = [:]

        var lotResult: LotCalculationResult? = nil
        var rows: [[String]] = []
        var colors: [[Color]] = []
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case validate
        case validateField(_ field: String)
        case calculateButtonTapped(brokerFee: BrokerFee, stampDutyFee: Double, stampDutyThreshold: Double)
        case calculate(brokerFee: BrokerFee, stampDutyFee: Double, stampDutyThreshold: Double)
        case calculateProfitPerTick(brokerFee: BrokerFee)
    }

    var body: some ReducerOf<Self> {
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

            case .binding(\.price):
                return .send(.validateField("price"))
            case .binding(\.maxBuy):
                return .send(.validateField("maxBuy"))

            case let .calculateButtonTapped(brokerFee, stampDutyFee, stampDutyThreshold):
                return .concatenate(
                    .send(.validate),
                    .send(.calculate(brokerFee: brokerFee, stampDutyFee: stampDutyFee, stampDutyThreshold: stampDutyThreshold))
                )
            case let .calculate(brokerFee, stampDutyFee, stampDutyThreshold):
                guard state.errors.isEmpty else { return .none }

                calculateResult(
                    state: &state,
                    brokerFee: brokerFee,
                    stampDutyFee: stampDutyFee,
                    stampDutyThreshold: stampDutyThreshold
                )
                return .send(.calculateProfitPerTick(brokerFee: brokerFee))

            case let .calculateProfitPerTick(brokerFee):
                guard state.errors.isEmpty else { return .none }

                calculateProfitPerTickResult(state: &state, brokerFee: brokerFee)
                return .none
            default:
                return .none
            }
        }
    }

    /// Shared by live submissions and session restoration.
    func calculateResult(
        state: inout State,
        brokerFee: BrokerFee,
        stampDutyFee: Double,
        stampDutyThreshold: Double
    ) {
        let sharesPerLot: Double = self.stockCalculator.sharesPerLot
        guard state.price > 0, state.maxBuy > 0, sharesPerLot > 0 else {
            state.lotResult = LotCalculationResult()
            return
        }

        let feeRate = state.calculateBrokerFee ? (brokerFee.buy / 100.0) : 0.0
        let costPerLotWithoutStampDuty = state.price * sharesPerLot * (1.0 + feeRate)
        guard costPerLotWithoutStampDuty > 0 else {
            state.lotResult = LotCalculationResult()
            return
        }

        func computeBreakdown(for lot: Double) -> (buyValue: Double, buyFee: Double, stampDuty: Double, totalPaid: Double) {
            let buyValue = state.price * lot * sharesPerLot
            let buyFee = state.calculateBrokerFee ? (buyValue * feeRate) : 0.0
            let stampDuty = (state.calculateStampDuty && buyValue > stampDutyThreshold) ? stampDutyFee : 0.0
            let totalPaid = buyValue + buyFee + stampDuty
            return (buyValue, buyFee, stampDuty, totalPaid)
        }

        var candidateLot = floor(state.maxBuy / costPerLotWithoutStampDuty)

        while candidateLot > 0 && computeBreakdown(for: candidateLot).totalPaid > state.maxBuy {
            candidateLot -= 1
        }

        let breakdown = computeBreakdown(for: candidateLot)
        state.lotResult = LotCalculationResult(
            lot: candidateLot,
            buyValue: breakdown.buyValue,
            buyFee: breakdown.buyFee,
            stampDuty: breakdown.stampDuty,
            totalPaid: breakdown.totalPaid
        )
    }

    /// Shared by live submissions and session restoration.
    func calculateProfitPerTickResult(state: inout State, brokerFee: BrokerFee) {
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
    }

}
