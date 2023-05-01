import ComposableArchitecture
import CSTVMatchesService
import Foundation

public struct MatchDetail: ReducerProtocol {
    public struct State: Equatable {
        var matchData: MatchesData
        var playersTeam1: [Players]?
        var playersTeam2: [Players]?
        var error: CommonErrors?

        public init(
            matchData: MatchesData,
            playersTeam1: [Players]? = nil,
            playersTeam2: [Players]? = nil,
            error: CommonErrors? = nil
        ) {
            self.matchData = matchData
            self.playersTeam1 = playersTeam1
            self.playersTeam2 = playersTeam2
            self.error = error
        }
    }

    public enum Action {
        case onAppear
        case requestDataTeam1
        case handleRequestedDataTeam1(Result<[Players], CommonErrors>)
        case requestDataTeam2
        case handleRequestedDataTeam2(Result<[Players], CommonErrors>)
        case refresh
    }

    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.cstvMatchesService) var matchesService

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:                
                return .merge(
                    .init(value: .requestDataTeam1),
                    .init(value: .requestDataTeam2)
                )
            case .requestDataTeam1:
                guard let opponents = state.matchData.opponents[safe: 0] else { return .none }
                return matchesService
                    .getPlayers(opponents.opponent.id)
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.handleRequestedDataTeam1)
            case let .handleRequestedDataTeam1(.success(playersTeam1)):
                state.playersTeam1 = playersTeam1
                return .none
                
            case let .handleRequestedDataTeam1(.failure(error)):
                state.error = error
                return .none

            case .requestDataTeam2:
                guard let opponents = state.matchData.opponents[safe: 1] else { return .none }
                return matchesService
                    .getPlayers(opponents.opponent.id)
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.handleRequestedDataTeam2)

            case let .handleRequestedDataTeam2(.success(playersTeam2)):
                if state.playersTeam1 != nil {
                    state.error = nil
                }

                state.playersTeam2 = playersTeam2
                return .none
                
            case let .handleRequestedDataTeam2(.failure(error)):
                state.error = error
                return .none

            case .refresh:
                state.error = nil
                state.playersTeam1 = nil
                state.playersTeam2 = nil
                return .init(value: .onAppear)
            }
        }
    }
}


