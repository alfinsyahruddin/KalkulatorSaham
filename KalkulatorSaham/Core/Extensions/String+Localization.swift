//
//  String+Localization.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import Foundation


extension String {
    func tr(with arguments: [CVarArg] = []) -> String {
        let language: Language = Language(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.language) ?? "system") ?? .system

        let path = Bundle.main.path(forResource: language.code, ofType: "lproj")
        let bundle = path.flatMap(Bundle.init(path:)) ?? .main

        return String(format: NSLocalizedString(self, tableName: nil, bundle: bundle, value: self, comment: ""), arguments: arguments)
    }
}
