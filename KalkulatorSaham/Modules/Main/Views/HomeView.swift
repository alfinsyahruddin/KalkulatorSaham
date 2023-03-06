//
//  HomeView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 05/03/23.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<Settings>

    var body: some View {
        ScreenView {
            WithViewStore(store, observe: \.language) { viewStore in
                Text("welcome".tr())
            }
        }
    }
}
