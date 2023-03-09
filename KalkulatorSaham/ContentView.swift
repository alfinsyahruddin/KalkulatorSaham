//
//  ContentView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store = Store(
        initialState: Main.State(),
        reducer: Main()
    )
    
    var body: some View {
        MainView(
            store: store
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
