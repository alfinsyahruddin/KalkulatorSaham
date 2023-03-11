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
    static let liveValue: StockCalculator = StockCalculator()
}

extension DependencyValues {
  var stockCalculator: StockCalculator {
    get { self[StockCalculatorDependencyKey.self] }
    set { self[StockCalculatorDependencyKey.self] = newValue }
  }
}
