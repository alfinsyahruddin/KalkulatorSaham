//
//  AveragePriceCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//

import SwiftUI
import ComposableArchitecture
import StockCalculator

struct AveragePriceCalculatorView: View {
    @Bindable var store: StoreOf<AveragePriceCalculator>

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
                            label: "lot".tr(),
                            value: $store.lot,
                            keyboardType: .numberPad,
                            error: store.errors["lot"]
                        )
                    }

                    HStack {
                        Text("value".tr() + ":")
                        Text(store.value.f(.currency))
                            .fontWeight(.bold)
                    }

                    Button("buy".tr()) {
                        store.send(.buyButtonTapped)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .disabled(!store.errors.isEmpty)


                    if let portfolio = store.portfolio {
                        Separator()

                        InformationCard(
                            title: "portfolio".tr(),
                            totalColumn: 3,
                            items: [
                                InformationCardItem(
                                    key: "lot".tr(),
                                    value: "\(portfolio.lot.f()) Lot"
                                ),
                                InformationCardItem(
                                    key: "avg_price".tr(),
                                    value: portfolio.averagePrice.f(.currency)
                                ),
                                InformationCardItem(
                                    key: "value".tr(),
                                    value: portfolio.value.f(.currency)
                                ),
                            ]
                        )
                    }


                    if store.transactions.count > 0 {
                        Text("transaction_history".tr().uppercased())
                            .font(.caption.weight(.light))
                            .foregroundColor(.secondaryLabel)

                        VStack(spacing: 10) {
                            ForEach(0..<store.transactions.count, id: \.self) { index in
                                let transaction = store.transactions[index]

                                TransactionCard(
                                    type: "buy".tr().uppercased(),
                                    value: transaction.value,
                                    price: transaction.price,
                                    lot: transaction.lot
                                ) {
                                    store.send(.deleteButtonTapped(index: index))
                                }
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
            $0.navigationBarTitle("average_price_calculator".tr(), displayMode: .inline)
            #endif
        }
    }
}


struct AveragePriceCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Main.State()
        ) {
            Main()
        }

        AveragePriceCalculatorView(
            store: store.scope(
                state: \.averagePriceCalculator,
                action: \.averagePriceCalculator
            )
        )
    }
}
