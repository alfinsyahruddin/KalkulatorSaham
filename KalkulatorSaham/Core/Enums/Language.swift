//
//  Language.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import Foundation

enum Language: String, CaseIterable {
    case english, indonesia, system
}

extension Language {
    var code: String {
        switch self {
        case .english:
            return "en"
        case .indonesia:
            return "id"
        case .system:
            return "en"
        }
    }
}
