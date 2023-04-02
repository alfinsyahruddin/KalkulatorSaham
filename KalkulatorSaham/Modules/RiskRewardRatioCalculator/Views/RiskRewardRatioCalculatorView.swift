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
    let store: StoreOf<RiskRewardRatioCalculator>
    
    var body: some View {
        ScreenView {
            ScrollView {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 10) {
                            CustomTextField(
                                label: "buy_price".tr(),
                                value: viewStore.binding(\.$buyPrice),
                                keyboardType: .numberPad
                            )
                            
                            CustomTextField(
                                label: "stop_loss".tr(),
                                value: viewStore.binding(\.$stopLossPrice),
                                keyboardType: .numberPad
                            )
                            
                            
                            CustomTextField(
                                label: "target_price".tr(),
                                value: viewStore.binding(\.$targetPrice),
                                keyboardType: .numberPad
                            )
                            
                            
                        }
                        
                        Button("calculate".tr()) {
                            viewStore.send(.calculateButtonTapped)
                        }
                        .buttonStyle(CustomButtonStyle())
                        
                        Separator()
                        
                        if let riskRewardRatio = viewStore.riskRewardRatio {
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
            initialState: Main.State(),
            reducer: Main()
        )
        
        RiskRewardRatioCalculatorView(
            store: store.scope(
                state: \.riskRewardRatioCalculator,
                action: Main.Action.riskRewardRatioCalculator
            )
        )
    }
}
