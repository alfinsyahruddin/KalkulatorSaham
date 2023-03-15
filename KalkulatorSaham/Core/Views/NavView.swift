//
//  NavigationView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import SwiftUI
import ComposableArchitecture

struct NavView<Content: View>: View {
    var store: StoreOf<Main>
    var content: () -> Content
    
    init(store: StoreOf<Main>, @ViewBuilder content: @escaping () -> Content) {
        self.store = store
        self.content = content
    }
    
    var body: some View {
        #if os(macOS)
        NavigationSplitView(sidebar: content, detail: {
            HomeView(store: store.scope(state: \.settings, action: Main.Action.settings))
                .toolbar {
                    Toolbar(store: store)
                }
        })
        #else
        NavigationView {
            content()
                .toolbar {
                    Toolbar(store: store)
                }
        }
        #endif
    }
}



struct Toolbar: View {
    var store: StoreOf<Main>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                #if os(iOS)
                Button(action: {
                    viewStore.send(.didTapShareButton)
                }) {
                    Image("icon.share").renderingMode(.template)
                }
                #endif
                
                
                NavigationLink(
                    destination: SettingsView(store: self.store.scope(
                        state: \.settings,
                        action: Main.Action.settings
                    ))
                ) {
                    Image("icon.settings").renderingMode(.template)
                }
                
            }
            .modify {
                #if os(iOS)
                $0.sheet(isPresented: viewStore.binding(\.$showShareSheet)) {
                    ActivityView(
                        text: "download_kalkulator_saham_app_on_the_appstore".tr()
                    )
                }
                #endif
            }
        }
    }
}

