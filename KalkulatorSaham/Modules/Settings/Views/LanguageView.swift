//
//  LanguageView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import SwiftUI
import ComposableArchitecture


struct LanguageView: View {
    let store: StoreOf<Settings>
    
    var body: some View {
        ScreenView {
            WithViewStore(store, observe: \.language) { viewStore in
                RadioSelect<Language>(
                    options: Language.allCases.map { $0.rawValue.capitalized },
                    values: Language.allCases,
                    selected: viewStore.binding(
                        get: { $0 },
                        send: { .setLanguage($0) }
                    )
                )
            }
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("language".tr(), displayMode: .inline)
            #endif
        }
    }
}
