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
    @Bindable var store: StoreOf<AraArbCalculator>

    var body: some View {
        ScreenView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(spacing: 10) {
                        CustomTextField(
                            label: "price".tr(),
                            value: $store.price,
                            keyboardType: .numberPad,
                            error: store.errors["price"]
                        )

                        Picker("Type", selection: $store.type) {
                            Text("symmetric".tr()).tag(0)
                            Text("asymmetric".tr()).tag(1)
                            Text("acceleration".tr()).tag(2)
                        }
                        .pickerStyle(.segmented)
                    }

                    Button("calculate".tr()) {
                        store.send(.calculateButtonTapped)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .disabled(!store.errors.isEmpty)


                    if let autoRejects = store.autoRejects {
                        Separator()

                        VStack(spacing: 10) {
                            ForEach(0..<autoRejects.ara.count, id: \.self) { index in
                                let autoReject = autoRejects.ara[index]

                                AutoRejectCard(
                                    priceCaption: "ARA #\(5-index)",
                                    price: autoReject.price,
                                    priceChange: autoReject.priceChange,
                                    percentage: autoReject.percentage,
                                    totalPercentage: autoReject.totalPercentage,
                                    color: .green
                                )
                            }

                            AutoRejectCard(
                                priceCaption: "Price",
                                price: store.autoRejectPrice,
                                priceChange: 0,
                                percentage: 0,
                                totalPercentage: 0,
                                color: .yellow
                            )

                            ForEach(0..<autoRejects.arb.count, id: \.self) { index in
                                let autoReject = autoRejects.arb[index]

                                AutoRejectCard(
                                    priceCaption: "ARB #\(index+1)",
                                    price: autoReject.price,
                                    priceChange: autoReject.priceChange,
                                    percentage: autoReject.percentage,
                                    totalPercentage: autoReject.totalPercentage,
                                    color: .red
                                )
                            }
                        }
                    }


                    Spacer()
                }
                .padding()
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
            initialState: Main.State()
        ) {
            Main()
        }

        AraArbCalculatorView(
            store: store.scope(
                state: \.araArbCalculator,
                action: \.araArbCalculator
            )
        )
    }
}
