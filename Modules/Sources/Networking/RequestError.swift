public enum RequestError: Error, Equatable {
    case decode(String)
    case unauthorized
    case invalidURL
    case unexpectedStatusCode
    case noResponse
    case unknown
    case text(String)
    
    public var customMessage: String {
        switch self {
        case let .decode(object):
            return "Error decoding data from \(object)"
        case .unauthorized:
            return "Session expired"
        case let .text(string):
            return string
        default:
            return "Unknown error \(self)"
        }
    }
}
