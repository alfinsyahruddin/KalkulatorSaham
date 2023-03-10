//
//  TradingReturnCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import SwiftUI
import ComposableArchitecture

struct TradingReturnCalculatorView: View {
    let store: StoreOf<TradingReturnCalculator>
    
    var body: some View {
        ScreenView {
            ScrollView {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 10) {
                            CustomTextField(
                                label: "buy_price".tr(),
                                text: viewStore.binding(\.$buyPrice)
                            )
                            
                            CustomTextField(
                                label: "sell_price".tr(),
                                text: viewStore.binding(\.$sellPrice)
                            )
                            
                            CustomTextField(
                                label: "lot".tr(),
                                text: viewStore.binding(\.$lot)
                            )
                        }
                        
                        
                        BrokerFeeInformation()
                        
                        
                        Button("calculate".tr()) {
                            
                        }
                        .buttonStyle(CustomButtonStyle())
                        
                        
                        InformationCard(
                            title: "calculation_result".tr(),
                            headerStyle: InformationCardHeaderStyle(
                                color: .systemBackground,
                                backgroundColor: .green
                            ),
                            items: [
                                InformationCardItem(
                                    key: "status".tr(),
                                    value: "xxx",
                                    valueStyle: InformationCardItemStyle(
                                        color: .green
                                    )
                                ),
                                InformationCardItem(
                                    key: "profit".tr(),
                                    value: "xxx"
                                ),
                                
                                InformationCardItem(
                                    key: "total_fee".tr(),
                                    value: "xxx"
                                ),
                                InformationCardItem(
                                    key: "net_profit".tr(),
                                    value: "xxx"
                                )
                            ]
                        )
                        
                        
                        InformationCard(
                            title: "buy_detail".tr(),
                            items: [
                                InformationCardItem(
                                    key: "buy_price".tr(),
                                    value: "xxx"
                                ),
                                InformationCardItem(
                                    key: "buy_value".tr(),
                                    value: "xxx"
                                ),
                                
                                InformationCardItem(
                                    key: "buy_fee".tr(),
                                    value: "xxx"
                                ),
                                InformationCardItem(
                                    key: "total_paid".tr(),
                                    value: "xxx"
                                )
                            ]
                        )
                        
                        InformationCard(
                            title: "sell_detail".tr(),
                            items: [
                                InformationCardItem(
                                    key: "sell_price".tr(),
                                    value: "xxx"
                                ),
                                InformationCardItem(
                                    key: "sell_value".tr(),
                                    value: "xxx"
                                ),
                                
                                InformationCardItem(
                                    key: "sell_fee".tr(),
                                    value: "xxx"
                                ),
                                InformationCardItem(
                                    key: "total_received".tr(),
                                    value: "xxx"
                                )
                            ]
                        )
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("trading_return_calculator".tr(), displayMode: .inline)
            #endif
        }
    }
}




struct TradingReturnCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Main.State(),
            reducer: Main()
        )
        
        TradingReturnCalculatorView(
            store: store.scope(
                state: \.tradingReturnCalculator,
                action: Main.Action.tradingReturnCalculator
            )
        )
    }
}
