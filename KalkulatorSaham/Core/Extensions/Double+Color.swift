//
//  Double+Color.swift
//  KalkulatorSaham
//
//  Created by Alfin on 11/03/23.
//

import SwiftUI

extension Double {
    func getColor(_ start: Double = 0) -> Color {
        if self < start {
            return .red
        } else if self > start {
            return .green
        } else {
            return .yellow
        }
    }
}

