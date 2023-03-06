//
//  String+Localization.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import Foundation


extension String {
    func tr() -> String {
        let language: Language = Language.init(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.language) ?? "system")!
        
        let path = Bundle.main.path(forResource: language.code, ofType: "lproj")
        let bundle: Bundle
        if let path = path {
            bundle = Bundle(path: path) ?? .main
        } else {
            bundle = .main
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}
