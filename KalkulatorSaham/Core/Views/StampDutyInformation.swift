//
//  StampDutyInformation.swift
//  KalkulatorSaham
//
//  Created by Antigravity on 12/11/26.
//

import SwiftUI
import ComposableArchitecture

struct StampDutyInformation: View {
    let store: StoreOf<Settings>
    var calculateStampDuty: Binding<Bool>

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Toggle("", isOn: calculateStampDuty)
                    .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    .labelsHidden()
                    .scaleEffect(0.6)
                    .frame(width: 30)

                Text("calculate_stamp_duty".tr())
                Spacer()
            }
            HStack {
                Text("stamp_duty".tr() + ":")
                    .fontWeight(.bold)
                Text("stamp_duty_rule".tr(with: [
                    store.stampDutyFee.f(.currency),
                    store.stampDutyThreshold.f(.currency)
                ]))

                NavigationLink(destination: { StampDutyView(store: store) }) {
                    Text("change".tr())
                        .foregroundColor(.accentColor)
                        .fontWeight(.bold)
                }
            }
        }
        .font(.caption)
    }
}
