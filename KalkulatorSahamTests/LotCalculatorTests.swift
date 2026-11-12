import ComposableArchitecture
import Foundation
import StockCalculator
import Testing
@testable import KalkulatorSaham

@MainActor
struct LotCalculatorTests {
    @Test func calculatesWithoutFeesWhenBothTogglesOff() async {
        let store = TestStore(initialState: LotCalculator.State(
            price: 1000,
            maxBuy: 10_000_000,
            calculateBrokerFee: false,
            calculateStampDuty: false
        )) {
            LotCalculator()
        }
        store.exhaustivity = .off

        await store.send(.calculateButtonTapped(
            brokerFee: BrokerFee(buy: 0.15, sell: 0.25),
            stampDutyFee: 10_000,
            stampDutyThreshold: 10_000_000
        ))
        await store.receive(\.validate)
        await store.receive(\.calculate)
        await store.receive(\.calculateProfitPerTick)

        #expect(store.state.lotResult == LotCalculationResult(
            lot: 100,
            buyValue: 10_000_000,
            buyFee: 0,
            stampDuty: 0,
            totalPaid: 10_000_000
        ))
        #expect(store.state.rows.count == 11)
    }

    @Test func calculatesWithBrokerFeeOnlyWhenStampDutyBelowThreshold() async {
        let store = TestStore(initialState: LotCalculator.State(
            price: 1000,
            maxBuy: 10_015_000,
            calculateBrokerFee: true,
            calculateStampDuty: true
        )) {
            LotCalculator()
        }
        store.exhaustivity = .off

        await store.send(.calculateButtonTapped(
            brokerFee: BrokerFee(buy: 0.15, sell: 0.25),
            stampDutyFee: 10_000,
            stampDutyThreshold: 10_000_000
        ))
        await store.receive(\.validate)
        await store.receive(\.calculate)
        await store.receive(\.calculateProfitPerTick)

        // Exactly 100 lots = 10,000,000 buyValue which is NOT > 10,000,000 threshold.
        // buyFee = 15,000. totalPaid = 10,015,000 <= maxBuy.
        #expect(store.state.lotResult == LotCalculationResult(
            lot: 100,
            buyValue: 10_000_000,
            buyFee: 15_000,
            stampDuty: 0,
            totalPaid: 10_015_000
        ))
        #expect(store.state.rows.count == 11)
    }

    @Test func appliesStampDutyWhenBuyValueExceedsThreshold() async {
        let store = TestStore(initialState: LotCalculator.State(
            price: 1000,
            maxBuy: 10_130_000,
            calculateBrokerFee: true,
            calculateStampDuty: true
        )) {
            LotCalculator()
        }
        store.exhaustivity = .off

        await store.send(.calculateButtonTapped(
            brokerFee: BrokerFee(buy: 0.15, sell: 0.25),
            stampDutyFee: 10_000,
            stampDutyThreshold: 10_000_000
        ))
        await store.receive(\.validate)
        await store.receive(\.calculate)
        await store.receive(\.calculateProfitPerTick)

        // 101 lots = 10,100,000 buyValue (> 10,000,000 threshold).
        // buyFee = 10,100,000 * 0.0015 = 15,150.
        // stampDuty = 10,000.
        // totalPaid = 10,125,150 <= 10,130,000.
        #expect(store.state.lotResult == LotCalculationResult(
            lot: 101,
            buyValue: 10_100_000,
            buyFee: 15_150,
            stampDuty: 10_000,
            totalPaid: 10_125_150
        ))
        #expect(store.state.rows.count == 11)
    }

    @Test func stepsDownWhenStampDutyPushesTotalPaidOverMaxBuy() async {
        let store = TestStore(initialState: LotCalculator.State(
            price: 1000,
            maxBuy: 10_120_000,
            calculateBrokerFee: true,
            calculateStampDuty: true
        )) {
            LotCalculator()
        }
        store.exhaustivity = .off

        // 10,120,000 can afford 101 lots without stamp duty (10,115,150),
        // but with stamp duty (10,125,150) it exceeds 10,120,000.
        // It must step down to 100 lots, which incurs no stamp duty (total: 10,015,000).
        await store.send(.calculateButtonTapped(
            brokerFee: BrokerFee(buy: 0.15, sell: 0.25),
            stampDutyFee: 10_000,
            stampDutyThreshold: 10_000_000
        ))
        await store.receive(\.validate)
        await store.receive(\.calculate)
        await store.receive(\.calculateProfitPerTick)

        #expect(store.state.lotResult == LotCalculationResult(
            lot: 100,
            buyValue: 10_000_000,
            buyFee: 15_000,
            stampDuty: 0,
            totalPaid: 10_015_000
        ))
        #expect(store.state.rows.count == 11)
    }

    @Test func disablingStampDutyToggleAllowsHigherLotWithoutDuty() async {
        let store = TestStore(initialState: LotCalculator.State(
            price: 1000,
            maxBuy: 10_120_000,
            calculateBrokerFee: true,
            calculateStampDuty: false
        )) {
            LotCalculator()
        }
        store.exhaustivity = .off

        await store.send(.calculateButtonTapped(
            brokerFee: BrokerFee(buy: 0.15, sell: 0.25),
            stampDutyFee: 10_000,
            stampDutyThreshold: 10_000_000
        ))
        await store.receive(\.validate)
        await store.receive(\.calculate)
        await store.receive(\.calculateProfitPerTick)

        #expect(store.state.lotResult == LotCalculationResult(
            lot: 101,
            buyValue: 10_100_000,
            buyFee: 15_150,
            stampDuty: 0,
            totalPaid: 10_115_150
        ))
        #expect(store.state.rows.count == 11)
    }
}
