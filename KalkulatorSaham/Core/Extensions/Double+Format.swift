//
//  Double+Format.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//


import Foundation

extension String {
    func unformatNumber() -> Int {
        return Int(self.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")) ?? 0
    }
}

extension Double {
    func f(
        _ type: NumberFormatType = .normal
    ) -> String {
        var formattedDouble: String? = nil
        
        switch type {
        case .normal:
            formattedDouble = self.formatted_ios14()
        case .short:
            formattedDouble = self.formattedShort()
        case .currency:
            formattedDouble = "Rp \(self.f())"
        case .withPlus:
            formattedDouble = "\(self > 0 ? "+" : "")\(self.clean())"
        }
        
        return formattedDouble!
    }
    
    private func formatted_ios14() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: self as NSNumber)!
    }
    
    private func formattedShort() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            var formatted = num / 1_000_000_000_000
            formatted = formatted.reduceScale(to: 2)
            return "\(sign)\(formatted.clean())T"
            
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted.clean())B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 0)
            return "\(sign)\(formatted.clean())M"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 0)
            return "\(sign)\(formatted.clean())K"

        case 0...:
            return "\(self)"

        default:
            return "\(sign)\(self)"
        }
    }
    
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
    
    func clean() -> String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
}
