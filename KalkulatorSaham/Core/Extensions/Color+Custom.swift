//
//  Color+Custom.swift
//  KalkulatorSaham
//
//  Created by Alfin on 05/03/23.
//

import SwiftUI


extension Color {
    static let accentColor = Color("AccentColor")
    static let accentColorFG = Color("AccentColorFG")

    static let systemBackground = Color("SystemBackground")
    static let secondarySystemBackground = Color("SecondarySystemBackground")
    static let tertiarySystemBackground = Color("TertiarySystemBackground")
    static let cardBackground = Color("CardBackground")
    
    static let yellow = Color("AccentColor")
}

#if os(iOS)
extension Color {
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)
    
    static let divider = Color(UIColor.separator)
}
#endif

#if os(macOS)
extension Color {
    static let label = Color(NSColor.labelColor)
    static let secondaryLabel = Color(NSColor.secondaryLabelColor)
    static let tertiaryLabel = Color(NSColor.tertiaryLabelColor)
    static let quaternaryLabel = Color(NSColor.quaternaryLabelColor)
    
    static let divider = Color(NSColor.separatorColor)
}
#endif


extension Color {
    init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "").trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
