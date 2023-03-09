//
//  BrokerFeeInformation.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI

struct BrokerFeeInformation: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("calculate_broker_fee".tr())
            HStack {
                Text("broker_fee".tr() + ":")
                    .fontWeight(.bold)
                Text("buy_x_&_sell_x".tr(with: ["0.15%", "0.25%"]))
                Text("change".tr())
                    .foregroundColor(.red)
                    .fontWeight(.bold)
            }
        }
        .font(.callout)
    }
}
