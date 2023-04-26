import Dependencies
import Foundation
import Networking
import CSTVMatchesService

public extension CSTVMatchesService {
    static let live: Self = .init {
        // request
        return HTTPClient.shared.request(
            from: CSTVEndpoint.matchesList,
            responseModel: [MatchesDataResponse].self
        )
        .mapError { error in
            return CommonErrors.decodingError
        }
        .map { response in
            response.map { data in
                MatchesData(
                    beginAt: data.beginAt,
                    id: String(data.id),
                    league: .init(
                        id: String(data.league.id),
                        imageURL: data.league.imageURL,
                        name: data.league.name,
                        slug: data.league.slug
                    ),
                    leagueID: String(data.leagueID),
                    name: data.name,
                    opponents: data.opponents.map {
                        .init(
                            opponent: .init(
                                id: String($0.opponent.id),
                                imageURL: $0.opponent.imageURL,
                                name: $0.opponent.name,
                                slug: $0.opponent.slug
                            )
                        )
                    }
                )
            }
        }
        .eraseToAnyPublisher()
    } getMatchDetail: { matchID in
        // request
        return HTTPClient.shared.request(
            from: CSTVEndpoint.matchesList,
            responseModel: MatchesDataResponse.self
        )
        .mapError { error in
            return CommonErrors.decodingError
        }
        .map { _ in
            .fixture()
        }
        .eraseToAnyPublisher()
    }
}

extension CSTVMatchesService: DependencyKey {
    public static var liveValue: CSTVMatchesService = .live
}
