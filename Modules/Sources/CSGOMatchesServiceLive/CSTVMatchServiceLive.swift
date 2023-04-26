import Foundation
import Networking
import CSGOMatchesService

public extension CSTVMatchesService {
    static let live: Self = .init {
        // request
        return HTTPClient.shared.request(
            from: CSTVEndpoint.matchesList,
            responseModel: [MatchesData].self
        )
        
    } getMatchDetail: { matchID in
        // request
        return HTTPClient.shared.request(
            from: CSTVEndpoint.matchesList,
            responseModel: MatchesData.self
        )
        
        
    }
}
