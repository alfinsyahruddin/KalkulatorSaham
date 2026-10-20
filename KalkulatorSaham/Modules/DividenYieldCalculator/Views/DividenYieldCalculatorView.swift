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
    @Bindable var store: StoreOf<DividenYieldCalculator>

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
                            label: "dividen".tr(),
                            value: $store.dividen,
                            keyboardType: .numberPad,
                            error: store.errors["dividen"]
                        )
                    }

                    Button("calculate".tr()) {
                        store.send(.calculateButtonTapped)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .disabled(!store.errors.isEmpty)


                    if let dividenYield = store.dividenYield {
                        Separator()

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
            initialState: Main.State()
        ) {
            Main()
        }

        DividenYieldCalculatorView(
            store: store.scope(
                state: \.dividenYieldCalculator,
                action: \.dividenYieldCalculator
            )
        )
    }
}
