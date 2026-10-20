//
//  Settings.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import Foundation
import ComposableArchitecture


@Reducer
struct Settings {
    @Dependency(\.userDefaults) var userDefaults

    @ObservableState
    struct State: Equatable {
        var theme: Theme = {
            @Dependency(\.userDefaults) var userDefaults

            let theme = Theme(rawValue: userDefaults.string(forKey: UserDefaultsKey.theme) ?? "system") ?? .system

            return theme
        }()

        var language: Language = {
            @Dependency(\.userDefaults) var userDefaults

            let language = Language(rawValue: userDefaults.string(forKey: UserDefaultsKey.language) ?? "system") ?? .system

            return language
        }()

        var buyFee = {
            @Dependency(\.userDefaults) var userDefaults

            let buyFee = userDefaults.double(forKey: UserDefaultsKey.buyFee)

            return buyFee
        }()

        var sellFee = {
            @Dependency(\.userDefaults) var userDefaults

            let sellFee = userDefaults.double(forKey: UserDefaultsKey.sellFee)

            return sellFee
        }()

    }

    enum Action: Equatable, BindableAction {
        case setTheme(Theme)
        case setLanguage(Language)

        case binding(BindingAction<State>)
    }

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.buyFee):
                userDefaults.set(state.buyFee, forKey: UserDefaultsKey.buyFee)
                return .none
            case .binding(\.sellFee):
                userDefaults.set(state.sellFee, forKey: UserDefaultsKey.sellFee)
                return .none
            case let .setTheme(theme):
                state.theme = theme
                userDefaults.set(theme.rawValue, forKey: UserDefaultsKey.theme)
                return .none
            case let .setLanguage(language):
                state.language = language
                userDefaults.set(language.rawValue, forKey: UserDefaultsKey.language)
                return .none
            default:
                return .none
            }
        }
    }

}


