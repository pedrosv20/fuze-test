import Foundation

public struct MatchesData: Equatable {
    public let beginAt: String?
    public let id: String
    public let league: League
    public let leagueID: String
    public let name: String
    public let opponents: [Opponents]

    public init(
        beginAt: String?,
        id: String,
        league: League,
        leagueID: String,
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
    
    public struct League: Equatable {
        public let id: String
        public let imageURL: String?
        public let name: String
        public let slug: String
        
        public init(
            id: String,
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

    public struct Opponents: Equatable {
        public let opponent: Opponent
        
        public init(opponent: Opponent) {
            self.opponent = opponent
        }
    }

    public struct Opponent: Equatable {
        public let id: String
        public let imageURL: String?
        public let name: String
        public let slug: String
        
        public init(id: String, imageURL: String?, name: String, slug: String) {
            self.id = id
            self.imageURL = imageURL
            self.name = name
            self.slug = slug
        }
    }
}

public extension MatchesData {
    static func fixture(
        beginAt: String? = "25/11/2000 - 16:00:00",
        id: String = UUID().uuidString,
        league: League = .fixture(),
        leagueID: String = UUID().uuidString,
        name: String = "match name",
        opponents: [Opponents] = [.fixture(), .fixture()]
    ) -> Self {
        MatchesData(
            beginAt: beginAt,
            id: id,
            league: league,
            leagueID: leagueID,
            name: name,
            opponents: opponents
        )
    }
}

public extension MatchesData.League {
    static func fixture(
        id: String = UUID().uuidString,
        imageURL: String? = nil,
        name: String = "league name",
        slug: String = "league slug"
    ) -> Self {
        MatchesData.League(
            id: id,
            imageURL: imageURL,
            name: name,
            slug: slug
        )
    }
}

public extension MatchesData.Opponents {
    static func fixture(
        opponent: MatchesData.Opponent = .fixture()
    ) -> Self {
        MatchesData.Opponents(opponent: .fixture())
    }
}

public extension MatchesData.Opponent {
    static func fixture(
        id: String = UUID().uuidString,
        imageURL: String? = nil,
        name: String = "opponent name",
        slug: String = "opponent slug"
    ) -> Self {
        MatchesData.Opponent(
            id: id,
            imageURL: imageURL,
            name: name,
            slug: slug
        )
    }
}
