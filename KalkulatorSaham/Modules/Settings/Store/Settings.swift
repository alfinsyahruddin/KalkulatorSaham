//
//  Settings.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import Foundation
import ComposableArchitecture


struct Settings: ReducerProtocol {
    @Dependency(\.userDefaults) var userDefaults

    struct State: Equatable {
        var theme: Theme = {
            @Dependency(\.userDefaults) var userDefaults
         
            let theme = Theme.init(rawValue: userDefaults.string(forKey: UserDefaultsKey.theme) ?? "system")!
            ThemeManager.updateTheme(theme)
            
            return theme
        }()
        
        var language: Language = {
            @Dependency(\.userDefaults) var userDefaults
         
            let language = Language.init(rawValue:  userDefaults.string(forKey: UserDefaultsKey.language) ?? "system")!
            
            return language
        }()
        
        @BindingState var buyFee = {
            @Dependency(\.userDefaults) var userDefaults
         
            let buyFee = userDefaults.string(forKey: UserDefaultsKey.buyFee) ?? "0.0"
            
            return buyFee
        }()
        
        @BindingState var sellFee = {
            @Dependency(\.userDefaults) var userDefaults
         
            let sellFee = userDefaults.string(forKey: UserDefaultsKey.sellFee) ?? "0.0"
            
            return sellFee
        }()
        
    }
    
    enum Action: Equatable, BindableAction {
        case setTheme(Theme)
        case setLanguage(Language)
        
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding(\.$buyFee):
                return .fireAndForget { [state] in
                    userDefaults.set(state.buyFee, forKey: UserDefaultsKey.buyFee)
                }
            case .binding(\.$sellFee):
                return .fireAndForget { [state] in
                    userDefaults.set(state.sellFee, forKey: UserDefaultsKey.sellFee)
                }
            case let .setTheme(theme):
                state.theme = theme
                return .fireAndForget {
                    userDefaults.set(theme.rawValue, forKey: UserDefaultsKey.theme)
                    
                    ThemeManager.updateTheme(theme)
                }
            case let .setLanguage(language):
                state.language = language
                return .fireAndForget {
                    userDefaults.set(language.rawValue, forKey: UserDefaultsKey.language)
                }
            default:
                return .none
            }
        }
    }
    
}


