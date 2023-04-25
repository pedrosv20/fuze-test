import Foundation
import Networking
import CSGOMatchesService

public struct CSTVMatchesServiceLive: HTTPClient, CSTVMatchesService {
    public func getMatchesList() async -> [CSMatch] {
        return await request(from: .matchesList, responseModel: [CSMatch.self])
    }
    public func getMatchDetail(_ matchID: MatchID) async -> throws CSMatch {}
    
}
