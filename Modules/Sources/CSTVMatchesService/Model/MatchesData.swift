import Foundation

public struct MatchesData: Equatable {
    public let beginAt: Date
    public let id: String
    public let league: League
    public let serie: Serie
    public let leagueID: String
    public let name: String
    public let status: Status
    public let opponents: [Opponents]

    public init(
        beginAt: Date,
        id: String,
        league: League,
        serie: Serie,
        leagueID: String,
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
    
    public enum Status: String, Equatable {
        case notStarted = "not_started"
        case running = "running"
    }
    
    public struct Serie: Equatable {
        public let fullName: String

        public init(
            fullName: String
        ) {
            self.fullName = fullName
        }
    }

    public struct Opponents: Equatable {
        public let opponent: Opponent
        
        public init(
            opponent: Opponent
        ) {
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
        beginAt: Date = .now,
        id: String = UUID().uuidString,
        league: League = .fixture(),
        serie: Serie = .fixture(),
        leagueID: String = UUID().uuidString,
        name: String = "match name",
        status: Status = .running,
        opponents: [Opponents] = [.fixture(), .fixture()]
    ) -> Self {
        MatchesData(
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

public extension MatchesData.Serie {
    static func fixture(
        fullName: String = "Full name"
    ) -> Self {
        MatchesData.Serie(
            fullName: fullName
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
