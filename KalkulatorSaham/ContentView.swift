//
//  ContentView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    var body: some View {
        MainView(
            store: Store(
                initialState: Main.State(),
                reducer: Main()
            )
        )        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
