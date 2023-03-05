//
//  ScreenView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 05/03/23.
//

import SwiftUI

struct ScreenView<Content: View>: View {
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color.systemBackground
                .ignoresSafeArea()
            
            content()
        }
    }
}
