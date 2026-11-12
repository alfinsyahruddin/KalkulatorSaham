//
//  StampDutyView.swift
//  KalkulatorSaham
//
//  Created by Antigravity on 12/11/26.
//

import SwiftUI
import ComposableArchitecture

struct StampDutyView: View {
    @Bindable var store: StoreOf<Settings>

    var body: some View {
        ScreenView {
            VStack(alignment: .leading, spacing: 20) {
                Text("please_enter_stamp_duty".tr())

                HStack(spacing: 10) {
                    CustomTextField(
                        label: "stamp_duty_fee".tr(),
                        value: $store.stampDutyFee,
                        keyboardType: .numberPad
                    )

                    CustomTextField(
                        label: "threshold".tr(),
                        value: $store.stampDutyThreshold,
                        keyboardType: .numberPad
                    )
                }

                Spacer()
            }
            .padding()
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("stamp_duty".tr(), displayMode: .inline)
            #endif
        }
    }
}
