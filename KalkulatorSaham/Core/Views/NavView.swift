//
//  NavigationView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import SwiftUI
import ComposableArchitecture

struct NavView<Content: View>: View {
    @Bindable var store: StoreOf<Main>
    var content: () -> Content

    init(store: StoreOf<Main>, @ViewBuilder content: @escaping () -> Content) {
        self.store = store
        self.content = content
    }

    var body: some View {
        #if os(macOS)
        NavigationSplitView(sidebar: content, detail: {
            if let screen = store.selectedScreen {
                CalculatorDestinationView(screen: screen, store: store)
            } else {
                HomeView(store: store.scope(state: \.settings, action: \.settings))
            }
        })
        .toolbar {
            Toolbar(store: store)
        }
        #else
        NavigationStack(path: $store.path) {
            content()
                .navigationDestination(for: CalculatorScreen.self) { screen in
                    CalculatorDestinationView(screen: screen, store: store)
                }
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


            #if os(macOS)
            Button {
                store.send(.binding(.set(\.selectedScreen, .settings)))
            } label: {
                Image("icon.settings").renderingMode(.template)
                    .accessibilityLabel("settings".tr())
            }
            #else
            NavigationLink(value: CalculatorScreen.settings) {
                Image("icon.settings").renderingMode(.template)
                    .accessibilityLabel("settings".tr())
            }
            #endif

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

