import Foundation

public enum CSTVEndpoint {
    case matchesList
    case matchDetail(String)
    case playerStats(String)
}

extension CSTVEndpoint: Endpoint {
    public var path: String {
        switch self {
        case .matchesList:
            return "/csgo/matches/running"
        case let .matchDetail(id):
            return "/csgo/matches/\(id)"
        case let .playerStats(id):
            return "/csgo/players/\(id)/stats"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .matchesList, .matchDetail, .playerStats:
            return .get
        }
    }

    public var header: [String: String]? {
        switch self {
        case .matchesList, .matchDetail, .playerStats:
            return [
                "Authorization": "Bearer 41vFiGMXjPUhbd_RsTSGlo3mMgUrW1DEpiNkzexResSr5cV8Rbg",
                "accept": "application/json"
            ]
        }
    }
    
    public var body: [String: String]? {
        switch self {
        case .matchesList, .matchDetail, .playerStats:
            return nil
        }
    }
}
