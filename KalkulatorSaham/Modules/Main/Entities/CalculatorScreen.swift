import Foundation

/// Stable identifiers used by navigation and the saved calculation session.
enum CalculatorScreen: String, Codable, CaseIterable {
    case araArb, tradingReturn, profitPerTick, averagePrice, riskRewardRatio
    case priceBookValue, dividenYield, stockSplit, rightIssue, lot, settings
}
