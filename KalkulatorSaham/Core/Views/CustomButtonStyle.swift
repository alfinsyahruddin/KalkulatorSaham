//
//  CustomButtonStyle.swift
//  KalkulatorSaham
//
//  Created by Alfin on 10/03/23.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.bold))
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .frame(maxWidth: .infinity)
            .background(!isEnabled ? Color.secondarySystemBackground : Color(hex: "#FFC700"))
            .foregroundColor(!isEnabled ? Color.tertiaryLabel : Color.accentColorFG)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.25), value: configuration.isPressed)
    }
}

