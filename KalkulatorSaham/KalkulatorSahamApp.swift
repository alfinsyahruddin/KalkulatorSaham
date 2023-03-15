//
//  KalkulatorSahamApp.swift
//  KalkulatorSaham
//
//  Created by Alfin on 03/03/23.
//

import SwiftUI

@main
struct KalkulatorSahamApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modify {
                    #if os(iOS)
                    $0.onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                    #endif
                }
        }
    }
}

