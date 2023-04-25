import Networking

public protocol CSTVMatchesService {
    public func getMatchesList() -> async throws [CSMatch] {}
    public func getMatchDetail(_ matchID: MatchID) -> async throws CSMatch {}
}
