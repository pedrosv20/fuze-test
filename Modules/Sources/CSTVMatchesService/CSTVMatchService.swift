import Combine
import Dependencies
import Networking

public struct CSTVMatchesService {
    public var getMatchesList: (_ page: String, _ sort: String) -> AnyPublisher<[MatchesData], CommonErrors>
    public var getPlayers: (_ teamID: String) -> AnyPublisher<[Players], CommonErrors>
    
    public init(
        getMatchesList: @escaping (_ page: String, _ sort: String) -> AnyPublisher<[MatchesData], CommonErrors>,
        getPlayers: @escaping (_ teamID: String) -> AnyPublisher<[Players], CommonErrors>
    ) {
        self.getMatchesList = getMatchesList
        self.getPlayers = getPlayers
    }
}

extension CSTVMatchesService: TestDependencyKey {
    public static let testValue: CSTVMatchesService = .mock()
}

extension DependencyValues {
    public var cstvMatchesService:  CSTVMatchesService {
        get { self[CSTVMatchesService.self] }
        set { self[CSTVMatchesService.self] = newValue }
    }
}

#if DEBUG
extension CSTVMatchesService {
    public static var getMatchesListResponseToBeReturned: AnyPublisher<[MatchesData], CommonErrors> = Fail(error: .text("needs to implement matchesList mock"))
        .eraseToAnyPublisher()
    
    public static var getPlayersResponseToBeReturned: AnyPublisher<[Players], CommonErrors> = Fail(error: .text("needs to implement players mock"))
        .eraseToAnyPublisher()

    public static func mock() -> Self {
        .init(getMatchesList: { _, _ in
            return getMatchesListResponseToBeReturned
        }, getPlayers: { _ in
            return getPlayersResponseToBeReturned
        })
    }
}
#endif
