import Combine
import Dependencies
import Networking

public struct CSTVMatchesService {
    public var getMatchesList: (_ page: String, _ sort: String) -> AnyPublisher<[MatchesData], CommonErrors>
    
    public init(getMatchesList: @escaping (_ page: String, _ sort: String) -> AnyPublisher<[MatchesData], CommonErrors>) {
        self.getMatchesList = getMatchesList
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
    public static var mock: Self = .init { _, _ in
        Fail(error: .text("failed mock"))
            .eraseToAnyPublisher()
    }
}
