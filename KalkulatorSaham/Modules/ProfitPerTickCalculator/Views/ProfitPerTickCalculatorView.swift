//
//  ProfitPerTickCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI
import ComposableArchitecture
import StockCalculator

struct ProfitPerTickCalculatorView: View {
    @Bindable var store: StoreOf<ProfitPerTickCalculator>
    let settingsStore: StoreOf<Settings>

    var body: some View {
        ScreenView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 10) {
                            CustomTextField(
                                label: "price".tr(),
                                value: $store.price,
                                keyboardType: .numberPad,
                                error: store.errors["price"]
                            )

                            CustomTextField(
                                label: "lot".tr(),
                                value: $store.lot,
                                keyboardType: .numberPad,
                                error: store.errors["lot"]
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
                    }
                    .padding()


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
            }
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("profit_per_tick_calculator".tr(), displayMode: .inline)
            #endif
        }
    }
}


struct ProfitPerTickCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Main.State()
        ) {
            Main()
        }

        ProfitPerTickCalculatorView(
            store: store.scope(
                state: \.profitPerTickCalculator,
                action: \.profitPerTickCalculator
            ),
            settingsStore: store.scope(
                state: \.settings,
                action: \.settings
            )
        )
    }
}
