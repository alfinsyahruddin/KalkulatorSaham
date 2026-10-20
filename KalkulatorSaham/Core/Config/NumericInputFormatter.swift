import Foundation

/// Formats editable numbers without discarding a trailing comma or fractional zeros.
enum NumericInputFormatter {
    static func format(_ input: String, previous: String = "") -> String {
        var input = input
        // Decimal keyboards can insert a period even though the app displays commas.
        let edits = Array(input.difference(from: previous))
        if edits.count == 1, case let .insert(offset, character, _) = edits[0], character == "." {
            let index = input.index(input.startIndex, offsetBy: offset)
            input.replaceSubrange(index...index, with: ",")
        } else if edits.count == 1, case let .remove(offset, character, _) = edits[0],
                  character == ".", offset > 0 {
            // Backspacing over a grouping separator must still delete a digit.
            input.remove(at: input.index(input.startIndex, offsetBy: offset - 1))
        } else if previous.isEmpty, input.filter({ $0 == "." }).count == 1,
                  !input.contains(","), let dot = input.firstIndex(of: "."),
                  input.distance(from: input.index(after: dot), to: input.endIndex) != 3 {
            // Also accept pasted decimal values such as 0.15.
            input.replaceSubrange(dot...dot, with: ",")
        }

        let negative = input.first == "-"
        let parts = input.split(separator: ",", maxSplits: 1, omittingEmptySubsequences: false)
        let digits = parts[0].filter { $0.isASCII && $0.isNumber }
        let trimmed = digits.drop(while: { $0 == "0" })
        let integer = trimmed.isEmpty ? (digits.isEmpty ? "" : "0") : String(trimmed)
        var grouped = ""
        for (index, digit) in integer.enumerated() {
            if index > 0, (integer.count - index).isMultiple(of: 3) { grouped.append(".") }
            grouped.append(digit)
        }
        if parts.count == 2 {
            if grouped.isEmpty { grouped = "0" }
            grouped += "," + parts[1].filter { $0.isASCII && $0.isNumber }
        }
        return (negative ? "-" : "") + grouped
    }

    static func display(_ value: Double) -> String {
        value.formatted(.number.locale(Locale(identifier: "id_ID")).precision(.fractionLength(0...16)))
    }

    static func value(of input: String) -> Double? {
        if input.isEmpty || input == "-" { return 0 }
        let value = Double(input.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "."))
        return value.flatMap { $0.isFinite ? $0 : nil }
    }
}
