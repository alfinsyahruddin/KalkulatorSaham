//
//  ProfitLossCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import SwiftUI
import ComposableArchitecture

struct ProfitLossCalculatorView: View {
    let store: StoreOf<ProfitLossCalculator>
    
    var body: some View {
        ScreenView {
            Text("Profit & Loss Calculator")
        }
        .modify {
            #if os(iOS)
                $0.navigationBarTitle("Profit & Loss Calculator", displayMode: .inline)
            #endif
        }
    }
}
