import Foundation

public struct MatchesDataResponse: Decodable {
    public let beginAt: String?
    public let id: Int
    public let league: League
    public let serie: Serie
    public let leagueID: Int
    public let name: String
    public let status: Status
    public let opponents: [Opponents]

    public enum CodingKeys: String, CodingKey {
        case beginAt  = "begin_at"
        case leagueID = "league_id"
        case id, league, name, opponents, serie, status
    }
    
    public init(
        beginAt: String?,
        id: Int,
        league: League,
        serie: Serie,
        leagueID: Int,
        name: String,
        status: Status,
        opponents: [Opponents]
    ) {
        self.beginAt = beginAt
        self.id = id
        self.league = league
        self.serie = serie
        self.leagueID = leagueID
        self.name = name
        self.status = status
        self.opponents = opponents
    }
    
    public enum Status: String, Decodable {
        case canceled = "canceled"
        case finished = "finished"
        case running = "running"
    }
    
    public struct League: Decodable {
        public let id: Int
        public let imageURL: String?
        public let name: String
        public let slug: String
        
        public enum CodingKeys: String, CodingKey {
            case imageURL = "image_url"
            case id, name, slug
        }
        
        public init(
            id: Int,
            imageURL: String?,
            name: String,
            slug: String
        ) {
            self.id = id
            self.imageURL = imageURL
            self.name = name
            self.slug = slug
        }
    }
    
    public struct Serie: Decodable {
        public let fullName: String
        
        public enum CodingKeys: String, CodingKey {
            case fullName = "full_name"
        }
        
        public init(
            fullName: String
        ) {
            self.fullName = fullName
        }
    }

    public struct Opponents: Decodable {
        public let opponent: Opponent
        
        public init(
            opponent: Opponent
        ) {
            self.opponent = opponent
        }
    }

    public struct Opponent: Decodable {
        public let id: Int
        public let imageURL: String?
        public let name: String
        public let slug: String
        
        public enum CodingKeys: String, CodingKey {
            case imageURL  = "image_url"
            case id, name, slug
        }
        
        public init(id: Int, imageURL: String?, name: String, slug: String) {
            self.id = id
            self.imageURL = imageURL
            self.name = name
            self.slug = slug
        }
    }
}

public extension MatchesDataResponse {
    static func fixture(
        beginAt: String? = "25/11/2000 - 16:00:00",
        id: Int = UUID().hashValue,
        league: League = .fixture(),
        serie: Serie = .fixture(),
        leagueID: Int = UUID().hashValue,
        name: String = "match name",
        status: Status = .finished,
        opponents: [Opponents] = [.fixture(), .fixture()]
    ) -> Self {
        MatchesDataResponse(
            beginAt: beginAt,
            id: id,
            league: league,
            serie: serie,
            leagueID: leagueID,
            name: name,
            status: status,
            opponents: opponents
        )
    }
}

public extension MatchesDataResponse.Serie {
    static func fixture(
        fullName: String = "Full name"
    ) -> Self {
        MatchesDataResponse.Serie(
            fullName: fullName
        )
    }
}

public extension MatchesDataResponse.League {
    static func fixture(
        id: Int = UUID().hashValue,
        imageURL: String? = nil,
        name: String = "league name",
        slug: String = "league slug"
    ) -> Self {
        MatchesDataResponse.League(
            id: id,
            imageURL: imageURL,
            name: name,
            slug: slug
        )
    }
}

public extension MatchesDataResponse.Opponents {
    static func fixture(
        opponent: MatchesDataResponse.Opponent = .fixture()
    ) -> Self {
        MatchesDataResponse.Opponents(opponent: .fixture())
    }
}

public extension MatchesDataResponse.Opponent {
    static func fixture(
        id: Int = UUID().hashValue,
        imageURL: String? = nil,
        name: String = "opponent name",
        slug: String = "opponent slug"
    ) -> Self {
        MatchesDataResponse.Opponent(
            id: id,
            imageURL: imageURL,
            name: name,
            slug: slug
        )
    }
}
