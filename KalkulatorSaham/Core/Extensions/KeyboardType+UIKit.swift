//
//  KeyboardType+UIKit.swift
//  KalkulatorSaham
//
//  Created by Alfin on 15/03/23.
//

import SwiftUI

extension KeyboardType {
    #if os(iOS)
    var uikit: UIKeyboardType {
        switch self {
        case .decimalPad:
            return .decimalPad
        case .numberPad:
            return .numberPad
        case .default:
            return .default
        }
    }
    #endif
}
