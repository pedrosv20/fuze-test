import ComposableArchitecture
import CSTVMatchesService
import Foundation

public struct MatchDetail: ReducerProtocol {
    public struct State: Equatable {
        var selectedMatch: String
        var matchesData: MatchesData?
        public init(selectedMatch: String, matchesData: MatchesData? = nil) {
            self.selectedMatch = selectedMatch
            self.matchesData = matchesData
        }
    }

    public enum Action {
        case onAppear
        case requestData(String)
        case handleRequestedData(Result<MatchesData, CommonErrors>)
    }
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.cstvMatchesService) var matchesService

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .init(value: .requestData(state.selectedMatch))
                

            case let .handleRequestedData(.success(model)):
                state.matchesData = model
                return .none
                
            case let .handleRequestedData(.failure(error)):
                print(error.localizedDescription)
                return .none
            

            case let .requestData(matchID):
                return matchesService
                    .getMatchDetail(matchID)
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.handleRequestedData)
            }
        }
    }
}


