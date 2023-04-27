import ComposableArchitecture
import CSTVMatchesService
import Foundation

public struct MatchDetail: ReducerProtocol {
    public struct State: Equatable {
        var matchData: MatchesData
        var playersTeam1: [Players]?
        var playersTeam2: [Players]?
        public init(
            matchData: MatchesData,
            playersTeam1: [Players]? = nil,
            playersTeam2: [Players]? = nil
        ) {
            self.matchData = matchData
            self.playersTeam1 = playersTeam1
            self.playersTeam2 = playersTeam2
        }
    }

    public enum Action {
        case onAppear
        case requestDataTeam1
        case handleRequestedDataTeam1(Result<[Players], CommonErrors>)
        case requestDataTeam2
        case handleRequestedDataTeam2(Result<[Players], CommonErrors>)
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
                print(error)
                return .none

            case .requestDataTeam2:
                guard let opponents = state.matchData.opponents[safe: 1] else { return .none }
                return matchesService
                    .getPlayers(opponents.opponent.id)
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.handleRequestedDataTeam2)

            case let .handleRequestedDataTeam2(.success(playersTeam2)):
                state.playersTeam2 = playersTeam2
                return .none
                
            case let .handleRequestedDataTeam2(.failure(error)):
                print(error)
                return .none
            }
        }
    }
}


