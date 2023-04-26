import Combine
import Networking

public struct CSTVMatchesService {
    public var getMatchesList: () -> AnyPublisher<[MatchesData], RequestError>
    public var getMatchDetail: (_ matchID: MatchID) -> AnyPublisher<MatchesData, RequestError>
    
    public init(
        getMatchesList: @escaping () -> AnyPublisher<[MatchesData], RequestError>,
        getMatchDetail: @escaping (_ matchID: MatchID) -> AnyPublisher<MatchesData, RequestError>
    ) {
        self.getMatchesList = getMatchesList
        self.getMatchDetail = getMatchDetail
    }
}
