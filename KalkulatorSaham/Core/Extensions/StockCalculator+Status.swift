//
//  StockCalculator+Status.swift
//  KalkulatorSaham
//
//  Created by Alfin on 10/03/23.
//

import SwiftUI
import StockCalculator

extension TradingReturn.Status {
    var text: String {
        switch self {
        case .bep:
            return "BEP"
        case .profit:
            return "Profit"
        case .loss:
            return "Loss"
        }
    }
    
    var color: Color {
        switch self {
        case .bep:
            return .yellow
        case .profit:
            return .green
        case .loss:
            return .red
        }
    }
}
