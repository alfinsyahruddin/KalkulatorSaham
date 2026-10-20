//
//  BrokerFeeInformation.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI
import ComposableArchitecture

struct BrokerFeeInformation: View {
    let store: StoreOf<Settings>
    var calculateBrokerFee: Binding<Bool>

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Toggle("", isOn: calculateBrokerFee)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .labelsHidden()
                    .scaleEffect(0.6)
                    .frame(width: 30)

                Text("calculate_broker_fee".tr())
                Spacer()
            }
            HStack {
                Text("broker_fee".tr() + ":")
                    .fontWeight(.bold)
                Text("buy_x_&_sell_x".tr(with: [
                    store.buyFee.f().percentage(),
                    store.sellFee.f().percentage()
                ]))

                NavigationLink(destination: { BrokerFeeView(store: store ) }) {
                    Text("change".tr())
                        .foregroundColor(.accentColor)
                        .fontWeight(.bold)
                }
            }
        }
        .font(.caption)
    }
}
