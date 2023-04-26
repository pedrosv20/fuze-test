import Foundation

public struct MatchesDataResponse: Decodable {
    public let beginAt: String?
    public let id: Int
    public let league: League
    public let leagueID: Int
    public let name: String
    public let opponents: [Opponents]

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
    
    enum CodingKeys: String,CodingKey {
        case beginAt = "begin_at"
        case leagueID = "league_id"
        case id, league, name, opponents
    }
    
    public struct League: Decodable {
        public let id: Int
        public let imageURL: String?
        public let name: String
        public let slug: String
        
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
        
        enum CodingKeys: String, CodingKey {
            case imageURL = "image_url"
            case id, name, slug
        }
    }

    public struct Opponents: Decodable {
        public let opponent: Opponent
    }

    public struct Opponent: Decodable {
        public let id: Int
        public let imageURL: String?
        public let name: String
        public let slug: String
        
        public init(id: Int, imageURL: String?, name: String, slug: String) {
            self.id = id
            self.imageURL = imageURL
            self.name = name
            self.slug = slug
        }
        
        enum CodingKeys: String, CodingKey {
            case imageURL = "image_url"
            case id, name, slug
        }
    }
}


public typealias MatchID = String
