//
//  card.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI


extension View {
    func card(cornerRadius: Int = 8) -> some View {
        modifier(CardViewModifier(cornerRadius: cornerRadius))
    }
}


struct CardViewModifier: ViewModifier {
    var cornerRadius: Int
    
    func body(content: Content) -> some View {
        content
            .background(Color.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: CGFloat(cornerRadius))
                    .stroke(Color.divider, lineWidth: 1.5)
            )
    }
}
