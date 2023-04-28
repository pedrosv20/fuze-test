import Foundation

public extension String {
    func toFormattedDate() -> Date {
        let newFormatter = ISO8601DateFormatter()
        guard let date = newFormatter.date(from: self) else { return .now }
        return date
    }
}
