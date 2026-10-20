//
//  RightIssueCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import SwiftUI
import ComposableArchitecture
import StockCalculator

struct RightIssueCalculatorView: View {
    @Bindable var store: StoreOf<RightIssueCalculator>

    var body: some View {
        ScreenView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 10) {
                        CustomTextField(
                            label: "ticker".tr(),
                            text: $store.ticker,
                            error: store.errors["ticker"]
                        )

                        CustomTextField(
                            label: "cum_date_price".tr(),
                            value: $store.cumDatePrice,
                            keyboardType: .numberPad,
                            error: store.errors["cumDatePrice"]
                        )

                        CustomTextField(
                            label: "lot".tr(),
                            value: $store.lot,
                            keyboardType: .numberPad,
                            error: store.errors["lot"]
                        )
                    }

                    HStack(spacing: 10) {
                        CustomTextField(
                            label: "exercise_price".tr(),
                            value: $store.exercisePrice,
                            keyboardType: .numberPad,
                            error: store.errors["exercisePrice"]
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


                    if let rightIssue = store.rightIssue {
                        Separator()

                        VStack(alignment: .leading) {
                            Text("before_ex_date".tr().uppercased())
                                .font(.caption.weight(.light))
                                .foregroundColor(.secondaryLabel)

                            ResultCard(
                                title: "market_value".tr(),
                                content: rightIssue.value.f(.currency),
                                alignment: .leading,
                                contentFont: .body
                            )
                        }

                        VStack(alignment: .leading) {
                            Text("after_ex_date".tr().uppercased())
                                .font(.caption.weight(.light))
                                .foregroundColor(.secondaryLabel)

                            VStack(spacing: 10) {

                                ResultCard(
                                    title: "market_value".tr(),
                                    content: rightIssue.valueAfterExDate.f(.currency),
                                    alignment: .leading,
                                    contentFont: .body
                                )

                                HStack(spacing: 10) {
                                    ResultCard(
                                        title: "x_price".tr(with: [rightIssue.ticker]),
                                        content: rightIssue.theoreticalPrice.f(.currency),
                                        alignment: .leading,
                                        contentFont: .body
                                    )

                                    ResultCard(
                                        title: "\(rightIssue.ticker)-R",
                                        content: "\(rightIssue.rightLot.f()) Lot",
                                        alignment: .leading,
                                        contentFont: .body
                                    )
                                }
                            }
                        }


                        Separator(text: "scenarios".tr().uppercased())


                        HStack(spacing: 10) {
                            CustomTextField(
                                label: "theoretical_price".tr(),
                                value: $store.theoreticalPrice,
                                keyboardType: .numberPad,
                                isDisabled: true
                            )

                            CustomTextField(
                                label: "current_price".tr(),
                                value: $store.currentPrice,
                                keyboardType: .numberPad
                            )
                        }


                        InformationCard(
                            title: "redeem_hmetd".tr(),
                            headerStyle: InformationCardHeaderStyle(
                                color: .systemBackground,
                                backgroundColor: .accentColor
                            ),
                            items: [
                                InformationCardItem(
                                    key: "lot".tr(),
                                    value: "\(rightIssue.redeem.lot.f()) Lot"
                                ),
                                InformationCardItem(
                                    key: "market_value".tr(),
                                    value: rightIssue.redeem.marketValue.f(.currency),
                                    valueStyle: InformationCardItemStyle(
                                        color: rightIssue.redeem.marketValue.getColor()
                                    )
                                ),

                                InformationCardItem(
                                    key: "average_price".tr(),
                                    value: rightIssue.redeem.averagePrice.f(.currency)
                                ),
                                InformationCardItem(
                                    key: "trading_return".tr(),
                                    value: rightIssue.redeem.tradingReturn.f(.currency),
                                    valueStyle: InformationCardItemStyle(
                                        color: rightIssue.redeem.tradingReturn.getColor()
                                    )
                                ),

                                InformationCardItem(
                                    key: "redeem_cost".tr(),
                                    value: rightIssue.redeem.redeemCost.f(.currency)
                                ),
                                InformationCardItem(
                                    key: "percentage".tr(),
                                    value: rightIssue.redeem.tradingReturnPercentage.f(.withPlus).percentage(),
                                    valueStyle: InformationCardItemStyle(
                                        color: rightIssue.redeem.tradingReturnPercentage.getColor()
                                    )
                                ),

                                InformationCardItem(type: .divider),
                                InformationCardItem(type: .hidden),

                                InformationCardItem(
                                    key: "total_modal".tr(),
                                    value: rightIssue.redeem.totalModal.f(.currency)
                                ),
                                InformationCardItem(
                                    key: "net_profit".tr(),
                                    value: rightIssue.redeem.netTradingReturn.f(.currency),
                                    valueStyle: InformationCardItemStyle(
                                        color: rightIssue.redeem.netTradingReturn.getColor()
                                    )
                                ),


                            ]
                        )


                        InformationCard(
                            title: "not_redeem_hmetd".tr(),
                            headerStyle: InformationCardHeaderStyle(
                                color: .systemBackground,
                                backgroundColor: .accentColor
                            ),
                            items: [
                                InformationCardItem(
                                    key: "lot".tr(),
                                    value: "\(rightIssue.notRedeem.lot.f()) Lot"
                                ),
                                InformationCardItem(
                                    key: "market_value".tr(),
                                    value: rightIssue.notRedeem.marketValue.f(.currency),
                                    valueStyle: InformationCardItemStyle(
                                        color: rightIssue.notRedeem.marketValue.getColor()
                                    )
                                ),

                                InformationCardItem(
                                    key: "average_price".tr(),
                                    value: rightIssue.notRedeem.averagePrice.f(.currency)
                                ),
                                InformationCardItem(
                                    key: "trading_return".tr(),
                                    value: rightIssue.notRedeem.tradingReturn.f(.currency),
                                    valueStyle: InformationCardItemStyle(
                                        color: rightIssue.notRedeem.tradingReturn.getColor()
                                    )
                                ),

                                InformationCardItem(
                                    key: "x_price".tr(with: ["\(rightIssue.ticker)-R"]),
                                    value: rightIssue.notRedeem.rightPrice.f(.currency)
                                ),
                                InformationCardItem(
                                    key: "percentage".tr(),
                                    value: rightIssue.notRedeem.tradingReturnPercentage.f(.withPlus).percentage(),
                                    valueStyle: InformationCardItemStyle(
                                        color: rightIssue.notRedeem.tradingReturnPercentage.getColor()
                                    )
                                ),

                                InformationCardItem(
                                    key: "x_quantity".tr(with: ["\(rightIssue.ticker)-R"]),
                                    value: "\(rightIssue.notRedeem.lot.f()) Lot"
                                ),
                                InformationCardItem(
                                    key: "x_value".tr(with: ["\(rightIssue.ticker)-R"]),
                                    value: rightIssue.notRedeem.rightValue.f(.currency),
                                    valueStyle: InformationCardItemStyle(
                                        color: rightIssue.notRedeem.rightValue.getColor()
                                    )
                                ),

                                InformationCardItem(type: .divider),
                                InformationCardItem(type: .hidden),

                                InformationCardItem(
                                    key: "total_modal".tr(),
                                    value: rightIssue.notRedeem.totalModal.f(.currency)
                                ),
                                InformationCardItem(
                                    key: "net_profit".tr(),
                                    value: rightIssue.notRedeem.netTradingReturn.f(.currency),
                                    valueStyle: InformationCardItemStyle(
                                        color: rightIssue.notRedeem.netTradingReturn.getColor()
                                    )
                                ),


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
            $0.navigationBarTitle("right_issue_calculator".tr(), displayMode: .inline)
            #endif
        }
    }
}


struct RightIssueCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Main.State()
        ) {
            Main()
        }

        RightIssueCalculatorView(
            store: store.scope(
                state: \.rightIssueCalculator,
                action: \.rightIssueCalculator
            )
        )
    }
}
