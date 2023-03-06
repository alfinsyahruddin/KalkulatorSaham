//
//  SettingsView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<Settings>
    
    var body: some View {
        ScreenView {
            List {
                Group {
                    NavigationLink(
                        destination: ThemeView(
                            store: store
                        )
                    ) {
                        MenuRow(icon: "icon.moon", label: "theme".tr())
                    }
                    
                    NavigationLink(
                        destination: LanguageView(
                            store: store
                        )
                    ) {
                        MenuRow(icon: "icon.globe", label: "language".tr())
                    }
                    
                    NavigationLink(
                        destination: LanguageView(
                            store: store
                        )
                    ) {
                        MenuRow(icon: "icon.percent", label: "broker_fee".tr())
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .modify {
                if #available(macOS 13, *), #available(iOS 16, *) {
                    $0.scrollContentBackground(.hidden)
                }
            }
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("settings".tr(), displayMode: .inline)
            #endif
        }
    }
}

