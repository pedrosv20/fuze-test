import Foundation

public enum CSTVEndpoint {
    case matchesList(page: String, sort: String)
    case getPlayers(teamID: String)
    // tinha criado um matchDetail para pegar o ID da partida especifica e puxar as infos porém não tenho o acesso. This endpoint is only available to customers with a historical or real-time data plan
    // utilizarei a mesma resposta do matchesLIst e filtrarei pelo ID que preciso que foi clicado
}

extension CSTVEndpoint: Endpoint {
    public var path: String {
        switch self {
        case .matchesList:
            return "/csgo/matches"
        case .getPlayers:
            return "/csgo/teams"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .matchesList, .getPlayers:
            return .get
        }
    }

    public var header: [String: String]? {
        switch self {
        case .matchesList, .getPlayers:
            return [
                "Authorization": "Bearer 41vFiGMXjPUhbd_RsTSGlo3mMgUrW1DEpiNkzexResSr5cV8Rbg",
                "accept": "application/json"
            ]
        }
    }
    
    public var body: [String: String]? {
        switch self {
        case .matchesList, .getPlayers:
            return nil
        }
    }
    
    public var params: [String: String]? {
        switch self {
        case let .matchesList(page, sort):
            return ["page": page, "sort": sort]
        case let .getPlayers(id):
            return ["filter[id]": id]
        }
    }
}
