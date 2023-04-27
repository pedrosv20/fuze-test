import Foundation

public enum CSTVEndpoint {
    case matchesList(page: String, sort: String)
    // tinha criado um matchDetail para pegar o ID da partida especifica e puxar as infos porém não tenho o acesso. This endpoint is only available to customers with a historical or real-time data plan
    // utilizarei a mesma resposta do matchesLIst e filtrarei pelo ID que preciso que foi clicado
}

extension CSTVEndpoint: Endpoint {
    public var path: String {
        switch self {
        case .matchesList:
            return "/csgo/matches/running"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .matchesList:
            return .get
        }
    }

    public var header: [String: String]? {
        switch self {
        case .matchesList:
            return [
                "Authorization": "Bearer 41vFiGMXjPUhbd_RsTSGlo3mMgUrW1DEpiNkzexResSr5cV8Rbg",
                "accept": "application/json"
            ]
        }
    }
    
    public var body: [String: String]? {
        switch self {
        case .matchesList:
            return nil
        }
    }
    
    public var page: String {
        switch self {
        case let .matchesList(page, _):
            return page
        }
    }
    
    public var sort: String {
        switch self {
        case let .matchesList(_, sort):
            return sort
        }
    }
}
