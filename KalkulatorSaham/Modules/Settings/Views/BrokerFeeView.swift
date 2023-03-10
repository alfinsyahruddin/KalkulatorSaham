//
//  BrokerFeeSettingsView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//



import SwiftUI
import ComposableArchitecture

struct BrokerFeeView: View {
    let store: StoreOf<Settings>

    var body: some View {
        ScreenView {
            WithViewStore(store, observe: { $0 }) { viewStore in
                VStack(alignment: .leading, spacing: 20) {
                    Text("please_enter_broker_fee".tr())
                    
                    HStack(spacing: 10) {
                        CustomTextField(
                            label: "buy_fee".tr(),
                            text: viewStore.binding(\.$buyFee)
                        )
                        
                        CustomTextField(
                            label: "sell_fee".tr(),
                            text: viewStore.binding(\.$sellFee)
                        )
                    }
                                        
                    Spacer()
                }
                .padding()
            }
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("broker_fee".tr(), displayMode: .inline)
            #endif
        }
    }
}
