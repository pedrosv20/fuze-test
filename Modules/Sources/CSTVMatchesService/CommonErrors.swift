import Foundation

public enum CommonErrors: Error, Equatable {
    case text(String)
    
    public init(_ error: Error) {
        self = .text(error.localizedDescription)
    }

    public init(_ error: String) {
        self = .text(error)
    }
    
    public var customMessage: String {
        switch self {
        case let .text(string):
            return string
        }
    }
    
}
