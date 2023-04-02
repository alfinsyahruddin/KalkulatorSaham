//
//  DividenYieldCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import SwiftUI
import ComposableArchitecture
import StockCalculator

struct DividenYieldCalculatorView: View {
    let store: StoreOf<DividenYieldCalculator>
    
    var body: some View {
        ScreenView {
            ScrollView {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 10) {
                            CustomTextField(
                                label: "price".tr(),
                                value: viewStore.binding(\.$price),
                                keyboardType: .numberPad
                            )
                            
                            CustomTextField(
                                label: "dividen".tr(),
                                value: viewStore.binding(\.$dividen),
                                keyboardType: .numberPad
                            )
                        }
                        
                        Button("calculate".tr()) {
                            viewStore.send(.calculateButtonTapped)
                        }
                        .buttonStyle(CustomButtonStyle())
                        
                        Separator()
                        
                        if let dividenYield = viewStore.dividenYield {
                            ResultCard(
                                title: "dividen_yield".tr(),
                                content: dividenYield.f().percentage(),
                                color: .yellow
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
            $0.navigationBarTitle("dividen_yield_calculator".tr(), displayMode: .inline)
            #endif
        }
    }
}



struct DividenYieldCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Main.State(),
            reducer: Main()
        )
        
        DividenYieldCalculatorView(
            store: store.scope(
                state: \.dividenYieldCalculator,
                action: Main.Action.dividenYieldCalculator
            )
        )
    }
}
