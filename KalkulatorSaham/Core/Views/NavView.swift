//
//  NavigationView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import SwiftUI
import ComposableArchitecture

struct NavView<Content: View>: View {
    let store: StoreOf<Main>
    var content: () -> Content

    init(store: StoreOf<Main>, @ViewBuilder content: @escaping () -> Content) {
        self.store = store
        self.content = content
    }

    var body: some View {
        #if os(macOS)
        NavigationSplitView(sidebar: content, detail: {
            HomeView(store: store.scope(state: \.settings, action: \.settings))
        })
        .toolbar {
            Toolbar(store: store)
        }
        #else
        NavigationStack {
            content()
                .toolbar {
                    Toolbar(store: store)
                }
        }
        #endif
    }
}


struct Toolbar: View {
    @Bindable var store: StoreOf<Main>

    var body: some View {
        HStack {
            #if os(iOS)
            Button(action: {
                store.send(.didTapShareButton)
            }) {
                Image("icon.share").renderingMode(.template)
                    .accessibilityLabel("Share")
            }
            #endif


            NavigationLink(
                destination: SettingsView(store: self.store.scope(
                    state: \.settings,
                    action: \.settings
                ))
            ) {
                Image("icon.settings").renderingMode(.template)
                    .accessibilityLabel("settings".tr())
            }

        }
        .modify {
            #if os(iOS)
            $0.sheet(isPresented: $store.showShareSheet) {
                ActivityView(
                    text: "download_kalkulator_saham_app_on_the_appstore".tr()
                )
            }
            #endif
        }
    }
}

