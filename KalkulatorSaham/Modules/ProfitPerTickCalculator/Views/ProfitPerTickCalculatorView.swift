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
    let store: StoreOf<ProfitPerTickCalculator>
    let settingsStore: StoreOf<Settings>

    var body: some View {
        ScreenView {
            ScrollView {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 10) {
                                CustomTextField(
                                    label: "price".tr(),
                                    value: viewStore.binding(\.$price),
                                    keyboardType: .numberPad,
                                    error: viewStore.errors["price"]
                                )
                                
                                CustomTextField(
                                    label: "lot".tr(),
                                    value: viewStore.binding(\.$lot),
                                    keyboardType: .numberPad,
                                    error: viewStore.errors["lot"]
                                )
                            }
                            
                            BrokerFeeInformation(
                                store: settingsStore,
                                calculateBrokerFee: viewStore.binding(\.$calculateBrokerFee)
                            )

                            WithViewStore(settingsStore, observe: { $0 }) { settingsViewStore in
                                Button("calculate".tr()) {
                                    viewStore.send(.calculateButtonTapped(
                                        brokerFee: BrokerFee(
                                            buy: settingsViewStore.buyFee,
                                            sell: settingsViewStore.sellFee
                                        )
                                    ))
                                }
                                .buttonStyle(CustomButtonStyle())
                                .disabled(!viewStore.errors.isEmpty)
                            }
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
                            rows: viewStore.rows,
                            colors: viewStore.colors
                        )
                        
                        Spacer()
                    }
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
            initialState: Main.State(),
            reducer: Main()
        )
        
        ProfitPerTickCalculatorView(
            store: store.scope(
                state: \.profitPerTickCalculator,
                action: Main.Action.profitPerTickCalculator
            ),
            settingsStore: store.scope(
                state: \.settings,
                action: Main.Action.settings
            )
        )
    }
}
