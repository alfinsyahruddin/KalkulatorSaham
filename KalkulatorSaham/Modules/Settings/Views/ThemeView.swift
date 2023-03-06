//
//  ThemeView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//


import SwiftUI
import ComposableArchitecture

struct ThemeView: View {
    let store: StoreOf<Settings>
    
    var body: some View {
        ScreenView {
            WithViewStore(store, observe: \.theme) { viewStore in
                RadioSelect<Theme>(
                    options: Theme.allCases.map { $0.rawValue.capitalized },
                    values: Theme.allCases,
                    selected: viewStore.binding(
                        get: { $0 },
                        send: { .setTheme($0) }
                    )
                )
            }
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("theme".tr(), displayMode: .inline)
            #endif
        }
    }
}
