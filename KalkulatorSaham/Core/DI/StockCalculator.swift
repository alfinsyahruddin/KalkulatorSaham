//
//  StockCalculator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 10/03/23.
//

import Foundation
import ComposableArchitecture
import StockCalculator

private enum StockCalculatorDependencyKey: DependencyKey {
    // The SDK exposes a mutable class. Create an instance per access instead of
    // sharing that class across concurrent dependency contexts.
    static let liveValue: @Sendable () -> StockCalculator = { StockCalculator() }
    // Pure local calculations use the same deterministic implementation in tests.
    static let testValue = liveValue
}

extension DependencyValues {
  var stockCalculator: StockCalculator {
    self[StockCalculatorDependencyKey.self]()
  }
}
