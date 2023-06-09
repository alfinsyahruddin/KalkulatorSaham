//
//  PriceBookValueCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import SwiftUI
import ComposableArchitecture
import StockCalculator

struct PriceBookValueCalculatorView: View {
    let store: StoreOf<PriceBookValueCalculator>
    
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
                                label: "book_value".tr(),
                                value: viewStore.binding(\.$bookValue),
                                keyboardType: .numberPad,
                                error: viewStore.errors["bookValue"]
                            )
                        }
                        
                        Button("calculate".tr()) {
                            viewStore.send(.calculateButtonTapped)
                        }
                        .buttonStyle(CustomButtonStyle())
                        .disabled(!viewStore.errors.isEmpty)
                        
                        
                        if let priceBookValue = viewStore.priceBookValue {
                            Separator()
                            
                            ResultCard(
                                title: "price_book_value".tr(),
                                content: "\(priceBookValue.f())x",
                                color: priceBookValue < 1 ? .green
                                : priceBookValue > 1 ? .red
                                : .yellow
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
            $0.navigationBarTitle("price_book_value_calculator".tr(), displayMode: .inline)
            #endif
        }
    }
}



struct PriceBookValueCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Main.State(),
            reducer: Main()
        )
        
        PriceBookValueCalculatorView(
            store: store.scope(
                state: \.priceBookValueCalculator,
                action: Main.Action.priceBookValueCalculator
            )
        )
    }
}
