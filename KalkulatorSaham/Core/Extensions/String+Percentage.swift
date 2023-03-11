//
//  String+Percentage.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import Foundation

extension String {
    func percentage() -> Self {
        return self == "nan" ? "0%" : self + "%"
    }
}
