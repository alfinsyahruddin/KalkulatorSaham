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
    @Bindable var store: StoreOf<StockSplitCalculator>

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
                            label: "old_ratio".tr(),
                            value: $store.oldRatio,
                            keyboardType: .numberPad,
                            error: store.errors["oldRatio"]
                        )


                        CustomTextField(
                            label: "new_ratio".tr(),
                            value: $store.newRatio,
                            keyboardType: .numberPad,
                            error: store.errors["newRatio"]
                        )
                    }

                    Button("calculate".tr()) {
                        store.send(.calculateButtonTapped)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .disabled(!store.errors.isEmpty)

                    if let stockSplit = store.stockSplit {
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
            initialState: Main.State()
        ) {
            Main()
        }

        StockSplitCalculatorView(
            store: store.scope(
                state: \.stockSplitCalculator,
                action: \.stockSplitCalculator
            )
        )
    }
}
