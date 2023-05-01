import ComposableArchitecture
import CSTVMatchesService
import Foundation

public struct MatchesList: ReducerProtocol {
    public struct State: Equatable {
        var matchesData: [MatchesData]
        var goToDetail: Bool
        var shouldResetData: Bool
        var matchDetailSelected: MatchesData?
        var currentPage: Int
        var finishDownloading: Bool
        var error: CommonErrors?

        public init(
            currentPage: Int = 0,
            matchesData: [MatchesData],
            finishDownloading: Bool = false,
            goToDetail: Bool = false,
            shouldResetData: Bool = false,
            matchDetailSelected: MatchesData? = nil,
            error: CommonErrors? = nil
        ) {
            self.currentPage = currentPage
            self.matchesData = matchesData
            self.finishDownloading = finishDownloading
            self.goToDetail = goToDetail
            self.shouldResetData = shouldResetData
            self.matchDetailSelected = matchDetailSelected
            self.error = error
        }
    }

    public enum Action: Equatable {
        case onAppear
        case requestData
        case handleRequestedData(Result<[MatchesData], CommonErrors>)
        case refresh
        case matchSelected(String)
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
                state.error = nil
                
                if state.shouldResetData {
                    state.matchesData = []
                    state.shouldResetData = false
                }
                for match in model {
                    state.matchesData.append(match)
                }
                if model.count < 10 {
                    state.finishDownloading = true
                }
                return .none
                
            case let .handleRequestedData(.failure(error)):
                state.error = error
                return .none
            
            case .refresh:
                state.error = nil
                state.currentPage = 0
                state.shouldResetData = true
                return .init(value: .requestData)
            
            case let .matchSelected(id):
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
                    .getMatchesList("\(state.currentPage)", "begin_at")
                    .receive(on: mainQueue)
                    .catchToEffect()
                    .map(Action.handleRequestedData)
            }
        }
    }
}


