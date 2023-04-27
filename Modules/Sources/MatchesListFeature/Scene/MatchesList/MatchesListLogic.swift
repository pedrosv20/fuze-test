import ComposableArchitecture
import CSTVMatchesService
import Foundation

public struct MatchesList: ReducerProtocol {
    public struct State: Equatable {
        var matchesData: [MatchesData]
        var goToDetail = false
        var matchDetailSelected: MatchesData? = nil
        var currentPage: Int

        public init(currentPage: Int = 0, matchesData: [MatchesData]) {
            self.currentPage = currentPage
            self.matchesData = matchesData
        }
    }

    public enum Action {
        case onAppear
        case requestData
        case handleRequestedData(Result<[MatchesData], CommonErrors>)
        case refresh
        case matchselected(String)
        case shouldShowDetail(Bool)
    }
    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.cstvMatchesService) var matchesService

    public init() {}

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .init(value: .requestData)
                

            case let .handleRequestedData(.success(model)):
                state.matchesData = model
                return .none
                
            case let .handleRequestedData(.failure(error)):
                print(error.localizedDescription)
                return .none
            
            case .refresh:
                return .none
            
            case let .matchselected(id):
                guard let matchDetail = state.matchesData.filter({ $0.id == id }).first else {
                    return .none
                }
                state.matchDetailSelected = matchDetail
                
                return .init(value: .shouldShowDetail(true))

            case let .shouldShowDetail(bool):
                if bool == false {
                    state.matchDetailSelected = nil
                }
                state.goToDetail = bool
                return .none

            case .requestData:
//                state.currentPage += 1
                return matchesService
                    .getMatchesList("1", "")
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.handleRequestedData)
            }
        }
    }
}


