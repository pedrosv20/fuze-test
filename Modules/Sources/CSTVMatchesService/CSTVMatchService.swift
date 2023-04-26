import Combine
import Dependencies
import Networking

public struct CSTVMatchesService {
    public var getMatchesList: () -> AnyPublisher<[MatchesData], CommonErrors>
    public var getMatchDetail: (_ matchID: MatchID) -> AnyPublisher<MatchesData, CommonErrors>
    
    public init(
        getMatchesList: @escaping () -> AnyPublisher<[MatchesData], CommonErrors>,
        getMatchDetail: @escaping (_ matchID: MatchID) -> AnyPublisher<MatchesData, CommonErrors>
    ) {
        self.getMatchesList = getMatchesList
        self.getMatchDetail = getMatchDetail
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
    public static var mock: Self = .init(getMatchesList: {
        Fail(error: .text("failed mock"))
            .eraseToAnyPublisher()
    }, getMatchDetail: { _ in
        Fail(error: .text("failed mock"))
            .eraseToAnyPublisher()
    })
}
