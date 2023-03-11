//
//  Collection+Subscript.swift
//  KalkulatorSaham
//
//  Created by Alfin on 11/03/23.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
