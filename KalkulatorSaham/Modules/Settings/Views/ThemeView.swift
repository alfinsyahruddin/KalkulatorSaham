//
//  ThemeView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//


import SwiftUI
import ComposableArchitecture

struct ThemeView: View {
    @Bindable var store: StoreOf<Settings>

    var body: some View {
        ScreenView {
            RadioSelect<Theme>(
                options: Theme.allCases.map { $0.rawValue.capitalized },
                values: Theme.allCases,
                selected: $store.theme.sending(\.setTheme)
            )
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("theme".tr(), displayMode: .inline)
            #endif
        }
    }
}
