//
//  LanguageView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import SwiftUI
import ComposableArchitecture


struct LanguageView: View {
    @Bindable var store: StoreOf<Settings>

    var body: some View {
        ScreenView {
            RadioSelect<Language>(
                options: Language.allCases.map { $0.rawValue.capitalized },
                values: Language.allCases,
                selected: $store.language.sending(\.setLanguage)
            )
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("language".tr(), displayMode: .inline)
            #endif
        }
    }
}
