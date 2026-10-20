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
    @Bindable var store: StoreOf<LotCalculator>
    let settingsStore: StoreOf<Settings>

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
                            label: "max_buy".tr(),
                            value: $store.maxBuy,
                            keyboardType: .numberPad,
                            error: store.errors["maxBuy"]
                        )
                    }

                    BrokerFeeInformation(
                        store: settingsStore,
                        calculateBrokerFee: $store.calculateBrokerFee
                    )

                    Button("calculate".tr()) {
                        store.send(.calculateButtonTapped(
                            brokerFee: BrokerFee(
                                buy: settingsStore.buyFee,
                                sell: settingsStore.sellFee
                            )
                        ))
                    }
                    .buttonStyle(CustomButtonStyle())
                    .disabled(!store.errors.isEmpty)


                    if let lotResult = store.lotResult {
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

                    TableView(
                        columns: [
                            TableColumn("Value", width: 20, alignment: .trailing),
                            TableColumn("Loss", width: 15, alignment: .trailing),
                            TableColumn("Price", width: 15, alignment: .trailing),
                            TableColumn("Price", width: 15, alignment: .leading),
                            TableColumn("Profit", width: 15, alignment: .leading),
                            TableColumn("Value", width: 20, alignment: .leading)
                        ],
                        rows: store.rows,
                        colors: store.colors
                    )

                    Spacer()
                }
                .padding()
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
            initialState: Main.State()
        ) {
            Main()
        }

        LotCalculatorView(
            store: store.scope(
                state: \.lotCalculator,
                action: \.lotCalculator
            ),
            settingsStore: store.scope(
                state: \.settings,
                action: \.settings
            )
        )
    }
}
