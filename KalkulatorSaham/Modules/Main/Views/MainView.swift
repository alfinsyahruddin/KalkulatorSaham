//
//  MainView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    @Bindable var store: StoreOf<Main>

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
                #if os(macOS)
                List(selection: $store.selectedScreen) {
                    menuItems
                }
                #else
                List {
                    menuItems
                }
                #endif
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationTitle("Kalkulator Saham")
        }
    }

    private var menuItems: some View {
        Group {
            NavigationLink(value: CalculatorScreen.araArb) {
                MenuRow(id: "AA", label: "ara_arb_calculator".tr())
            }

            NavigationLink(value: CalculatorScreen.tradingReturn) {
                MenuRow(id: "PL", label: "trading_return_calculator".tr())
            }

            NavigationLink(value: CalculatorScreen.profitPerTick) {
                MenuRow(id: "PT", label: "profit_per_tick_calculator".tr())
            }

            NavigationLink(value: CalculatorScreen.averagePrice) {
                MenuRow(id: "AP", label: "average_price_calculator".tr())
            }

            NavigationLink(value: CalculatorScreen.riskRewardRatio) {
                MenuRow(id: "RR", label: "risk_reward_ratio_calculator".tr())
            }

            NavigationLink(value: CalculatorScreen.priceBookValue) {
                MenuRow(id: "PB", label: "price_book_value_calculator".tr())
            }

            NavigationLink(value: CalculatorScreen.dividenYield) {
                MenuRow(id: "DY", label: "dividen_yield_calculator".tr())
            }

            NavigationLink(value: CalculatorScreen.stockSplit) {
                MenuRow(id: "SS", label: "stock_split_calculator".tr())
            }

            NavigationLink(value: CalculatorScreen.rightIssue) {
                MenuRow(id: "RI", label: "right_issue_calculator".tr())
            }

            NavigationLink(value: CalculatorScreen.lot) {
                MenuRow(id: "LC", label: "lot_calculator".tr())
            }
        }
        .listRowBackground(Color.clear)
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
