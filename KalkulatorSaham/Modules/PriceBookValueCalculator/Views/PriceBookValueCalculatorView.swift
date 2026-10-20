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
    @Bindable var store: StoreOf<PriceBookValueCalculator>

    var body: some View {
        ScreenView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 10) {
                        CustomTextField(
                            label: "price".tr(),
                            value: $store.price,
                            keyboardType: .numberPad,
                            error: store.errors["price"]
                        )

                        CustomTextField(
                            label: "book_value".tr(),
                            value: $store.bookValue,
                            keyboardType: .numberPad,
                            error: store.errors["bookValue"]
                        )
                    }

                    Button("calculate".tr()) {
                        store.send(.calculateButtonTapped)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .disabled(!store.errors.isEmpty)


                    if let priceBookValue = store.priceBookValue {
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
            initialState: Main.State()
        ) {
            Main()
        }

        PriceBookValueCalculatorView(
            store: store.scope(
                state: \.priceBookValueCalculator,
                action: \.priceBookValueCalculator
            )
        )
    }
}
