//
//  Settings.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import Foundation
import ComposableArchitecture

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif


struct Settings: ReducerProtocol {
    struct State: Equatable {
        var theme: Theme = Theme.init(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.theme) ?? "system")!
        var language: Language = Language.init(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.language) ?? "system")!
    }
    
    enum Action: Equatable {
        case setTheme(Theme)
        case setLanguage(Language)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setTheme(theme):
                state.theme = theme
                return .fireAndForget {
                    UserDefaults.standard.set(theme.rawValue, forKey: UserDefaultsKey.theme)
                    
                    self.updateTheme(theme)
                }
            case let .setLanguage(language):
                state.language = language
                return .fireAndForget {
                    UserDefaults.standard.set(language.rawValue, forKey: UserDefaultsKey.language)
                }
            }
        }
    }
    
    
    private func updateTheme(_ theme: Theme) {
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

