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
    public static let testValue: CSTVMatchesService = .mock
}

extension DependencyValues {
    public var cstvMatchesService:  CSTVMatchesService {
        get { self[CSTVMatchesService.self] }
        set { self[CSTVMatchesService.self] = newValue }
    }
}

extension CSTVMatchesService {
    public static var mock: Self = .init(getMatchesList: { _, _ in
        Fail(error: .text("failed mock"))
            .eraseToAnyPublisher()
    }, getPlayers: { _ in
        Fail(error: .text("failed mock"))
            .eraseToAnyPublisher()
    })
}
