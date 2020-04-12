import Foundation

public extension NumberFormatter {
    static var commaSeparatedFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
}
