//
//  AraArbCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//


import SwiftUI
import ComposableArchitecture
import StockCalculator

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
                                value: viewStore.binding(\.$price),
                                keyboardType: .numberPad
                            )
                            
                            Picker("Type", selection: viewStore.binding(\.$type)) {
                                Text("symmetric".tr()).tag(0)
                                Text("asymmetric".tr()).tag(1)
                                Text("acceleration".tr()).tag(2)
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        Button("calculate".tr()) {
                            viewStore.send(.calculateButtonTapped)
                        }
                        .buttonStyle(CustomButtonStyle())
                        
                        Divider()
                        
                        if let autoRejects = viewStore.autoRejects {
                            VStack(spacing: 10) {
                                ForEach(0..<autoRejects.ara.count, id: \.self) { index in
                                    let autoReject = autoRejects.ara[index]
                                    
                                    AutoRejectCard(
                                        color: .green,
                                        priceCaption: "ARA #\(5-index)",
                                        price: autoReject.price,
                                        priceChange: autoReject.priceChange,
                                        percentage: autoReject.percentage,
                                        totalPercentage: autoReject.totalPercentage
                                    )
                                }
                                
                                AutoRejectCard(
                                    color: .yellow,
                                    priceCaption: "Price",
                                    price: viewStore.autoRejectPrice,
                                    priceChange: 0,
                                    percentage: 0,
                                    totalPercentage: 0
                                )

                                ForEach(0..<autoRejects.arb.count, id: \.self) { index in
                                    let autoReject = autoRejects.arb[index]
                                    
                                    AutoRejectCard(
                                        color: .red,
                                        priceCaption: "ARB #\(index+1)",
                                        price: autoReject.price,
                                        priceChange: autoReject.priceChange,
                                        percentage: autoReject.percentage,
                                        totalPercentage: autoReject.totalPercentage
                                    )
                                }
                            }
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
