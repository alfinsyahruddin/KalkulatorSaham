//
//  LotCalculatorView.swift
//  KalkulatorSaham
//
//  Created by M Alfin Syahruddin on 01/06/25.
//

import SwiftUI
import ComposableArchitecture
import StockCalculator

struct LotCalculatorView: View {
    let store: StoreOf<LotCalculator>
    
    var body: some View {
        ScreenView {
            ScrollView {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 10) {
                            CustomTextField(
                                label: "price".tr(),
                                value: viewStore.binding(\.$price),
                                keyboardType: .numberPad,
                                error: viewStore.errors["price"]
                            )
                            
                            CustomTextField(
                                label: "max_buy".tr(),
                                value: viewStore.binding(\.$maxBuy),
                                keyboardType: .numberPad,
                                error: viewStore.errors["maxBuy"]
                            )
                        }
                        
                        Button("calculate".tr()) {
                            viewStore.send(.calculateButtonTapped)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .disabled(!viewStore.errors.isEmpty)
                        
                        if let lotResult = viewStore.lotResult {
                            Separator()
                            
                            HStack(spacing: 16) {
                                ResultCard(
                                    title: "lot".tr(),
                                    content: lotResult.lot.f(),
                                    alignment: .leading,
                                    contentFont: .body
                                )
                                
                                ResultCard(
                                    title: "total".tr(),
                                    content: lotResult.value.f(.currency),
                                    alignment: .leading,
                                    contentFont: .body
                                )
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
            $0.navigationBarTitle("lot_calculator".tr(), displayMode: .inline)
            #endif
        }
    }
}



struct LotCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Main.State(),
            reducer: Main()
        )
        
        LotCalculatorView(
            store: store.scope(
                state: \.lotCalculator,
                action: Main.Action.lotCalculator
            )
        )
    }
}
