//
//  watermarked.swift
//  KalkulatorSaham
//
//  Created by Alfin on 05/03/23.
//

import SwiftUI


extension View {
    func watermarked(with text: String) -> some View {
        modifier(Watermark(text: text))
    }
}


struct Watermark: ViewModifier {
    var text: String

    func body(content: Content) -> some View {
        ZStack(alignment: .topTrailing) {
            content
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
        }
    }
}
