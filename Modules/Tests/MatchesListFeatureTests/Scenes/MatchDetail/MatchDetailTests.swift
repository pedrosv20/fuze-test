import Combine
import ComposableArchitecture
import Foundation
import XCTest
import CSTVMatchesService
@testable import MatchesListFeature

public final class MatchDetailTests: XCTestCase {
    func test_onAppear_shouldDownloadPlayersLists() {
        // Given
        let testScheduler = DispatchQueue.test
        let store = TestStore(
            initialState: MatchDetail.State(matchData: .fixture(opponents: [
                .fixture(opponent: .fixture(id: "123")),
                .fixture(opponent: .fixture(id: "321"))
            ])),
            reducer: MatchDetail()
        ) {
            $0.mainQueue = testScheduler.eraseToAnyScheduler()
            $0.cstvMatchesService = .mock()
        }
        
        let model1ToBeReturend: [Players] = [.fixture()]
        let model2ToBeReturend: [Players] = [.fixture()]
        
        CSTVMatchesService.getPlayersResponseToBeReturned = Just(model1ToBeReturend)
            .setFailureType(to: CommonErrors.self)
            .eraseToAnyPublisher()
        
        // When
        store.send(.onAppear)
        testScheduler.advance()
        
        // Then
        store.receive(.init(.requestDataTeam1))
        store.receive(.init(.requestDataTeam2))

        store.receive(.init(.handleRequestedDataTeam1(.success(model1ToBeReturend)))) {
            $0.playersTeam1 = model1ToBeReturend
        }
        
        
        store.receive(.init(.handleRequestedDataTeam2(.success(model2ToBeReturend)))) {
            $0.playersTeam2 = model2ToBeReturend
        }
    }
}
