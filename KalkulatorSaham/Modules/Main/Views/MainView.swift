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
        NavigationView {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ScreenView {
                    List {
                        Group {
                            NavigationLink(
                                destination: ProfitLossCalculatorView(
                                    store: self.store.scope(
                                        state: \.profitLossCalculator,
                                        action: Main.Action.profitLossCalculator
                                    )
                                )
                            ) {
                                MenuRow(id: "AA", label: "Kalkulator ARA & ARB")
                            }
                            
                            NavigationLink(
                                destination: ProfitLossCalculatorView(
                                    store: self.store.scope(
                                        state: \.profitLossCalculator,
                                        action: Main.Action.profitLossCalculator
                                    )
                                )
                            ) {
                                MenuRow(id: "PL", label: "Kalkulator Profit / Loss")
                            }
                            
                            NavigationLink(
                                destination: ProfitLossCalculatorView(
                                    store: self.store.scope(
                                        state: \.profitLossCalculator,
                                        action: Main.Action.profitLossCalculator
                                    )
                                )
                            ) {
                                MenuRow(id: "PT", label: "Kalkulator Profit per Tick")
                            }
                            
                            NavigationLink(
                                destination: ProfitLossCalculatorView(
                                    store: self.store.scope(
                                        state: \.profitLossCalculator,
                                        action: Main.Action.profitLossCalculator
                                    )
                                )
                            ) {
                                MenuRow(id: "AP", label: "Kalkulator Average Price")
                            }
                            
                            NavigationLink(
                                destination: ProfitLossCalculatorView(
                                    store: self.store.scope(
                                        state: \.profitLossCalculator,
                                        action: Main.Action.profitLossCalculator
                                    )
                                )
                            ) {
                                MenuRow(id: "RR", label: "Kalkulator Risk Reward Ratio")
                            }
                            
                            NavigationLink(
                                destination: ProfitLossCalculatorView(
                                    store: self.store.scope(
                                        state: \.profitLossCalculator,
                                        action: Main.Action.profitLossCalculator
                                    )
                                )
                            ) {
                                MenuRow(id: "PB", label: "Kalkulator Price Book Value")
                            }
                            
                            NavigationLink(
                                destination: ProfitLossCalculatorView(
                                    store: self.store.scope(
                                        state: \.profitLossCalculator,
                                        action: Main.Action.profitLossCalculator
                                    )
                                )
                            ) {
                                MenuRow(id: "DY", label: "Kalkulator Dividen Yield")
                            }
                            
                            NavigationLink(
                                destination: ProfitLossCalculatorView(
                                    store: self.store.scope(
                                        state: \.profitLossCalculator,
                                        action: Main.Action.profitLossCalculator
                                    )
                                )
                            ) {
                                MenuRow(id: "SS", label: "Kalkulator Stock Split")
                            }
                            
                            NavigationLink(
                                destination: ProfitLossCalculatorView(
                                    store: self.store.scope(
                                        state: \.profitLossCalculator,
                                        action: Main.Action.profitLossCalculator
                                    )
                                )
                            ) {
                                MenuRow(id: "RI", label: "Kalkulator Right Issue")
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
                .toolbar {
                    HStack {
                        Button(action: {
                            viewStore.send(.didTapShareButton)
                        }) {
                            Image("icon.share").renderingMode(.template)
                        }
                        
                        Button(action: {
                            viewStore.send(.didTapSettingsButton)
                        }) {
                            Image("icon.settings").renderingMode(.template)
                        }
                    }
                }
                
                #if os(macOS)
                HomeView()
                #endif

            }
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
