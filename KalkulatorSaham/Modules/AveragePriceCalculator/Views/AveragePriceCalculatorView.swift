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
    let store: StoreOf<AveragePriceCalculator>
    
    var body: some View {
        ScreenView {
            ScrollView {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(spacing: 10) {
                            CustomTextField(
                                label: "price".tr(),
                                value: viewStore.binding(\.$price),
                                keyboardType: .numberPad
                            )
                            
                            CustomTextField(
                                label: "lot".tr(),
                                value: viewStore.binding(\.$lot),
                                keyboardType: .numberPad
                            )
                        }
                        
                        HStack {
                            Text("value".tr() + ":")
                            Text(viewStore.value.f(.currency))
                                .fontWeight(.bold)
                        }
                        
                        Button("buy".tr()) {
                            viewStore.send(.buyButtonTapped)
                        }
                        .buttonStyle(CustomButtonStyle())
                        
                        Separator()
                        
                        if let portfolio = viewStore.portfolio {
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
                        
                        
                        
                        if viewStore.transactions.count > 0 {
                            Text("transaction_history".tr().uppercased())
                                .font(.caption.weight(.light))
                                .foregroundColor(.secondaryLabel)

                            VStack(spacing: 10) {
                                ForEach(0..<viewStore.transactions.count, id: \.self) { index in
                                    let transaction = viewStore.transactions[index]
                                    
                                    TransactionCard(
                                        type: "buy".tr().uppercased(),
                                        value: transaction.value,
                                        price: transaction.price,
                                        lot: transaction.lot
                                    ) {
                                        viewStore.send(.deleteButtonTapped(index: index))
                                    }
                                }
                            }
                        }
                        
                        
                        
                        Spacer()
                    }
                    .padding()
                }
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
            initialState: Main.State(),
            reducer: Main()
        )
        
        AveragePriceCalculatorView(
            store: store.scope(
                state: \.averagePriceCalculator,
                action: Main.Action.averagePriceCalculator
            )
        )
    }
}
