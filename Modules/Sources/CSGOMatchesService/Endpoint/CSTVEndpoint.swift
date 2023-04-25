import Foundation
import Networking

public enum CSTVEndpoint {
    case matchesList
    case matchDetail(String)
}

extension CSTVEndpoint: Endpoint {
    public var path: String {
        switch self {
        case .matchesList:
            return scheme + "://" + host + "/csgo/matches/running"
        case let .matchDetail(id):
            return scheme + "://" + host + "/csgo/matches/\(id)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .matchesList, .matchDetail:
            return .get
        }
    }

    public var header: [String: String]? {
        switch self {
        case .matchesList, .matchDetail:
            return [
                "accept": "application/json"
            ]
        }
    }
    
    public var body: [String: String]? {
        switch self {
        case .matchesList, .matchDetail:
            return nil
        }
    }
}
