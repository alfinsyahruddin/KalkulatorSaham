//
//  NumberFormatter.swift
//  KalkulatorSaham
//
//  Created by Alfin on 10/03/23.
//

import Foundation

let numberFormatter: NumberFormatter = {
   let numberFormatter = NumberFormatter()
   numberFormatter.groupingSeparator = "."
   numberFormatter.groupingSize = 3
   numberFormatter.usesGroupingSeparator = true
   numberFormatter.decimalSeparator = ","
   numberFormatter.numberStyle = .decimal
   numberFormatter.maximumFractionDigits = 2
   return numberFormatter
}()
