public protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var params: [String: String]? { get }
    var method: HTTPMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
}

public extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.pandascore.co"
    }
}
