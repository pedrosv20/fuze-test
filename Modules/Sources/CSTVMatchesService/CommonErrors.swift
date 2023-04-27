import Foundation

public enum CommonErrors: Error, Equatable {
    case text(String)
    case decodingError
    
    public init(_ error: Error) {
        self = .text(error.localizedDescription)
    }

    public init(_ error: String) {
        self = .text(error)
    }
    
}
