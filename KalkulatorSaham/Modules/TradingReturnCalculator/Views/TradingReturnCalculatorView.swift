//
//  TradingReturnCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import SwiftUI
import ComposableArchitecture
import StockCalculator

struct TradingReturnCalculatorView: View {
    @Bindable var store: StoreOf<TradingReturnCalculator>
    let settingsStore: StoreOf<Settings>

    var body: some View {
        ScreenView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 10) {
                        CustomTextField(
                            label: "buy_price".tr(),
                            value: $store.buyPrice,
                            keyboardType: .numberPad,
                            error: store.errors["buyPrice"]
                        )

                        CustomTextField(
                            label: "sell_price".tr(),
                            value: $store.sellPrice,
                            keyboardType: .numberPad,
                            error: store.errors["sellPrice"]
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
                        store.send(.calculateButtonTapped)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .disabled(!store.errors.isEmpty)


                    if let tradingReturn = store.tradingReturn {
                        Separator()

                        InformationCard(
                            title: "calculation_result".tr(),
                            headerStyle: InformationCardHeaderStyle(
                                color: .systemBackground,
                                backgroundColor: tradingReturn.calculationResult.status.color
                            ),
                            items: [
                                InformationCardItem(
                                    key: "status".tr(),
                                    value: tradingReturn.calculationResult.status.text,
                                    valueStyle: InformationCardItemStyle(
                                        color: tradingReturn.calculationResult.status.color
                                    )
                                ),
                                InformationCardItem(
                                    key: tradingReturn.calculationResult.status.text,
                                    value: "\(tradingReturn.calculationResult.tradingReturn.f(.currency)) (\(tradingReturn.calculationResult.tradingReturnPercentage.f(.withPlus).percentage()))",
                                    valueStyle: InformationCardItemStyle(
                                        color: tradingReturn.calculationResult.status.color
                                    )
                                ),

                                InformationCardItem(
                                    key: "\("total_fee".tr())",
                                    value: "\(tradingReturn.calculationResult.totalFee.f(.currency))"
                                ),
                                InformationCardItem(
                                    key: "net_profit".tr(),
                                    value: "\(tradingReturn.calculationResult.netTradingReturn.f(.currency)) (\(tradingReturn.calculationResult.netTradingReturnPercentage.f(.withPlus).percentage()))",
                                    valueStyle: InformationCardItemStyle(
                                        color: tradingReturn.calculationResult.status.color
                                    )
                                )
                            ]
                        )


                        InformationCard(
                            title: "buy_detail".tr(),
                            items: [
                                InformationCardItem(
                                    key: "buy_price".tr(),
                                    value: "\(tradingReturn.buyDetail.buyPrice.f(.currency)) x \(Int(tradingReturn.buyDetail.lot)) Lot"
                                ),
                                InformationCardItem(
                                    key: "buy_value".tr(),
                                    value: tradingReturn.buyDetail.buyValue.f(.currency)
                                ),

                                InformationCardItem(
                                    key: "\("buy_fee".tr()) (\(tradingReturn.buyDetail.buyFeePercentage.f().percentage()))",
                                    value: tradingReturn.buyDetail.buyFee.f(.currency)
                                ),
                                InformationCardItem(
                                    key: "total_paid".tr(),
                                    value: tradingReturn.buyDetail.totalPaid.f(.currency)
                                )
                            ]
                        )

                        InformationCard(
                            title: "sell_detail".tr(),
                            items: [
                                InformationCardItem(
                                    key: "sell_price".tr(),
                                    value: "\(tradingReturn.sellDetail.sellPrice.f(.currency)) x \(Int(tradingReturn.sellDetail.lot)) Lot"
                                ),
                                InformationCardItem(
                                    key: "sell_value".tr(),
                                    value: tradingReturn.sellDetail.sellValue.f(.currency)
                                ),

                                InformationCardItem(
                                    key: "\("sell_fee".tr()) (\(tradingReturn.sellDetail.sellFeePercentage.f().percentage()))",
                                    value: tradingReturn.sellDetail.sellFee.f(.currency)
                                ),
                                InformationCardItem(
                                    key: "total_received".tr(),
                                    value: tradingReturn.sellDetail.totalReceived.f(.currency)
                                )
                            ]
                        )

                    }

                    Spacer()
                }
                .padding()
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
            initialState: Main.State()
        ) {
            Main()
        }

        TradingReturnCalculatorView(
            store: store.scope(
                state: \.tradingReturnCalculator,
                action: \.tradingReturnCalculator
            ),
            settingsStore: store.scope(
                state: \.settings,
                action: \.settings
            )
        )
    }
}
