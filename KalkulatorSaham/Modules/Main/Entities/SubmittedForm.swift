import Foundation

struct SubmittedForm: Codable, Equatable {
    var numbers: [String: Double] = [:]
    var flags: [String: Bool] = [:]
    var ticker = ""
    var transactions: [SubmittedTransaction] = []
    var buyFee: Double = 0
    var sellFee: Double = 0
}
