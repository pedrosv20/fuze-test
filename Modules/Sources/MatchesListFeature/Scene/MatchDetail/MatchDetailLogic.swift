import ComposableArchitecture
import CSTVMatchesService
import Foundation

public struct MatchDetail: ReducerProtocol {
    public struct State: Equatable {
        var matchData: MatchesData
        public init(matchData: MatchesData) {
            self.matchData = matchData
        }
    }

    public enum Action {
        case onAppear
    }
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.cstvMatchesService) var matchesService

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}


