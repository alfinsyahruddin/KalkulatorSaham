//
//  RiskRewardRatioCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import SwiftUI
import ComposableArchitecture
import StockCalculator

struct RiskRewardRatioCalculatorView: View {
    @Bindable var store: StoreOf<RiskRewardRatioCalculator>

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
                            label: "stop_loss".tr(),
                            value: $store.stopLossPrice,
                            keyboardType: .numberPad,
                            error: store.errors["stopLoss"]
                        )


                        CustomTextField(
                            label: "target_price".tr(),
                            value: $store.targetPrice,
                            keyboardType: .numberPad,
                            error: store.errors["targetPrice"]
                        )


                    }

                    Button("calculate".tr()) {
                        store.send(.calculateButtonTapped)
                    }
                    .buttonStyle(CustomButtonStyle())
                    .disabled(!store.errors.isEmpty)


                    if let riskRewardRatio = store.riskRewardRatio {
                        Separator()

                        ResultCard(
                            title: "risk_reward_ratio".tr(),
                            content: "\(riskRewardRatio.risk.f()) : \(riskRewardRatio.reward.f())",
                            color: (riskRewardRatio.reward - riskRewardRatio.risk) > 0 ? .green
                                : (riskRewardRatio.reward - riskRewardRatio.risk) < 0 ? .red
                                : .yellow
                        )
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("risk_reward_ratio_calculator".tr(), displayMode: .inline)
            #endif
        }
    }
}


struct RiskRewardRatioCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Main.State()
        ) {
            Main()
        }

        RiskRewardRatioCalculatorView(
            store: store.scope(
                state: \.riskRewardRatioCalculator,
                action: \.riskRewardRatioCalculator
            )
        )
    }
}
