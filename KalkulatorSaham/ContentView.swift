//
//  ContentView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    @State private var store = Store(
        initialState: Main.State()
    ) {
        Main()
    }

    var body: some View {
        MainView(
            store: store
        )
        .preferredColorScheme(store.settings.theme == .system ? nil : store.settings.theme == .dark ? .dark : .light)
        .id(store.settings.language)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
