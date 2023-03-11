//
//  CustomButtonStyle.swift
//  KalkulatorSaham
//
//  Created by Alfin on 10/03/23.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.bold))
            .foregroundColor(Color.accentColorFG)
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#FFC700"))
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.25), value: configuration.isPressed)

    }
}

