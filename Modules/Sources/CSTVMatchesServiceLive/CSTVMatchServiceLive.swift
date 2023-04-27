import Combine
import Dependencies
import Foundation
import Networking
import CSTVMatchesService

public extension CSTVMatchesService {
    static let live: Self = .init(
        getMatchesList: { page, sort in
            return HTTPClient.shared.request(
                from: CSTVEndpoint.matchesList(page: page, sort: sort),
                responseModel: [MatchesDataResponse].self
            )
            .mapError { _ in
                    .decodingError
            }
            .map { response in
                response.map { data in
                    // TODO: - Common Extension Modules
                    let newFormatter = ISO8601DateFormatter()
                    let date = newFormatter.date(from: data.beginAt ?? "")
                    var dateFormatStyle = Date.FormatStyle.dateTime
                    dateFormatStyle.timeZone = .current
                    
                    return MatchesData(
                        beginAt: date ?? .now,
                        id: String(data.id),
                        league: .init(
                            id: String(data.league.id),
                            imageURL: data.league.imageURL,
                            name: data.league.name,
                            slug: data.league.slug
                        ),
                        serie: .init(
                            fullName: data.serie.fullName
                        ),
                        leagueID: String(data.leagueID),
                        name: data.name,
                        status: .init(rawValue: data.status.rawValue) ?? .running,
                        opponents: data.opponents.map {
                            MatchesData.Opponents(
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
        },
        getPlayers: { teamID in
            return HTTPClient.shared.request(
                from: CSTVEndpoint.getPlayers(teamID: teamID),
                responseModel: [PlayersResponse].self
            )
            .mapError { _ in
                CommonErrors.decodingError
            }
            .map { response in
                response[0].players.map { player in
                    
                    Players(
                        name: player.name,
                        imageURL: URL(string: player.imageURL ?? ""),
                        firstName: player.firstName,
                        lastName: player.lastName
                    )
                }
            }
            
            .eraseToAnyPublisher()
        }
    )
}

extension CSTVMatchesService: DependencyKey {
    public static var liveValue: CSTVMatchesService = .live
}
