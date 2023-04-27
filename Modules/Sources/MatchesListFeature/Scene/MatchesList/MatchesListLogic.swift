import ComposableArchitecture
import CSTVMatchesService
import Foundation

public struct MatchesList: ReducerProtocol {
    public struct State: Equatable {
        var matchesData: [MatchesData]
        var goToDetail = false
        var matchDetailSelected: MatchesData? = nil
        var currentPage: Int
        var finishDownloading: Bool

        public init(
            currentPage: Int = 0,
            matchesData: [MatchesData],
            finishDownloading: Bool = false
        ) {
            self.currentPage = currentPage
            self.matchesData = matchesData
            self.finishDownloading = finishDownloading
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
                for match in model {
                    state.matchesData.append(match)
                }
                if model.count < 10 {
                    state.finishDownloading = true
                }
                return .none
                
            case let .handleRequestedData(.failure(error)):
                print(error.localizedDescription)
                return .none
            
            case .refresh:
                state.matchesData = []
                state.currentPage = 0
                return .init(value: .requestData)
            
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
                state.currentPage += 1
                return matchesService
                    .getMatchesList("\(state.currentPage)", "")
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.handleRequestedData)
            }
        }
    }
}


