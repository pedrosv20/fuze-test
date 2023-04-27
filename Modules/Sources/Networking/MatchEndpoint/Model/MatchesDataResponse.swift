import Foundation

public struct MatchesDataResponse: Decodable {
    public let beginAt: String?
    public let id: Int
    public let league: League
    public let leagueID: Int
    public let name: String
    public let opponents: [Opponents]

    public enum CodingKeys: String, CodingKey {
        case beginAt  = "begin_at"
        case leagueID = "league_id"
        case id, league, name, opponents
    }
    
    public init(
        beginAt: String?,
        id: Int,
        league: League,
        leagueID: Int,
        name: String,
        opponents: [Opponents]
    ) {
        self.beginAt = beginAt
        self.id = id
        self.league = league
        self.leagueID = leagueID
        self.name = name
        self.opponents = opponents
    }
    
    public struct League: Decodable {
        public let id: Int
        public let imageURL: String?
            // TODO: - in MatchesData change type to URL
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
        leagueID: Int = UUID().hashValue,
        name: String = "match name",
        opponents: [Opponents] = [.fixture(), .fixture()]
    ) -> Self {
        MatchesDataResponse(
            beginAt: beginAt,
            id: id,
            league: league,
            leagueID: leagueID,
            name: name,
            opponents: opponents
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
