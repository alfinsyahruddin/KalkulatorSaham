//
//  card.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI


extension View {
    func card(cornerRadius: CGFloat = 8, backgroundColor: Color = .cardBackground) -> some View {
        modifier(CardViewModifier(cornerRadius: cornerRadius, backgroundColor: backgroundColor))
    }
}


struct CardViewModifier: ViewModifier {
    var cornerRadius: CGFloat
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.divider, lineWidth: 1.5)
            )
    }
}
