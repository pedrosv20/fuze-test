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
            return "/csgo/matches"
        case let .matchDetail(id):
            return "/csgo/matches/\(id)"
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
                "Authorization": "Bearer 41vFiGMXjPUhbd_RsTSGlo3mMgUrW1DEpiNkzexResSr5cV8Rbg",
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
