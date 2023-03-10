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
        #endif
    }


    var body: some View {
        NavView(store: store) {
                
                ScreenView {
                    List {
                        
                        WithViewStore(store, observe: \.settings) { viewStore in
                                
                                NavigationLink(
                                    destination: AraArbCalculatorView(
                                        store: self.store.scope(
                                            state: \.araArbCalculator,
                                            action: Main.Action.araArbCalculator
                                        )
                                    )
                                ) {
                                    MenuRow(id: "AA", label: "ara_arb_calculator".tr())
                                }
                                
                                NavigationLink(
                                    destination: TradingReturnCalculatorView(
                                        store: self.store.scope(
                                            state: \.tradingReturnCalculator,
                                            action: Main.Action.tradingReturnCalculator
                                        )
                                    )
                                ) {
                                    MenuRow(id: "PL", label: "trading_return_calculator".tr())
                                }
                                
                                NavigationLink(
                                    destination: ProfitPerTickCalculatorView(
                                        store: self.store.scope(
                                            state: \.profitPerTickCalculator,
                                            action: Main.Action.profitPerTickCalculator
                                        )
                                    )
                                ) {
                                    MenuRow(id: "PT", label: "profit_per_tick_calculator".tr())
                                }
                                
                                NavigationLink(
                                    destination: ComingSoonView()
                                        .modify {
                                            #if os(iOS)
                                            $0.navigationBarTitle("average_price_calculator".tr(), displayMode: .inline)
                                            #endif
                                        }
                                ) {
                                    MenuRow(id: "AP", label: "average_price_calculator".tr())
                                }
                                
                                NavigationLink(
                                    destination: ComingSoonView()
                                        .modify {
                                            #if os(iOS)
                                            $0.navigationBarTitle("risk_reward_ratio_calculator".tr(), displayMode: .inline)
                                            #endif
                                        }
                                ) {
                                    MenuRow(id: "RR", label: "risk_reward_ratio_calculator".tr())
                                }
                                
                                NavigationLink(
                                    destination: ComingSoonView()
                                        .modify {
                                            #if os(iOS)
                                            $0.navigationBarTitle("price_book_value_calculator".tr(), displayMode: .inline)
                                            #endif
                                        }
                                ) {
                                    MenuRow(id: "PB", label: "price_book_value_calculator".tr())
                                }
                                
                                NavigationLink(
                                    destination: ComingSoonView()
                                        .modify {
                                            #if os(iOS)
                                            $0.navigationBarTitle("dividen_yield_calculator".tr(), displayMode: .inline)
                                            #endif
                                        }
                                ) {
                                    MenuRow(id: "DY", label: "dividen_yield_calculator".tr())
                                }
                                
                                NavigationLink(
                                    destination: ComingSoonView()
                                        .modify {
                                            #if os(iOS)
                                            $0.navigationBarTitle("stock_split_calculator".tr(), displayMode: .inline)
                                            #endif
                                        }
                                ) {
                                    MenuRow(id: "SS", label: "stock_split_calculator".tr())
                                }
                                
                                NavigationLink(
                                    destination: ComingSoonView()
                                        .modify {
                                            #if os(iOS)
                                            $0.navigationBarTitle("right_issue_calculator".tr(), displayMode: .inline)
                                            #endif
                                        }
                                ) {
                                    MenuRow(id: "RI", label: "right_issue_calculator".tr())
                                }
                                
                            
                        }
                            .listRowBackground(Color.clear)
                        
                    }
                    
                }
                .listStyle(.plain)
                .modify {
                    if #available(macOS 13, *), #available(iOS 16, *) {
                        $0.scrollContentBackground(.hidden)
                    }
                }
                .modify {
                    #if os(iOS)
                    $0.navigationBarTitle("Kalkulator Saham", displayMode: .large)
                    #endif
                }
            }
            .modify {
                #if os(iOS)
                $0.navigationViewStyle(.stack)
                #endif
            }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            store: Store(
                initialState: Main.State(),
                reducer: Main()
            )
        )
    }
}
