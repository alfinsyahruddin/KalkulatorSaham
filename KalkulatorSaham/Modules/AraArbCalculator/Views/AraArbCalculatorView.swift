//
//  AraArbCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//


import SwiftUI
import ComposableArchitecture

struct AraArbCalculatorView: View {
    let store: StoreOf<AraArbCalculator>
    
    var body: some View {
        ScreenView {
            ScrollView {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(spacing: 10) {
                            CustomTextField(
                                label: "price".tr(),
                                text: viewStore.binding(\.$price)
                            )
                            
                            Picker("Type", selection: viewStore.binding(\.$type)) {
                                Text("symmetric".tr()).tag(0)
                                Text("asymmetric".tr()).tag(1)
                                Text("acceleration".tr()).tag(2)
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        Button("calculate".tr()) {
                            
                        }
                        .buttonStyle(CustomButtonStyle())
                        
                        VStack(spacing: 10) {
                            AutoRejectCard(
                                color: .green,
                                priceCaption: "ARA #1",
                                price: 135,
                                priceChange: 35,
                                percentage: 35,
                                totalPercentage: 35
                            )
                            
                            AutoRejectCard(
                                color: .yellow,
                                priceCaption: "price".tr(),
                                price: 100,
                                priceChange: 0,
                                percentage: 0,
                                totalPercentage: 0
                            )
                            
                            AutoRejectCard(
                                color: .red,
                                priceCaption: "ARB #1",
                                price: 135,
                                priceChange: 35,
                                percentage: 35,
                                totalPercentage: 35
                            )
                        }
                        
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("ara_arb_calculator".tr(), displayMode: .inline)
            #endif
        }
    }
}



struct AraArbCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Main.State(),
            reducer: Main()
        )
        
        AraArbCalculatorView(
            store: store.scope(
                state: \.araArbCalculator,
                action: Main.Action.araArbCalculator
            )
        )
    }
}
