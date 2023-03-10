//
//  Theme.swift
//  KalkulatorSaham
//
//  Created by Alfin on 10/03/23.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

final class ThemeManager {
    static func updateTheme(_ theme: Theme) {
        DispatchQueue.main.async {
            #if os(iOS)
            var userInterfaceStyle: UIUserInterfaceStyle
            switch theme {
            case .system:
                userInterfaceStyle = .unspecified
            case .light:
                userInterfaceStyle = .light
            case .dark:
                userInterfaceStyle = .dark
            }

            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = userInterfaceStyle
            
            #elseif os(macOS)
            switch theme {
            case .system:
                NSApp.appearance = nil
            case .light:
                NSApp.appearance = NSAppearance(named: .vibrantLight)
            case .dark:
                NSApp.appearance = NSAppearance(named: .vibrantDark)
            }
            
            #endif
        }
    }

}
