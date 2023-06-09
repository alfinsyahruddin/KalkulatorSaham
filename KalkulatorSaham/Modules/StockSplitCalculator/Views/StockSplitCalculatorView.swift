//
//  StockSplitCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import SwiftUI
import ComposableArchitecture
import StockCalculator

struct StockSplitCalculatorView: View {
    let store: StoreOf<StockSplitCalculator>
    
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
                                label: "old_ratio".tr(),
                                value: viewStore.binding(\.$oldRatio),
                                keyboardType: .numberPad,
                                error: viewStore.errors["oldRatio"]
                            )
                            
                            
                            CustomTextField(
                                label: "new_ratio".tr(),
                                value: viewStore.binding(\.$newRatio),
                                keyboardType: .numberPad,
                                error: viewStore.errors["newRatio"]
                            )
                        }
                        
                        Button("calculate".tr()) {
                            viewStore.send(.calculateButtonTapped)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .disabled(!viewStore.errors.isEmpty)                        
                        
                        if let stockSplit = viewStore.stockSplit {
                            Separator()
                            
                            ResultCard(
                                title: "new_price".tr(),
                                content: stockSplit.f(.currency)
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
            $0.navigationBarTitle("stock_split_calculator".tr(), displayMode: .inline)
            #endif
        }
    }
}



struct StockSplitCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Main.State(),
            reducer: Main()
        )
        
        StockSplitCalculatorView(
            store: store.scope(
                state: \.stockSplitCalculator,
                action: Main.Action.stockSplitCalculator
            )
        )
    }
}
