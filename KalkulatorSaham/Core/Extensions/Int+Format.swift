//
//  Int+Format.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import Foundation

extension Int {
    func f(
        _ type: NumberFormatType = .normal
    ) -> String {
        return Double(self).f(type)
    }
}
