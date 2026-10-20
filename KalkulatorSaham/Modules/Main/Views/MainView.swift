//
//  MainView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    let store: StoreOf<Main>

    init(store: StoreOf<Main>) {
        self.store = store

        #if canImport(UIKit)
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.accentColor)
        ]
        UIView.appearance().tintColor = UIColor(Color.accentColor)
        #endif
    }


    var body: some View {
        NavView(store: store) {
            ScreenView {
                List {
                    Group {
                        NavigationLink(
                            destination: AraArbCalculatorView(
                                store: store.scope(
                                    state: \.araArbCalculator,
                                    action: \.araArbCalculator
                                )
                            )
                        ) {
                            MenuRow(id: "AA", label: "ara_arb_calculator".tr())
                        }

                        NavigationLink(
                            destination: TradingReturnCalculatorView(
                                store: store.scope(
                                    state: \.tradingReturnCalculator,
                                    action: \.tradingReturnCalculator
                                ),
                                settingsStore: store.scope(
                                    state: \.settings,
                                    action: \.settings
                                )
                            )
                        ) {
                            MenuRow(id: "PL", label: "trading_return_calculator".tr())
                        }

                        NavigationLink(
                            destination: ProfitPerTickCalculatorView(
                                store: store.scope(
                                    state: \.profitPerTickCalculator,
                                    action: \.profitPerTickCalculator
                                ),
                                settingsStore: store.scope(
                                    state: \.settings,
                                    action: \.settings
                                )
                            )
                        ) {
                            MenuRow(id: "PT", label: "profit_per_tick_calculator".tr())
                        }

                        NavigationLink(
                            destination: AveragePriceCalculatorView(
                                store: store.scope(
                                    state: \.averagePriceCalculator,
                                    action: \.averagePriceCalculator
                                )
                            )
                        ) {
                            MenuRow(id: "AP", label: "average_price_calculator".tr())
                        }

                        NavigationLink(
                            destination: RiskRewardRatioCalculatorView(
                                store: store.scope(
                                    state: \.riskRewardRatioCalculator,
                                    action: \.riskRewardRatioCalculator
                                )
                            )
                        ) {
                            MenuRow(id: "RR", label: "risk_reward_ratio_calculator".tr())
                        }

                        NavigationLink(
                            destination: PriceBookValueCalculatorView(
                                store: store.scope(
                                    state: \.priceBookValueCalculator,
                                    action: \.priceBookValueCalculator
                                )
                            )
                        ) {
                            MenuRow(id: "PB", label: "price_book_value_calculator".tr())
                        }

                        NavigationLink(
                            destination: DividenYieldCalculatorView(
                                store: store.scope(
                                    state: \.dividenYieldCalculator,
                                    action: \.dividenYieldCalculator
                                )
                            )
                        ) {
                            MenuRow(id: "DY", label: "dividen_yield_calculator".tr())
                        }

                        NavigationLink(
                            destination: StockSplitCalculatorView(
                                store: store.scope(
                                    state: \.stockSplitCalculator,
                                    action: \.stockSplitCalculator
                                )
                            )
                        ) {
                            MenuRow(id: "SS", label: "stock_split_calculator".tr())
                        }

                        NavigationLink(
                            destination: RightIssueCalculatorView(
                                store: store.scope(
                                    state: \.rightIssueCalculator,
                                    action: \.rightIssueCalculator
                                )
                            )
                        ) {
                            MenuRow(id: "RI", label: "right_issue_calculator".tr())
                        }

                        NavigationLink(
                            destination: LotCalculatorView(
                                store: store.scope(
                                    state: \.lotCalculator,
                                    action: \.lotCalculator
                                ),
                                settingsStore: store.scope(
                                    state: \.settings,
                                    action: \.settings
                                )
                            )
                        ) {
                            MenuRow(id: "LC", label: "lot_calculator".tr())
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationTitle("Kalkulator Saham")
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            store: Store(
                initialState: Main.State()
            ) {
                Main()
            }
        )
    }
}
